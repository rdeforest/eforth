require "sdl"
require "chipmunk"
require "random"
require "math"

require "./dots/*"

module Dots
  maxDots = 10
  radius = 5
  mass = 1
  dragCoef = 0.01
  moment = CP::Circle.moment @mass, 0.0, radius

  startX = 0
  startY = 40

  class Ball
    def initialize(space, x, y)
      @body = space.add CP::Body.new mass, moment

      angle = Math::TAU * rand
      @body.velocity CP.v Math.cos(angle), Math.sin(angle)
      @body.position CP.v x, y
      @body.friction = 0.7
    end

    def burnedOut?
    end
  end

  class Toy
    def initialize
      @dots = [] of Ball
      @space = CP::Space.new
      @space.gravity = CP.v 0, -100
      @addDots Time.now

      ground = CP::Segment.new @space.static_body, CP.v(-20, 5), CP.v(20, -5), 0.0
    end

    def addDots
      while @dots.length < maxDots
        @dots.push Ball.new @space, startX, startY
      end
    end

    def expireDots(now)
      while @dots.length && @dots[0].burnedOut? now
        @dots.shift
      end

      @addDots
    end

    def onTick
      curTime = Time.now
      dt = curTime - @prevStep

      @expireDots curTime

      @space.step dt
      @updateDisplay

      @prevStep = curTime
    end
  end

  class App
    def initialize
      Random
      SDL.init      SDL::Init::Video;    at_exit { SDL.quit }
      SDL::IMG.init SDL::IMG::Init::PNG; at_exit { SDL::IMG.quit }

      @window = SDL::Window.new "Dots", 640, 480
      @renderer = SDL::Rendered.new @window,
        SDL::Renderer::Flags::ACCELERATED |
        SDL::Renderer::Flags::PRESENTING

      @toy = Toy.new @renderer
    end

    def run
      loop do
        case event = SDL::Event.poll
        when SDL::Event::Quit or SDL::Event::Keyboard && event.sym.q?
          break
        end

        @toy.onTick
      end
    end

  end
  # TODO Put your code here
end
