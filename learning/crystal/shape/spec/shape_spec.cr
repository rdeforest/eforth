require "./spec_helper"

describe Shape do
  describe "::Point" do
    it "has an x and y" do
      p = Shape::Point.new 1, 2
      p.x.should eq 1
      p.y.should eq 2
    end

    it "has a Point distance from another Point" do
      p = Shape::Point.new 1, 2
      q = Shape::Point.new 4, 6

      diff = p - q
      diff.x.should eq 3
      diff.y.should eq 4
    end

    #it "knows the distance to another Point" do
    #  p = Shape::Point.new 0, 0
    #  q = Shape::Point.new 1, 0

    #  dist = p.distTo q
    #  dist.should eq 1

    #  p = Shape::Point.new 1, 2
    #  q = Shape::Point.new 4, 6

    #  dist = p.distTo q
    #  dist.should eq 5
    #end
  end

  describe "::Shape" do
    it "has a default origin" do
      Shape::Shape.new().origin.should be_truthy
    end
  end

  describe "::Circle" do
    it "has a radius" do
      circle = Shape::Circle.new radius: 5
      circle.radius.should eq 5
    end

    it "should know if it contains a point" do
      circle = Shape::Circle.new radius: 5
      p = Shape::Point.new 1, 2
      q = Shape::Point.new 4, 6

      circle.contains(p).should be_true
      circle.contains(q).should be_false
    end

    it "should know if it overlaps another circle" do
      p = Shape::Circle.new radius: 5
      q = Shape::Circle.new radius: 5

      q.shift x: 1, y: 1
      p.touches(q).should be_true

      q.shift x: 4, y: 4
      p.touches(q).should be_false

    end
  end
end
