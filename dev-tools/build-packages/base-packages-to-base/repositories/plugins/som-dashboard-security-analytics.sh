# Clone the Som Security Analytics plugin
cd /home/node/app/plugins
git clone --depth 1 --branch ${SOM_DASHBOARD_SECURITY_ANALYTICS_BRANCH} https://github.com/som/som-dashboard-security-analytics.git
cd som-dashboard-security-analytics
yarn install
echo "Building Som Security Analytics plugin"
yarn build
echo "Copying Som Security Analytics plugin"
mkdir /home/node/packages/som-security-analytics-plugin
cp -r build/* /home/node/packages/som-security-analytics-plugin