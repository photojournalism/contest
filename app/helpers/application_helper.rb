module ApplicationHelper

  def require_admin
    if current_user
      if !current_user.admin?
        flash[:alert] = "You are not authorized to perform that request."
        redirect_back_or_to(root_path)
      end
    else
      flash[:notice] = "Please log in first."
      redirect_to(user_session_path)
    end
  end

  def redirect_back_or_to(path)
    redirect_to(request.referer || path)
  end
end
