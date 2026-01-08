#!/usr/bin/env -S uv run --script
#
# /// script
# dependencies = [
#   "rich",
# ]
# ///


# This script prints information about the currently active Python environment.

import sys
import os
import pathlib
from rich import print


print("uv sys.executable:", sys.executable)
print("uv venv root:", pathlib.Path(sys.executable).parent.parent)
print("uv VIRTUAL_ENV:", os.environ.get("VIRTUAL_ENV"))
print("uv CONDA_PREFIX:", os.environ.get("CONDA_PREFIX"))