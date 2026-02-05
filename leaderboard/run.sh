#!/bin/bash

# Start the FastAPI leaderboard server
# Requires: pip install fastapi uvicorn

uvicorn leaderboard:app --host 0.0.0.0 --port 8000 --reload
