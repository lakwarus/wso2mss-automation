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
echo "Delete Redis Cluster"
echo "--------------------------------------------------------------"

cd $REDIS_HOME/container/kubernetes/
kubectl delete -f redis-sentinel-service.yaml
kubectl delete -f redis-controller.yaml
kubectl delete -f redis-sentinel-controller.yaml


echo "--------------------------------------------------------------"
echo "Deleting Pet"
echo "--------------------------------------------------------------"

cd $PET_HOME/container/kubernetes/
kubectl delete -f .


echo "--------------------------------------------------------------"
echo "Deleting FileServer"
echo "--------------------------------------------------------------"
cd $FILESERVER_HOME/container/kubernetes/
kubectl delete -f .


echo "--------------------------------------------------------------"
echo "Deleting FrontEnd Admin"
echo "--------------------------------------------------------------"
cd $FRONTEND_ADMIN/container/kubernetes/
kubectl delete -f .

echo "--------------------------------------------------------------"
echo "Deleting FrontEnd User"
echo "--------------------------------------------------------------"
cd $FRONTEND_USER/container/kubernetes/
kubectl delete -f .


echo "--------------------------------------------------------------"
echo "Deleting Security"
echo "--------------------------------------------------------------"
cd $SECURITY/container/kubernetes/
kubectl delete -f .


echo "--------------------------------------------------------------"
echo "Deleting Transaction"
echo "--------------------------------------------------------------"
cd $TRANSACTION/container/kubernetes/
kubectl delete -f .

