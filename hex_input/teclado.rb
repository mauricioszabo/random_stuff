require 'hexagono'

class Teclado
  COLUNAS = 9

  def initialize(teclado)
    @hexagonos = []
    teclado.each_with_index do |letra, indice|
      x = (indice % COLUNAS)

      y = if x.even?
        indice / COLUNAS * 40 + 40
      else
        indice / COLUNAS * 40 + 20
      end

      
      @hexagonos << Hexagono.new(letra, x * 30, y)
    end
  end

  def self.ler_teclado(arquivo)
    teclado = File.readlines(arquivo)

    matriz = []
    teclado[0..-2].each_slice(2) do |linha1, linha2|
      letras = []
      COLUNAS.times do |indice|
        letras << if indice.even?
          linha2[indice / 2 * 8 + 2].chr
        else
          linha1[indice / 2 * 8 + 6].chr
        end
      end

      matriz << letras
    end

    Teclado.new(matriz.flatten)
  end

  def desenhar
    @hexagonos.each { |hexagono| hexagono.desenhar }
  end
end
