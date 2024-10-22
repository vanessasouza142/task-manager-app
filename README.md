# Task-Manager App

Este é um projeto gerenciamento de tarefas que se comunica com três microserviços (de autenticação de usuários, de notificações e de web-scraping). Ele também fornece endpoint para atualizar o status/resultado da tarefa.

## Requisitos

- **Ruby** 3.2.2
- **Rails** 7.1.4.1
- **MySQL** 8.0+
- **Docker** (opcional, para rodar via Docker)

## Instalação

1. Clone o repositório do task-manager para o seu computador:
   > git clone https://github.com/vanessasouza142/task-manager-app.git
2. Clone o repositório do microserviço de autenticação para o seu computador:
   > git clone https://github.com/vanessasouza142/auth-microservice.git
3. Clone o repositório do microserviço de notificação para o seu computador:
   > git clone https://github.com/vanessasouza142/notification-microservice.git
4. Clone o repositório do microserviço de web-scraping para o seu computador:
   > git clone https://github.com/vanessasouza142/web-scraping-microservice.git
5. Navegue até o diretório de cada projeto: 
   > cd <nome-do-projeto>
6. Instale as dependências de cada projeto:
   > bundle install
7. Crie e migre o banco de dados MySQL de cada projeto:
   > rails db:create
   > rails db:migrate

## Executando o Servidor

1. Inicie o servidor Rails de cada projeto:
   > task-manager-app: rails server -p 3000
   > auth-microservice: rails server -p 3001
   > notification-microservice: rails server -p 3002
   > web-scraping-microservice: rails server -p 3003

## Documentação

A documentação da API desse projeto foi desenvolvida e pode ser acessada através do Postman.

1. Acesse a documentação no link abaixo:
   > https://documenter.getpostman.com/view/23291260/2sAXxY3oEp

## Testes

1. O projeto inclui testes de funcionalidades e para os microserviços. Para rodar, execute:
   > rspec