module Refinery
  module Longdrinks
    module Admin
      class LongdrinksController < ::Refinery::AdminController

        crudify :'refinery/longdrinks/longdrink', :xhr_paging => true

        def before_create
          # event = ActiveSupport::Notifications::Event.new(*args)
          # puts "Got notification: #{event.inspect}"
          super
        end
        
        
      end
    end
  end
end
