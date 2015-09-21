require 'rspec/core/formatters'
require 'json'
require 'rspec/rotten/example_store'

module Rspec
  module Rotten
    module Formatters
      class RottenReportFormatter
        RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending, :close

        def initialize(output)
          @output = output
          @store = ExampleStore.new
        end

        def example_passed(notification)
          record = @store.find(notification.example)
          if record && record['state'] != 'passed'
            @store.delete record
            @store.records << example_data(notification.example, :passed)
          elsif record.nil?
            @store.records << example_data(notification.example, :passed)
          end
        end

        def example_failed(notification)
          record = @store.find(notification.example)
          if record && record['state'] != 'failed'
            @store.delete record
            @store.records << example_data(notification.example, :failed)
          elsif record.nil?
            @store.records << example_data(notification.example, :failed)
          end
        end

        def example_pending(notification)
          record = @store.find(notification.example)
          if record && record['state'] != 'pending'
            @store.delete record
            @store.records << example_data(notification.example, :pending)
          elsif record.nil?
            @store.records << example_data(notification.example, :pending)
          end
        end

        def close(notification)
          @store.save
          @output << @store.notify_rotten if @store.rotten.any?
        end

        private

        def example_data(example, status)
          { id: example.id, state: status, date: Time.now, location: example.location, description: example.description }
        end
      end
    end
  end
end
