#!/bin/bash
echo "Building docker images..."

env=dev
    
docker build --no-cache --secret id=aws,src=$HOME/.aws/credentials --ssh default=$SSH_AUTH_SOCK --build-arg BUILD_TIME_CURRENT_ENV=$env -t test-launcher .
docker save test-launcher > test-launcher.tar
minikube image load test-launcher
kubectl apply -f deployment.yaml

echo "Saving docker image...$env"