#!/bin/bash

# Passo 01: Start Minikube e configurar o contexto
echo "Iniciando Minikube..."
minikube start
kubectl config use-context minikube

# Passo 02: Configurar Docker localmente e habilitar addons
echo "Configurando Docker localmente com Minikube..."
eval $(minikube docker-env)

echo "Habilitando addons do Minikube..."
minikube addons enable metallb
minikube addons enable metrics-server

# Passo 03: Build da imagem Docker
echo "Construindo a imagem Docker..."
docker build -t full-plate:v1 .

# Passo 04: Aplicar postgres.yaml e deployment.yaml
echo "Aplicando postgres.yaml e deployment.yaml..."
kubectl apply -f postgres.yaml
kubectl apply -f deployment.yaml

# Passo 05: Aplicar service.yaml
echo "Aplicando service.yaml..."
kubectl apply -f service.yaml

# Passo 06: Aplicar secret.yaml
echo "Aplicando secret.yaml..."
kubectl apply -f secret.yaml

# Passo 07: Aplicar configmap.yaml
echo "Aplicando configmap.yaml..."
kubectl apply -f configmap.yaml

# Passo 08: Aplicar hpa.yaml
echo "Aplicando hpa.yaml..."
kubectl apply -f hpa.yaml

# Passo 09: Validar objetos criados
echo "Validando objetos criados..."
kubectl get pods
kubectl get svc
kubectl get hpa

# Passo 10: Obter o endpoint do serviço
echo "Obtendo o endpoint do serviço..."
minikube service full-plate-service --url

echo "Processo concluído!"
