#!/bin/bash

HOME=`pwd`
VAGRANT_HOME="$HOME/coreos-kubernetes/multi-node/vagrant/"
SHARE_FOLDER="$HOME/coreos-kubernetes/multi-node/vagrant/docker/"
PET_HOME="$HOME/product-mss/samples/petstore/microservices/pet"
FILESERVER_HOME="$HOME/product-mss/samples/petstore/microservices/fileserver"
REDIS_HOME="$HOME/product-mss/samples/petstore/microservices/redis"
FRONTEND_ADMIN="$HOME/product-mss/samples/petstore/microservices/frontend-admin"
FRONTEND_USER="$HOME/product-mss/samples/petstore/microservices/frontend-user"
SECURITY="$HOME/product-mss/samples/petstore/microservices/security"
TRANSACTION="$HOME/product-mss/samples/petstore/microservices/transaction"


echo "--------------------------------------------------------------"
echo "Deploying Redis Cluster"
echo "--------------------------------------------------------------"

cd $REDIS_HOME/container/kubernetes/
kubectl create -f redis-master.yaml
sleep 10
kubectl create -f redis-sentinel-service.yaml
kubectl create -f redis-controller.yaml
kubectl create -f redis-sentinel-controller.yaml
kubectl scale rc redis --replicas=3
kubectl scale rc redis-sentinel --replicas=3
sleep 10
kubectl delete pods redis-master


echo "--------------------------------------------------------------"
echo "Deploying Pet"
echo "--------------------------------------------------------------"

cd $PET_HOME/container/kubernetes/
kubectl create -f .


echo "--------------------------------------------------------------"
echo "Deploying FileServer"
echo "--------------------------------------------------------------"
kubectl label nodes 172.17.4.201 disktype=ssd
cd $FILESERVER_HOME/container/kubernetes/
kubectl create -f .


echo "--------------------------------------------------------------"
echo "Deploying FrontEnd Admin"
echo "--------------------------------------------------------------"
cd $FRONTEND_ADMIN/container/kubernetes/
kubectl create -f .

echo "--------------------------------------------------------------"
echo "Deploying FrontEnd User"
echo "--------------------------------------------------------------"
cd $FRONTEND_USER/container/kubernetes/
kubectl create -f .


echo "--------------------------------------------------------------"
echo "Deploying Security"
echo "--------------------------------------------------------------"
cd $SECURITY/container/kubernetes/
kubectl create -f .


echo "--------------------------------------------------------------"
echo "Deploying Transaction"
echo "--------------------------------------------------------------"
cd $TRANSACTION/container/kubernetes/
kubectl create -f .

