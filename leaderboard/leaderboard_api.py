import os
import sqlite3 as sql
from typing import List
import fastapi
from fastapi import Depends, HTTPException
import uvicorn
from pydantic import BaseModel


app = fastapi.FastAPI()


class ScoreEntry(BaseModel):
    name: str
    score: float


def get_db():
    # Checks if docker or local db exists
    db_path = "data/leaderboard_data.db" if os.path.exists(
        "/app") else "./data/leaderboard_data.db"
    conn = sql.connect(db_path)
    # Creates the table if it does not exist yet
    conn.execute(
        "CREATE TABLE IF NOT EXISTS leaderboard (id INTEGER PRIMARY KEY, name TEXT NOT NULL, score INTEGER NOT NULL)")
    try:
        yield conn
    finally:
        conn.close()


@app.get("/leaderboard")
def get_leaderboard(db: sql.Connection = Depends(get_db)) -> List[dict]:
    cursor = db.cursor()
    cursor.execute(
        "select name, score from leaderboard order by score desc limit 10")
    result = cursor.fetchall()
    return [{"name": row[0], "score": row[1]} for row in result]


@app.post("/score")
def add_score(entry: ScoreEntry, db: sql.Connection = Depends(get_db)) -> List[dict]:
    if not entry.name.strip():
        raise HTTPException(
            status_code=400, detail="Name cannot be empty or whitespace")
    cursor = db.cursor()
    cursor.execute(
        "insert into leaderboard (name, score) values (?, ?)", (entry.name.strip(), entry.score))
    db.commit()
    cursor.execute(
        "select name, score from leaderboard order by score desc limit 10")
    result = cursor.fetchall()
    return [{"name": row[0], "score": row[1]} for row in result]


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
