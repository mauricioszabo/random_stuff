require 'comum'

module Playarte
  HOST = 'http://www.playarte.com.br/Filme/Exibicao/'
  def self.buscar
    buscar_filmes HOST do |resp|
      filmes = resp.grep(/<a href=.*?www.playarte.com.br\/Filme\/Default.*?>(.*?)</) { $1 }
    end
  end
end
