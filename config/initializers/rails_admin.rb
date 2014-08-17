RailsAdmin.config do |config|

  config.main_app_name = ["Atlanta Photojournalism Seminar", "Administration"]
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :admin
  # end
  # config.current_user_method(&:current_user)

  config.authorize_with do |controller|
    unless current_user.try(:admin)
      flash[:alert] = "You are not authorized to perform that action."
      redirect_to '/'
    end
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
