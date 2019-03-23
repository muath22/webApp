#! /bin/bash

# $1 = icp cluster ip address
# $2 = icp cluster port
# $3 = namespace
# $4 = application name
# $5 = application listening port

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
elif [ $# -lt 6 ]
  then
    echo "arguments are not completed"
    exit 1
fi

# login to icp registry
docker login $1:$2 -u admin -p admin

# build Docker image
docker build -t $1:$2/$3/$4 .
docker push $1:$2/$3/$4

# create Kubernetes deployment
kubectl run $4-deployment --image=$1:$2/$3/$4 -n $3
# create Kubernetes service
kubectl expose deployment/$4-deployment --type=NodePort --port=$5 --name=$4-service --target-port=$5 -n $3
