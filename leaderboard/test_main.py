from fastapi.testclient import TestClient
from main import app, get_db
import sqlite3 as sql
import pytest


@pytest.fixture
def test_db():
    # Creates a db in memory to not affect real db
    conn = sql.connect(":memory:", check_same_thread=False)
    conn.execute(
        "CREATE TABLE leaderboard (id INTEGER PRIMARY KEY, name TEXT, score INTEGER)")
    yield conn
    conn.close()


@pytest.fixture
def client(test_db):
    def override_get_db():
        try:
            yield test_db
        finally:
            pass
    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()


def test_get_leaderboard_empty(client):
    response = client.get("/leaderboard")
    assert response.status_code == 200
    assert response.json() == []


def test_add_score(client):
    response = client.post("/score", json={"name": "Alice", "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert data[0]["name"] == "Alice"
    assert data[0]["score"] == 100


def test_leaderboard_order(client):
    client.post("/score", json={"name": "Bob", "score": 50})
    client.post("/score", json={"name": "Alice", "score": 100})
    response = client.get("/leaderboard")
    data = response.json()
    assert data[0]["name"] == "Alice"
    assert data[0]["score"] == 100
    assert data[1]["name"] == "Bob"
    assert data[1]["score"] == 50


def test_sql_injection_prevention(client):
    response = client.post(
        "/score", json={"name": "'; DROP TABLE leaderboard; --", "score": 100})
    assert response.status_code == 200
    response = client.get("/leaderboard")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 1
    assert data[0]["name"] == "'; DROP TABLE leaderboard; --"


def test_drop_table_as_name_preserves_table(client, test_db):
    client.post(
        "/score", json={"name": "DROP TABLE leaderboard", "score": 100})
    result = test_db.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='leaderboard'").fetchone()
    assert result is not None, "Table was dropped - SQL injection successful!"


def test_empty_name(client):
    response = client.post("/score", json={"name": "", "score": 100})
    assert response.status_code == 400


def test_whitespace_only_name(client):
    response = client.post("/score", json={"name": "   ", "score": 100})
    assert response.status_code == 400


def test_unicode_name(client):
    response = client.post("/score", json={"name": "🎮 gamer123", "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert data[0]["name"] == "🎮 gamer123"


def test_long_name(client):
    long_name = "a" * 10000
    response = client.post("/score", json={"name": long_name, "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert len(data[0]["name"]) == 10000


def test_trim_leading_space(client):
    response = client.post("/score", json={"name": " Alice", "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert data[0]["name"] == "Alice"


def test_trim_trailing_space(client):
    response = client.post("/score", json={"name": "Alice ", "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert data[0]["name"] == "Alice"


def test_trim_both_spaces(client):
    response = client.post("/score", json={"name": " Alice ", "score": 100})
    assert response.status_code == 200
    data = response.json()
    assert data[0]["name"] == "Alice"


# For now the db allows for the same name (spelling, case, everything)
# hence Alice can be entered twice (this is a design decision I will stick
# with until I inevitavly decide another path)
def test_trim_prevents_duplicate(client):
    client.post("/score", json={"name": "Alice", "score": 100})
    client.post("/score", json={"name": " Alice", "score": 200})
    response = client.get("/leaderboard")
    data = response.json()
    assert len(data) == 2
    assert data[0]["name"] == "Alice"
    assert data[0]["score"] == 200
    assert data[1]["name"] == "Alice"
    assert data[1]["score"] == 100
