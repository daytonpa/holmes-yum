#
# Cookbook:: holmes-yum
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

file_cache_path = Chef::Config[:file_cache_path]

update_security = node['holmes-yum']['cron']['update-security']

execute 'update yum' do
  command 'yum update -y'
  not_if { ::File.exist?("#{file_cache_path}/first_run") }
  notifies :create, 'file[first run]', :immediately
end

file 'first run' do
  path "#{file_cache_path}/first_run"
  action :nothing
end

cron 'yum security updates' do
  minute    update_security['minute']
  hour      update_security['hour']
  day       update_security['day']
  weekday   update_security['weekday']
  month     update_security['month']
  command   update_security['command']

  case update_security['enabled']
  when true
    action :create
  when false
    action :delete
    only_if "crontab -l | grep -q '#{update_security['command']}'"
  end
end
