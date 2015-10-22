#!/bin/bash

HOME="/vagrant"
PET=$HOME/pet/docker
FILESERVER=$HOME/fileserver/docker


# creating fileserver folder
mkdir /home/core/fileserver

echo "------------------------------------------------------------------"
echo " load / pull kubernetes/redis:v1"
echo "------------------------------------------------------------------"

if [ -f $HOME/redis.tgz ];then
    cd $HOME
    docker load < redis.tgz
else
    docker pull kubernetes/redis:v1
fi

echo "------------------------------------------------------------------"
echo " load / pull ubuntu:14.04"
echo "------------------------------------------------------------------"

if [ -f $HOME/ubuntu.tgz ];then
    cd $HOME
    docker load < ubuntu.tgz
else
    docker pull ubuntu:14.04 
fi

echo "------------------------------------------------------------------"
echo " load / pull php:5.6-apache"
echo "------------------------------------------------------------------"

if [ -f $HOME/php.tgz ];then
    cd $HOME
    docker load < php.tgz
else
    docker pull php:5.6-apache 
fi


echo "------------------------------------------------------------------"
echo "building / load pet docker"
echo "------------------------------------------------------------------"

if [ ! -f $HOME/pet.tgz ];then
    cd $PET
    docker build -t wso2mss/petstore-pet .
    #sleep 5
    #docker save wso2mss/petstore-pet > pet.tgz
    #mv pet.tgz $HOME/
    #cd $PET/ssh
    #docker build -t wso2mss/ssh .
else
    cd $HOME
    echo ">>>>>>>>>>>>>>>>> LOADING"
    docker load < pet.tgz
fi


echo "------------------------------------------------------------------"
echo "building fileserver docker"
echo "------------------------------------------------------------------"
if [ ! -f $HOME/fileserver.tgz ];then
    cd $FILESERVER
    docker build -t wso2mss/petstore-fileserver .
    #sleep 1
    #docker save wso2mss/petstore-fileserver > fileserver.tgz
    #mv fileserver.tgz $HOME/
else
    cd $HOME
    docker load < fileserver.tgz
fi

