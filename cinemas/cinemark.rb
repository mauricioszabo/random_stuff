require 'comum'

module Cinemark
  HOST = 'http://cinemark.com.br/programacao/sao-paulo/1'
  def self.buscar
    buscar_filmes HOST do |resp|
      resp.scan(/Filmes\[.*?= \'(.+?)';/).flatten
      #filmes = resp.grep(/Filmes.*?=.*?'(.*?)';/) { |r| a = $1 }
    end
  end
end
