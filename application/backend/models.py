from decimal import Decimal
from datetime import datetime
from pydantic import BaseModel, ConfigDict


class orderCreate(BaseModel):
    customer_name: str
    customer_email: str
    origin: str
    destination: str
    weight: float
    shipment_type: str

class orderResponse(BaseModel):
    id: int
    customer_name: str
    customer_email: str
    origin: str
    destination: str
    weight: float
    shipment_type: str
    weighted_cost: float
    price: Decimal
    status: str 
    created_at: datetime
    updated_at: datetime

model_config = ConfigDict(from_attributes=True)