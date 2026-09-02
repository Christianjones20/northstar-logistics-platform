from pydantic import BaseModel


class orderCreate(BaseModel):
    customer_name: str
    customer_email: str
    origin: str
    destination: str
    destination: str
    shipment_type: str