require 'net/http'

class String
  def as_utf8
    string = unpack("U*").pack("C*") rescue self

    string.unpack("C*").pack("U*")
  end
end

def buscar_filmes(host)
    resp = Net::HTTP.get URI.parse(host)

    filmes = yield resp
    filmes.collect { |f| f.as_utf8 }
end
