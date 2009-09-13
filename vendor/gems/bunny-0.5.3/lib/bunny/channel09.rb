module Bunny
	class Channel09 < Qrack::Channel
		
		def initialize(client)
			super
		end
		
		def open
			client.channel = self
			client.send_frame(Qrack::Protocol09::Channel::Open.new)
      raise Bunny::ProtocolError, "Cannot open channel #{number}" unless client.next_method.is_a?(Qrack::Protocol09::Channel::OpenOk)

			@active = true
			:open_ok
		end
		
		def close
			client.channel = self
			client.send_frame(
	      Qrack::Protocol09::Channel::Close.new(:reply_code => 200, :reply_text => 'bye', :method_id => 0, :class_id => 0)
	    )
	    raise Bunny::ProtocolError, "Error closing channel #{number}" unless client.next_method.is_a?(Qrack::Protocol09::Channel::CloseOk)
	
			@active = false
			:close_ok
		end
		
		def open?
			active
		end
		
	end
end