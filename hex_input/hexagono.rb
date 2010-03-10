require 'sdl'
SDL::TTF.init

class Hexagono
  TAMANHO = 20

  attr_reader :altura

  @@fonte = SDL::TTF.open('fonts/verdana.ttf', 14)

  def initialize(letra, x, y, tipo = :inteiro)
    @letra = letra
    @x, @y = x, y
    @cima = SDL::Surface.load 'imagens/cima.png' if tipo == :cima or tipo == :inteiro
    @baixo = SDL::Surface.load 'imagens/baixo.png' if tipo == :baixo or tipo == :inteiro

    @altura = tipo == :inteiro ? TAMANHO * 2 : TAMANHO
  end

  def desenhar
    @surfaces ||= [@cima, @baixo].compact
    @surfaces.each_with_index do |surface, index|
      SDL::Surface.blit(surface,0,0,0,0, SDL::Screen.get, @x, @y + TAMANHO * index)
    end

    local_y = @y + (TAMANHO * @surfaces.size) / 2 - 10
    @@fonte.draw_blended_utf8(SDL::Screen.get, @letra, @x + 15, local_y, 0, 0, 0)
  end
end
