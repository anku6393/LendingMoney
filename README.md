# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

-   Ruby version

-   System dependencies

-   Configuration

-   Database creation

-   Database initialization

-   How to run the test suite

-   Services (job queues, cache servers, search engines, etc.)

-   Deployment instructions

-   ...

# Initial steps and project info

-   When you will run the migrations an admin will be created by deafult which will have 1000000 wallet balance. Credentials will be

-   Email - admin@gmail.com
-   password - 123456

-   We can create user by sign up, user will have default 10000 wallet balance.

# Steps to setup and start the project

-   We need redis version more than 6
-   To run redis use $redis-server in root directory of the project.

-   To run the sidekiq schedular use $bundle exec sidekiq.
-   sidekiq is used to calculate interest periodically.

-   Run rails server $rails s
-   Install gems $bundle install
-   create database $rails db:create, $rails db:migrate

-   By default server will serve at 3000 port. http://127.0.0.1:3000

* Note: If there will be the issue while running the $bundle install use $gem update --system 3.3.22
