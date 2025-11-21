# Clone the Som security plugin
cd /home/node/app/plugins
git clone --depth 1 --branch ${SOM_DASHBOARD_REPORTING_BRANCH} https://github.com/som/som-dashboards-reporting.git
cd som-dashboards-reporting
yarn install
echo "Building Som reporting plugin"
yarn build
echo "Copying Som reporting plugin"
mkdir /home/node/packages/som-dashboards-reporting
cp -r build/* /home/node/packages/som-dashboards-reporting
