import json
import os
import sys
from typing import List

import fastapi
import uvicorn
from pydantic import BaseModel


app = fastapi.FastAPI()


class ScoreEntry(BaseModel):
    name: str
    score: float


def get_leaderboard_file() -> str:
    if len(sys.argv) > 1:
        return sys.argv[1]
    return "leaderboard.json"


def load_leaderboard() -> List[dict]:
    leaderboard_file = get_leaderboard_file()
    if not os.path.exists(leaderboard_file):
        with open(leaderboard_file, "w") as f:
            json.dump([], f)
        return []
    with open(leaderboard_file, "r") as f:
        return json.load(f)


def save_leaderboard(leaderboard: List[dict]) -> None:
    leaderboard_file = get_leaderboard_file()
    with open(leaderboard_file, "w") as f:
        json.dump(leaderboard, f, indent=2)


@app.get("/leaderboard")
def get_leaderboard() -> List[dict]:
    return load_leaderboard()


@app.post("/score")
def add_score(entry: ScoreEntry) -> List[dict]:
    leaderboard = load_leaderboard()

    leaderboard.append({"name": entry.name, "score": entry.score})

    # After appending we sort and take only the best 10
    # in descending
    leaderboard = sorted(
        leaderboard, key=lambda x: x["score"], reverse=True)[:10]

    save_leaderboard(leaderboard)

    return leaderboard


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
