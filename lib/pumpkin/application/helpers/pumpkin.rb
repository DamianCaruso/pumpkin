class Pumpkin::Application
  helpers do
    def json(*args)
      content_type :json
      render(:json, *args)
    end
  end
end