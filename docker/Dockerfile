ARG PDI_RELEASE=8.2
ARG PDI_VERSION=8.2-mine
ARG PDI_HOME=/opt/pentaho-di
ARG KETTLE_HOME=/pentaho-di

FROM alpine as base

MAINTAINER Aloysius Lim
MAINTAINER Peter Borkuti

ARG PDI_RELEASE
ARG PDI_VERSION
ARG PDI_HOME
ARG KETTLE_HOME

ENV PDI_RELEASE=$PDI_RELEASE \
    PDI_VERSION=$PDI_VERSION \
    PDI_HOME=$PDI_HOME \
    KETTLE_HOME=$KETTLE_HOME

FROM base as builder

#
# You should download pdi-ce-${PDI_VERSION}.zip into this directory
# BEFORE trying to create docker build
# http://downloads.sourceforge.net/project/pentaho/Data%20Integration/${PDI_RELEASE}/pdi-ce-${PDI_VERSION}.zip
#

RUN mkdir -p $PDI_HOME

COPY pdi-ce-${PDI_VERSION}.zip /tmp

RUN unzip -q /tmp/pdi-ce-${PDI_VERSION}.zip -d $PDI_HOME && \
    rm /tmp/pdi-ce-${PDI_VERSION}.zip


FROM openjdk:8-jre-alpine

ARG PDI_RELEASE
ARG PDI_VERSION
ARG PDI_HOME
ARG KETTLE_HOME

ENV PDI_RELEASE=$PDI_RELEASE \
    PDI_VERSION=$PDI_VERSION \
    PDI_HOME=$PDI_HOME \
    KETTLE_HOME=$KETTLE_HOME

RUN apk --no-cache add bash

RUN mkdir -p $PDI_HOME
RUN mkdir $KETTLE_HOME

COPY --from=builder $PDI_HOME $PDI_HOME

ENV PATH=$PDI_HOME/data-integration:$PATH

EXPOSE 8080

RUN mkdir -p $KETTLE_HOME/.kettle /docker-entrypoint.d /templates

COPY carte_config*.xml /templates/

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["carte.sh", "/pentaho-di/carte_config.xml"]
