require 'rubygems'
require 'google_spreadsheet'
require 'yaml'

require 'playarte'
require 'cinemark'
require 'unibanco'

require 'sinopse'

config = YAML.load_file('config.yml')
session = GoogleSpreadsheet.login(config['login'], config['senha'])

planilha = session.spreadsheets.find { |x| x.title == config['planilha'] }

work = planilha.worksheets[0]
work.rows.size.times { |x| work[x + 1, 1] = work[x + 1, 2] = '' }
work[1,1] = 'Filme'
work[1,2] = 'Cinema'
cont = 1

filmes = []
[Playarte, Cinemark, Unibanco].each do |cinema|
  cinema.buscar.each do |filme|
    cont += 1
    work[cont, 1] = filme
    work[cont, 2] = cinema.to_s
    filmes << filme
  end
end

work.save

work = planilha.worksheets[1]
work.rows.size.times { |x| work[x + 1, 1] = work[x + 1, 2] = '' }
work[1, 1] = 'Filme'
work[1, 2] = 'Site'
work[1, 3] = 'Sinopse'
cont = 1

f = filmes.collect { |x| x.downcase.strip }
f.uniq.each_with_index do |filme, indice|
  sinopse, site = buscar_sinopse(filme)
  next if sinopse.nil?

  cont += 1
  
  work[cont, 1] = filmes[indice]
  work[cont, 2] = site
  work[cont, 3] = sinopse
end

work.save
