import json
from fastapi import FastAPI
from pydantic import BaseModel


app = FastAPI()


class Node:
    def __init__(self, data):
        self.data = data
        self.next = None


class NameRequest(BaseModel):
    name: str
    score: int


@app.post("/submit/")
def submit(data: NameRequest):
    try:
        with open("top_10.txt", "r") as file:
            current_leaderboard = json.load(file)
    except FileNotFoundError:
        current_leaderboard = []

    new_entry = {"name": data.name, "score": data.score}
    current_leaderboard.append(new_entry)

    current_leaderboard.sort(key=lambda x: x["score"], reverse=True)

    current_leaderboard = current_leaderboard[:10]

    with open("top_10.txt", "w") as file:
        json.dump(current_leaderboard, file, indent=2)

    return {"message": "Submitted", "leaderboard": current_leaderboard}
