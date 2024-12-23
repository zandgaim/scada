import asyncio
import json
import pyads
import logging

# Configure logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

async def handle_client(reader, writer):
    async def send_response(response):
        try:
            message = json.dumps(response).encode('utf-8') + b'\n'
            writer.write(message)
            await writer.drain()
            logger.info(f"Sent response: {response}")
        except Exception as e:
            logger.error(f"Failed to send response: {str(e)}")

    plc = None  # Ensure plc is initialized

    try:
        # Read initial configuration from the client
        config_data = await reader.readline()
        config = json.loads(config_data.decode('utf-8'))
        ams_net_id = config.get("ams_net_id")
        ams_port = config.get("ams_port")

        if not ams_net_id or not ams_port:
            logger.error("Missing AMS Net ID or port in initial configuration.")
            await send_response({
                "routing_key": "error",
                "message": "Missing AMS Net ID or port in initial configuration."
            })
            return

        logger.info(f"Attempting to connect to PLC with AMS Net ID: {ams_net_id} and AMS Port: {ams_port}")
        plc, connect_response = connect_to_plc(ams_net_id, ams_port)
        await send_response(connect_response)

        if not plc:
            logger.error("Failed to establish connection to PLC.")
            return

        logger.info("Connection established successfully. Waiting for commands...")

        while True:
            try:
                # Read commands from the client
                data = await reader.readline()
                if not data:
                    logger.info("Client disconnected.")
                    break

                try:
                    request_data = json.loads(data.decode('utf-8'))
                except json.JSONDecodeError as e:
                    logger.error(f"Invalid JSON input: {str(e)}")
                    await send_response({
                        "routing_key": "error",
                        "message": f"Invalid JSON input: {str(e)}"
                    })
                    continue

                command = request_data.get("command")
                var_list = request_data.get("data", None)

                if command:
                    logger.info(f"Received command: {command}")
                    response = handle_command(plc, command, var_list)
                else:
                    logger.warning("No command provided in the request.")
                    response = {"routing_key": "error", "message": "No command provided"}

                await send_response(response)

            except Exception as e:
                logger.error(f"Error handling client request: {str(e)}")
                await send_response({"routing_key": "error", "message": f"Error handling client: {str(e)}"})
                break
    finally:
        writer.close()
        await writer.wait_closed()
        if plc and plc.is_open:
            logger.info("Closing PLC connection.")
            plc.close()


def connect_to_plc(ams_net_id, ams_port):
    try:
        plc = pyads.Connection(ams_net_id, ams_port)
        plc.open()
        state = plc.read_state()

        if isinstance(state, tuple) and len(state) == 2:
            ads_state, device_state = state
            logger.info(f"PLC connection successful. ADS State: {ads_state}, Device State: {device_state}")
            return plc, {
                "routing_key": "connect",
                "status": "connected",
                "message": "Connection established successfully.",
                "ads_state": ads_state,
                "device_state": device_state,
            }
        else:
            plc.close()
            logger.error(f"Unexpected response from PLC: {state}")
            return None, {
                "routing_key": "connect",
                "status": "error",
                "message": f"Unexpected response from PLC: {state}",
            }
    except Exception as e:
        logger.error(f"Failed to connect to PLC: {str(e)}")
        return None, {"routing_key": "connect", "status": "error", "message": f"Failed to connect: {str(e)}"}


def fetch_plc_data(plc, var_list):
    if not plc or not plc.is_open:
        logger.warning("Not connected to PLC.")
        return {
            "routing_key": "fetch_data",
            "message": "Not connected to PLC.",
        }

    try:
        logger.info(f"Fetching data for variables: {var_list}")
        result = plc.read_list_by_name(var_list)

        logger.info("Data fetched successfully.")
        return {
            "routing_key": "fetch_data",
            "status": "connected",
            "message": "Data fetched successfully",
            "data": result
        }

    except Exception as e:
        logger.error(f"Failed to fetch data: {str(e)}")
        return {
            "routing_key": "fetch_data",
            "message": f"Failed to fetch data: {str(e)}",
        }


def handle_command(plc, command, var_list=None):
    if command == "fetch_data":
        if var_list is None or len(var_list) == 0:
            logger.warning("No variables specified to fetch.")
            return {
                "routing_key": "fetch_data",
                "message": "No variables specified to fetch.",
            }
        response = fetch_plc_data(plc, var_list)
    else:
        logger.warning(f"Unknown command received: {command}")
        response = {"message": "Unknown command"}

    return response


async def main(host="127.0.0.1", port=8888):
    server = await asyncio.start_server(handle_client, host, port)

    addr = server.sockets[0].getsockname()
    logger.info(f"Server running on {addr}")

    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())