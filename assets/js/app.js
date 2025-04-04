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
            data: [], // We'll fill this later
            borderColor: "rgba(75, 192, 192, 1)",
            backgroundColor: "rgba(75, 192, 192, 0.2)",
            fill: true,
            tension: 0.1,
            spanGaps: false // Important for showing actual gaps
          }
        ]
      },
      options: {
        scales: {
          x: {
            type: "time", // ← Use 'time' so Chart.js reads `x` from data points
            time: {
              unit: "minute",
              tooltipFormat: "yyyy-MM-dd HH:mm:ss"
            },
            title: { display: true, text: "Timestamp" },
            ticks: {
              maxTicksLimit: 10,
            }
          },
          y: {
            title: { display: true, text: "Value" },
            beginAtZero: true
          }
        },
        plugins: {
          legend: { display: true },
          annotation: {
            annotations: [] // We'll update this dynamically
          }
        },
        maintainAspectRatio: false,
        responsive: true
      }
    });

    this.handleEvent("update-chart", ({ label, raw_times, values }) => {
      const dataPoints = [];
    
      for (let i = 0; i < raw_times.length; i++) {
        const time = raw_times[i];
        const value = values[i] === null ? null : values[i]; // 👈 handle nil safely
        dataPoints.push({ x: time, y: value });
      }
    
      this.chart.data.datasets[0].data = dataPoints;
      this.chart.data.datasets[0].label = label;
      this.chart.update("none");
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
