monit:
  pkg.installed: []
  service.running:
    - watch:
      - pkg: monit

monitrc-copy:
  file.copy:
   - name: /etc/monit/monitrc.bak
   - source: /etc/monit/monitrc
/etc/monit/monitrc:
  file.managed:
    - source: salt://monit/etc/monit/monitrc
    - template: jinja
    - context:
      aws_ses_username: {{ salt['pillar.get']('default:amazon:ses_username') }}
      aws_ses_password: {{ salt['pillar.get']('default:amazon:ses_password') }}
      from: monit@noinc.com
      email1: lovell@noinc.com
    - backup: /etc/monit/backup
