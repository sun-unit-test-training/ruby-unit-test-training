# ruby-unit-test-training

* Ruby version: 2.7.1
* Rails version: 6.0.3.3

* Configuration steps:
  - Run `cp config/application.yml.example config/application.yml` and setup values for environment variables in `config/application.yml`
  - Run `bundle exec rails db:create db:migrate` to setup database

* Check coverage result:
  - After running your tests, open `coverage/index.html` in the browser to view the detail report of coverage result

* Init database for exercise 9:
  - Run `bundle exec rake init_hanoi_quest_data:create` to setup database for exercise 9

* Docker version:
  - Run `docker-compose build` to build image
  - Run `docker-compose run web bundle exec rails db:create db:migrate` to create and migrate database
  - Run `docker-compose run --rm web bundle exec rails init_hanoi_quest_data:create` to setup database for exercise 9 
  - Run `docker-compose up` to start application container
