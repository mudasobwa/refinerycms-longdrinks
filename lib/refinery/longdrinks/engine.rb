module Refinery
  module Longdrinks
    class Engine < Rails::Engine
      include Refinery::Engine
      isolate_namespace Refinery::Longdrinks

      engine_name :refinery_longdrinks

      initializer "register refinerycms_longdrinks plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "longdrinks"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.longdrinks_admin_longdrinks_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/longdrinks/longdrink'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Longdrinks)
      end
    end
  end
end
