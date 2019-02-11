# # encoding: utf-8

# Inspec test for recipe vault_client::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/var/test_file') do
  its('content') { should match('turkington') }
end
