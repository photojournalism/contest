require 'digest'

module UsersHelper
  
  def gravatar_url_for(user)
    md5 = Digest::MD5.new
    md5 << user.email.downcase
    "http://www.gravatar.com/avatar/#{md5.hexdigest}?s=400"
  end

  def gravatar_for(user, width=400, css_class='')
    "<img src='#{gravatar_url_for(user)}' alt='Gravatar for #{user.first_name} #{user.last_name}' width='#{width}' class='#{css_class}'>"
  end
end
