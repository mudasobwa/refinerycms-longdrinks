require 'spec_helper'

module Refinery
  module Longdrinks
    describe Longdrink do
      describe "validations" do
        subject do
          FactoryGirl.create(:longdrink,
          :title => "Refinery CMS")
        end

        it { should be_valid }
        its(:problems) { should be_empty }
        its(:title) { should == "Refinery CMS" }
      end
    end
  end
end
