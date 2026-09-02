from fastapi import FastAPI
from models import orderCreate
from database import engine
import db_models

db_models.Base.metadata.create_all(bind=engine)

app = FastAPI()


@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/orders")
def create_order(order: orderCreate):
    return order