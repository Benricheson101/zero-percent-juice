# Build:   docker build -t leaderboard .
# Run:     docker run -v /path/to/data:/app/data -p 8000:8000 leaderboard
# Example: docker run -v ./leaderboard_data:/app/data -p 8000:8000 leaderboard
#
# The volume mount persists leaderboard.json at /app/data/leaderboard.json
# on the host at the specified path.

FROM python:3.11-slim

WORKDIR /app/code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py /app/code/

EXPOSE 8000

CMD ["python", "main.py", "/app/data/leaderboard.json"]
