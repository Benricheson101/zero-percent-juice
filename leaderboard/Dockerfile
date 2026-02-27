# Build:   docker build -t leaderboard .
# Run:     docker run -v $(pwd):/app -p 8000:8000 --name <container name> <image name>
#
# Mounts current directory to /app so main.py and leaderboard_data.db are accessible.

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY leaderboard_api.py /app/

EXPOSE 8000

CMD ["python", "leaderboard_api.py"]
