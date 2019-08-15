module Requests  
  module JsonHelpers
    def hash_body
    	JSON.parse(response.body)
    end
  end
end 