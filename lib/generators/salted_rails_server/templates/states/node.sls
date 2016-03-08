nodejs:
  pkg.installed

npm:
  pkg.installed:
    - require:
      - pkg: nodejs

symlink:
  cmd.run:
    - name: ln -s /usr/bin/nodejs /usr/bin/node
    - require:
      - pkg: nodejs
