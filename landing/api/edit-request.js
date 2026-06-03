const OPENROUTER_URL = 'https://openrouter.ai/api/v1/chat/completions';
const DEFAULT_MODEL = 'google/gemini-2.5-flash';
const MAX_FIELD_CHARS = 12000;

function getEnv(overrides) {
  return overrides || process.env || {};
}

function readBody(req) {
  if (req.body && typeof req.body === 'object') return req.body;
  if (typeof req.body === 'string') {
    try { return JSON.parse(req.body); } catch { return {}; }
  }
  return {};
}

function cleanField(value, max = MAX_FIELD_CHARS) {
  if (typeof value !== 'string') return '';
  return value.trim().slice(0, max);
}

function buildMessages(body) {
  const title = cleanField(body.title, 300) || 'Untitled LinkedIn draft';
  const cadence = cleanField(body.cadence, 200) || 'Raw idea';
  const notes = cleanField(body.notes, 3000) || '(none)';
  const draft = cleanField(body.draft);
  const currentEdited = cleanField(body.currentEdited) || '(none yet)';

  return [
    {
      role: 'system',
      content: [
        'You are Captain editing NE\'s LinkedIn post.',
        'Return only the updated edited version. No explanation. No markdown wrapper.',
        'Voice: genuine, helpful, plain-English, deadpan, useful, not corporate, not spammy.',
        'Style: short lines, clear examples, light parenthetical humor only if it fits.',
        'Strategy: Jab posts teach with no CTA. Hook posts teach first and include one soft Agent Path CTA.',
        'Do not over-polish. Preserve the author\'s point of view and make it sound human.'
      ].join('\n')
    },
    {
      role: 'user',
      content: [
        `Title: ${title}`,
        `Cadence: ${cadence}`,
        '',
        'Notes:',
        notes,
        '',
        'Latest draft:',
        draft,
        '',
        'Current edited version, if useful as a starting point:',
        currentEdited
      ].join('\n')
    }
  ];
}

function requestId() {
  return `edit_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`;
}

function send(res, statusCode, payload) {
  if (typeof res.setHeader === 'function') {
    res.setHeader('content-type', 'application/json; charset=utf-8');
    res.setHeader('cache-control', 'no-store');
    res.setHeader('access-control-allow-origin', '*');
    res.setHeader('access-control-allow-methods', 'POST, OPTIONS');
    res.setHeader('access-control-allow-headers', 'content-type');
  }
  if (typeof res.status === 'function' && typeof res.json === 'function') {
    return res.status(statusCode).json(payload);
  }
  res.statusCode = statusCode;
  res.end(JSON.stringify(payload));
}

async function handler(req, res, options = {}) {
  const method = req.method || 'GET';
  if (method === 'OPTIONS') return send(res, 204, {});
  if (method !== 'POST') return send(res, 405, { ok: false, error: 'Use POST.' });

  const body = readBody(req);
  const draft = cleanField(body.draft);
  if (!draft) return send(res, 400, { ok: false, error: 'Draft text is required.' });

  const env = getEnv(options.env);
  const apiKey = env.OPENROUTER_API_KEY;
  if (!apiKey) return send(res, 503, { ok: false, error: 'Captain edit backend is not configured.' });

  const id = requestId();
  const model = env.CAPTAIN_EDIT_MODEL || DEFAULT_MODEL;
  const fetchImpl = options.fetchImpl || fetch;

  try {
    const response = await fetchImpl(OPENROUTER_URL, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://agent-path.vercel.app/editor.html',
        'X-Title': 'Agent Path Draft Editor'
      },
      body: JSON.stringify({
        model,
        temperature: 0.45,
        max_tokens: 1400,
        messages: buildMessages({ ...body, draft })
      })
    });

    const data = await response.json().catch(() => ({}));
    if (!response.ok) {
      const detail = data?.error?.message || `OpenRouter returned ${response.status}`;
      return send(res, 502, { ok: false, requestId: id, error: detail });
    }

    const edited = data?.choices?.[0]?.message?.content?.trim();
    if (!edited) return send(res, 502, { ok: false, requestId: id, error: 'Model returned an empty edit.' });

    return send(res, 200, { ok: true, requestId: id, edited, model });
  } catch (error) {
    return send(res, 502, { ok: false, requestId: id, error: error.message || 'Edit request failed.' });
  }
}

module.exports = handler;
module.exports.handler = handler;
module.exports.buildMessages = buildMessages;
