FROM ghcr.io/open-webui/open-webui:0.11.3

COPY run.sh /run.sh

RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
