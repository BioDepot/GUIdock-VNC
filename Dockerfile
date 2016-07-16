FROM ubuntu:14.04
MAINTAINER Somebody <somebody@acme.com>
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root
RUN apt-get update
RUN apt-get install -y --force-yes --no-install-recommends software-properties-common apt-transport-https
RUN add-apt-repository -y 'ppa:openjdk-r/ppa'
RUN add-apt-repository -y 'deb https://cran.rstudio.com/bin/linux/ubuntu/ trusty/'
RUN add-apt-repository -y 'ppa:nginx/stable'
RUN apt-get -y update --allow-unauthenticated
RUN apt-get install -y --force-yes --no-install-recommends openjdk-8-jre r-base-dev r-base python-django python-pip build-essential python-dev python-oauth2 python-googleapi supervisor pwgen sudo vim-tiny lxde x11vnc x11vnc-data xvfb nginx python-pip python-dev build-essential libcurl4-openssl-dev libX11-dev libglu-dev libxml2-dev
#GUIdock.json
#cynetwork_bma.json
#cytoscape_3_3.json
#openjre8.json
#--
add http://chianti.ucsd.edu/cytoscape-3.3.0/cytoscape-3.3.0.tar.gz /deps/cytoscape-3.3.0.tar.gz
add lib/cytoscape_3_3/cytoscape.desktop /usr/share/applications/cytoscape.desktop
#--
add lib/cytoscape_3_3/cytoscape_setup.sh /ff23b3c4-7a5f-47d3-b830-1e36fbf5b2c8
add lib/cynetwork_bma/CyNetworkBMA-1.0.0_1.jar /deps/cytoscape-unix-3.3.0/apps/CyNetworkBMA-1.0.0_1.jar
#--
#r.json
#r_dev.json
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
#--
#--
#novnc.json
#broker_base.json
RUN pip install librabbitmq mongoengine 
copy lib/broker_base/broker.tar.gz /
#--
add lib/broker_base/init.sh /fecf618b-c445-4d6f-b3a2-0652031b6762
add lib/novnc/web /web/
RUN pip install -r /web/requirements.txt 
add lib/novnc/noVNC /noVNC/
add lib/novnc/nginx.conf /etc/nginx/sites-enabled/default
add lib/novnc/startup.sh /
add lib/novnc/supervisord.conf /etc/supervisor/conf.d/
#--
add lib/GUIdock/deps.R /tmp/deps.R
RUN Rscript /tmp/deps.R 
RUN rm /tmp/deps.R 
copy lib/GUIdock/DEMO.tar.gz /
copy lib/GUIdock/rserve.R /deps/
#--
add lib/GUIdock/init.sh /3ef91016-5855-4839-adce-cd66e4c0d319
#cytoscape_3_3_bench.json
add lib/cytoscape_3_3_bench/packages_bench.R /tmp/packages_bench.R
RUN Rscript /tmp/packages_bench.R 
add lib/cytoscape_3_3_bench/testDocker /deps/testDocker
add lib/cytoscape_3_3_bench/cytoscape_bench.desktop /usr/share/applications/cytoscape_bench.desktop
add lib/cytoscape_3_3_bench/date_nanoseconds /usr/bin/date_nanoseconds
RUN chmod +x /usr/bin/date_nanoseconds 
add lib/cytoscape_3_3_bench/run_test.sh /usr/bin/run_test.sh
RUN chmod +x /usr/bin/run_test.sh 
#--
RUN apt-get purge -y --force-yes r-base-dev python-pip build-essential python-dev python-pip python-dev build-essential
RUN apt-get purge software-properties-common -y --force-yes
RUN apt-get -y autoclean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN rm -rf /var/tmp/*
EXPOSE 6080
RUN bash -c 'echo -e "#!/bin/bash\nchmod +x /ff23b3c4-7a5f-47d3-b830-1e36fbf5b2c8\n/bin/bash /ff23b3c4-7a5f-47d3-b830-1e36fbf5b2c8 \$@\nrm -rf /ff23b3c4-7a5f-47d3-b830-1e36fbf5b2c8\nchmod +x /fecf618b-c445-4d6f-b3a2-0652031b6762\n/bin/bash /fecf618b-c445-4d6f-b3a2-0652031b6762 \$@\nchmod +x /3ef91016-5855-4839-adce-cd66e4c0d319\n/bin/bash /3ef91016-5855-4839-adce-cd66e4c0d319 \$@\n/startup.sh \$@" >> /entrypoint.sh'
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]