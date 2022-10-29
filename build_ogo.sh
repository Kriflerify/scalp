#! /bin/zsh

if [[ $MINIKUBE_ACTIVE_DOCKERD != "minikube" ]]; then
    echo $MINIKUBE_ACTIVE_DOCKERD
    echo "ACTIVATING Minikube-dockerd"
    eval $(minikube docker-env)
fi
    

WD=$HOME/scalp
NEW_BUILD_DATE=$(find $WD/ogo -path "$WD/ogo/bin*" -o -path "$WD/ogo/obj*" -prune -o -exec stat -f%m {} \; | sort -n -r | head -1)
if [[ $NEW_BUILD_DATE != $OLDBUILDDATE ]]; then
    echo "BUILDING"
    export OLDBUILDDATE=$NEW_BUILD_DATE
    DOCKER_BUILDKIT=1 docker build -t ogo $WD/ogo
    yes | docker image prune


    OGO_DEPLOYED=$(kubectl get deployments -o=jsonpath="{.items[?(@.metadata.name=='ogo-deployment')].status.conditions[0].type}")
    echo $OGO_DEPLOYED
    if [[ $OGO_DEPLOYED != "Available" ]]; then
        echo "DEPLOYING OGO"
        kubectl apply -f $WD/ogo-deployment.yaml
    else
        echo "ALREADY DEPLOYED"
        kubectl rollout restart deployments/ogo-deployment
    fi
    kubectl wait deployments -l app=ogo --for=condition=Available=True --timeout=90s
else
    echo "NOT BUILDING ogo because already built"
fi
