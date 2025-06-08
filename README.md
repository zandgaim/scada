# SCADA

This project is a Supervisory Control and Data Acquisition (SCADA) system developed using the Elixir programming language. It provides real-time monitoring and control capabilities for industrial processes.

This project is developed as part of a master's thesis in cooperation with SIMES.

Features:

 * Real-time data acquisition and processing
 * Web-based user interface for monitoring and control
 * Integration with the Python ADS library for communication with industrial equipment
 * TCP-based connection between the Phoenix app and the Python process
 * Docker support for easy deployment
# Setup

Make sure Docker and Docker Compose are installed, then:

 * `docker-compose up --build -d`
 Builds images (if needed) and starts the containers in the background (detached mode).

* `docker-compose up -d`
 Starts the containers using existing images, without rebuilding.

* `docker-compose down`
 Stops and removes all containers defined in docker-compose.yml.
