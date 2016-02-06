class StartpageController < ApplicationController
  def start
    logger.debug "* Locale set to '#{I18n.locale}'"
  end
end
