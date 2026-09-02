from decimal import Decimal
from enum import Enum
from typing import Optional
from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field, EmailStr


class ShipmentType(str, Enum):
    standard = "Standard"
    express = "Express"
    overnight = "Overnight"


class OrderStatus(str, Enum):
    PENDING = "Pending"
    SHIPPED = "Shipped"
    DELIVERED = "Delivered"
    CANCELLED = "Cancelled"
    IN_TRANSIT = "In Transit"
    PROCESSING = "Processing"


class orderCreate(BaseModel):
    customer_name: str
    customer_email: EmailStr
    origin: str
    destination: str
    weight: float = Field(
        ...,
        gt=0,
        description="Weight of the shipment in kg"
    )
    shipment_type: ShipmentType


class orderUpdate(BaseModel):
    customer_name: Optional[str] = None
    customer_email: Optional[EmailStr] = None
    origin: Optional[str] = None
    destination: Optional[str] = None
    weight: Optional[float] = Field(default=None, gt=0)
    shipment_type: Optional[ShipmentType] = None
    status: Optional[OrderStatus] = None


class orderResponse(BaseModel):
    id: int
    customer_name: str
    customer_email: str
    origin: str
    destination: str
    weight: float
    shipment_type: ShipmentType
    weighted_cost: float
    price: Decimal
    status: OrderStatus
    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)