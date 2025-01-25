defmodule ScadaWeb.Components.ConnectionStatusComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <section class="bg-white w-full max-w-screen-xl p-6 rounded-lg shadow-md text-center">
      <div class="flex flex-col items-center">
        <div class="flex items-center space-x-4">
          <div class={"rounded-full w-4 h-4 " <> status_color(@status)}></div>
          
          <h2 class="text-2xl font-semibold">Connection Status: {@status}</h2>
        </div>
        
        <p class="text-lg text-gray-600 mt-2">{@message}</p>
      </div>
      
    <!-- TCP Status and Message -->
      <div class="mt-6 p-4 bg-gray-50 rounded-lg shadow-inner border-t">
        <h3 class="text-md font-semibold text-teal-700">TCP Details</h3>
        
        <p class="text-sm text-gray-700 mt-1"><strong>Status:</strong> {@tcp_status}</p>
        
        <p class="text-sm text-gray-700"><strong>Message:</strong> {@tcp_message}</p>
      </div>
    </section>
    """
  end

  defp status_color("Connected"), do: "bg-green-500"
  defp status_color("Disconnected"), do: "bg-red-500"
  defp status_color(_), do: "bg-yellow-500"
end
