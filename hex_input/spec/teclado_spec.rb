require 'teclado'

describe Teclado do
  it 'deve criar um teclado com a array passada' do
    Hexagono.should_receive(:new).with('a', 0, 40)
    Hexagono.should_receive(:new).with('b', 30, 20)
    Hexagono.should_receive(:new).with('c', 60, 40)
    Hexagono.should_receive(:new).with('d', 90, 20)
    Teclado.new %w(a b c d)
  end

  it 'deve ler um teclado' do
    Teclado.should_receive(:new).with(%w(a b c d e f g h i j k l m n o p q r s t u v w x y z -)).
      and_return(@teclado = mock("Teclado"))

    Teclado.ler_teclado('spec/teste.layout').should == @teclado
  end

  it 'deve exibir um teclado' do
    Hexagono.stub!(:new).and_return(@hexagono = mock('Hexagono'))

    teclado = Teclado.new(['a'])
    @hexagono.should_receive(:desenhar).once
    teclado.desenhar
  end
end
