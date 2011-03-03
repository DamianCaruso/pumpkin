class Pumpkin::Application
  get "/*.json" do    
    path = params[:splat].first.split("/")
    node = Pumpkin::Content.find_by_path(path)
    raise Sinatra::NotFound if node.nil?
    json :content
  end
  
  get "/*.xml" do    
    path = params[:splat].first.split("/")
    @content = Pumpkin::Content.find_by_path(path)
    raise Sinatra::NotFound if @content.nil?    
    nokogiri :content
  end
end