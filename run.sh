#!/bin/bash

PRE_REQ=1
HOME=`pwd`
VAGRANT_HOME="$HOME/coreos-kubernetes/multi-node/vagrant/"
SHARE_FOLDER="$HOME/coreos-kubernetes/multi-node/vagrant/docker/"
PET_HOME="$HOME/product-mss/samples/petstore/microservices/pet"
FILESERVER_HOME="$HOME/product-mss/samples/petstore/microservices/fileserver"
REDIS_HOME="$HOME/product-mss/samples/petstore/microservices/redis"


PRE_RELEASE="Y"
if [ $PRE_RELEASE == "Y" ];then
    RELEASE="-SNAPSHOT"
else
    RELEASE=""
fi
# Checking prerequisites for the build
command -v docker >/dev/null 2>&1 || { echo >&2 "Missing Docker!!! Build required docker install in the host. Try 'curl -sSL https://get.docker.com/ | sh' "; $PRE_REQ=1; }

if [ $PRE_REQ -eq 0 ];then
    echo "--------------------------------------------------------------"
    echo "All prerequisite not met. Existing build..."
    echo "--------------------------------------------------------------"
    exit;
fi

# get latest from git
if [ ! -d product-mss ];then
   echo "--------------------------------------------------------------"
   echo "Clone source code from https://github.com/wso2/product-mss.git"
   echo "--------------------------------------------------------------"
   git clone https://github.com/wso2/product-mss.git
else
    echo "-------------------------------------------------------------------"
    echo "Fetching new updates from https://github.com/wso2/product-mss.git"
    echo "-------------------------------------------------------------------"
    cd product-mss
    git pull
fi

echo "--------------------------------------------------------------"
echo "Building petstore sample"
echo "--------------------------------------------------------------"
cd $HOME/product-mss/samples/petstore/
mvn clean install

# copy Pet
echo "--------------------------------------------------------------"
echo "Copy Pet"
echo "--------------------------------------------------------------"
[ ! -d $SHARE_FOLDER/pet ] && mkdir -P $SHARE_FOLDER/pet
cp -fr $PET_HOME/container/docker $SHARE_FOLDER/pet
[ ! -d $SHARE_FOLDER/pet/docker/packages ] && mkdir -p $SHARE_FOLDER/pet/docker/packages
cp -f $PET_HOME/target/petstore-pet-1.0.0${RELEASE}.jar $SHARE_FOLDER/pet/docker/packages/
cp -f $HOME/jdk-8u60-linux-x64.gz $SHARE_FOLDER/pet/docker/packages/


echo "--------------------------------------------------------------"
echo "Copy FileServer"
echo "--------------------------------------------------------------"
[ ! -d $SHARE_FOLDER/fileserver ] && mkdir -P $SHARE_FOLDER/fileserver
cp -fr $FILESERVER_HOME/container/docker $SHARE_FOLDER/fileserver/



echo "--------------------------------------------------------------"
echo "Cleaning up old docker files"
echo "--------------------------------------------------------------"
[ -f $SHARE_FOLDER/fileserver.tgz ] && rm $SHARE_FOLDER/fileserver.tgz 
[ -f $SHARE_FOLDER/pet.tgz ] && rm $SHARE_FOLDER/pet.tgz 


echo "--------------------------------------------------------------"
echo "Setting up CoreOS and Kubernetes"
echo "--------------------------------------------------------------"

if [ ! -f /usr/local/bin/kubectl ];then
    # TODO need to check incompatibility	
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        wget https://storage.googleapis.com/kubernetes-release/release/v1.0.6/bin/linux/amd64/kubectl
    elif [[ "$OSTYPE" == "darwin"* ]]; then
       wget https://storage.googleapis.com/kubernetes-release/release/v1.0.6/bin/darwin/amd64/kubectl
    fi
    chmod +x kubectl
    mv kubectl /usr/local/bin/kubectl
    cp -a $HOME/bootstrap.sh $VAGRANT_HOME  
fi
cd $VAGRANT_HOME
vagrant up
./kubctl-setup.sh

# TODO check k8s api endpoint
kubectl get nodes


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


