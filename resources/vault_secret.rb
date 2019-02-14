resource_name :vault_secret
property :path, String, required: true
property :vault_url, String, required: true
property :vault_role, String, required: true

action :read do
  authenticate!(new_resource.vault_url, new_resource.vault_role)
  secret = Vault.logical.read(new_resource.path)
  node.run_state[new_resource.path] = secret.data
end

action_class do
  include Helper::VaultAuthentication
end
