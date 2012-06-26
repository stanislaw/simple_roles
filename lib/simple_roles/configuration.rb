module SimpleRoles
  module Configuration
    extend self
    
    attr_writer :strategy, :user_models

    def user_models
      @user_models ||= []
    end

    def valid_roles *vr
      if vr.any?
        self.valid_roles = vr.flatten
      end

      @valid_roles ||= default_roles
    end

    def valid_roles= vr
      check_roles(vr)

      @valid_roles = vr

      distribute_methods
    end

    def default_roles
      [:user, :admin]
    end

    def strategy st = nil
      if st
        self.strategy = st
      end

      @strategy ||= default_strategy
    end

    def strategy= st
      check_strategy st

      @strategy = st
    end

    def available_strategies
      strategies.keys
    end

    def strategy_class _strategy = nil
      strategies[_strategy || strategy]
    end

    def strategies
      {
        :one => SimpleRoles::One,
        :many => SimpleRoles::Many
      }
    end

    private

    def distribute_methods
      user_models.each(&:register_dynamic_methods)
    end

    def check_strategy strategy
      raise "Wrong strategy!" unless available_strategies.include? strategy
    end

    def check_roles rolez = valid_roles
      raise "There should be an array of valid roles" unless rolez.kind_of?(Array)

      rolez.map do |rolle|
        begin
          Role.find_by_name! rolle.to_s
        rescue
          puts "SimpleRoles warning: Couldn't find Role for #{rolle}. Maybe you need to re-run migrations?"
        end
      end if strategy == :many
    end
    
    def default_strategy
      :one
    end
  end
end
