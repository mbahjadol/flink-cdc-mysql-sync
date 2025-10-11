---
SETUP
---
inside folder producer

If you doesn't have uv on your system then you can install UV

Bash

    curl -LsSf https://astral.sh/uv/install.sh | sh

Poweshell

    irm https://astral.sh/uv/install.ps1 | iex

Then setup for current python virtual environment 

    uv venv .venv

    source .venv/bin/activate

    uv pip install --upgrade pip setuptools wheel
    
    pip install pymysql

    pip list
