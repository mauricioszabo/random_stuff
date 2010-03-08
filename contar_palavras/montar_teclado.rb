def montar(array, custo)
  File.open "teclados/teclado_#{custo}.txt", 'w' do |f|
    f.puts "Custo: #{custo}"

    array = array.transpose

    array.each do |linha|
      i, p = pares(linha)
      f.print "\\"
      i.each do |letra|
        f.print "___/ #{letra} \\"
      end
      f.puts "___/   \\"

      f.print "/"
      p.each do |letra|
        f.print " #{letra} \\___/"
      end
      f.puts
    end
    f.puts "\\___/   \\___/   \\___/   \\___/   \\"
  end
end

def pares(linha)
  par = []
  impar = []
  
  linha.each_with_index { |e, i| if i % 2 == 0 then par << e else impar << e end }
  return impar, par
end
