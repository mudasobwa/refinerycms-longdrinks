module Refinery
  module Longdrinks
    class Longdrink < Refinery::Core::BaseModel
      self.table_name = 'refinery_longdrinks'

      attr_accessible :title, :command, :started, :finished, :errors, :position

      acts_as_indexed :fields => [:title, :command, :errors]

      validates :title, :presence => true, :uniqueness => true
    end
  end
end
