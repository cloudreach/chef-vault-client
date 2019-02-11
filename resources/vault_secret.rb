resource_name :vault_secret
property :path, String, required: true

action :read do
  authenticate!
  secret = Vault.logical.read(new_resource.path)
  node.run_state[new_resource.path] = secret.data
end

action_class do
  include Helper::VaultAuthentication
end
