require "ldap_class"
require "fusefs"
 
class LdapMount < FuseFS::FuseDir
  def initialize
    @ldap = LdapClass.new
    @all_dns = Set.new
  end
 
  def contents(path)
    dn = base_entry(path)
    contents = @ldap.search 'objectClass=*', dn
    @all_dns += contents.map { |x| path_to_dn(File.join(path, x.id)) }
    contents.map! { |x| file_name x.id }
    contents + contents.map { |x| x + ".yml" }
  end

  def base_entry(path)
    return if path == "/"
    path = scan_path path
    path.collect! { |x| dn_name x }
    return path.reverse.join(",")
  end
  private :base_entry

  def dn_name(file_name)
    path = file_name.split(".")
    name, attribute = path[0..-2], path[-1]
    "#{attribute}=#{name.join(".")}"
  end
  private :dn_name
 
  def file_name(id)
    attribute, name = id.split("=")
    "#{name}.#{attribute}"
  end
  private :file_name

  def directory?(path)
    return false if path.end_with?(".yml")
    path = path_to_dn(path)
    return true if @all_dns.include?(path)
    !search_for(path).empty?
  end

  def size(path)
    read_file(path).size
  end

  def read_file(path)
    path = path_to_dn(path[0..-5])
    object = search_for(path).first
    object.to_yaml
  end

  def search_for(dn)
    query, base = dn.split(",", 2)
    @ldap.search(query, base)
  end

  def path_to_dn(path)
    path = scan_path(path).map do |x|
      x.include?("=") ?  x : dn_name(x)
    end
    path.reverse.join(",")
  end
  private :path_to_dn

  def file?(path)
    return false unless directory?(path[0..-5])
    path.end_with?('.yml')
  end
 
  #def can_mkdir?(path)
  #end
 
  #def mkdir(path)
  #end
end
 
if $0 == __FILE__
  #Define os parâmetros para o FuseFS
  ldap = LdapMount.new
  FuseFS.set_root( ldap )
   
  #CTRL+C desmonta e sai do programa.
  trap 'INT' do
    FuseFS.unmount
    exit 0
  end
   
  #Montar sobre o diretório que for passado como primeiro argumento
  FuseFS.mount_under ARGV.shift
  puts "Montado e rodando..."
  FuseFS.run
end
