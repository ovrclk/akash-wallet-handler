FROM debian
COPY *.sh /
COPY variables /
RUN ./install-akash.sh
