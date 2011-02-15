Puppet::Type.type(:cloud_vm).provide(:ec2) do
  desc "ec2 provider that uses fog to launch instances on AWS."

  require 'fog'

  def self.connect
    Fog::Compute.new(
      :provider => 'AWS'
    )
  end

  def self.instances

    connection = connect

    inst = []

    vm = {}

    connection.servers.each { |i|
      vm = {
        :name    => i.tags['Name'],
        :status  => i.state,
        :managed => i.tags['puppet_prov'],
        :id      => i.id,
        :flavor  => i.flavor_id,
        :image   => i.image_id
      }

      vm[:provider] = self.name

      if vm[:status] == 'running'
        vm[:ensure] = :present
      else
        vm[:ensure] = :absent
      end
      if vm[:name] != nil and vm[:managed] == 'true' and vm[:status] != 'terminated'
        inst << new(vm)
      end
    }
    inst
    debug "From Instances inst #{inst}"
  end

  def self.prefetch(resources)

    connection = connect

    vm = {}

    resources.each { |name, resource|

      inst = connection.servers.find { |x| x.tags['Name'] == name }

      vm = {
        :name        => inst.tags['Name'],
        :status      => inst.state,
        :managed     => inst.tags['puppet_prov'],
        :instance_id => inst.id,
        :flavor      => inst.flavor_id,
        :image       => inst.image_id
      }

      vm[:provider] = self.name

      if vm[:status] == 'running' or vm[:status] == 'pending'
        vm[:ensure] = :present
      elsif vm[:status] == 'shutting-down' or vm[:status] == 'terminated'
        vm[:ensure] = :absent
      else
        vm[:ensure] = :absent
      end
      if vm[:name] != nil and vm[:managed] == 'true'
        resource.provider = new(vm)
      end
    }

  end

  def exists?
    debug @property_hash.inspect
    !(@property_hash[:ensure] == :absent or @property_hash.empty?)
  end

  def create

    #connection = self.class.connect

    #id = connection.servers.create(
    #  :flavor_id => @resource[:flavor],
    #  :image_id  => @resource[:image]
    #).id

    #connection.tags.create(
    #  :resource_id => id,
    #  :key         => 'Name',
    #  :value       => @resource[:name]
    #)

    #connection.tags.create(
    #  :resource_id => id,
    #  :key         => 'puppet_prov',
    #  :value       => 'true'
    #)
    true

  end

  def destroy

    connection = self.class.connect

    debug @property_hash.inspect

    debug "Destroying #{@property_hash[:name]} with #{@property_hash[:instance_id]}"

    if connection.terminate_instances(@property_hash[:instance_id])
      sleep 5
      connection.delete_tags(@property_hash[:instance_id], 'Name')
    end
  end

end
