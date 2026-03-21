FROM python:3.14-slim

RUN apt update && apt install -y awscli curl unzip zip
RUN pip install --no-cache-dir gallery-dl
RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY config/gallery-dl.conf /etc/gallery-dl.conf
COPY scripts/netscape_cookies.py /usr/local/bin/netscape_cookies.py
COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /app
RUN mkdir -p /tmp/downloads

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
