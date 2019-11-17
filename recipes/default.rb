#
# Cookbook:: holmes-yum
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

update_security = node['holmes-yum']['cron']['update-security']

execute 'update yum' do
  command 'yum update -y'
  not_if "ls -a #{node['holmes-yum']['logs-directory']} | grep -q 'first_run'"
  notifies :create, 'file[first run]', :delayed
end

directory node['holmes-yum']['logs-directory'] do
  mode '0750'
end

file 'first run' do
  path "#{node['holmes-yum']['logs-directory']}/first_run"
  mode '0600'
  action :nothing
end

cron 'yum security updates' do
  minute    update_security['minute']
  hour      update_security['hour']
  day       update_security['day']
  weekday   update_security['weekday']
  month     update_security['month']
  command   "#{update_security['update-command']} >> #{update_security['log-file']}"

  case update_security['enabled']
  when true
    action :create
  when false
    action :delete
    only_if "crontab -l | grep -q '#{update_security['update-command']}'"
  end
end
