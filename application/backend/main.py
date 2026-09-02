from fastapi import FastAPI, Depends
from models import orderCreate, orderResponse, orderUpdate
from database import engine
from sqlalchemy.orm import Session
from database import SessionLocal
import db_models

db_models.Base.metadata.create_all(bind=engine)


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def calculate_weighted_cost(weight: float, shipment_type: str) -> float:
    base_cost = 5.0  # Base cost for all shipments
    weight_cost = weight * 0.5  # Cost per kg
    type_multiplier = 1.0

    if shipment_type == "express":
        type_multiplier = 1.5
    elif shipment_type == "overnight":
        type_multiplier = 2.0

    return (base_cost + weight_cost) * type_multiplier
app = FastAPI()


@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.post("/orders", response_model=orderResponse, status_code=201)
def create_order(order: orderCreate, db: Session = Depends(get_db)):
    weighted_cost = calculate_weighted_cost(order.weight, order.shipment_type)
    price = weighted_cost * 1.2  # Assuming a 20% markup for the final price

    new_order = db_models.Order(
        customer_name=order.customer_name,
        customer_email=order.customer_email,
        origin=order.origin,
        destination=order.destination,
        weight=order.weight,
        shipment_type=order.shipment_type,
        weighted_cost=weighted_cost,
        price=price,
        status="pending"
    )
    db.add(new_order)
    db.commit()
    db.refresh(new_order)
    return new_order

@app.get("/orders", response_model=list[orderResponse])
def get_orders(db: Session = Depends(get_db)):
    orders = db.query(db_models.Order).all()
    return orders

@app.get("/orders/{order_id}", response_model=orderResponse)
def get_order(order_id: int, db: Session = Depends(get_db)):
    order = db.query(db_models.Order).filter(db_models.Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    return order

@app.patch("/orders/{order_id}", response_model=orderResponse)
def update_order(order_id: int, order_update: orderUpdate, db: Session = Depends(get_db)):
    order = db.query(db_models.Order).filter(db_models.Order.id == order_id).first()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    for key, value in order_update.dict(exclude_unset=True).items():
        setattr(order, key, value)

    db.commit()
    db.refresh(order)
    return order