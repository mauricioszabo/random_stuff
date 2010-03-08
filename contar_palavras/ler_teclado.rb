require 'yaml'
require 'genetico'

$custos.delete_if { |k, v| k.include? " " }

class LerTeclado
  def initialize(arquivo)
    teclado = File.readlines(arquivo)

    matriz = []
    teclado[1..-2].each_slice(2) do |linha1, linha2|
      letras = []
      letras << linha2[2].chr   #Segunda linha 
      letras << linha1[6].chr   #Primeira linha 
      letras << linha2[10].chr  #Segunda linha 
      letras << linha1[14].chr  #Primeira linha 
      letras << linha2[18].chr  #Segunda linha 
      letras << linha1[22].chr  #Primeira linha 
      letras << linha2[26].chr  #Segunda linha 

      matriz << letras
    end

    @me = Cromossomo.new(matriz.flatten, false)
  end

  def custo
    @me.custo
  end
end

if $0 == __FILE__
  teclado = LerTeclado.new ARGV[0]
  puts "Custo: #{teclado.custo}"
end
