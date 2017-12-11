# encoding: utf-8

##
# Backup v5.x Configuration
#
# Documentation: http://meskyanichi.github.io/backup
# Issue Tracker: https://github.com/meskyanichi/backup/issues
#
# Demo DB Backup
# To backup the dabasse: backup perform -c /home/deploy/bin/backup.rb -t demo
Backup::Model.new('{{ role }}', '{{ role }} backup strategy') do

  # Backup for staging
  database MySQL do |database|
    database.name = '{{ db_name }}'
    database.username = 'root'
    database.password = '{{ db_password}}'
    database.additional_options = ['--single-transaction', '--quick']
  end

  compress_with Gzip

  store_with S3 do |s3|
    s3.access_key_id = '{{ aws_access_key }}'
    s3.secret_access_key = '{{ aws_secret_key }}'
    s3.region = 'us-east-1'
    s3.bucket = '{{ s3_bucket_name }}'
    s3.path = 'backups'
    s3.keep = 1000
  end

  store_with Local do |local|
    local.path = "/var/backups/rails"
    local.keep = 10
  end

  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_warning           = false
    mail.on_failure           = true

    # For information on the types of these attributes, see the Mail gem documentation.
    # http://www.rubydoc.info/github/mikel/mail/Mail/Message
    mail.from                 = 'wtw-{{ role }}-backup@noinc.com'
    mail.to                   = '{{ aws_ses_emails }}'
    # mail.cc                   = 'cc@email.com'
    # mail.bcc                  = 'bcc@email.com'
    mail.reply_to             = 'no_reply@noinc.com'
    mail.address              = 'email-smtp.us-east-1.amazonaws.com'
    mail.port                 = 587
    mail.domain               = 'noinc.com'
    mail.user_name            = '{{ aws_ses_username }}'
    mail.password             = '{{ aws_ses_password }}'
    mail.authentication       = 'plain'
    mail.encryption           = :starttls

    # Change default notifier message.
    # See https://github.com/backup/backup/pull/698 for more information.
    # mail.message = lambda do |model, data|
    #   "[#{data[:status][:message]}] #{model.label} (#{model.trigger})"
    # end
  end

end
