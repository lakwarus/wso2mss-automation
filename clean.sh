#!/bin/bash

# exporting paths
source path.sh

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

