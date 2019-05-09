# Kubernetes exercise 

## Docker

### Build and Push
Build a docker image and push it to the Docker Hub 
```
cd docker
docker build -t echo-server .
tag echo-server olivernadj/echo-server
push olivernadj/echo-server
```

### Run the public image locally
Run te newly created public image locally as a service
```
docker pull olivernadj/echo-server
docker stop echo-server-container
docker rm echo-server-container
docker run --name=echo-server-container -p 8080:8080 -d olivernadj/echo-server
```

### Run the local image for development purpose
```
docker build -t echo-server .
docker run --name echo-server-container -p 8080:8080 --rm -it echo-server
```

## kubectl examples

Useful commands
```
# check contexs
kubectl config get-contexts

# set current context
kubectl config use-context minikube

# remove all pods, deployments and services
kubectl delete --all pods && kubectl delete --all deployments && kubectl delete --all services

```


### 01-fist-app
```
cd examples/01-fist-app

# create a pod in kubernetes
kubectl create -f echo-server.yaml

# get description of the pod
kubectl get pod
kubectl describe pod echoserver-pod

# execute a command on the running pod
kubectl exec echoserver-pod -it -- bash

# possible command line way to expose the pod
kubectl port-forward echoserver-pod 8081:8080
kubectl expose pod echoserver-pod --type=NodePort --name echoserver-service
kubectl get svc
minikube service echoserver-service --url
kubectl describe svc echoserver-service
kubectl delete svc echoserver-service

# expose with config
kubectl create -f echo-server-service.yaml

# remove recently created kubernetes object
kubectl delete -f echo-server.yaml,echo-server-service.yaml
```

### 02-replication
```
cd examples/02-replication

# create replication controller
kubectl create -f echo-server-repl-controller.yaml,echo-server-service.yaml

# get list of replication controller
kubectl get rc

# remove recently created kubernetes object
kubectl delete -f echo-server-repl-controller.yaml,echo-server-service.yaml
```




