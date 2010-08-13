require "ldap_mount"

describe LdapMount do
  before do
    @ldap = LdapMount.new
  end

  it 'should show the correct DN given a path' do
    res = @ldap.send(:path_to_dn, '/groups.ou/admin.cn')
    res.should == 'cn=admin,ou=groups'
  end

  it 'should not reorder "=" or "." if it\'s already ordered' do
    res = @ldap.send(:path_to_dn, '/groups.ou/cn=admin')
    res.should == 'cn=admin,ou=groups'
  end
end
