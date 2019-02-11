require 'vault'
require 'net/http'

# Modules used to help the rest of the cookbook run.
module Helper
  module VaultAuthentication
    def authenticate!
      Vault.address = node['vault_client']['address']
      uri = URI('http://metadata/computeMetadata/v1/instance/service-accounts/default/identity?audience=vault/default&format=full')
      req = Net::HTTP::Get.new(uri)
      req['Metadata-Flavor'] = 'Google'
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      Vault.auth.gcp(node['vault_client']['role'], res.body)
    end
  end
end
