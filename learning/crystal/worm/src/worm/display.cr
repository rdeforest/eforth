require "sdl"
require "math"

require "../shape/*"

module Worm
  class Display
    def addCircle
      raise Exception.new "Display::addCircle not implemented by {{@type.to_s}}"
    end

    def removeCircle
      raise Exception.new "Display::removeCircle not implemented by {{@type.to_s}}"
    end
  end

  class Screen < Display
    def initialize(windowMaker, rendererMaker, colorMaker)
      @window   = windowMaker "Worm version #{VERSION}", 640, 480
      @renderer = rendererMaker @window

      @white = colorMaker 255, 255, 255, 255
      @black = colorMaker   0,   0,   0, 255
    end

    def drawCircle(location, width, color)
      renderer.draw_color color
      Shape::Circle.new(location, width).drawOn renderer
    end

    def addCircle(location, width)
      drawCircle location, width, @white
    end

    def removeCircle(location, width)
      drawCircle location, width, @black
    end

    def update
      @renderer.present
    end
  end

  class Console < Display
    class Circle
      def initialize(@location, @width)
      end

      def to_s
        "<#{@location.i},#{@location.j}> x #{@width}"
      end
    end

    @@circles = [] of Circle

    def initialize
      @@circles.push self
      puts "+ #{to_s}"
    end

    def finalize
      puts "- #{to_s}"
    end
  end
end
