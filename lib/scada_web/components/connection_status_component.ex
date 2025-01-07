defmodule ScadaWeb.Components.ConnectionStatusComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <header class="w-full bg-teal-700 text-white text-center py-6 shadow-lg rounded-lg">
      <h2 class="text-2xl font-semibold">Connection Status: {@status}</h2>
      <p class="text-lg text-gray-300 mt-1">{@message}</p>
      
    <!-- TCP Status and Message Section -->
      <div class="mt-4 p-4 bg-teal-800 rounded-lg shadow-md">
        <p class="text-sm font-semibold text-teal-100">TCP Status:</p>
        <p class="text-sm text-teal-200">{@tcp_status}</p>
      </div>
    </header>
    """
  end
end
