import sys
import json
import pyads
import argparse


def connect_to_plc(ams_net_id, ams_port):
    try:
        plc = pyads.Connection(ams_net_id, ams_port)
        plc.open()
        state = plc.read_state()

        if isinstance(state, tuple) and len(state) == 2:
            ads_state, device_state = state
            return plc, {
                "routing_key": "connect",
                "status": "connected",
                "message": "Connection established successfully.",
                "ads_state": ads_state,
                "device_state": device_state,
            }
        else:
            plc.close()
            return None, {
                "routing_key": "connect",
                "status": "error",
                "message": f"Unexpected response from PLC: {state}",
            }
    except Exception as e:
        return None, {"routing_key": "connect", "status": "error", "message": f"Failed to connect: {str(e)}"}


def fetch_plc_data(plc):
    """Fetch data from the PLC."""
    if not plc or not plc.is_open:
        return {
            "routing_key": "fetch_data",
            "status": "error",
            "message": "Not connected to PLC.",
        }

    try:
        state = plc.read_state()
        return {
            "routing_key": "fetch_data",
            "status": "connected",
            "message": "Data fetched successfully",
            "data": state,
        }
    except Exception as e:
        return {
            "routing_key": "fetch_data",
            "status": "error",
            "message": f"Failed to fetch data: {str(e)}",
        }

def handle_command(command, ams_net_id, ams_port):
    plc, connect_response = connect_to_plc(ams_net_id, ams_port)

    if command == "connect":
        return connect_response

    if not plc:
        return {
            "routing_key": command,
            "status": "error",
            "message": "Connection to PLC not established. Unable to execute command.",
        }

    if command == "fetch_data":
        response = fetch_plc_data(plc)
    else:
        response = {"status": "error", "message": "Unknown command"}

    plc.close()
    return response


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ams_net_id", required=True)
    parser.add_argument("--ams_port", required=True)
    parser.add_argument("--command", required=True)

    args = parser.parse_args()

    response = handle_command(args.command, args.ams_net_id, int(args.ams_port))

    print(json.dumps(response))
