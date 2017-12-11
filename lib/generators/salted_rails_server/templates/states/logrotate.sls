/etc/logrotate.d/rails:
  file.managed:
    - source: salt://logrotate/files/etc/logrotate.d/rails
