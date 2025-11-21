git clone --depth 1 --branch ${SOM_DASHBOARD_BRANCH} https://github.com/som/som-dashboard.git /home/node/app
cd /home/node/app
yarn osd bootstrap --production
echo "Building Som dashboard"
if [ $ENV_ARCHITECTURE == "arm" ]; then
  yarn build-platform --linux-arm --skip-os-packages --release
else
  yarn build-platform --linux --skip-os-packages --release
fi
mkdir /home/node/packages/som-dashboard
echo "Copying Som dashboard"
ls -la /home/node/app/target
cp -r /home/node/app/target/*.tar.gz /home/node/packages/som-dashboard
