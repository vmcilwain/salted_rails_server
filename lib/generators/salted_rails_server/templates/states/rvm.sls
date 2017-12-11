gpg-deps:
    pkg.installed:
        - names:
            - gpgv

gpg-import-D39DC0E3:
    cmd.run:
      - require:
          - pkg: gpg-deps
#      - user: rvm
#      - require:
#        - user: rvm
      - name: gpg --keyserver hkp://keys.gnupg.net:80 --recv-keys D39DC0E3; echo '409B6B1796C275462A1703113804BB82D39DC0E3:4:' |gpg --import-ownertrust
      - unless: gpg --fingerprint |fgrep 'Key fingerprint = 409B 6B17 96C2 7546 2A17  0311 3804 BB82 D39D C0E3'

rvm-deps:
  pkg.installed:
    - names:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion

mri-deps:
  pkg.installed:
    - names:
      - build-essential
      - openssl
      - libreadline6
      - libreadline-dev
      - curl
      - git-core
      - zlib1g
      - zlib1g-dev
      - libssl-dev
      - libyaml-dev
      - libsqlite3-0
      - libsqlite3-dev
      - sqlite3
      - libxml2-dev
      - libxslt1-dev
      - autoconf
      - libc6-dev
      - libncurses5-dev
      - automake
      - libtool
      - bison
      - subversion
      - ruby

rvm_install:
  cmd.run:
    - name: curl -sSL https://get.rvm.io | bash
    - user: {{ salt['pillar.get']('default:user:username') }}
    - unless: /home/rvm/.rvm/bin/rvm --version
    - require:
      - pkg: rvm-deps
      - pkg: mri-deps
      - cmd: gpg-import-D39DC0E3

rvm_reload:
  cmd.run:
    - name: source ~/.rvm/scripts/rvm
    - user: {{ salt['pillar.get']('default:user:username') }}
    - require:
      - cmd: rvm_install

ruby-{{ salt['pillar.get']('default:ruby:version', '2.2.3') }}:
    cmd.run:
      - name: rvm install {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}
      - user: {{ salt['pillar.get']('default:user:username') }}
      - require:
        - cmd: rvm_reload

rvm_default:
  cmd.run:
    - name: /bin/bash --login -c 'rvm use {{ salt['pillar.get']('default:ruby:version', '2.2.3') }} --default'
    - user: {{ salt['pillar.get']('default:user:username') }}
    - require:
      - cmd: ruby-{{ salt['pillar.get']('default:ruby:version', '2.2.3') }}
