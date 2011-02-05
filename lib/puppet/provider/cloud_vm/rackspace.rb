Puppet::Type.type(:cloud_vm).provide(:rackspace) do
  desc "Rackspace provider that uses fog to launch instances on Rackspace
    cloud."

  require 'fog'

  def exists?
  end

  def create
  end

  def destroy
  end

end
