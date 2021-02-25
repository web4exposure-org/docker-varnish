FROM debian:stretch
MAINTAINER Fabrizio Balliano <fabrizio@fabrizioballiano.com>

RUN apt-get update && apt-get install -y varnish vim  && apt-get install -y gnupg2 && 
ADD ./configure_telegraf_install.sh /configure_telegraf_install.sh
RUN chmod +x /configure_telegraf_install.sh
RUN ./configure_telegraf_install.sh
RUN apt-get update && apt-get install telegraf && apt-get clean
ADD ./start.sh /start.sh
RUN chmod +x /start.sh

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      256M
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600 -T 0.0.0.0:6082 -S /etc/varnish/secret

EXPOSE 80 6082

CMD /start.sh
