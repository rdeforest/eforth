require "sdl"

module Worm
  class Screen
    def initialize
      SDL.init SDL::Init::VIDEO
      at_exit { SDL.quit }

      SDL::IMG.init SDL::IMG::Init::PNG
      at_exit { SDL::IMG.quit }
    end
  end
end

# SDL.init(SDL::Init::VIDEO); at_exit { SDL.quit }
# SDL::IMG.init(SDL::IMG::Init::PNG); at_exit { SDL::IMG.quit }
#
# window = SDL::Window.new("SDL tutorial", 640, 480)
# renderer = SDL::Renderer.new(window)
#
# image = SDL::IMG.load(File.join(__DIR__, "data", "sprites.png"))
# image.color_key = {0, 255, 255}
# sprite = SDL::Texture.from(image, renderer)
#
# width, height = renderer.output_size
