class StartpageController < ApplicationController
  def index
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
end
