# vault_client

Cookbook used to retrieve secrets from Vault using the `GCP Auth Backend` that are then discarded at the end of a Chef run as to not retain them on a server.

## Usage

Add this cookbook as a dependency in metadata.rb and in the Berksfile.

You can then use the `vault_secret` resource in your cookbook.

In order to retrieve secrets from vault, the service account attached to the instance must be allowed to read from the secret path specified.

## Resources

### vault_secret
#### Properties
* :path, String, Path to the secret that you are trying to read.
* :vault_url, String, URL of the Vault service
* :vault_role, String, Vault Role that gives the GCE IAM Service account rights to authenticate to Vault using GCP Auth

#### Actions
* :read, currently this is the only supported action. 

Note: As this block needs to be evaluated at compile time it is necessary to use end.run_action(:read) at the end of the resource block as opposed to action :read.

For example:

`vault_secret 'test' do`

`path 'bakery/secret/test'`

`end.run_action(:read)`

#### Returns
Returns a hash of the secret keys to node.run_state['path'] where path is the value of the :path property.

To access the values stored in the hash map, do so like this: node.run_state['example/path'][:example_key]

## Libraries
Contains a helper library for authenticating the vault.
### helper.rb
helper.rb contains a module that authenticates with the vault server provided in attributes.rb using the gce JWT token. Note that this requires the service account attached to the GCE instance to have permission to authenticate with vault and to access the path specified.


## Tests
In order to run the integration tests, the url and secret path specified in [test.rb](recipes/test.rb) must be reachable from kitchen, and contain the following secret `greg=turkington`

It also requires the GCP Auth backend enabled on the Vault service and a policy/role created to allow the GCE service account used for kitchen to have read rights on the above secret

To create this, you can use the following:
```bash
vault auth enable gcp
vault write "auth/gcp/role/chef" \
  type="gce"  \
  project_id="REPLACE_WITH_{GCP_PROJECT_ID}"  \
  bound_service_accounts="REPLACE_WITH_{GCP_SERVICE_ACCOUNT_EMAIL}"  \
  policies="chef"

vault policy write chef -<<EOF
path "secret/*" {
capabilities = ["read"]
}
EOF

vault write scret/cheftest gregg=turkington
```

You will also need to generate an SSH key in the root of the repo called `kitchen`

```bash
ssh-keygen -t ed25519 -f kitchen -C kitchen
export USER=kitchen
export SSH_KEY=./kitchen
```
kitchen prereqs - TODO - add to a Gemfile for bundler

`chef gem install kitchen-google inspec rbnacl:'< 5.0' rbnacl-libsodium bcrypt_pbkdf`