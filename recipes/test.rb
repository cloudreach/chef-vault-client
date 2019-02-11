#
# Cookbook:: vault_client
# Recipe:: test
# Description:: Test recipe to test that the resource can read from a test vault backend.
# Copyright:: 2018, The Authors, All Rights Reserved.

vault_secret 'test' do
  path 'bakery/secret/test'
end.run_action(:read)

file '/var/test_file' do
  content node.run_state['bakery/secret/test'][:gregg]
end
