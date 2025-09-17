#!/bin/bash


function active-python(){
  uv run -- python - <<'PY'
  import sys, os, pathlib
  print("uv sys.executable:", sys.executable)
  print("uv venv root:", pathlib.Path(sys.executable).parent.parent)
  print("uv VIRTUAL_ENV:", os.environ.get("VIRTUAL_ENV"))
  print("uv CONDA_PREFIX:", os.environ.get("CONDA_PREFIX"))
  PY
}