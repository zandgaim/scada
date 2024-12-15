defmodule ScadaWeb.Pages.ConnectionLive do
  use Phoenix.LiveView
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    # Subscribe to connection_status topic for updates from PythonPort
    PubSub.subscribe(Scada.PubSub, "connection_status")

    # Initialize connection state with a default message and empty field input
    {:ok,
     assign(socket,
       status: "waiting",
       message: "Not connected to machine",
       field_name: "",
       last_status: nil,
       last_message: nil,
       data: nil
     )}
  end

  def render(assigns) do
    ~L"""
    <div id="connection-status" class="connection-container">
      <header class="full-width-header">
        <h2>Connection Status: <%= @status %></h2>
        <p class="status-message"><%= @message %></p>
      </header>

      <!-- Field Input Form -->
      <div class="field-input">
        <form phx-submit="fetch_data">
          <label for="field_name">Enter Field Name:</label>
          <input type="text" id="field_name" name="field_name" phx-change="validate_field" value="<%= @field_name %>" />
          <button type="submit">Query</button>
        </form>
      </div>

      <div class="context-placeholder">
        <%= if @data do %>
          <ul>
            <%= for {key, value} <- @data do %>
              <li><strong><%= key %>:</strong> <%= value %></li>
            <% end %>
          </ul>
        <% else %>
          <p>No data available</p>
        <% end %>
      </div>
      </div>
    </div>

    <style>
      /* Full width header */
      .full-width-header {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        background-color: #007B8C;
        color: white;
        padding: 5px 0;
        text-align: center;
        font-family: 'Arial', sans-serif;
        font-size: 16px;
        z-index: 1000;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      }

      .status-message {
        font-size: 10px;
        color: #D1E5E5;
        margin-top: 2px;
      }

      .connection-container {
        margin-top: 60px;
        padding: 20px;
        text-align: center;
      }

      .field-input {
        margin-top: 30px;
        font-size: 14px;
      }

      .field-input input {
        padding: 8px;
        font-size: 14px;
        width: 200px;
        margin-right: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
      }

      .field-input button {
        padding: 8px 16px;
        font-size: 14px;
        cursor: pointer;
        background-color: #007B8C;
        color: white;
        border: none;
        border-radius: 4px;
        transition: background-color 0.3s ease;
      }

      .field-input button:hover {
        background-color: #005f66;
      }

      .context-placeholder {
        margin-top: 20px;
        font-size: 12px;
        color: #888;
        font-style: italic;
      }
    </style>
    """
  end

  def handle_event("validate_field", %{"field_name" => field_name}, socket) do
    {:noreply, assign(socket, field_name: field_name)}
  end

  def handle_event("fetch_data", %{"field_name" => field_name}, socket) do
    if field_name != "" do
      # Split the field_name string by commas and trim any extra spaces
      field_list =
        field_name
        |> String.split(",")
        |> Enum.map(&String.trim/1)

      # Call the fetch_data function with the list of fields
      Scada.PythonPort.fetch_data(field_list)

      {:noreply, assign(socket, message: "Fetching data...")}
    else
      {:noreply, assign(socket, message: "Field name cannot be empty.")}
    end
  end

  def handle_info(%{:status => status, :message => message, :data => data}, socket) do
    # Prevent unnecessary state updates
    if status != socket.assigns.last_status or message != socket.assigns.last_message do
      {:noreply,
       assign(socket,
         status: status,
         message: message,
         last_status: status,
         last_message: message,
         data: data
       )}
    else
      {:noreply, socket}
    end
  end
end
