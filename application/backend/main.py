from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from models import (
    orderCreate,
    orderResponse,
    orderUpdate,
    ShipmentType,
    OrderStatus,
)

from database import engine, SessionLocal
import db_models


# Create database tables
db_models.Base.metadata.create_all(bind=engine)


# Create FastAPI application
app = FastAPI(
    title="NorthStar Logistics API",
    description="Order Management API for NorthStar Logistics",
    version="1.0.0",
)


# Allow React frontend to communicate with FastAPI
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:5173",
        "http://127.0.0.1:5173",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Database dependency
def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()


# Shipping cost calculation
def calculate_weighted_cost(
    weight: float,
    shipment_type: ShipmentType,
) -> float:

    base_cost = 5.0
    weight_cost = weight * 0.5

    type_multiplier = 1.0

    if shipment_type == ShipmentType.express:
        type_multiplier = 1.5

    elif shipment_type == ShipmentType.overnight:
        type_multiplier = 2.0

    return (base_cost + weight_cost) * type_multiplier


# -------------------------
# HEALTH CHECK
# -------------------------

@app.get("/health")
def health_check():
    return {
        "status": "healthy"
    }


# -------------------------
# CREATE ORDER
# -------------------------

@app.post(
    "/orders",
    response_model=orderResponse,
    status_code=201,
)
def create_order(
    order: orderCreate,
    db: Session = Depends(get_db),
):

    weighted_cost = calculate_weighted_cost(
        order.weight,
        order.shipment_type,
    )

    price = weighted_cost * 1.2

    new_order = db_models.Order(
        customer_name=order.customer_name,
        customer_email=order.customer_email,
        origin=order.origin,
        destination=order.destination,
        weight=order.weight,
        shipment_type=order.shipment_type.value,
        weighted_cost=weighted_cost,
        price=price,
        status=OrderStatus.PENDING.value,
    )

    db.add(new_order)
    db.commit()
    db.refresh(new_order)

    return new_order


# -------------------------
# GET ALL ORDERS
# -------------------------

@app.get(
    "/orders",
    response_model=list[orderResponse],
)
def get_orders(
    db: Session = Depends(get_db),
):

    orders = db.query(db_models.Order).all()

    return orders


# -------------------------
# GET ONE ORDER
# -------------------------

@app.get(
    "/orders/{order_id}",
    response_model=orderResponse,
)
def get_order(
    order_id: int,
    db: Session = Depends(get_db),
):

    order = (
        db.query(db_models.Order)
        .filter(db_models.Order.id == order_id)
        .first()
    )

    if order is None:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    return order


# -------------------------
# UPDATE ORDER
# -------------------------

@app.patch(
    "/orders/{order_id}",
    response_model=orderResponse,
)
def update_order(
    order_id: int,
    order_update: orderUpdate,
    db: Session = Depends(get_db),
):

    order = (
        db.query(db_models.Order)
        .filter(db_models.Order.id == order_id)
        .first()
    )

    if order is None:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    update_data = order_update.model_dump(
        exclude_unset=True
    )

    # Convert Enum values into strings before saving
    if "shipment_type" in update_data:
        update_data["shipment_type"] = (
            update_data["shipment_type"].value
        )

    if "status" in update_data:
        update_data["status"] = (
            update_data["status"].value
        )

    # Apply updates
    for key, value in update_data.items():
        setattr(order, key, value)

    # Recalculate weighted cost and price
    order.weighted_cost = calculate_weighted_cost(
        order.weight,
        ShipmentType(order.shipment_type),
    )

    order.price = order.weighted_cost * 1.2

    db.commit()
    db.refresh(order)

    return order


# -------------------------
# DELETE ORDER
# -------------------------

@app.delete(
    "/orders/{order_id}",
    status_code=204,
)
def delete_order(
    order_id: int,
    db: Session = Depends(get_db),
):

    order = (
        db.query(db_models.Order)
        .filter(db_models.Order.id == order_id)
        .first()
    )

    if order is None:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    # Already cancelled
    if order.status == OrderStatus.CANCELLED.value:
        raise HTTPException(
            status_code=400,
            detail="Order is already cancelled",
        )

    # Prevent deletion once shipping has started
    if order.status in [
        OrderStatus.SHIPPED.value,
        OrderStatus.IN_TRANSIT.value,
    ]:
        raise HTTPException(
            status_code=400,
            detail="Shipped or in-transit orders cannot be deleted",
        )

    db.delete(order)
    db.commit()

    return None