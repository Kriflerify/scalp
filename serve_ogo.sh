#! /bin/zsh

WD=$HOME/scalp
mkdir -p $WD/tmp
OGO_SERVICE_ADDR_FILE=$WD/tmp/ogo_service_addr

TRAPINT() {
    rm -rf $OGO_SERVICE_ADDR_FILE
}

kubectl delete services/ogo-svc
kubectl apply -f $WD/ogo-service.yaml

coproc { minikube service --url ogo-svc 2> /dev/tty ; }
# read -Ep OGO_SVC_IP > $WD/tmp/ogo_service_addr
# { tee >(xargs printf "OGO: %s\n" > /dev/tty) | read OGO_SVC_IP } <&p &
exec 3< <({ tee $OGO_SERVICE_ADDR_FILE <&p })
read OGO_SVC_IP <&3
echo "OGO service address: " $OGO_SVC_IP

wait
