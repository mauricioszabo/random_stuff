class LdapEntry
  def initialize(entry)
    @entry = entry
  end

  def to_hash
    hash = {}
    @entry.each do |k, v|
      hash[k.to_s] = v
    end
    return hash
  end

  def dn
    @entry.dn
  end

  def id
    dn.split(",").first
  end

  def to_yaml(arg=nil)
    return to_hash.to_yaml(arg) if arg
    yaml = to_hash.to_yaml
    yaml.gsub(/^---/, "--- Entry: #{dn}")
  end
end
