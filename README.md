# holmes-yum

### Version

**1.0.1**

### Maintainer(s)
- Patrick Dayton

## About
Simple yum package/updater cookbook.  Runs an initial yum update, then configures various cron jobs for updating various yum groups.

## Usage
Include this cookbook within your [Policyfile](./Policyfile) and [metdata](./metadata.rb), and run the default recipe.

The main attributes to configure are the various cron related settings:

*attributes/default.rb*
```ruby

default['holmes-yum']['cron'].tap do |cron|

  cron['update-security']['enabled'] = true
  # More attributes....

```
- By enabling a yum group, it will be assigned to a cron job for auto-updates.  When set to `false`, the cookbook will remove the cron job if it exists, otherwise ignores.

The cron values for each configured cron job are setup as the following:

*attributes/default.rb*
```ruby

  cron['update-security']['enabled'] = true
  cron['update-security']['minute'] = '0'
  cron['update-security']['hour'] = '*/12'
  cron['update-security']['day'] = nil
  cron['update-security']['weekday'] = '1' # Monday
  cron['update-security']['month'] = '*'
  cron['update-security']['command'] = 'yum -y update --security'

```

- Every [cron resource](https://docs.chef.io/resource_cron.html) has a default value within Chef, so `nil` values are accepted.

*More resources/cron jobs will be configured as needed*
