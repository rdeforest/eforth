require "sdl"

module Worm
  class App
    def initialize(@tickHandler : ->(x : Int64))
      SDL.init      SDL::Init::VIDEO   ; at_exit { SDL.quit      }
      SDL::IMG.init SDL::IMG::Init::PNG; at_exit { SDL::IMG.quit }

      @window = SDL::Window.new "Worm version #{VERSION}", 640, 480
      @renderer = SDL::Renderer.new window,
        SDL::Renderer::Flags::ACCELERATED |
        SDL::Renderer::Flags::PRESENTING

      @frame = 0
    end

    def run
      loop do
        case event = SDL::Event.poll
        when SDL::Event::Quit
          break
        when SDL::Event::Keyboard
          if event.sym.q?
            break
          end
        end

        @tickHandler @frame++
      end
    end
  end
end
