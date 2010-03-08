#!/usr/bin/ruby

require 'sdl'

SCREEN_X = 300
SCREEN_Y = 200

@screen = SDL.set_video_mode SCREEN_X, SCREEN_Y, 0, SDL::DOUBLEBUF + SDL::HWSURFACE
unless @screen
  @screen = SDL.set_video_mode SCREEN_X, SCREEN_Y, 0, SDL::SWSURFACE
end

['INT', 'TERM'].each do |s|
  trap(s) { exit 0 }
end

while true
  while(event = SDL::Event2.poll)
    case event
      when SDL::Event2::Quit
        exit 0
    end
  end
end
