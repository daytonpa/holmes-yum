
default['holmes-yum']['cron'].tap do |cron|

  cron['update-security']['enabled'] = false
  cron['update-security']['minute'] = '0'
  cron['update-security']['hour'] = '*/12'
  cron['update-security']['day'] = nil
  cron['update-security']['weekday'] = '1' # Monday
  cron['update-security']['month'] = '*'
  cron['update-security']['command'] = 'yum -y update --security'

end
