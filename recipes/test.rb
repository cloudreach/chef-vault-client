#
# Cookbook:: vault_client
# Recipe:: test
# Description:: Test recipe to test that the resource can read from a test vault backend.
# Copyright:: 2018, The Authors, All Rights Reserved.

# This Test relies on a vault server specified in the url to have a secret specified in the path of {'gregg'='turkington'}

# It also requires the GCP Auth backend enabled on the Vault service and a policy/role created to allow the GCE service account used for kitchen to have read rights on the below secret
# To create this, you can use the following:
## vault auth enable gcp
## vault write "auth/gcp/role/chef" \
##   type="gce"  \
##   project_id="REPLACE_WITH_{GCP_PROJECT_ID}"  \
##   bound_service_accounts="REPLACE_WITH_{GCP_SERVICE_ACCOUNT_EMAIL}"  \
##   policies="chef"
##
## vault policy write chef -<<EOF
## path "secret/*" {
## capabilities = ["read"]
## }
## EOF

## vault write scret/cheftest gregg=turkington

vault_secret 'test' do
  vault_url 'http://<VAULT_ADDRESS>:8200'
  path 'secret/cheftest'
  vault_role 'chef'
end.run_action(:read)

file '/var/test_file' do
  content node.run_state['secret/cheftest'][:gregg]
end
