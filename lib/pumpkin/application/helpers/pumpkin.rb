class Pumpkin::Application
  helpers do
    def json(*args)
      content_type :json
      render(:json, *args)
    end
    
    def logger
      Pumpkin.logger
    end
  end
end