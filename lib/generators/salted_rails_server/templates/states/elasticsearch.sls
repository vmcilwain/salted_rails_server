openjdk_7_jre:
  pkg.installed:
    - name: openjdk-7-jre

es_download:
  cmd.run:
    - name: wget -P /tmp/ https://download.elastic.co/elasticsearch/elasticsearch/{{ salt['pillar.get']('default:elasticsearch:version', 'elasticsearch-1.7.2.deb') }}
    - require:
      - pkg: openjdk_7_jre

es_install:
  cmd.run:
    - name: dpkg -i /tmp/{{ salt['pillar.get']('default:elasticsearch:version', 'elasticsearch-1.7.2.deb') }}
    - require:
      - cmd: es_download

es_auto_start:
  cmd.run:
    - name: update-rc.d elasticsearch defaults
    - require:
      - cmd: es_install

start_elasticsearch:
  cmd.run:
    - name: service elasticsearch start
    - require:
      - cmd: es_auto_start
