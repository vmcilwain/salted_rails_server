backup:
  gem.installed:
    - user: {{ salt['pillar.get']('default:user:username') }}
    - ruby: {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}
    - version: {{ salt['pillar.get']('default:backup:version', '5.0.0.beta.1') }}

whenever:
  gem.installed:
    - user: {{ salt['pillar.get']('default:user:username') }}
    - ruby: {{ salt['pillar.get']('default:ruby:version', '2.2.3') }}

/home/{{ salt['pillar.get']('default:user:username') }}/config:
  file.directory:
    - user: {{ salt['pillar.get']('default:user:username') }}
    - group: {{ salt['pillar.get']('default:user:username') }}

/home/{{ salt['pillar.get']('default:user:username') }}/config/schedule.rb:
  file.managed:
    - source: salt://backup/files/home/deploy/config/schedule.rb
    - user: {{ salt['pillar.get']('default:user:username') }}
    - group: {{ salt['pillar.get']('default:user:username') }}
    - template: jinja
    - context:
        role: {{salt['grains.get']('role')}}
update_crontab:
  cmd.run:
    - name: cd /home/{{ salt['pillar.get']('default:user:username') }}/ && whenever --update-crontab
    - user: deploy

/home/{{ salt['pillar.get']('default:user:username') }}/bin:
  file.directory:
    - user: {{ salt['pillar.get']('default:user:username') }}
    - group: {{ salt['pillar.get']('default:user:username') }}

/home/{{ salt['pillar.get']('default:user:username') }}/bin/backup.rb:
  file.managed:
    - source: salt://backup/files/home/{{ salt['pillar.get']('default:user:username') }}/bin/backup.rb
    - template: jinja
    - context:
      aws_access_key: {{ salt['pillar.get']('default:amazon:access_key') }}
      aws_secret_key: {{ salt['pillar.get']('default:amazon:secret_key') }}
      aws_ses_username: {{ salt['pillar.get']('default:amazon:ses_username') }}
      aws_ses_password: {{ salt['pillar.get']('default:amazon:ses_password') }}
      aws_ses_emails: 'lovell@noinc.com'
      role: {{salt['grains.get']('role')}}
      db_name: {{ salt['grains.get']('db_name') }}
      db_password: {{ salt['grains.get']('db_password') }}
      s3_bucket_name: {{ salt['grains.get']('s3_bucket_name') }}
/var/backups/rails:
  file.directory:
    - user: {{ salt['pillar.get']('default:user:username') }}
    - group: {{ salt['pillar.get']('default:user:username') }}
