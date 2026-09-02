from fastapi import FastAPI
from models import orderCreate

app = FastAPI()


@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/orders")
def create_order(order: orderCreate):
    return order