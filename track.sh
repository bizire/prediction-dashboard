#!/bin/bash
# Portfolio tracker — run via cron every 15 minutes
# Collects data from Polymarket and pushes to GitHub

set -euo pipefail

TRADE_DIR=~/PolyMarketTrade
DASHBOARD_DIR=~/prediction-dashboard

source ~/.bashrc
export DASHBOARD_REPO="$DASHBOARD_DIR"

# Collect data
cd "$TRADE_DIR"
.venv/bin/python track_portfolio.py

# Commit & push
cd "$DASHBOARD_DIR"
git add data/portfolio.json
git diff --cached --quiet && exit 0
git commit -m "data: $(date -u '+%Y-%m-%d %H:%M') UTC"
git push origin main
