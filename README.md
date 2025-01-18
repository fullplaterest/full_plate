# FullPlate

Este projeto utiliza [Elixir](https://elixir-lang.org/) e [Phoenix Framework](https://www.phoenixframework.org/) para criar uma aplicação web referente ao projeto da pos graduacao FIAP ARQUITETURA DE SOFTWARE.
Este projeto tem como objetivo criar uma aplicacao que resolve uma demanda de gerenciamento de pedido para um restaurante, organizando os pedidos em filas e facilitando a organizacao para o restaurante

Aqui estão as instruções para configurar e rodar a aplicação localmente usando Docker.

## Links Relevantes

**ATIVIDADE 01 -> Pos_tech Tech Challenge Fast Food**  
**TIME:** ELIXIR  
**NOME:** IGOR DE SOUSA PINTO  
**DISCORD NAME:** igorspinto  

- **SWAGGER:** [Documentação no SwaggerHub](https://app.swaggerhub.com/apis/IGORSOUSAPINTO140/full_plate/1.0.0)
- **DRAWIO:** [Diagrama no Draw.io](https://drive.google.com/file/d/1E9i8Jp-_gwBR-zGy5yjTs3kpkzwACpIf/view?usp=drive_link)
- **FIGMA:** [Evento no Figma](https://www.figma.com/board/97LXAMigMP3FbAa8Ytp4Tq/Event-Storming-FIAP?node-id=0-1&t=aeubb6RDalzolFHq-1)
- **GITHUB:** [Repositório no GitHub](https://github.com/igorsousap/full_plate)

## Pré-requisitos

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)

## Configuração do Ambiente

### Passos para iniciar o projeto:

1. **Clone o repositório do projeto**

   Se você ainda não clonou o repositório, faça isso com o comando:

   ```bash
   git clone https://github.com/igorsousap/full_plate.git
   cd full_plate

2. **Iniciando docker**

    ```bash
   docker compose up or docker-compose up

3. **Iniciando kubernats/Minikube**
   Execute o comendo na pasta do projeto
   ```bash
   ./setup_minikube.sh
   ```
   O arquivo executa todos esse passos: 
    ```bash
   passo 01: start minikube -> minikube start -> kubectl config use-context minikube
   passo 02: apontar docker localmente -> eval $(minikube docker-env) 
   -> simula load balancer no minukube -> minikube addons enable metallb
   -> metrics services -> minikube addons enable metrics-server
   passo 03: docker build -t full-plate:v1 .
   passo 04: kubectl apply -f postgres.yaml -> kubectl apply -f deployment.yaml
   passo 05: kubectl apply -f service.yaml
   passo 06: kubectl apply -f secret.yaml
   passo 07: kubectl apply -f configmap.yaml
   passo 08: kubectl apply -f hpa.yaml
   passo 09: validar objetos 
   kubectl get pods
   kubectl get svc
   kubectl get hpa
   passo 10: endpoint -> minikube service full-plate-service --url

Para recuperar os ids dos produtos e usar na criacao dos pedidos segue a configuracao do banco para conexao
```
host: localhost
database: postgres
username: postgres
password: postgres
port: 5432

select * from products
```
Isso iniciará a aplicação e ela estará disponível em http://localhost:4000


Em caso de erro de permissao rodar o comando

   ```bash
  sudo chmod 777 -R .../full_plate/postgres-data
  
