require "net/ldap"
require "active_ldap"
require "ldap_entry"
require "yaml"

class LdapClass
  def initialize
    config = YAML.load_file(File.dirname(__FILE__) + "/config.yml")
    config.symbolize_keys!
    @net_ldap = Net::LDAP.new config
    @@base = config[:base]
  end

  def self.base
    @@base.dup
  end

  def search(query, base = nil)
    resultado = if base.nil?
      @net_ldap.search :filter => query, :scope => Net::LDAP::SearchScope_SingleLevel
    else
      @net_ldap.search :filter => query, :base => "#{base},#@@base", :scope => Net::LDAP::SearchScope_SingleLevel
    end
    (resultado || []).collect { |x| LdapEntry.new x }
  end
end
