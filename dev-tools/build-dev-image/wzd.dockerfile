# Usage:
# docker build \
#         --build-arg NODE_VERSION=20.18.3 \
#         --build-arg OPENSEARCH_DASHBOARD_VERSION=3.3.0.0 \
#         --build-arg SOM_DASHBOARD_BRANCH=main \
#         --build-arg SOM_DASHBOARD_SECURITY_BRANCH=main \
#         --build-arg SOM_DASHBOARD_REPORTING_BRANCH=main \
#         --build-arg SOM_DASHBOARD_PLUGINS_BRANCH=main \
#         --build-arg SOM_DASHBOARD_SECURITY_ANALYTICS_BRANCH=main \
#         -t quay.io/som/osd-dev:3.3.0-5.0.0 \
#         -f wzd.dockerfile .

ARG NODE_VERSION=20.18.3
FROM node:${NODE_VERSION} AS base
ARG OPENSEARCH_DASHBOARD_VERSION
ARG SOM_DASHBOARD_BRANCH
ARG SOM_DASHBOARD_SECURITY_BRANCH
ARG SOM_DASHBOARD_REPORTING_BRANCH
ARG SOM_DASHBOARD_PLUGINS_BRANCH
ARG SOM_DASHBOARD_SECURITY_ANALYTICS_BRANCH
USER node
RUN git clone --depth 1 --branch ${SOM_DASHBOARD_BRANCH} https://github.com/som/som-dashboard.git /home/node/kbn
RUN chown node.node /home/node/kbn

WORKDIR /home/node/kbn
RUN yarn osd bootstrap --production

WORKDIR /home/node/kbn/plugins

ADD ./install-plugins.sh /home/node/install-plugins.sh
ADD ./plugins /home/node/plugins
RUN bash /home/node/install-plugins.sh
RUN mkdir -p /home/node/kbn/data/som/config

FROM node:${NODE_VERSION}
USER node
COPY --chown=node:node --from=base /home/node/kbn /home/node/kbn
WORKDIR /home/node/kbn
ADD ./entrypoint.sh /usr/local/bin/entrypoint.sh
USER root
RUN chmod +x /usr/local/bin/entrypoint.sh
USER node
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
