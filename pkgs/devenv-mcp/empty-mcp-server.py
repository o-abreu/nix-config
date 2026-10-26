#!/usr/bin/env python3
"""Empty stdio MCP server used when no devenv project is present.

OpenCode raises an error toast for every configured MCP server that fails to
start ("MCP server failed: <name>"), and it has no per-server option to
silence it. `devenv mcp` exits with an error outside a devenv project, so the
`devenv-mcp` shim runs this stub instead: it completes the MCP handshake and
reports no tools, resources, or prompts. The server therefore connects
cleanly and silently, and still becomes the real `devenv mcp` inside a devenv
project.
"""

import json
import sys

PROTOCOL_FALLBACK = "2025-06-18"


def send(message):
    sys.stdout.write(json.dumps(message) + "\n")
    sys.stdout.flush()


def reply(request_id, payload):
    send({"jsonrpc": "2.0", "id": request_id, "result": payload})


for raw in sys.stdin:
    line = raw.strip()
    if not line:
        continue
    try:
        request = json.loads(line)
    except ValueError:
        continue

    method = request.get("method")
    if method is None:  # response to a server-initiated request: ignore
        continue

    request_id = request.get("id")

    if method == "initialize":
        reply(
            request_id,
            {
                "protocolVersion": request.get("params", {}).get(
                    "protocolVersion", PROTOCOL_FALLBACK
                ),
                "capabilities": {},
                "serverInfo": {"name": "devenv-mcp-stub", "version": "0"},
            },
        )
    elif method == "ping":
        reply(request_id, {})
    elif method == "tools/list":
        reply(request_id, {"tools": []})
    elif method == "resources/list":
        reply(request_id, {"resources": []})
    elif method == "resources/templates/list":
        reply(request_id, {"resourceTemplates": []})
    elif method == "prompts/list":
        reply(request_id, {"prompts": []})
    elif request_id is not None:
        send(
            {
                "jsonrpc": "2.0",
                "id": request_id,
                "error": {"code": -32601, "message": f"Method not found: {method}"},
            }
        )
    # Notifications (no id) need no response.
