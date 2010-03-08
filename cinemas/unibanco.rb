require 'comum'

module Unibanco
  HOST = 'http://www.unibancocinemas.com.br/em_cartaz/sao_paulo_-_pompeia/index.asp'
  def self.buscar
    buscar_filmes HOST do |resp|
      filmes = resp.grep(/<h3 style="padding-top: 5pt;">(.*?)</) { $1 }
    end
  end
end
