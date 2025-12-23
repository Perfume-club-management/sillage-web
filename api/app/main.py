import os
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {
        "status": "ok",
        "env": os.getenv("API_ENV", "unknown"),
    }
