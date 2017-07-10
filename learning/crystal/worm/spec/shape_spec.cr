require "./spec_helper"

class Renderer
  def initialize(@log)
  end

  def draw_point(*args)
    @log.push args
  end
end


describe Shape do
  describe Shape::Circle do
    describe "#drawOn" do
      it "calls draw_point on the supplied renderer" do
        log = [] of Array
        renderer = Renderer.new log
        circle = Shape::Circle.new 0, 0, 10
        circle.drawOn renderer
        log.size.should be > 0
      end
    end
  end
end
