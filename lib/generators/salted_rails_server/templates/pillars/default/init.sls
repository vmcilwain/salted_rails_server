default:
  rails_env: development
  user:
    username: deploy
    shell: /bin/bash
  ssh:
    key: ssh-rsa ......
  ruby:
    version: 2.2.4
  mysql:
    root_password: somepassword
    rails_user: rails_user
    rails_user_password: somepassword
  elasticsearch:
    version: 2.3.4
