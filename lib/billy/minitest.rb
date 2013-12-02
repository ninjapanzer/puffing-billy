require 'minitest/spec'
require 'capybara_minitest_spec'
require 'billy'

Billy.register_drivers

module Billy
  module Minitest

    def inherited(child)
      # running normal minitest inherited logic first
      orig_inherited child

      # adding the local proxy method to the minitest spec class
      child.class_eval do
        def proxy
          Billy.proxy
        end
      end

      # Adding cleanup to the after block
      child.instance_eval do
        after do
          proxy.reset
        end
      end
      
    end

  end
end

class << Minitest::Spec
  alias_method :orig_inherited, :inherited
  include Billy::Minitest
end
