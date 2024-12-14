import sys
import json
import pyads
import argparse

class AdsConnection:
    plc = None  # Class-level variable to store the connection object

    def __init__(self, ams_net_id, ams_port):
        self.ams_net_id = ams_net_id
        self.ams_port = ams_port

    def connect(self):
        """Establish a persistent connection to the PLC."""
        if AdsConnection.plc is None:
            try:
                AdsConnection.plc = pyads.Connection(self.ams_net_id, self.ams_port)
                AdsConnection.plc.open()
                state = AdsConnection.plc.read_state()

                if isinstance(state, tuple) and len(state) == 2:
                    ads_state, device_state = state
                    return {
                        "routing_key": "connect",
                        "status": "connected",
                        "message": "Connection established successfully.",
                        "ads_state": ads_state,
                        "device_state": device_state
                    }
                else:
                    return {
                        "routing_key": "connect",
                        "status": "error",
                        "message": f"Unexpected response from PLC: {state}"
                    }
            except Exception as e:
                return {"routing_key": "connect", "status": "error", "message": f"Failed to connect: {str(e)}"}
        else:
            return {
                "routing_key": "connect",
                "status": "connected",
                "message": "Already connected to PLC"
            }

    def disconnect(self):
        """Disconnect the connection to the PLC."""
        if AdsConnection.plc:
            AdsConnection.plc.close()
            AdsConnection.plc = None
            return {"routing_key": "disconnect", "status": "disconnected", "message": "Connection closed."}
        return {"routing_key": "disconnect", "status": "error", "message": "No active connection to close."}

    def fetch_data(self):
        """Fetch the latest data from the PLC."""
        if AdsConnection.plc is None:
            return {"routing_key": "fetch_data", "status": "error", "message": "Not connected to PLC."}

        try:
            state = AdsConnection.plc.read_state()
            return {"routing_key": "fetch_data", "status": "connected", "message": "Data fetched successfully", "data": state}
        except Exception as e:
            return {"routing_key": "fetch_data", "status": "error", "message": f"Failed to fetch data: {str(e)}"}

    def heartbeat(self):
        """Check if the connection is alive by performing a simple operation (e.g., reading state)."""
        if AdsConnection.plc is None:
            return {"routing_key": "heartbeat", "status": "error", "message": "Not connected to PLC."}

        try:
            state = AdsConnection.plc.read_state()
            return {"routing_key": "heartbeat", "status": "connected", "message": "Heartbeat successful", "state": state}
        except Exception as e:
            return {"routing_key": "heartbeat", "status": "error", "message": f"Heartbeat failed: {str(e)}"}

def handle_command(command, ams_net_id, ams_port):
    ads = AdsConnection(ams_net_id, ams_port)

    if command == "connect":
        return ads.connect()

    elif command == "fetch_data":
        return ads.fetch_data()

    elif command == "heartbeat":
        return ads.heartbeat()

    elif command == "disconnect":
        return ads.disconnect()

    else:
        return {"status": "error", "message": "Unknown command"}

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ams_net_id", required=True)
    parser.add_argument("--ams_port", required=True)
    parser.add_argument("--command", required=True)

    args = parser.parse_args()

    # Handle the command (connect, fetch_data, heartbeat, disconnect)
    response = handle_command(args.command, args.ams_net_id, int(args.ams_port))

    print(json.dumps(response))
