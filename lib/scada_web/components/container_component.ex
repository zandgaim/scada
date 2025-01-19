defmodule ScadaWeb.Components.ContainerComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="bg-gray-800 p-6 rounded-lg shadow-md text-white w-full flex items-start">
      <!-- Left Section: Icon and Status -->
      <div class="flex-shrink-0 flex flex-col items-center mr-6">
        <div class="w-14 h-14 bg-gray-600 rounded-full flex items-center justify-center">
          <img
            src={"/images/containers/#{@id}.png"}
            alt="Status Icon"
            class="w-10 h-10 object-contain"
            onerror="this.onerror=null; this.src='/images/default_icon.png';"
          />
        </div>
        <%= if @status_indicator do %>
          <div class="mt-3">
            <div class={
              if @status_indicator == "Operational",
                do: "w-4 h-4 bg-green-500 rounded-full",
                else: "w-4 h-4 bg-red-500 rounded-full"
            }>
            </div>
          </div>
        <% end %>
      </div>
      
    <!-- Right Section: Content -->
      <div class="flex-grow">
        <!-- Title -->
        <div class="mb-4">
          <h3 class="text-xl font-bold text-white">{@title}</h3>
        </div>
        
    <!-- Grid of Key-Value Pairs -->
        <div class="grid grid-cols-2 gap-y-3 text-sm">
          <%= for {label, _, symb, value} <- @items do %>
            <div class="col-span-1 text-gray-400">{label}</div>
            <div class="col-span-1 text-right font-semibold text-gray-100">
              {value || "N/A"} {symb}
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
