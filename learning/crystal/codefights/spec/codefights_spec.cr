require "./spec_helper"

describe Codefights do
  # TODO: Write tests

  #it "works" do
  #  false.should eq(true)
  #end

  describe Prime do
    it ".isPrime" do
      2.isPrime.should be_true
      3.isPrime.should be_true
      4.isPrime.should be_false
      5.isPrime.should be_true
      6.isPrime.should be_false
    end

    it ".factors" do
      factors = 6.factors
      factors.should contain 2
      factors.should contain 3
      factors.
    end
  end
end
