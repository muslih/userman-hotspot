helpers do
  # helpers untuk url dan css
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
    # "<link href=\"/css/#{stylesheet}.css\" media=\"all, projection\" rel=\"stylesheet\" />"
    "<link href=\"/css/#{stylesheet}.css\" media=\"all\" rel=\"stylesheet\" />"
    end.join
  end

  def js(*stylesheets)
    stylesheets.map do |javascript|
    "<script src=\"/js/#{javascript}.js\"></script>"
    end.join
  end

  def current?(path='/')
    (request.path==path || request.path==path+'/') ? "current" : nil
  end

  # helpers authentikasi
  def admin?
    request.cookies[settings.username] == settings.token
  end
  
  def protected!
    # halt [ 401, 'Not Authorized' ] unless admin?
     redirect to('/login') unless admin?
  end
end