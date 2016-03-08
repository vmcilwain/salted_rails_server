default:
  user:
    username: deploy
    shell: /bin/bash
  ssh:
    key: ssh-rsa ......
  ruby:
    version: 2.2.3
  mysql:
    root_password: somepassword
    rails_user: rails_user
    rails_user_password: somepassword
  elasticsearch:
    version: elasticsearch-1.7.2.deb