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
    @@circles = [] of Circle

    class Circle
      def initialize(@location, @width)
        @@circles.push self
      end

      def to_s
        "<#{@location.i},#{@location.j}> x #{@width}"
      end
    end


    def initialize
      puts "+ #{to_s}"
    end

    def finalize
      puts "- #{to_s}"
    end

    def drawCircle(circle, color)
      case color
      when @white
        color_name = "white"
      when @black
        color_name = "black"
      else
        color_name = color.to_s
      end

      puts "-> #{circle.to_s} in #{colorName}"
    end

    def addCircle(location, width)
      circle = Circle.new location, width
      puts "+o #{circle.to_s}"
    end

    def removeCircle()
      circle = @@circles.shift()
      puts "-o #{circle.to_s}"
    end
  end
end
