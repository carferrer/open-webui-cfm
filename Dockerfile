FROM ghcr.io/open-webui/open-webui:main

COPY run.sh /run.sh

RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
