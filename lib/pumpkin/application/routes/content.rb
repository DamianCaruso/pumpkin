class Pumpkin::Application
  get "/*.json" do
    content_type :json
    path = params[:splat].first.split("/")
    node = Pumpkin::Content.find_by_path(path)
    raise Sinatra::NotFound if node.nil?
    node.to_json
  end
  
  get "/*.xml" do
    content_type :xml
    path = params[:splat].first.split("/")
    node = Pumpkin::Content.find_by_path(path)
    raise Sinatra::NotFound if node.nil?
    node.to_xml
  end
end