#!/bin/bash

# 실행 경로 진입
cd /home/lion/tee2/
# activate venv
source /home/lion/tee2/venv/bin/activate
# gunicorn 실행
gunicorn tee2.wsgi:application --config tee2/gunicorn_config.py