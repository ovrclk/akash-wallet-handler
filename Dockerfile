FROM debian
COPY *.sh /
RUN apt-get update ; apt-get install -yqq curl unzip jq bsdmainutils nano
RUN AKASH_VERSION="$(curl -s "https://raw.githubusercontent.com/ovrclk/net/master/mainnet/version.txt")"
RUN export AKASH_VERSION
RUN curl https://raw.githubusercontent.com/ovrclk/akash/master/godownloader.sh | sh -s -- "$AKASH_VERSION"
