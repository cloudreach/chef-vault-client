require 'vault'
require 'net/http'

# Modules used to help the rest of the cookbook run.
module Helper
  module VaultAuthentication
    def authenticate!(vault_url, vault_role)
      Vault.address = vault_url
      instance_sa = node['gce']['instance']['serviceAccounts'].keys[0]
      uri = URI('http://metadata/computeMetadata/v1/instance/service-accounts/' + instance_sa + '/identity?audience=vault/' + vault_role + '&format=full')
      req = Net::HTTP::Get.new(uri)
      req['Metadata-Flavor'] = 'Google'
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      Vault.auth.gcp(vault_role, res.body)
    end
  end
end
