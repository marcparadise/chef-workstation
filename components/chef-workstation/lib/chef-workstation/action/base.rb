require "chef-workstation/telemetry"
require "chef-workstation/action/errors"

module ChefWorkstation
  module Action
    # Derive new Actions from Action::Base
    # "connection" is a train connection that may be active and available
    #              based on
    # "reporter" is an interface to the UI that supports 'status', 'success', and 'failure'.
    # "config" is hash containing any options that your command may need
    #
    # Implement perform_action to perform whatever action your class is intended to do.
    # Run time will be captured via telemetry and categorized under ":action" with the
    # unqualified class name of your Action.
    class Base
      attr_reader :reporter, :connection, :config
      def initialize(config = {})
        c = config.dup
        @reporter = c.delete :reporter
        @connection = c.delete :connection
        # Remaining options are for child classes to make use of.
        @config = c
      end

      def run
        Telemetry.timed_capture(:action, name: self.class.name.split("::").last) do
          perform_action
        end
      end

      def perform_action
        raise NotImplemented
      end
    end
  end
end