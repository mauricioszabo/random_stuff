require 'hexagono'

describe Hexagono do
  before do
    Hexagono.send :class_variable_set, :@@fonte, @fonte = mock('Font')
  end

  context 'na criação' do
    it 'deve criar um hexágono completo' do
      SDL::Surface.should_receive(:load).with('imagens/cima.png')
      SDL::Surface.should_receive(:load).with('imagens/baixo.png')

      hexagono = Hexagono.new('a', 10, 10)
      hexagono.altura.should == 40
    end

    it 'deve criar um hexágono apenas com a parte de cima' do
      SDL::Surface.should_receive(:load).with('imagens/cima.png')

      hexagono = Hexagono.new('a', 10, 10, :cima)
      hexagono.altura.should == 20
    end

    it 'deve criar um hexágono apenas com a parte de baixo' do
      SDL::Surface.should_receive(:load).with('imagens/baixo.png')

      hexagono = Hexagono.new('a', 10, 10, :baixo)
      hexagono.altura.should == 20
    end
  end

  it 'deve conseguir desenhá-lo na tela' do
    SDL::Surface.stub!(:load).and_return(@mock = mock("Surface"))
    SDL::Screen.stub!(:get).and_return(@screen = mock("Screen"))

    SDL::Surface.should_receive(:blit).with(@mock,0,0,0,0,@screen,10,20)
    SDL::Surface.should_receive(:blit).with(@mock,0,0,0,0,@screen,10,40)

    @fonte.should_receive(:draw_blended_utf8).with(@screen, 'a', 25, 30, 0,0,0)

    hexagono = Hexagono.new('a', 10, 20)
    hexagono.desenhar
  end
end
