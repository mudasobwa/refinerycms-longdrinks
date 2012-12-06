require 'refinery/longdrinks'

module SlowGrowl
  # Code based on https://github.com/igrigorik/slowgrowl library
  # FIXME Make library choice more elegant
  if RUBY_PLATFORM =~ /linux/i
    NOTIFIER = :libnotify
    require 'libnotify'
  else
    NOTIFIER = :growl
    require 'growl'
  end
  
  class Railtie < Rails::Railtie
    config.slowgrowl = ActiveSupport::OrderedOptions.new
    config.slowgrowl.warning = 500  # default slow alert set to 10ms for warnings
    config.slowgrowl.error = 2000   # default slow alert set to 1000ms for errors
    config.slowgrowl.sticky = false # should error warnings be sticky?
    config.slowgrowl.debug = true   # print debug information

    initializer "slowgrowl.initialize" do |app|
      iconpath = Rails.root.join("vendor", "extensions", "longdrinks").to_s + "/images/"
      ActiveSupport::Notifications.subscribe do |*args|

        if NOTIFIER
          event = ActiveSupport::Notifications::Event.new(*args)

          sticky = false
          action, type = event.name.split('.')
          alert = case event.duration
            when (0...config.slowgrowl.warning) then
              false
            when (config.slowgrowl.warning..config.slowgrowl.error) then
              :warning
            else
              sticky = config.slowgrowl.sticky
              :error
          end

          begin
            e = event.payload
            message = case type
              when 'action_controller' then
                alert_icon = "controller"
                case action
                  when 'process_action' then
                    # {:controller=>"WidgetsController", :action=>"index", :params=>{"controller"=>"widgets", "action"=>"index"},
                    #  :formats=>[:html], :method=>"GET", :path=>"/widgets", :status=>200, :view_runtime=>52.25706100463867,
                    #  :db_runtime=>0}


                    if e[:exception]
                      "%s#%s.\n\n%s" % [
                        e[:controller], e[:action], e[:exception].join(', ')
                      ]
                    else
                      "%s#%s (%s).\nDB: %.1f, View: %.1f" % [
                        e[:controller], e[:action], e[:status], (e[:db_runtime] || 0), (e[:view_runtime] || 0)
                      ]
                    end

                  else
                    '%s#%s (%s)' % [e[:controller], e[:action], e[:status]]
                end

              when 'action_view' then
                alert_icon = "view"
                # {:identifier=>"text template", :layout=>nil }
                '%s, layout: %s' % [e[:identifier], e[:layout].nil? ? 'none' : e[:layout]]

              when 'active_record' then
                alert_icon = "model"
                # {:sql=>"SELECT "widgets".* FROM "widgets", :name=>"Widget Load", :connection_id=>2159415800}
                "%s\n\n%s" % [e[:name], e[:sql].gsub("\n", ' ').squeeze(' ')]
              else
                'Duration: %.1f' % [event.duration] if event.respond_to? :duration
            end

            if alert
              title = "%1.fms - %s : %s" % [event.duration, action.humanize, type.camelize]

              case NOTIFIER
                when :growl
                  if Growl.installed?
                    Growl.send("notify_#{alert}", message, {:title => title, :sticky => sticky})
                  end

                when :libnotify
                  # Notify::Notification.new(title, message, nil, nil).show
                  alert_icon ||= "#{alert}";
                  Libnotify.show :summary => "#{title}", :body => "\n#{message}", :icon_path => iconpath + alert_icon + ".png" 
              end
            end
          rescue Exception => e
            if config.slowgrowl.debug
              Refinery::Longdrinks::Longdrink::logger.error e
              Refinery::Longdrinks::Longdrink::logger.error event.inspect
              Refinery::Longdrinks::Longdrink::logger.error e.backtrace.join("\n")
            end
          end

        end
      end

    end
  end
end
