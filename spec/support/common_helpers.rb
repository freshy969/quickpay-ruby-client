module QuickPay
  module CommonHelpers
    
    def secret
      'foo:bar'  
    end
    
    def url_with_secret
      "https://#{secret}@#{QuickPay::BASE_URI.split('://').last}"  
    end
    
    def stub_qp_request(method, path, status, response_body, response_headers = {})
      url = URI.join(url_with_secret, path)
      
      stub_request(method, url)
        .with(:headers => headers)
        .to_return(:status => status, 
                   :headers => response_headers, 
                   :body => response_body.to_json)
        
    end
    
    def stub_json_request *args
      stub_qp_request(*(args << { 'Content-Type' => 'application/json' }))  
    end
    
    def expect_qp_request(method, path, body)
      url = URI.join(url_with_secret, path)

      expect(WebMock).to have_requested(method, url).with(
        :body => body,
        :headers => headers)
    end    
    
    def headers options = {}
      user_agent = "quickpay-ruby-client, v#{QuickPay::VERSION}"
      user_agent += ", #{RUBY_VERSION}, #{RUBY_PLATFORM}, #{RUBY_PATCHLEVEL}"
      if defined?(RUBY_ENGINE)
        user_agent += ", #{RUBY_ENGINE}"
      end

      {
        "Accept-Version" => "v10", 
        "User-Agent" => user_agent 
      }      
    end        
        
  end
end
