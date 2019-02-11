# vault_client

Cookbook used to retrieve secrets from vault that are discarded at the end of a Chef run as to not retain them on a server.

## Usage

Add this cookbook as a dependency in metadata.rb and in the Berksfile.

You can then use the `vault_secret` resource in your cookbook.

In order to retrieve secrets from vault, the service account attached to the instance must be allowed to read from the secret path specified.

To configure backends for Vault see the [Vault Config Repo](https://gitlab.platform.nwm-poc.com/cloud-platform/vault-config)

## Resources

### vault_secret
#### Properties
* :path, String, Path to the secret that you are trying to read.

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
