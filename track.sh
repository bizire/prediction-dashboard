#!/bin/bash
# Portfolio tracker — run via cron every 15 minutes
# Collects data from Polymarket and pushes to GitHub

set -e

TRADE_DIR="$HOME/PythonProjects/PolyMarketTrade"
DASHBOARD_DIR="$HOME/PythonProjects/prediction-dashboard"

cd "$TRADE_DIR"
source .venv/bin/activate
python track_portfolio.py

cd "$DASHBOARD_DIR"
git add data/portfolio.json
git diff --cached --quiet && exit 0  # nothing changed — skip commit
git commit -m "data: $(date -u '+%Y-%m-%d %H:%M') UTC"
git push
