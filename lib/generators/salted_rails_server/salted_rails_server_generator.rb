class SaltedRailsServerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'create directories'
  def create_file_structure
    run 'mkdir -p salt_ssh/pillars'
    run 'mkdir -p salt_ssh/states/backup/files/home/deploy/bin'
    run 'mkdir -p salt_ssh/states/backup/files/home/deploy/config'
    run 'mkdir -p salt_ssh/states/logrotate/files/etc/logrotate.d'
    run 'mkdir -p salt_ssh/states/monit/etc/monit'
  end

  desc 'generatre default pillar'
  def copy_pillar_files
    copy_file 'pillars/default.sls', 'salt_ssh/pillars/default.sls'
    copy_file 'pillars/top.sls', 'salt_ssh/pillars/top.sls'
  end

  desc 'generate state files'
  def copy_state_files
    Dir["#{__dir__}/templates/states/**/*"].each do |file|
      copy_file file, "salt_ssh/#{file.gsub(__dir__+'/templates/', '')}" unless File.directory? file
    end
  end

  desc 'generate roster file'
  def copy_roster
    copy_file 'roster', 'roster'
  end

  desc 'generate master file'
  def generate_master
    create_file 'master', <<-CODE
file_roots:
  base:
    - #{Rails.root}/salt_ssh/states

pillar_roots:
  base:
  - #{Rails.root}/salt_ssh/pillars
    CODE
  end

  desc 'generate Saltfile file'
  def generate_saltfile
    create_file "Saltfile", <<-CODE
salt-ssh:
  config_dir: #{Rails.root}
  roster_file: #{Rails.root}/roster
  log_file: #{Rails.root}/salt.log
    CODE
  end
end
