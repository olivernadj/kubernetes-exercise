# Kubernetes exercise 

## Docker

### Build and Push
Build a docker image and push it to the Docker Hub 
```
cd docker
docker build -t echo-server .
docker tag echo-server olivernadj/echo-server:1.0
docker tag echo-server olivernadj/echo-server
docker login
docker push olivernadj/echo-server:1.0
docker push olivernadj/echo-server
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


# export current kube config in case you interact with multiple configs.
export KUBECONFIG=./kubeconfig.yaml

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
kubectl delete -f echo-server.yaml
```

### 02-replication
```
cd examples/02-replication

# create replication controller
kubectl create -f echo-server-repl-controller.yaml

# get list of replication controller
kubectl get rc

# remove recently created kubernetes object
kubectl delete -f echo-server-repl-controller.yaml
```

### 03-deployment
```
cd examples/03-deployment

# create replication controller
kubectl create -f echo-server-deployment.yaml --record

# get deployemnt rollout status
kubectl rollout status deployment/echoserver-depl

# get list of deployments
kubectl get deploy

# get list of replica sets
kubectl get rs

# get list of pods with lables
kubectl get pod --show-labels

# expose it
kubectl expose deployment echoserver-depl --name=echoserver-service --type=NodePort
# check the content
minikube service echoserver-service --url

# update image of deployment
kubectl set image deployment/echoserver-depl echoserver-container=olivernadj/echo-server:1.1
kubectl rollout history deployment/echoserver-depl

kubectl rollout undo deployment/echoserver-depl

kubectl edit deployment/echoserver-depl

# remove recently created kubernetes object
kubectl delete -f echo-server-deployment.yaml
```

### 04-service
```
cd examples/04-service

# create replication controller
kubectl create -f echo-server-deployment.yaml,echo-server-service.yaml --record

# get list of services
kubectl get svc

kubectl delete -f echo-server-deployment.yaml,echo-server-service.yaml
```

### 05-label
```
cd examples/05-label
kubectl create -f echo-server-deployment.yaml
kubectl get deploy
kubectl rollout status deployment/echoserver-depl
kubectl describe pod echoserver-depl-<randid>

kubectl get nodes --show-labels
kubectl label nodes minikube hardware=high-spec

kubectl delete -f echo-server-deployment.yaml
```

### 06-health-check
```
cd examples/06-health-check

# create replication controller
kubectl create -f echo-server-deployment.yaml,echo-server-service.yaml

kubectl describe pod echoserver-depl-<randid>

kubectl delete -f echo-server-deployment.yaml,echo-server-service.yaml
```


### 07-nfs

This example uses hostPath for persistent volume. In production, better use an auto-provisioned persistent volume on GCE, Azure, etc
Credit: https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs


```
cd examples/07-nfs

# create persistent volume for nfs server.
kubectl create -f nfs-server-pv.yaml

# spin up the nfs server.
kubectl create -f nfs-server-deployment.yaml,nfs-server-service.yaml

# get the endpoint IP of the server using the following command
$ kubectl describe services nfs-server

# use the NFS server IP to update www-pv.yaml and execute the following

kubectl describe pod echoserver-depl-<randid>
kubectl delete -f echo-server-deployment.yaml,echo-server-service.yaml
```


### 10-secret-server

You can check out the secret-server repo here:
https://github.com/olivernadj/secret-server-task

```
cd examples/10-secret-server

kubectl create -f goapi-deployment.yaml,grafana-deployment.yaml,nginx-deployment.yaml,prometheus-deployment.yaml,\
redis-deployment.yaml,redis-exporter-service.yaml,goapi-service.yaml,grafana-service.yaml,nginx-service.yaml,\
prometheus-service.yaml,redis-exporter-deployment.yaml,redis-service.yaml

kubectl get deploy
    NAME             READY   UP-TO-DATE   AVAILABLE   AGE
    goapi            3/3     3            3           14s
    grafana          1/1     1            1           14s
    nginx            1/1     1            1           14s
    prometheus       1/1     1            1           14s
    redis            1/1     1            1           14s
    redis-exporter   1/1     1            1           14s

kubectl get svc
    NAME             TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    goapi            ClusterIP      10.111.203.167   <none>        8080/TCP       43s
    grafana          ClusterIP      10.104.213.211   <none>        3000/TCP       43s
    kubernetes       ClusterIP      10.96.0.1        <none>        443/TCP        38m
    nginx            LoadBalancer   10.101.53.13     <pending>     80:30365/TCP   43s
    prometheus       ClusterIP      10.100.100.79    <none>        9090/TCP       43s
    redis            ClusterIP      10.108.52.230    <none>        6379/TCP       43s


minikube service nginx --url

kubectl delete -f goapi-deployment.yaml,grafana-deployment.yaml,nginx-deployment.yaml,prometheus-deployment.yaml,\
redis-deployment.yaml,redis-exporter-service.yaml,goapi-service.yaml,grafana-service.yaml,nginx-service.yaml,\
prometheus-service.yaml,redis-exporter-deployment.yaml,redis-service.yaml

```


### 11-web-ui

More info: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

```
cd examples/11-web-ui

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f dashboard-adminuser.yaml

#this will provide you with the token you need for token auth
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')

#this one will hangs, means the proxy is opened
kubectl proxy
```
Kubectl will make Dashboard available at [localhost:8001](http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/.)
