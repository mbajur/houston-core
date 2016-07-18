require "thread_safe"
require "delegate"

module Houston
  class DuplicateTriggerError < ArgumentError; end


  class Triggers < SimpleDelegator
    attr_reader :config

    def initialize(config)
      @config = config
      super ThreadSafe::Array.new
    end


    def at(value, action, params={})
      push build(:at, value, action, params)
    end

    def every(value, action, params={})
      push build(:every, value, action, params)
    end

    def on(event, action, params={})
      push build(:on, event, action, params)
    end

    def build(method_name, value, action, params)
      Trigger.new(self, method_name, value, action, params)
    end

    def push(trigger)
      raise DuplicateTriggerError, "That exact trigger has already been defined" if member?(trigger)
      super trigger
      trigger.register!
      trigger
    end

  end


  class Trigger < Struct.new(:method_name, :value, :action, :params)

    def initialize(triggers, *args)
      @triggers = triggers
      super *args
    end

    def register!
      case method_name
      when :at then config.timer.at(value, &method(:call))
      when :every then config.timer.every(value, &method(:call))
      when :on then config.observer.on(value, &method(:call))
      else raise NotImplementedError, "Unrecognized method name: #{method_name.inspect}"
      end
    end

    def call(params={})
      config.actions.run action, self.params.merge(params.to_h), trigger: to_s
    end

    def to_s
      "#{method_name}(#{value})"
    end

  private
    attr_reader :triggers

    def config
      triggers.config
    end

  end
end