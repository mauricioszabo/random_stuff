#coding: utf-8
require 'yaml'
require 'montar_teclado'

$custos = YAML.load_file 'contagem.yml'


class Cromossomo
  attr_reader :custo
  attr_reader :matriz

  def initialize(matriz = nil)
    if matriz
      @matriz = matriz.dup
      #rand(10).times { trocar_matriz }
      rand(2).times { trocar_matriz }
      trocar_matriz
    else
      @matriz = ('a'..'z').to_a
      @matriz << 'A' << ' '
      @matriz.sort! { rand(3) - 1 }
    end

    @custo = fitness
  end

  def vizinhos(x, y, matriz)
    yielder x, y do |x1, y1|
      if x1 >= 0 && y1 >= 0 && x1 < 7 && y1 < 4
        yield matriz[x1][y1]
      end
    end
  end

  def cruzar(outro)
    max = @matriz.size
    split = rand(max)

    matriz = @matriz[0..split]
    outro.matriz.each do |elemento|
      break if matriz.size == max
      matriz << elemento unless matriz.include? elemento
    end

    Cromossomo.new(matriz)
  end

  def teclado
    @matriz.each_slice(7).to_a.transpose
  end

  def fitness
    matriz = self.teclado
    fit = 0

    7.times do |x|
      4.times do |y|
        letra = matriz[x][y].downcase
        vizinhos x, y, matriz do |vizinho|
          silaba = letra + vizinho.downcase

          custo = $custos[silaba] || -10
          custo *= 100
          fit += custo
        end
      end
    end

    return fit
  end

  private
  def yielder(x, y)
    yield x+0, y-1
    yield x-1, y+0
    yield x+0, y+1
    yield x+1, y+0

    if x % 2 == 0
      yield x-1, y+1
      yield x+1, y+1
    else
      yield x-1, y-1
      yield x+1, y-1
    end
  end

  def trocar_matriz
    max = @matriz.size
    x1, x2 = rand(max), rand(max)
    @matriz[x1], @matriz[x2] = @matriz[x2], @matriz[x1]
  end
end


MAX_GENES = 50

def genetico
  #Solução Inicial
  cromossomos = Array.new(MAX_GENES)
  cromossomos.collect! { Cromossomo.new  }

  maximo = contagem = 0
  3000.times do |geracao|
    #Pega os mais aptos
    outros = cromossomos.sort { |e1, e2| e1.custo <=> e2.custo }
    cromossomos.clear
    cromossomos << outros[-1] << outros[-2]

    contagem += 1 if outros[-1].custo == maximo
    if contagem == 500
      puts "Explosão"
      #8.times { |x| cromossomos << outros[-3-x] }
      cromossomos.delete_at(-2)
      (MAX_GENES - 1).times { cromossomos << Cromossomo.new }
      contagem = -150
    end

    maximo = outros[-1].custo

    puts "Cromossomo mais apto (geração #{geracao}): #{outros[-1].teclado.inspect}"
    puts "Custo: #{outros[-1].custo}\n\n"

    #Explode todos
    #if geracao % 500 == 0
    #  puts "Explosão"
    #  8.times { |x| cromossomos << outros[-3-x] }
    #  (MAX_GENES - 10).times { cromossomos << Cromossomo.new }
    #  next
    #end

    (MAX_GENES / 2 - 2).times do
      #Sorteia um cromossomo
      c1 = sorteia outros

      #Sorteia outro cromossomo
      c2 = sorteia outros

      #Cruza os dois
      cromossomos << c1.cruzar(c2)
      cromossomos << c2.cruzar(c1)

      #Adiciona alguns randômicos
      #5.times { cromossomos << Cromossomo.new }
    end

    #Adiciona uns cromossomos únicos para evitar mesmo gen
    #cromossomos.uniq!
    #(MAX_GENES - cromossomos.size).times { cromossomos << Cromossomo.new }
  end

  
  cromossomos.sort! { |e1, e2| e1.custo <=> e2.custo }
  montar(cromossomos[-1].teclado, cromossomos[-1].custo)
end

def sorteia(outros)
  #return outros[rand(outros.size)]

  random = rand(outros[-1].custo)
  c1 = outros.each_with_index { |e, i| break e if random > e.custo && random < outros[i+1].custo }
  c1 = outros[-1] if c1.is_a? Array
  return c1
end

#def sorteia(outros)
#  #return outros[rand(outros.size)]
#
#  random = rand(outros[-1].custo / 1000)
#  c1 = outros.each_with_index { |e, i| break e if random > e.custo / 1000 && random < outros[i+1].custo / 1000 }
#  c1 = outros[-1] if c1.is_a? Array
#  return c1
#end

genetico if $0 == __FILE__
