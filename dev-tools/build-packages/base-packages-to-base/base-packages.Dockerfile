# Usage:
# docker build \
#         --build-arg NODE_VERSION=20.18.3 \
#         --build-arg SOM_DASHBOARD_BRANCH=main \
#         --build-arg SOM_DASHBOARD_SECURITY_BRANCH=main \
#         --build-arg SOM_DASHBOARD_PLUGINS_BRANCH=main \
#         --build-arg SOM_DASHBOARD_REPORTING_BRANCH=main \
#         --build-arg SOM_DASHBOARD_SECURITY_ANALYTICS_BRANCH=main \
#         --build-arg ARCHITECTURE=arm \
#         -t som-packages-to-base:5.0.0 \
#         -f base-packages.Dockerfile .

ARG NODE_VERSION=20.18.3
FROM node:${NODE_VERSION} AS base
ARG ARCHITECTURE='amd'
ARG SOM_DASHBOARD_BRANCH
ARG SOM_DASHBOARD_SECURITY_BRANCH
ARG SOM_DASHBOARD_SECURITY_ANALYTICS_BRANCH
ARG SOM_DASHBOARD_PLUGINS_BRANCH
ARG SOM_DASHBOARD_REPORTING_BRANCH
ENV OPENSEARCH_DASHBOARDS_VERSION=3.3.0
ENV ENV_ARCHITECTURE=${ARCHITECTURE}
USER root
RUN apt-get update && apt-get install -y jq
USER node
ADD ./clone-plugins.sh /home/node/clone-plugins.sh
ADD ./repositories/som-dashboard.sh /home/node/repositories/som-dashboard.sh
ADD ./repositories/plugins/som-dashboard-security-analytics.sh /home/node/repositories/plugins/som-dashboard-security-analytics.sh
ADD ./repositories/plugins/som-security-dashboards-plugin.sh /home/node/repositories/plugins/som-security-dashboards-plugin.sh
ADD ./repositories/plugins/som-dashboard-reporting.sh /home/node/repositories/plugins/som-dashboard-reporting.sh
ADD ./repositories/plugins/som-dashboard-plugins.sh /home/node/repositories/plugins/som-dashboard-plugins.sh
RUN bash /home/node/clone-plugins.sh

FROM node:${NODE_VERSION}
USER node
COPY --chown=node:node --from=base /home/node/packages /home/node/packages
WORKDIR /home/node/packages
