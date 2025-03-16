#!/bin/bash

echo "Iniciando Minikube..."
minikube start
kubectl config use-context minikube

echo "Configurando Docker localmente com Minikube..."
eval $(minikube docker-env)

echo "Habilitando addons do Minikube..."
minikube addons enable metallb
minikube addons enable metrics-server

echo "Construindo a imagem Docker..."
docker build -t full-plate:v1 .

echo "Aplicando postgres.yaml e deployment.yaml..."
kubectl apply -f postgres.yaml
kubectl apply -f deployment.yaml

echo "Aguardando os pods ficarem prontos..."
while [[ $(kubectl get pods --no-headers | grep -c "0/1") -gt 0 ]]; do
  echo "Ainda aguardando os pods ficarem prontos..."
  sleep 5
done
echo "Todos os pods estão prontos!"

echo "Aplicando service.yaml..."
kubectl apply -f service.yaml

echo "Aplicando secret.yaml..."
kubectl apply -f secret.yaml

echo "Aplicando configmap.yaml..."
kubectl apply -f configmap.yaml

echo "Aplicando hpa.yaml..."
kubectl apply -f hpa.yaml

echo "Validando objetos criados..."
kubectl get pods
kubectl get svc
kubectl get hpa

echo "Obtendo o endpoint do serviço..."
minikube service full-plate-service --url

echo "Processo concluído!"
