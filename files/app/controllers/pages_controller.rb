class PagesController < ApplicationController

  before_filter :localized_page

  def home
  end

  protected

    def localized_page
      # locale = params[:locale]
      locale = I18n.locale
      action = action_name
      @page = "#{Rails.root}/config/locales/#{controller_name}/"\
              "#{action}/#{action}.#{locale}.md"
    end
end
