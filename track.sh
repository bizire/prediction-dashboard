#!/bin/bash
# Portfolio tracker — run via cron every 15 minutes
# Collects data from Polymarket and pushes to GitHub

set -euo pipefail

TRADE_DIR=~/PolyMarketTrade
DASHBOARD_DIR=~/prediction-dashboard

export ENV_KEY="$(grep -E '^export ENV_KEY=' ~/.bashrc | head -1 | sed 's/^export ENV_KEY=//' | tr -d '"')"
export DASHBOARD_REPO="$DASHBOARD_DIR"

# Start from the latest dashboard state before appending a new point.
cd "$DASHBOARD_DIR"
git pull --rebase --autostash origin main

# Collect data
cd "$TRADE_DIR"
.venv/bin/python track_portfolio.py

# Commit & push
cd "$DASHBOARD_DIR"
git add data/portfolio.json
git diff --cached --quiet && exit 0
git commit -m "data: $(date -u '+%Y-%m-%d %H:%M') UTC"
git pull --rebase --autostash origin main
git push origin main
