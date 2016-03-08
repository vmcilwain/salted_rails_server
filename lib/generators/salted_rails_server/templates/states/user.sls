{{ salt['pillar.get']('user:username', 'deploy') }}:
  user.present:
    - name: {{ salt['pillar.get']('default:user:username', 'deploy') }}
    - shell: {{ salt['pillar.get']('default:user:shell', '/bin/bash') }}
    - home: /home/{{ salt['pillar.get']('default:user:username', 'deploy') }}

deploy-rsa:
  ssh_auth:
    - present
    - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}
    - enc: rsa
    - names:
      -  {{ salt['pillar.get']('default:ssh:key') }}
    - require:
      - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}

add-to-sudo:
  cmd.run:
    - name: "echo '{{ salt['pillar.get']('default:user:username', 'deploy') }} ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
    - require:
      - user: {{ salt['pillar.get']('default:user:username', 'deploy') }}
