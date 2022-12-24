STAGE=$1 # DEV O PROD
GRAFANA_PASSWORD=$GRAFANA_PASSWORD # LA CONTRASENA PARA LA PWD DE GRAFANA DEBE ESTAR COMO VARIABLE DE ENTORNO
DEV_HOST=ec2-3-216-199-173.compute-1.amazonaws.com
PROD_HOST=ec2-35-169-79-235.compute-1.amazonaws.com

APP_PORT=3002 # PUERTO DE LA APLICACION A MONITORIZAR
APP_NAME=smmp-api # HOST DE LA APLICACION A MONITORIZAR
DOCKER_NET=local_net # RED DE DOCKER
PROMETHEUS_NAME=smmp-prometheus
GRAFANA_NAME=smmp-grafana

if [[ $STAGE == 'dev' ]] 
then
  echo "[*] on: DEV"
  SERVER_HOST=$DEV_HOST
elif [[ $STAGE == 'prod' ]] 
then
  echo "[*] on: PROD"
  SERVER_HOST=$PROD_HOST
else
  echo "usage: config-monitor.sh <stage:dev|prod> "
  exit 0
fi

# clean previous containers
sudo docker stop $PROMETHEUS_NAME
sudo docker stop $GRAFANA_NAME

# make prometheus config
export APP_HOST=$APP_NAME
export APP_PORT=$APP_PORT
envsubst < ci/templates/prometheus.yml  > prometheus.yml

# run prometheus
sudo docker run --network $DOCKER_NET --name $PROMETHEUS_NAME --rm -d \
  -p 9090:9090 \
  -v "$(pwd)/prometheus.yml":/etc/prometheus/prometheus.yml \
  prom/prometheus

# run grafana
sudo docker run --network $DOCKER_NET --name $GRAFANA_NAME --rm -d \
  -p 4000:4000 \
  grafana/grafana

# change grafana password
echo "Grafana: updating password..."
curl localhost:3000/api/user/password -u "admin:admin" \
  -X 'PUT' \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/plain, */*' \
  --data-raw '{"oldPassword":"admin","newPassword":"$GRAFANA_PASSWORD","confirmNew":"$GRAFANA_PASSWORD"}' \
  --compressed

# add prometheus data source to grafana
echo "Grafana: set prometheus data source..."
curl localhost:3000/api/datasources -u "admin:$GRAFANA_PASSWORD" \
  -H "Content-Type: application/json;charset=UTF-8" \
  -H "accept: application/json, text/plain, */*" \
  --data-raw "{"name":"DS_PROMETHEUS","type":"prometheus","url":"http://$PROMETHEUS_NAME:$PROMETHEUS_PORT","access":"proxy","jsonData":{"keepCookies":[]},"secureJsonFields":{}}" \
  --compressed