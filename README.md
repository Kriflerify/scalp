## Running dev version
```
minikube start
. ./build_ogo.sh
./serve_ogo.sh
```
Second terminal:
```
./run.sh
```
## <3
kubectl set image deployment/frontend www=image:v2
