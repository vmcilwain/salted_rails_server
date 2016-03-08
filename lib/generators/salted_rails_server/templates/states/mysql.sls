python-mysqldb:
  pkg.installed:
    - name:
      - python-mysqldb

debconf-utils:
    pkg.installed:
      - name:
        - debconf-utils

mysql:
  pkg.installed:
    - name: mysql-server
  service.running:
    - restart: True
    - enable: True
    - require:
      - pkg: mysql-server
      - pkg: python-mysqldb
    - watch:
      - pkg: mysql-server

libmysqlclient-dev:
  pkg.installed:
    - name:
      - libmysqlclient-dev
    - require:
      - pkg: mysql-server

mysql-client:
  pkg.installed:
    - name:
      - mysql-client
    - require:
      - pkg: mysql-server

{{ salt['pillar.get']('default:mysql:rails_user', 'rails_user') }}:
  mysql_user.present:
    - host: localhost
    - password: {{ salt['pillar.get']('default:mysql:rails_user_password', 'temppassword') }}
    - connection_user: root
    - connection_charset: utf8

rails_user_privs:
  cmd.run:
    - name: mysql -u root -e "GRANT Select,Insert,Update,Delete,Create,Drop,Index,Alter,Lock Tables ON *.* TO '{{ salt['pillar.get']('default:mysql:rails_user', 'rails_user') }}'@'localhost';"
    - require:
      - mysql_user: {{ salt['pillar.get']('default:mysql:rails_user', 'rails_user') }}

change root password:
  cmd.run:
    - name: mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{ salt['pillar.get']('default:mysql:root_password', 'temppassword') }}');"
    - require:
      - cmd: rails_user_privs
