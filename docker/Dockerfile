FROM openjdk:8-jre-alpine


MAINTAINER Aloysius Lim
MAINTAINER Peter Borkuti

ENV PDI_RELEASE=5.3 \
    PDI_VERSION=5.3.0.0-213 \
    PDI_HOME=/opt/pentaho-di \
    KETTLE_HOME=/pentaho-di

RUN apk --no-cache add curl
RUN apk --no-cache add bash

RUN mkdir -p $PDI_HOME
RUN mkdir $KETTLE_HOME

#
# You should download pdi-ce-${PDI_VERSION}.zip into this directory
# BEFORE trying to create docker build
# http://downloads.sourceforge.net/project/pentaho/Data%20Integration/${PDI_RELEASE}/pdi-ce-${PDI_VERSION}.zip
#

COPY pdi-ce-${PDI_VERSION}.zip /tmp

RUN unzip -q /tmp/pdi-ce-${PDI_VERSION}.zip -d $PDI_HOME && \
    rm /tmp/pdi-ce-${PDI_VERSION}.zip

ENV PATH=$PDI_HOME/data-integration:$PATH

EXPOSE 8080

RUN mkdir -p $KETTLE_HOME/.kettle /docker-entrypoint.d /templates

COPY carte_config*.xml /templates/

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["carte.sh", "/pentaho-di/carte_config.xml"]
