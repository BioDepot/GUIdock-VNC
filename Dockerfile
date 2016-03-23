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
RUN apt-get install -y --force-yes --no-install-recommends openjdk-8-jre apt-transport-https r-base-dev r-base python-django python-pip build-essential python-dev python-oauth2 python-googleapi supervisor openssh-server pwgen sudo vim-tiny net-tools lxde x11vnc x11vnc-data xvfb gtk2-engines-murrine ttf-ubuntu-font-family nginx python-pip python-dev build-essential mesa-utils libgl1-mesa-dri
#GUIdock.json
#cynetwork_bma.json
#cytoscape_3_3.json
#openjre8.json
#--
add http://chianti.ucsd.edu/cytoscape-3.3.0/cytoscape-3.3.0.tar.gz /deps/cytoscape-3.3.0.tar.gz
#--
add lib/cytoscape_3_3/cytoscape_setup.sh /c6305ece-2195-41d7-b506-cf8ec63df995
add lib/cynetwork_bma/CyNetworkBMA-1.0.0_1.jar /deps/cytoscape-unix-3.3.0/apps/CyNetworkBMA-1.0.0_1.jar
#--
#r.json
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
add lib/r/deps.R /tmp/deps.R
RUN Rscript /tmp/deps.R 
RUN rm /tmp/deps.R 
#--
#novnc.json
#broker_base.json
RUN pip install librabbitmq mongoengine 
copy lib/broker_base/broker.tar.gz /
#--
add lib/broker_base/init.sh /6e017df8-9735-4d60-bce0-41cedf55f477
add lib/novnc/web /web/
RUN pip install -r /web/requirements.txt 
add lib/novnc/noVNC /noVNC/
add lib/novnc/nginx.conf /etc/nginx/sites-enabled/default
add lib/novnc/startup.sh /
add lib/novnc/supervisord.conf /etc/supervisor/conf.d/
add lib/novnc/doro-lxde-wallpapers /usr/share/doro-lxde-wallpapers/
#--
copy lib/GUIdock/DEMO.tar.gz /
copy lib/GUIdock/rserve.R /deps/
#--
add lib/GUIdock/init.sh /584d1a86-22b1-433e-b26d-80e7a5375bbd
RUN apt-get purge -y --force-yes r-base-dev python-pip build-essential python-dev python-pip python-dev build-essential
RUN apt-get purge software-properties-common -y --force-yes
RUN apt-get -y autoclean
RUN apt-get -y autoremove
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN rm -rf /var/tmp/*
RUN bash -c 'echo -e "#!/bin/bash\nchmod +x /c6305ece-2195-41d7-b506-cf8ec63df995\n/bin/bash /c6305ece-2195-41d7-b506-cf8ec63df995 \$@\nrm -rf /c6305ece-2195-41d7-b506-cf8ec63df995\nchmod +x /6e017df8-9735-4d60-bce0-41cedf55f477\n/bin/bash /6e017df8-9735-4d60-bce0-41cedf55f477 \$@\nchmod +x /584d1a86-22b1-433e-b26d-80e7a5375bbd\n/bin/bash /584d1a86-22b1-433e-b26d-80e7a5375bbd \$@\n/startup.sh \$@" >> /entrypoint.sh'
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
