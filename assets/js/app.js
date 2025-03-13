import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let Hooks = {};

Hooks.ChartHook = {
  mounted() {
    this.chart = new Chart(this.el, {
      type: "line",
      data: {
        labels: [],
        datasets: [
          {
            label: "Historical Data",
            data: [],
            borderColor: "rgba(75, 192, 192, 1)",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            fill: true,
            tension: 0.1
          }
        ]
      },
      options: {
        scales: {
          x: {
            type: "category", // Use category scale for string labels (timestamps)
            title: { display: true, text: "Timestamp" },
            ticks: { maxTicksLimit: 10 } // Limit x-axis labels
          },
          y: { title: { display: true, text: "Value" }, beginAtZero: true }
        },
        plugins: {
          legend: {
            display: true
          }
        },
        maintainAspectRatio: false,
        responsive: true
      }
    });

    this.handleEvent("update-chart", ({ labels, values, label }) => {
      console.log("Chart update received:", { labels, values, label });
    
      this.chart.data.labels = labels;
      this.chart.data.datasets[0].data = values.map((v, index) => ({ x: labels[index], y: v }));
      this.chart.data.datasets[0].label = label;
    
      this.chart.update("none"); // Try "none" to prevent animations
    });
  },
  destroyed() {
    if (this.chart) {
      this.chart.destroy();
    }
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
});

topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", _info => topbar.show(300));
window.addEventListener("phx:page-loading-stop", _info => topbar.hide());

liveSocket.connect();

window.liveSocket = liveSocket;