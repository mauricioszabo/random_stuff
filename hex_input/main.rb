#!/usr/bin/ruby

require 'sdl'
require 'hexagono'

SCREEN_X = 480
SCREEN_Y = 200

@screen = SDL.set_video_mode SCREEN_X, SCREEN_Y, 0, SDL::DOUBLEBUF + SDL::HWSURFACE
unless @screen
  @screen = SDL.set_video_mode SCREEN_X, SCREEN_Y, 0, SDL::SWSURFACE
end

font = SDL::TTF.open('fonts/verdana.ttf', 14)

['INT', 'TERM'].each do |s|
  trap(s) { exit 0 }
end

hex = []
hex << Hexagono.new('a', 0, 40)
hex << Hexagono.new('b', 0, 80)
hex << Hexagono.new('c', 0, 120)
hex << Hexagono.new('d', 0, 160)

hex << Hexagono.new('e', 30, 20)
hex << Hexagono.new('f', 30, 60)
while true
  while(event = SDL::Event2.poll)
    case event
      when SDL::Event2::Quit
        exit 0
    end
  end

  hex.each { |x| x.desenhar }
  @screen.flip
end
