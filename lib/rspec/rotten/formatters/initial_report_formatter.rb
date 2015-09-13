require 'rspec/core/formatters'
module Rspec
  module Rotten
    module Formatters
      class InitialReportFormatter
        RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending, :close

        def initialize(output)
          @output = output
          @arr = []
        end

        def example_passed(notification)
          @arr << example_data(notification.example, :passed)
        end

        def example_failed(notification)
          @arr << example_data(notification.example, :failed)
        end

        def example_pending(notification)
          @arr << example_data(notification.example, :pending)
        end

        def close(notification)
          @output.write @arr.to_json
          @output.close if IO === @output && @output != $stdout
        end

        private

        def example_data(example, status)
          { id: example.id, state: status, date: Time.now, location: example.location, description: example.description }
        end
      end
    end
  end
end
