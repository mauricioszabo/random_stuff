require 'comum'

module Cinemark
  HOST = 'http://www.cinemark.com.br/scripts/javascript_scale.js'
  def self.buscar
    buscar_filmes HOST do |resp|
      filmes = resp.grep(/Filmes.*?=.*?'(.*?)';/) { |r| a = $1 }
    end
  end
end
