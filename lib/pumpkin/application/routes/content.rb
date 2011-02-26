class Pumpkin::Application
  get "/*" do
    content_type :json
    path = params[:splat].first.split("/")
    node = Pumpkin::Content.find_by_path(path)
    raise Sinatra::NotFound if node.nil?
    node.to_json
  end
end