#Matriz 4x7
#
#

require 'yaml'

class Matriz
  def initialize
    @matriz = ('a'..'z').to_a
    @matriz << 'a' << 'e' << 'i' << 'o' << 'u' << ' '
    @matriz = @matriz.each_slice(8).to_a.transpose
    #@matriz = [
    #  %w(a b c d e f g a),
    #  %w(h i j k l m n e),
    #  %w(o p q r s t u i),
    #  ['v', 'w', 'x', 'y', 'z', 'o', 'u', ' ']
    #].transpose

    @custos = YAML.load_file 'contagem.yml'

    @melhor = {
      :custo => 0,
      :matriz => [[]]
    }
  end

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

  def vizinhos(x, y)
    yielder x, y do |x1, y1|
      if x1 >= 0 && y1 >= 0 && x1 < 7 && y1 < 4
        yield @matriz[x1][y1]
      end
    end
  end

  def trocar(x)
    x1 = x % 7
    y1 = x / 7

    x += 1
    x2 = x % 7
    y2 = x / 7

    @matriz[x1][y1], @matriz[x2][y2] = @matriz[x2][y2], @matriz[x1][y1]
  end

  def fitness
    fit = 0

    7.times do |x|
      4.times do |y|
        letra = @matriz[x][y]
        vizinhos x, y do |vizinho|
          silaba = letra + vizinho

          custo = @custos[silaba] || -50
          custo *= 10
          fit += custo
        end
      end
    end

    return fit
  end

  def trocar_tudo
    n = 27

    (n+1).times do
      n.times do |i|
        trocar(i)

        melhor_achado(fitness)
      end
    end
  end

  def trocar_random
    1000000.times do
      x1, x2 = rand(8), rand(8)
      y1, y2 = rand(4), rand(4)

      @matriz[x1][y1], @matriz[x2][y2] = @matriz[x2][y2], @matriz[x1][y1]
      melhor_achado(fitness)
    end
  end

  def melhor_achado(fit)
    if fit > @melhor[:custo]
      puts "Melhor custo achado: #{fit}"
      print "Melhor matriz: "; p @matriz
      puts

      @melhor[:custo] = fit
      @melhor[:matriz] = @matriz.collect { |x| x.dup }
    end
  end
end


class Annealing
  def initialize
    @temperatura = 10
    
  end
end
