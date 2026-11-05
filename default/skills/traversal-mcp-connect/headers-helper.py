#!/usr/bin/env python3
import json
import os
from pathlib import Path
import select
import shlex
import stat
import sys
import time


def read_headers(mount, timeout=15):
    if not stat.S_ISFIFO(os.lstat(mount).st_mode):
        raise ValueError("mount is not a FIFO")
    descriptor = os.open(mount, os.O_RDONLY | os.O_NONBLOCK | os.O_NOFOLLOW)
    try:
        if not stat.S_ISFIFO(os.fstat(descriptor).st_mode):
            raise ValueError("mount is not a FIFO")
        deadline = time.monotonic() + timeout
        content = bytearray()
        while True:
            remaining = deadline - time.monotonic()
            if remaining <= 0:
                raise TimeoutError("mount read timed out")
            if not select.select([descriptor], [], [], remaining)[0]:
                raise TimeoutError("mount read timed out")
            chunk = os.read(descriptor, 65536)
            if not chunk:
                break
            content.extend(chunk)
            if len(content) > 1048576:
                raise ValueError("mount exceeds size limit")
        for line in content.decode("utf-8").splitlines():
            name, separator, value = line.removeprefix("export ").partition("=")
            if separator and name.strip() == "TRAVERSAL_API_KEY":
                parts = shlex.split(value, comments=True)
                if len(parts) != 1 or not parts[0] or any(
                    character in parts[0] for character in "\r\n"
                ):
                    raise ValueError("invalid credential in mount")
                return {"Authorization": "Bearer " + parts[0]}
        raise ValueError("credential is missing from mount")
    finally:
        os.close(descriptor)


if __name__ == "__main__":
    try:
        headers = read_headers(Path.home() / ".config/traversal-mcp/.env")
    except (OSError, ValueError, TimeoutError):
        print("traversal-mcp: approved 1Password FIFO is unavailable or invalid", file=sys.stderr)
        sys.exit(1)
    json.dump(headers, sys.stdout)
    sys.stdout.write("\n")
