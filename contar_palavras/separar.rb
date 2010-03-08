comb = YAML.load_file 'combinacoes.yml'

comb.delete_if { |x| x =~ /[\dwky]/ }
comb.collect! { |x| x.downcase }
#comb.sort!

contar = Hash.new { 0 }
comb.each { |x| contar[x] += 1 }
File.open("contagem.yml", 'w') { |f| f.print contar.to_yaml }
