#!/bin/bash
#
# install_fresh.sh — Full VPS setup for Agent Install customers
#
# For customers with a fresh Ubuntu VPS. Installs hermes-agent, configures
# Telegram gateway, and starts the agent.
#
# Usage (interactive — prompts for credentials):
#   bash scripts/install_fresh.sh
#
# Usage (non-interactive — pass credentials as args):
#   bash scripts/install_fresh.sh --api-key "sk-or-v1-..." --bot-token "123:ABC..." --model "google/gemini-2.5-flash"
#
# Can also be piped:
#   curl -sSL https://raw.githubusercontent.com/c-bottleson/agent-path/main/scripts/install_fresh.sh | bash
#

set -euo pipefail

# ─── Colors ─────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# ─── Parse Arguments ────────────────────────────────────────────────────────
API_KEY=""
BOT_TOKEN=""
MODEL="google/gemini-2.5-flash"
SKIP_TELEGRAM=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --api-key)    API_KEY="$2"; shift 2 ;;
        --bot-token)  BOT_TOKEN="$2"; shift 2 ;;
        --model)      MODEL="$2"; shift 2 ;;
        --no-telegram) SKIP_TELEGRAM=true; shift ;;
        -h|--help)
            echo "Usage: bash install_fresh.sh [--api-key KEY] [--bot-token TOKEN] [--model MODEL] [--no-telegram]"
            exit 0 ;;
        *) warn "Unknown option: $1"; shift ;;
    esac
done

# ─── Header ─────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  HERMES AGENT INSTALL — Fresh VPS Setup"
echo "════════════════════════════════════════════════════════════"
echo ""

# ─── System Check ───────────────────────────────────────────────────────────
info "Checking system requirements..."

if ! grep -q "Ubuntu\|Debian" /etc/os-release 2>/dev/null; then
    warn "This script is designed for Ubuntu/Debian. It may work on other systems but is untested."
fi

TOTAL_RAM_MB=$(free -m | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM_MB" -lt 1800 ]; then
    error "Need at least 2GB RAM. Found: ${TOTAL_RAM_MB}MB."
fi
ok "RAM: ${TOTAL_RAM_MB}MB"

AVAIL_DISK_GB=$(df -BG / | awk 'NR==2{print $4}' | tr -d 'G')
if [ "$AVAIL_DISK_GB" -lt 10 ]; then
    error "Need at least 10GB free disk. Found: ${AVAIL_DISK_GB}GB."
fi
ok "Disk: ${AVAIL_DISK_GB}GB available"

if [ "$EUID" -ne 0 ]; then
    error "Please run as root (sudo bash scripts/install_fresh.sh)"
fi
ok "Running as root"

# ─── System Packages ───────────────────────────────────────────────────────
info "Updating system packages..."
apt-get update -qq
apt-get upgrade -y -qq
apt-get install -y -qq git curl wget unzip build-essential > /dev/null 2>&1
ok "System packages installed"

# ─── Install Hermes Agent ──────────────────────────────────────────────────
info "Installing Hermes Agent..."

mkdir -p ~/.hermes
curl -fsSL https://raw.githubusercontent.com/NousResearch/hermes-agent/main/scripts/install.sh | bash -s -- --skip-setup

if command -v hermes &> /dev/null; then
    ok "Hermes installed: $(hermes --version 2>/dev/null || echo 'installed')"
else
    error "Hermes installation failed. Check the output above."
fi

# ─── Gather Credentials ────────────────────────────────────────────────────
echo ""
info "Configuring credentials..."

# Check if running interactively (stdin is a terminal)
if [ -t 0 ]; then
    # Interactive mode — prompt for missing values
    if [ -z "$API_KEY" ]; then
        read -rp "OpenRouter API Key (sk-or-v1-...): " API_KEY
    fi
    if [ -z "$BOT_TOKEN" ] && [ "$SKIP_TELEGRAM" = false ]; then
        read -rp "Telegram Bot Token (from @BotFather, or press Enter to skip): " BOT_TOKEN
        if [ -z "$BOT_TOKEN" ]; then
            SKIP_TELEGRAM=true
        fi
    fi
    if [ "$SKIP_TELEGRAM" = false ] && [ -n "$BOT_TOKEN" ]; then
        echo ""
        echo "  To find your Telegram User ID:"
        echo "  1. Open Telegram, search for @userinfobot"
        echo "  2. Send /start"
        echo "  3. It replies with your numeric ID"
        echo ""
        read -rp "Your Telegram User ID (numeric): " TELEGRAM_USER_ID
    fi
else
    # Non-interactive mode — credentials must be passed as args
    if [ -z "$API_KEY" ]; then
        error "No API key provided. Use --api-key flag or run interactively."
    fi
fi

if [ -z "$API_KEY" ]; then
    error "OpenRouter API key is required."
fi

# ─── Configure .env ────────────────────────────────────────────────────────
info "Writing environment configuration..."

cat << ENVFILE > ~/.hermes/.env
OPENROUTER_API_KEY=${API_KEY}
ENVFILE

if [ "$SKIP_TELEGRAM" = false ] && [ -n "$BOT_TOKEN" ]; then
    cat << ENVFILE >> ~/.hermes/.env
TELEGRAM_BOT_TOKEN=${BOT_TOKEN}
TELEGRAM_ALLOWED_USERS=${TELEGRAM_USER_ID:-REPLACE_WITH_USER_ID}
TELEGRAM_HOME_CHANNEL=${TELEGRAM_USER_ID:-REPLACE_WITH_USER_ID}
ENVFILE
    ok "Telegram configured"
else
    warn "Telegram skipped — agent will only work via CLI (run 'hermes' to chat)"
fi

# ─── Configure config.yaml ─────────────────────────────────────────────────
info "Writing agent configuration..."

cat << YAMLFILE > ~/.hermes/config.yaml
model:
  default: ${MODEL}
  provider: openrouter
YAMLFILE

ok "Config written"

# ─── Start Gateway ─────────────────────────────────────────────────────────
if [ "$SKIP_TELEGRAM" = false ] && [ -n "$BOT_TOKEN" ]; then
    info "Installing and starting Telegram gateway..."
    hermes gateway install
    hermes gateway start
    sleep 5

    if hermes gateway status 2>/dev/null | grep -qi "running\|active"; then
        ok "Gateway is running"
    else
        warn "Gateway may still be starting. Check: hermes gateway status"
    fi
else
    info "Testing CLI connection..."
    hermes chat -q "Hello, are you online?" || warn "CLI test failed — check your API key"
fi

# ─── Done ───────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  ✓ SETUP COMPLETE"
echo "════════════════════════════════════════════════════════════"
echo ""

if [ "$SKIP_TELEGRAM" = false ]; then
    echo "  Your agent is live on Telegram. Send it a message!"
    echo ""
    echo "  If it doesn't reply within 30 seconds:"
    echo "    1. Check your Telegram User ID is correct"
    echo "    2. Run: hermes gateway status"
    echo "    3. Run: tail -20 ~/.hermes/logs/agent.log"
else
    echo "  Your agent is running in CLI mode."
    echo "  Start chatting: hermes"
fi

echo ""
echo "  Useful commands:"
echo "    Chat via CLI:       hermes"
echo "    Check gateway:      hermes gateway status"
echo "    View logs:          tail -f ~/.hermes/logs/agent.log"
echo "    Restart gateway:    hermes gateway restart"
echo "    Edit config:        hermes config edit"
echo ""
echo "  Agent config: ~/.hermes/config.yaml"
echo "  API keys:     ~/.hermes/.env"
echo ""
