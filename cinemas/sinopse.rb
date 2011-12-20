require 'net/http'
require 'active_support'
require 'yaml'
require "nokogiri"

$yaml = YAML.load_file("entities.yml")

def buscar_sinopse(argumento)
  argumento.gsub /[ºª]/, ''
  string = ActiveSupport::Multibyte::Chars.new(argumento)
  string = string.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s

  filme = string.gsub(/\s+/, "-").downcase
  filme.gsub!(/[\[\]]/, '')
  uri = "http://www.adorocinema.com/filmes/#{URI.escape(filme)}"
  begin
    body = Net::HTTP.get URI.parse(uri + "/")
  rescue Timeout::Error
    return
  end

  nokogiri = Nokogiri.parse(body)
  return nokogiri.css("div#f-sinopse p").inner_text, uri
end
