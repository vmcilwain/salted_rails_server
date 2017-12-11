nodejs:
  pkg.installed

npm:
  pkg.installed:
    - require:
      - pkg: nodejs

{% if not salt['file.file_exists' ]('/usr/bin/node') %}
symlink:
  file.symlink:
    - name: /usr/bin/node
    - target: /usr/bin/nodejs
{% endif %}
