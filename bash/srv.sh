#!/bin/bash
. ~/.local/share/etoh/venv/bin/activate
export PYTHONPATH=${PYTHONPATH}:${HOME}/etoh
gunicorn app:app --bind=0.0.0.0:5000 --workers=5 --timeout 10 --access-logfile -
