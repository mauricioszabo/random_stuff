require 'active_support'
require 'yaml'

class String
  def remover_acentos
    string = ActiveSupport::Multibyte::Chars.new(self)
    string.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
  end
end

texto = File.read 'pipas.txt'
texto.gsub! /[\t\n\f]/, ' '
texto.gsub! /\s+/, ' '
sem_acentos = texto.remover_acentos
sem_acentos.downcase!


combinacoes = sem_acentos.scan(/[\w\s][\w\s]/)
File.open('combinacoes.yml', 'w') { |f| f.print combinacoes.to_yaml }
