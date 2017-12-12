default:
  rails_env: development
  user:
    username: deploy
    shell: /bin/bash
  ssh:
    key: ssh-rsa ...
  ruby:
    version: 2.4.1
  rails:
    version: 5.1.3
  mysql:
    root_password: db-password
    rails_user: db-user
    rails_user_password: db-user-password
  elasticsearch:
    version: elasticsearch-5.2.2.deb
  backup:
      version: 5.0.0.beta.1
  amazon:
    access_key:
    secret_key:
    ses_username:
    ses_password:
