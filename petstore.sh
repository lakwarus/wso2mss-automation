#!/bin/bash

# exporting paths
source path.sh


echo "--------------------------------------------------------------"
echo "Creating Kube-System Namespace, Kube-DNS, Kube-UI"
echo "--------------------------------------------------------------"
kubectl create -f $VAGRANT_HOME/plugins/namespace/kube-system.json
kubectl create -f $VAGRANT_HOME/plugins/dns/dns-service.yaml
kubectl create -f $VAGRANT_HOME/plugins/dns/dns-controller.yaml
kubectl create -f $VAGRANT_HOME/plugins/kube-ui/kube-ui-controller.yaml
kubectl create -f $VAGRANT_HOME/plugins/kube-ui/kube-ui-service.yaml


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
kubectl label nodes 172.17.8.102 disktype=ssd
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

