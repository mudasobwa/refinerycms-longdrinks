module Refinery
  module Longdrinks
    module Admin
      class LongdrinksController < ::Refinery::AdminController

        crudify :'refinery/longdrinks/longdrink', :xhr_paging => true

      end
    end
  end
end
