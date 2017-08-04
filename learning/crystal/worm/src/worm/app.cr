require "sdl"
require "./display"

module Worm
  class App
    def initialize
      @tickHandlers = [] of Proc(Int64, Void)

      SDL.init      SDL::Init::VIDEO   ; at_exit { SDL.quit }
      SDL::IMG.init SDL::IMG::Init::PNG; at_exit { SDL::IMG.quit }

      @window = SDL::Window.new "Worm version #{VERSION}", 640, 480
      @renderer = SDL::Renderer.new @window,
        SDL::Renderer::Flags::ACCELERATED |
        SDL::Renderer::Flags::PRESENTING

      @frame = 0
    end

    def onTick(handler : Proc(Int64, Void))
      @tickHandlers.push handler
    end

    def run
      loop do
        case event = SDL::Event.poll
          when SDL::Event::Quit
            break

          when SDL::Event::Keyboard && event.sym.q?
            break
        end

        @tickHandlers.each ...

        ret = @tickHandler.call @frame, @renderer

        if ret
          break
        end

        @frame += 1
      end
    end
  end
end
