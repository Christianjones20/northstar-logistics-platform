from decimal import Decimal
from datetime import datetime
from pydantic import BaseModel, ConfigDict
from typing import Optional
from pydantic import BaseModel, Field



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

class orderUpdate(BaseModel):
    customer_name: Optional[str] = None
    customer_email: Optional[str] = None
    origin: Optional[str] = None
    destination: Optional[str] = None
    weight: Optional[float] = None
    shipment_type: Optional[str] = None
    status: Optional[str] = None

model_config = ConfigDict(from_attributes=True)