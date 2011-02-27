# Type that can launch vm instances in the clouds.

module Puppet

  newtype(:cloud_vm) do
    @doc = "Doing stuff"

    ensurable do
      desc "Create or destroy an instance ."

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end
    end

    newparam(:name) do
      desc "name of the machine..."
      isnamevar
    end

    newparam(:id) do
      desc "user_id associated with your api key."
    end

    newparam(:api_key) do
      desc "A secret API key."
    end

    newparam(:flavor) do
      desc "The size of the instance"
    end

    newparam(:image) do
      desc "The type (os/ami) of the instance"
    end

    newparam(:region) do
      desc "What part of the planet is this instance in?"
      defaultto 'us-east-1'
    end

    newparam(:access_key) do
      desc "Key name that gives you ssh access to instance"
      defaultto ''
    end

    newparam(:user_data) do
      desc "User defined data"
      defaultto "#!/bin/sh\n/bin/echo 'Nothing done by Puppet...' > /root/user_data.txt"
    end
  end
end
