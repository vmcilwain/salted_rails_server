bundler:
  gem.installed:
    - name: bundler
    - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}
    - ruby: {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}
rails:
  gem.installed:
    - name: rails
    - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}
    - rdoc: False
    - ri: False
    - ruby: {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}
    - require:
      - gem: bundler

unicorn:
  gem.installed:
    - name: unicorn
    - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}
    - ruby: {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}

rails_env:
  cmd.run:
    - name: "echo 'export RAILS_ENV={{ salt['pillar.get']('default:rails_env', 'development') }}' >> $HOME/.bashrc"
    - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}

mkdir /var/www:
  cmd.run:
    - creates: /var/www

chown /var/www:
  cmd.run:
    - name: chown {{ salt['pillar.get']('default:user:username', 'deploy') }}:{{ salt['pillar.get']('default:user:username', 'deploy') }} /var/www
    - require:
      - cmd: mkdir /var/www
