# SCADA System Implementation in Elixir

This project is a Supervisory Control and Data Acquisition (SCADA) system developed using the Elixir programming language. It provides real-time monitoring and control capabilities for industrial processes.

Features:

 * Real-time data acquisition and processing
 * Web-based user interface for monitoring and control
 * Integration with the Python ADS library for communication with industrial equipment
 * TCP-based connection between the Phoenix app and the Python process
 * Docker support for easy deployment
# Setup

First of all run script priv/scripts/setup_python_env.bat:

  * Run `.\priv\scripts\setup_python_env.bat`


To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `iex -S mix phx.server`
