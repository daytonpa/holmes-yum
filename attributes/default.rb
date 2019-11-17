
default['holmes-yum']['logs-directory'] = '/var/log/yum'

default['holmes-yum']['cron'].tap do |cron|

  cron['update-security']['enabled'] = true
  cron['update-security']['minute'] = '0'
  cron['update-security']['hour'] = '*/12'
  cron['update-security']['day'] = '*'
  cron['update-security']['weekday'] = '1' # Monday
  cron['update-security']['month'] = '*'
  cron['update-security']['update-command'] = 'yum -y update --security'
  cron['update-security']['log-file'] = "#{node['holmes-yum']['logs-directory']}/cron-update-security.log"

end
