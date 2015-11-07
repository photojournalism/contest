class StatesController < ApplicationController

  def get_select_for_country
    @states = State.order('name ASC').where(country_id: params['country_id']);
    render layout: false
  end
end
