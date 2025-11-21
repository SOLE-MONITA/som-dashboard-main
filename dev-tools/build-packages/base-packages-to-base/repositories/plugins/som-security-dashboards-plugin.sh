# Clone the Som security plugin
cd /home/node/app/plugins
git clone --depth 1 --branch ${SOM_DASHBOARD_SECURITY_BRANCH} https://github.com/som/som-security-dashboards-plugin.git
cd som-security-dashboards-plugin
yarn install
echo "Building Som security plugin"
yarn build
echo "Copying Som security plugin"
mkdir /home/node/packages/som-security-dashboards-plugin
cp -r build/* /home/node/packages/som-security-dashboards-plugin
