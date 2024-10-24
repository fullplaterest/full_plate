# FullPlate

Este projeto utiliza [Elixir](https://elixir-lang.org/) e [Phoenix Framework](https://www.phoenixframework.org/) para criar uma aplicação web referente ao projeto da pos graduacao FIAP ARQUITETURA DE SOFTWARE.
Este projeto tem como objetivo criar uma aplicacao que resolve uma demanda de gerenciamento de pedido para um restaurante, organizando os pedidos em filas e facilitando a organizacao para o restaurante

Aqui estão as instruções para configurar e rodar a aplicação localmente usando Docker.

## Pré-requisitos

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)

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
  
