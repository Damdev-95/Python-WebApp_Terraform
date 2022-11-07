#!/bin/bash -v
apt-get update -y
apt install python3 python3-pip tmux htop
cat << 'EOF' > app.py
from wsgiref.simple_server import make_server
def simple_app(environ, start_response):
    """Simplest possible application object"""
    status = '200 OK'
    response_headers = [('Content-type', 'text/plain')]
    start_response(status, response_headers)
    return [b"Hello world!\n"]
with make_server('', 8000, simple_app) as httpd:
    print("Serving on port 8000...")
    httpd.serve_forever()
EOF
chmod 755 app.py
python3 app.py