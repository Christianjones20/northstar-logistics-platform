import { useEffect, useState } from "react";
import "./App.css";

const API_URL = "http://127.0.0.1:8000";

const initialFormData = {
  customer_name: "",
  customer_email: "",
  origin: "",
  destination: "",
  shipment_type: "Standard",
  weight: "",
};

const shipmentTypes = [
  "Standard",
  "Express",
  "Overnight",
];

const orderStatuses = [
  "Pending",
  "Processing",
  "Shipped",
  "In Transit",
  "Delivered",
  "Cancelled",
];


function App() {
  // --------------------------------------------------
  // State
  // --------------------------------------------------

  const [formData, setFormData] = useState(initialFormData);

  const [orders, setOrders] = useState([]);

  const [loading, setLoading] = useState(false);
  const [ordersLoading, setOrdersLoading] = useState(false);

  const [error, setError] = useState("");
  const [successMessage, setSuccessMessage] = useState("");

  const [editingOrder, setEditingOrder] = useState(null);

  const [editFormData, setEditFormData] = useState({
    customer_name: "",
    customer_email: "",
    origin: "",
    destination: "",
    shipment_type: "Standard",
    weight: "",
    status: "Pending",
  });


  // --------------------------------------------------
  // Fetch Orders
  // --------------------------------------------------

  const fetchOrders = async () => {
    setOrdersLoading(true);

    try {
      const response = await fetch(`${API_URL}/orders`);

      if (!response.ok) {
        throw new Error("Failed to fetch orders.");
      }

      const data = await response.json();

      setOrders(data);
    } catch (err) {
      console.error(err);

      setError(
        "Unable to load orders. Make sure the FastAPI backend is running."
      );
    } finally {
      setOrdersLoading(false);
    }
  };


  // --------------------------------------------------
  // Load Orders on Page Load
  // --------------------------------------------------

  useEffect(() => {
    fetchOrders();
  }, []);


  // --------------------------------------------------
  // Handle Create Form Changes
  // --------------------------------------------------

  const handleChange = (event) => {
    const { name, value } = event.target;

    setFormData((previousData) => ({
      ...previousData,
      [name]: value,
    }));
  };


  // --------------------------------------------------
  // Create Order
  // --------------------------------------------------

  const handleSubmit = async (event) => {
    event.preventDefault();

    setLoading(true);
    setError("");
    setSuccessMessage("");

    const orderData = {
      ...formData,
      weight: Number(formData.weight),
    };

    try {
      const response = await fetch(`${API_URL}/orders`, {
        method: "POST",

        headers: {
          "Content-Type": "application/json",
        },

        body: JSON.stringify(orderData),
      });

      if (!response.ok) {
        const errorData = await response.json();

        console.error("Create order error:", errorData);

        throw new Error(getBackendError(errorData));
      }

      const createdOrder = await response.json();

      setSuccessMessage(
        `Order #${createdOrder.id} was created successfully for ${createdOrder.customer_name}.`
      );

      setFormData(initialFormData);

      await fetchOrders();
    } catch (err) {
      console.error(err);

      setError(
        err.message ||
          "Unable to create order. Please check the information and try again."
      );
    } finally {
      setLoading(false);
    }
  };


  // --------------------------------------------------
  // Open Edit Modal
  // --------------------------------------------------

  const handleEditClick = (order) => {
    setError("");
    setSuccessMessage("");

    setEditingOrder(order);

    setEditFormData({
      customer_name: order.customer_name,
      customer_email: order.customer_email,
      origin: order.origin,
      destination: order.destination,
      shipment_type: order.shipment_type,
      weight: order.weight,
      status: order.status,
    });
  };


  // --------------------------------------------------
  // Handle Edit Form Changes
  // --------------------------------------------------

  const handleEditChange = (event) => {
    const { name, value } = event.target;

    setEditFormData((previousData) => ({
      ...previousData,
      [name]: value,
    }));
  };


  // --------------------------------------------------
  // Update Order
  // --------------------------------------------------

  const handleUpdateOrder = async (event) => {
    event.preventDefault();

    if (!editingOrder) {
      return;
    }

    setLoading(true);
    setError("");
    setSuccessMessage("");

    const updatedOrderData = {
      ...editFormData,
      weight: Number(editFormData.weight),
    };

    try {
      const response = await fetch(
        `${API_URL}/orders/${editingOrder.id}`,
        {
          method: "PATCH",

          headers: {
            "Content-Type": "application/json",
          },

          body: JSON.stringify(updatedOrderData),
        }
      );

      if (!response.ok) {
        const errorData = await response.json();

        console.error("Update order error:", errorData);

        throw new Error(getBackendError(errorData));
      }

      const updatedOrder = await response.json();

      setSuccessMessage(
        `Order #${updatedOrder.id} was updated successfully.`
      );

      setEditingOrder(null);

      await fetchOrders();
    } catch (err) {
      console.error(err);

      setError(
        err.message ||
          "Unable to update order. Please try again."
      );
    } finally {
      setLoading(false);
    }
  };


  // --------------------------------------------------
  // Cancel Order
  // --------------------------------------------------

  const handleCancelOrder = async (order) => {
    const confirmed = window.confirm(
      `Are you sure you want to cancel Order #${order.id}?`
    );

    if (!confirmed) {
      return;
    }

    setError("");
    setSuccessMessage("");

    try {
      const response = await fetch(
        `${API_URL}/orders/${order.id}`,
        {
          method: "DELETE",
        }
      );

      if (!response.ok) {
        const errorData = await response.json();

        console.error("Cancel order error:", errorData);

        throw new Error(getBackendError(errorData));
      }

      setSuccessMessage(
        `Order #${order.id} was cancelled successfully.`
      );

      await fetchOrders();
    } catch (err) {
      console.error(err);

      setError(
        err.message ||
          "Unable to cancel order. Please try again."
      );
    }
  };


  // --------------------------------------------------
  // Backend Error Formatter
  // --------------------------------------------------

  const getBackendError = (errorData) => {
    if (!errorData) {
      return "An unexpected error occurred.";
    }

    if (typeof errorData.detail === "string") {
      return errorData.detail;
    }

    if (Array.isArray(errorData.detail)) {
      return errorData.detail
        .map((item) => item.msg)
        .join(", ");
    }

    return "An unexpected error occurred.";
  };


  // --------------------------------------------------
  // Status CSS Class
  // --------------------------------------------------

  const getStatusClass = (status) => {
    if (!status) {
      return "status-default";
    }

    return `status-${status
      .toLowerCase()
      .replaceAll(" ", "-")}`;
  };


  // --------------------------------------------------
  // UI
  // --------------------------------------------------

  return (
    <div className="app">

      {/* -------------------------------------------
          Header
      -------------------------------------------- */}

      <header className="topbar">

        <div className="brand">
          <div className="brand-mark">N</div>

          <div>
            <h1>NorthStar Logistics</h1>
            <p>Order Management Platform</p>
          </div>
        </div>

        <div className="environment-badge">
          Local Development
        </div>

      </header>


      <main className="page-container">

        {/* -------------------------------------------
            Page Heading
        -------------------------------------------- */}

        <section className="page-heading">

          <div>
            <p className="eyebrow">
              OPERATIONS
            </p>

            <h2>
              Shipment Management
            </h2>

            <p className="page-description">
              Create, manage, update, and track NorthStar
              customer shipment orders.
            </p>
          </div>

        </section>


        {/* -------------------------------------------
            Notifications
        -------------------------------------------- */}

        {successMessage && (
          <div className="alert alert-success">

            <span className="alert-icon">
              ✓
            </span>

            <span>
              {successMessage}
            </span>

            <button
              type="button"
              className="alert-close"
              onClick={() => setSuccessMessage("")}
            >
              ×
            </button>

          </div>
        )}


        {error && (
          <div className="alert alert-error">

            <span className="alert-icon">
              !
            </span>

            <span>
              {error}
            </span>

            <button
              type="button"
              className="alert-close"
              onClick={() => setError("")}
            >
              ×
            </button>

          </div>
        )}


        {/* -------------------------------------------
            Summary Cards
        -------------------------------------------- */}

        <section className="stats-grid">

          <div className="stat-card">
            <span className="stat-label">
              Total Orders
            </span>

            <span className="stat-value">
              {orders.length}
            </span>
          </div>


          <div className="stat-card">
            <span className="stat-label">
              Active Orders
            </span>

            <span className="stat-value">
              {
                orders.filter(
                  (order) =>
                    order.status?.toLowerCase() !==
                      "cancelled" &&
                    order.status?.toLowerCase() !==
                      "delivered"
                ).length
              }
            </span>
          </div>


          <div className="stat-card">
            <span className="stat-label">
              Delivered
            </span>

            <span className="stat-value">
              {
                orders.filter(
                  (order) =>
                    order.status?.toLowerCase() ===
                    "delivered"
                ).length
              }
            </span>
          </div>


          <div className="stat-card">
            <span className="stat-label">
              Cancelled
            </span>

            <span className="stat-value">
              {
                orders.filter(
                  (order) =>
                    order.status?.toLowerCase() ===
                    "cancelled"
                ).length
              }
            </span>
          </div>

        </section>


        {/* -------------------------------------------
            Create Order Card
        -------------------------------------------- */}

        <section className="card">

          <div className="card-header">

            <div>
              <h3>Create Shipment Order</h3>

              <p>
                Enter the shipment information below.
                Pricing is calculated automatically.
              </p>
            </div>

          </div>


          <form
            className="order-form"
            onSubmit={handleSubmit}
          >

            <div className="form-grid">

              {/* Customer Name */}

              <div className="form-group">

                <label htmlFor="customer_name">
                  Customer Name
                </label>

                <input
                  type="text"
                  id="customer_name"
                  name="customer_name"
                  value={formData.customer_name}
                  onChange={handleChange}
                  placeholder="ABC Manufacturing"
                  required
                />

              </div>


              {/* Customer Email */}

              <div className="form-group">

                <label htmlFor="customer_email">
                  Customer Email
                </label>

                <input
                  type="email"
                  id="customer_email"
                  name="customer_email"
                  value={formData.customer_email}
                  onChange={handleChange}
                  placeholder="shipping@abc.com"
                  required
                />

              </div>


              {/* Origin */}

              <div className="form-group">

                <label htmlFor="origin">
                  Origin
                </label>

                <input
                  type="text"
                  id="origin"
                  name="origin"
                  value={formData.origin}
                  onChange={handleChange}
                  placeholder="Richmond, VA"
                  required
                />

              </div>


              {/* Destination */}

              <div className="form-group">

                <label htmlFor="destination">
                  Destination
                </label>

                <input
                  type="text"
                  id="destination"
                  name="destination"
                  value={formData.destination}
                  onChange={handleChange}
                  placeholder="Charlotte, NC"
                  required
                />

              </div>


              {/* Shipment Type */}

              <div className="form-group">

                <label htmlFor="shipment_type">
                  Shipment Type
                </label>

                <select
                  id="shipment_type"
                  name="shipment_type"
                  value={formData.shipment_type}
                  onChange={handleChange}
                  required
                >

                  {shipmentTypes.map((type) => (
                    <option
                      key={type}
                      value={type}
                    >
                      {type}
                    </option>
                  ))}

                </select>

              </div>


              {/* Weight */}

              <div className="form-group">

                <label htmlFor="weight">
                  Weight (lbs)
                </label>

                <input
                  type="number"
                  id="weight"
                  name="weight"
                  value={formData.weight}
                  onChange={handleChange}
                  min="0.01"
                  step="0.01"
                  placeholder="500"
                  required
                />

              </div>

            </div>


            <div className="form-actions">

              <button
                type="submit"
                className="button button-primary"
                disabled={loading}
              >

                {loading
                  ? "Creating Order..."
                  : "Create Order"}

              </button>

            </div>

          </form>

        </section>


        {/* -------------------------------------------
            Orders Dashboard
        -------------------------------------------- */}

        <section className="card">

          <div className="card-header dashboard-header">

            <div>
              <h3>Orders Dashboard</h3>

              <p>
                View and manage customer shipment orders.
              </p>
            </div>


            <button
              type="button"
              className="button button-secondary"
              onClick={fetchOrders}
              disabled={ordersLoading}
            >

              {ordersLoading
                ? "Refreshing..."
                : "Refresh Orders"}

            </button>

          </div>


          {/* Loading */}

          {ordersLoading && orders.length === 0 ? (

            <div className="empty-state">
              <div className="spinner"></div>

              <p>
                Loading orders...
              </p>
            </div>

          ) : orders.length === 0 ? (

            /* No Orders */

            <div className="empty-state">

              <div className="empty-icon">
                📦
              </div>

              <h4>
                No orders yet
              </h4>

              <p>
                Create your first shipment order above.
              </p>

            </div>

          ) : (

            /* Orders Table */

            <div className="table-container">

              <table className="orders-table">

                <thead>

                  <tr>
                    <th>Order</th>
                    <th>Customer</th>
                    <th>Route</th>
                    <th>Shipment</th>
                    <th>Weight</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>

                </thead>


                <tbody>

                  {orders.map((order) => (

                    <tr key={order.id}>

                      {/* ID */}

                      <td>
                        <span className="order-number">
                          #{order.id}
                        </span>
                      </td>


                      {/* Customer */}

                      <td>

                        <div className="customer-cell">

                          <strong>
                            {order.customer_name}
                          </strong>

                          <span>
                            {order.customer_email}
                          </span>

                        </div>

                      </td>


                      {/* Route */}

                      <td>

                        <div className="route-cell">

                          <span>
                            {order.origin}
                          </span>

                          <span className="route-arrow">
                            →
                          </span>

                          <span>
                            {order.destination}
                          </span>

                        </div>

                      </td>


                      {/* Type */}

                      <td>
                        {order.shipment_type}
                      </td>


                      {/* Weight */}

                      <td>
                        {Number(order.weight).toLocaleString()} lbs
                      </td>


                      {/* Price */}

                      <td className="price">
                        $
                        {Number(order.price).toFixed(2)}
                      </td>


                      {/* Status */}

                      <td>

                        <span
                          className={`status-badge ${getStatusClass(
                            order.status
                          )}`}
                        >
                          {order.status}
                        </span>

                      </td>


                      {/* Actions */}

                      <td>

                        <div className="action-buttons">

                          <button
                            type="button"
                            className="button button-small button-edit"
                            onClick={() =>
                              handleEditClick(order)
                            }
                          >
                            Edit
                          </button>


                          <button
                            type="button"
                            className="button button-small button-cancel"
                            onClick={() =>
                              handleCancelOrder(order)
                            }
                            disabled={
                              order.status?.toLowerCase() ===
                              "cancelled"
                            }
                          >
                            {order.status?.toLowerCase() ===
                            "cancelled"
                              ? "Cancelled"
                              : "Cancel"}
                          </button>

                        </div>

                      </td>

                    </tr>

                  ))}

                </tbody>

              </table>

            </div>

          )}

        </section>

      </main>


      {/* -------------------------------------------
          Edit Order Modal
      -------------------------------------------- */}

      {editingOrder && (

        <div className="modal-overlay">

          <div className="modal">

            <div className="modal-header">

              <div>

                <p className="eyebrow">
                  EDIT ORDER
                </p>

                <h3>
                  Order #{editingOrder.id}
                </h3>

              </div>


              <button
                type="button"
                className="modal-close"
                onClick={() =>
                  setEditingOrder(null)
                }
              >
                ×
              </button>

            </div>


            <form
              onSubmit={handleUpdateOrder}
              className="order-form"
            >

              <div className="form-grid">


                {/* Name */}

                <div className="form-group">

                  <label>
                    Customer Name
                  </label>

                  <input
                    type="text"
                    name="customer_name"
                    value={
                      editFormData.customer_name
                    }
                    onChange={handleEditChange}
                    required
                  />

                </div>


                {/* Email */}

                <div className="form-group">

                  <label>
                    Customer Email
                  </label>

                  <input
                    type="email"
                    name="customer_email"
                    value={
                      editFormData.customer_email
                    }
                    onChange={handleEditChange}
                    required
                  />

                </div>


                {/* Origin */}

                <div className="form-group">

                  <label>
                    Origin
                  </label>

                  <input
                    type="text"
                    name="origin"
                    value={editFormData.origin}
                    onChange={handleEditChange}
                    required
                  />

                </div>


                {/* Destination */}

                <div className="form-group">

                  <label>
                    Destination
                  </label>

                  <input
                    type="text"
                    name="destination"
                    value={editFormData.destination}
                    onChange={handleEditChange}
                    required
                  />

                </div>


                {/* Shipment Type */}

                <div className="form-group">

                  <label>
                    Shipment Type
                  </label>

                  <select
                    name="shipment_type"
                    value={
                      editFormData.shipment_type
                    }
                    onChange={handleEditChange}
                    required
                  >

                    {shipmentTypes.map((type) => (

                      <option
                        key={type}
                        value={type}
                      >
                        {type}
                      </option>

                    ))}

                  </select>

                </div>


                {/* Weight */}

                <div className="form-group">

                  <label>
                    Weight (lbs)
                  </label>

                  <input
                    type="number"
                    name="weight"
                    value={editFormData.weight}
                    onChange={handleEditChange}
                    min="0.01"
                    step="0.01"
                    required
                  />

                </div>


                {/* Status */}

                <div className="form-group form-group-full">

                  <label>
                    Order Status
                  </label>

                  <select
                    name="status"
                    value={editFormData.status}
                    onChange={handleEditChange}
                    required
                  >

                    {orderStatuses.map((status) => (

                      <option
                        key={status}
                        value={status}
                      >
                        {status}
                      </option>

                    ))}

                  </select>

                </div>

              </div>


              <div className="modal-actions">

                <button
                  type="button"
                  className="button button-secondary"
                  onClick={() =>
                    setEditingOrder(null)
                  }
                >
                  Close
                </button>


                <button
                  type="submit"
                  className="button button-primary"
                  disabled={loading}
                >

                  {loading
                    ? "Saving..."
                    : "Save Changes"}

                </button>

              </div>

            </form>

          </div>

        </div>

      )}


      {/* -------------------------------------------
          Footer
      -------------------------------------------- */}

      <footer className="footer">

        <p>
          NorthStar Logistics Order Management Platform
        </p>

      </footer>

    </div>
  );
}


export default App;