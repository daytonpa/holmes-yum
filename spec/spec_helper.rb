require 'chefspec'
require 'chefspec/policyfile'

module PlatformVersions
  @centos = %w( 7.6.1810 7.7.1908 )

  def self.centos
    @centos
  end
end
