# Type that can launch vm instances in the clouds.

module Puppet

  newtype(:cloud_vm) do

    ensurable do
      desc "Create or destroy an instance ."

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end
    end

    newparam(:provider) do
      desc "Who is your cloud provider?"
    end

    newparam(:id) do
      desc "id associated with your provider key."
    end

    newparam(:key) do
      desc "A secret API key."
    end

    newparam(:size) do
      desc "The size of the instance"
    end

    newparam(:
  end
end
