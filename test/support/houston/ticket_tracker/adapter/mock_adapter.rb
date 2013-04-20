module Houston
  module TicketTracker
    module Adapter
      class MockAdapter
        
        def self.errors_with_parameters(*args)
          {}
        end
        
        def self.build(*args)
          Houston::TicketTracker::NullConnection
        end
        
      end
    end
  end
end
