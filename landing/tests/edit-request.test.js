const test = require('node:test');
const assert = require('node:assert/strict');

function makeRes() {
  return {
    statusCode: 200,
    headers: {},
    body: undefined,
    setHeader(key, value) { this.headers[key.toLowerCase()] = value; },
    status(code) { this.statusCode = code; return this; },
    json(payload) { this.body = payload; return this; }
  };
}

test('rejects non-POST requests', async () => {
  const { handler } = require('../api/edit-request.js');
  const res = makeRes();

  await handler({ method: 'GET', body: {} }, res, { fetchImpl: async () => { throw new Error('should not fetch'); } });

  assert.equal(res.statusCode, 405);
  assert.equal(res.body.ok, false);
});

test('validates draft text', async () => {
  const { handler } = require('../api/edit-request.js');
  const res = makeRes();

  await handler({ method: 'POST', body: { draft: '' } }, res, { fetchImpl: async () => { throw new Error('should not fetch'); } });

  assert.equal(res.statusCode, 400);
  assert.match(res.body.error, /draft/i);
});

test('returns edited text from OpenRouter', async () => {
  const { handler } = require('../api/edit-request.js');
  const res = makeRes();

  await handler(
    {
      method: 'POST',
      body: {
        title: 'Test post',
        cadence: 'Jab - useful, no CTA',
        draft: 'rough draft',
        currentEdited: 'old edit',
        changeRequest: 'more upbeat',
        notes: 'keep it short'
      }
    },
    res,
    {
      env: { OPENROUTER_API_KEY: 'test-key', CAPTAIN_EDIT_MODEL: 'test-model' },
      fetchImpl: async (url, options) => {
        assert.equal(url, 'https://openrouter.ai/api/v1/chat/completions');
        assert.equal(options.method, 'POST');
        assert.equal(options.headers.Authorization, 'Bearer test-key');
        const payload = JSON.parse(options.body);
        assert.equal(payload.model, 'test-model');
        assert.match(payload.messages[1].content, /rough draft/);
        assert.match(payload.messages[1].content, /more upbeat/);
        return {
          ok: true,
          status: 200,
          json: async () => ({ choices: [{ message: { content: 'clean edited post' } }] })
        };
      }
    }
  );

  assert.equal(res.statusCode, 200);
  assert.equal(res.body.ok, true);
  assert.equal(res.body.edited, 'clean edited post');
  assert.match(res.body.requestId, /^edit_/);
});

test('reports missing OpenRouter key as unavailable', async () => {
  const { handler } = require('../api/edit-request.js');
  const res = makeRes();

  await handler({ method: 'POST', body: { draft: 'rough draft' } }, res, { env: {}, fetchImpl: async () => { throw new Error('should not fetch'); } });

  assert.equal(res.statusCode, 503);
  assert.equal(res.body.ok, false);
  assert.match(res.body.error, /not configured/i);
});

test('prioritizes plain-language change requests in the model prompt', () => {
  const { buildMessages } = require('../api/edit-request.js');

  const messages = buildMessages({
    title: 'Voice sample',
    cadence: 'Raw idea',
    draft: 'I like this but teh typo is bad.',
    currentEdited: 'Old edit',
    changeRequest: 'only fix typos. I like my voice, just learn from this one.',
    notes: ''
  });

  assert.match(messages[0].content, /Change request is the highest-priority/i);
  assert.match(messages[0].content, /only fix typos/i);
  assert.match(messages[0].content, /learn from this one/i);
  assert.match(messages[1].content, /only fix typos/);
  assert.match(messages[1].content, /I like my voice/);
});
