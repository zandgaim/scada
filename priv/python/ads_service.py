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
        return None, {"routing_key": "connect", "message": f"Failed to connect: {str(e)}"}


def fetch_plc_data(plc, var_list):
    if not plc or not plc.is_open:
        return {
            "routing_key": "fetch_data",
            "message": "Not connected to PLC.",
        }

    try:
        result = plc.read_list_by_name(var_list)

        return {
            "routing_key": "fetch_data",
            "status": "connected",
            "message": "Data fetched successfully",
            "data": result
        }

    except Exception as e:
        return {
            "routing_key": "fetch_data",
            "message": f"Failed to fetch data: {str(e)}",
        }


def handle_command(command, ams_net_id, ams_port, var_list=None):
    plc, connect_response = connect_to_plc(ams_net_id, ams_port)

    if command == "connect":
        return connect_response

    if not plc:
        return {
            "routing_key": command,
            "message": "Connection to PLC not established. Unable to execute command.",
        }

    if command == "fetch_data":
        if var_list is None or len(var_list) == 0:
            return {
                "routing_key": "fetch_data",
                "message": "No variables specified to fetch.",
            }
        response = fetch_plc_data(plc, var_list)
    else:
        response = {"message": "Unknown command"}

    plc.close()
    return response


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ams_net_id", required=True)
    parser.add_argument("--ams_port", required=True)
    parser.add_argument("--command", required=True)
    parser.add_argument("--data", nargs='*', default=[])

    args = parser.parse_args()

    response = handle_command(args.command, args.ams_net_id, int(args.ams_port), args.data)

    print(json.dumps(response, indent=4))
