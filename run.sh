minikube_status=$(minikube status)
if [[ $minikube_status != *"host: Running"* || $minikube_status != *"kubelet: Running"* || $minikube_status != *"apiserver: Running"* || $minikube_status != *"kubeconfig: Configured"* ]]; then
    minikube start 
fi

# if [[ $minikube_status != *"docker-env: in use"* ]]; then
    eval "$(minikube docker-env)"
# fi

eval "$(minikube completion zsh)"
eval "$(kubectl completion zsh)"

. ./build_ogo.sh

kubectl delete services/ogo-svc
kubectl apply -f $WD/ogo-service.yaml

kubectl apply -f ./secrets.yaml

coproc minikube mount ./data:/data 
grep -m 1 "Successfully mounted" <&p

kubectl apply -f ./mongo.yaml

export MONGO=$(k get pods -l app=mongodb | grep -m 1 -o "mongo-dep-[^ ]*")
export ME=$(k get pods -l app=mongodb-express | grep -m 1 -o "me-dep-[^ ]*")
