base_path_plugins="/home/node/app/plugins"
cd $base_path_plugins
git clone --depth 1 --branch ${SOM_DASHBOARD_PLUGINS_BRANCH} https://github.com/som/som-dashboard-plugins.git
som_dashboard_plugins=$(ls $base_path_plugins/som-dashboard-plugins/plugins)
mv som-dashboard-plugins/plugins/* ./
mkdir /home/node/packages/som-dashboard-plugins
for som_dashboard_plugin in $som_dashboard_plugins; do
  cd $base_path_plugins/$som_dashboard_plugin
  GIT_REF="${SOM_DASHBOARD_PLUGINS_BRANCH}" yarn install
  echo "Building $som_dashboard_plugin"
  yarn build
  echo "Copying $som_dashboard_plugin"
  package_name=$(jq -r '.id' ./opensearch_dashboards.json)
  cp $base_path_plugins/$som_dashboard_plugin/build/$package_name-$OPENSEARCH_DASHBOARDS_VERSION.zip /home/node/packages/som-dashboard-plugins/$package_name-$OPENSEARCH_DASHBOARDS_VERSION.zip
done
cd $base_path_plugins
rm -rf som-dashboard-plugins
