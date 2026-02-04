#!/bin/bash

echo "=== Deleting existing leaderboard file ==="
rm -f top_10.txt
echo "File deleted"
echo -e "\n"

echo "=== Test 1: Add first entry (file doesn't exist) ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Alice", "score": 100}'
echo -e "\n"

echo "=== Test 2: Add second entry ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Bob", "score": 95}'
echo -e "\n"

echo "=== Test 3: Add lower score (should be ranked lower) ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Charlie", "score": 80}'
echo -e "\n"

echo "=== Test 4: Add middle score ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Diana", "score": 90}'
echo -e "\n"

echo "=== Test 5-12: Add 8 more entries to fill up top 10 ==="
for i in {5..12}; do
  curl -X POST http://localhost:8000/submit/ \
    -H "Content-Type: application/json" \
    -d "{\"name\": \"Player$i\", \"score\": $((100 - i))}"
  echo -e "\n"
done

echo "=== Test 13: Add high score (should be #1) ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Champion", "score": 150}'
echo -e "\n"

echo "=== Test 14: Add low score (should NOT be in top 10) ==="
curl -X POST http://localhost:8000/submit/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Loser", "score": 10}'
echo -e "\n"

echo "=== Checking final leaderboard in file ==="
cat top_10.txt
