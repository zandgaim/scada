# SCADA System Implementation in Elixir

This project is a Supervisory Control and Data Acquisition (SCADA) system developed using the Elixir programming language. It provides real-time monitoring and control capabilities for industrial processes.

Features:

 * Real-time data acquisition and processing
 * Web-based user interface for monitoring and control
 * Integration with the Python ADS library for communication with industrial equipment
 * TCP-based connection between the Phoenix app and the Python process
 * Docker support for easy deployment
# Setup

Install Docker, then:

  * Build `docker build -t scada .`
  * Run `docker run -d -p 4020:4020 scada`
