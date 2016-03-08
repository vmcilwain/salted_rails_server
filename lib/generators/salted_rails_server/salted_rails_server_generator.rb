class SaltedRailsServerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  desc 'create salted_rails_server directories'
  def create_file_structure
    run 'mkdir -p salted_rails_server/pillars'
    run 'mkdir -p salted_rails_server/pillars/default'
    run 'mkdir -p salted_rails_server/states'
  end

  desc 'generatre salted_rails_server default pillar template'
  def copy_pillar_files
    copy_file 'pillars/default/init.sls', 'salted_rails_server/pillars/default/init.sls'
    copy_file 'pillars/top.sls', 'salted_rails_server/pillars/top.sls'
  end
  
  desc 'generate salted_rails_server state files'
  def copy_state_files
    copy_file 'states/elasticsearch.sls', 'salted_rails_server/states/elasticsearch.sls'
    copy_file 'states/mysql.sls', 'salted_rails_server/states/mysql.sls'
    copy_file 'states/nginx.sls', 'salted_rails_server/states/nginx.sls'
    copy_file 'states/node.sls', 'salted_rails_server/states/node.sls'
    copy_file 'states/rails.sls', 'salted_rails_server/states/rails.sls'
    copy_file 'states/rvm.sls', 'salted_rails_server/states/rvm.sls'
    copy_file 'states/setup.sls', 'salted_rails_server/states/setup.sls'
    copy_file 'states/user.sls', 'salted_rails_server/states/user.sls'
  end
  
  desc 'generate salted_rails_server salt-ssh roster file'
  def copy_roster
    copy_file 'roster', 'roster'
  end
  
  desc 'generate salted_rails_server salt-ssh master file'
  def generate_master
    create_file 'master', <<-CODE
file_roots:
  base:
    - #{Rails.root}/salted_rails_server/states

pillar_roots:
  base:
  - #{Rails.root}/salted_rails_server/pillars
    CODE
  end
  
  desc 'generate salted_rails_server salt-ssh Saltfile file'
  def generate_saltfile
    create_file "Saltfile", <<-CODE
salt-ssh:
  config_dir: #{Rails.root}
  roster_file: #{Rails.root}/roster
  log_file: #{Rails.root}/saltlog.txt
    CODE
  end
end
