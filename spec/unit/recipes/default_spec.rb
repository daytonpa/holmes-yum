#
# Cookbook:: holmes-yum
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'holmes-yum::default' do
  {
    'centos' => PlatformVersions.centos,
  }.each do |platform, platform_versions|
    platform_versions.each do |platform_version|
      context "When all attributes are default, on #{platform} #{platform_version}" do

        before do
          stub_command("ls -a /var/log/yum | grep -q 'first_run'").and_return(false)
          stub_command("crontab -l | grep -q 'yum -y update --security'").and_return(false)
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version).converge(described_recipe)
        end
        let(:execute_yum) { chef_run.execute('update yum') }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'updates yum, and creates a "first run" placeholder file' do
          expect(chef_run).to run_execute('update yum')
          expect(execute_yum).to notify('file[first run]').to(:create).delayed
        end
        it 'creates a cron job for yum-based security updates' do
          expect(chef_run).to create_cron('yum security updates')
        end

      end
      context "When cron jobs are disabled upon first run, on #{platform} #{platform_version}" do

        before do
          stub_command("ls -a /var/log/yum | grep -q 'first_run'").and_return(false)
          stub_command("crontab -l | grep -q 'yum -y update --security'").and_return(false)
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version) do |node|
            node.normal['holmes-yum']['cron']['update-security']['enabled'] = false
          end.converge(described_recipe)
        end
        let(:execute_yum) { chef_run.execute('update yum') }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'updates yum, and creates a "first run" placeholder file' do
          expect(chef_run).to run_execute('update yum')
          expect(execute_yum).to notify('file[first run]').to(:create).delayed
        end
        it 'does not create a cron job for yum-based security updates' do
          expect(chef_run).to_not create_cron('yum security updates')
        end

      end
      context "When cron jobs are disabled after the first run, on #{platform} #{platform_version}" do

        before do
          stub_command("ls -a /var/log/yum | grep -q 'first_run'").and_return(false)
          stub_command("crontab -l | grep -q 'yum -y update --security'").and_return(true)
        end

        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: platform_version) do |node|
            node.normal['holmes-yum']['cron']['update-security']['enabled'] = false
          end.converge(described_recipe)
        end
        let(:execute_yum) { chef_run.execute('update yum') }

        it 'converges successfully' do
          expect { chef_run }.to_not raise_error
        end
        it 'updates yum, and creates a "first run" placeholder file' do
          expect(chef_run).to run_execute('update yum')
          expect(execute_yum).to notify('file[first run]').to(:create).delayed
        end
        it 'deletes a cron job for yum-based security updates' do
          expect(chef_run).to delete_cron('yum security updates')
        end
      end
    end
  end
end
