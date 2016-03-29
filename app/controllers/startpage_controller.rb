class StartpageController < ApplicationController
  def start
    #logger.debug "* Locale set to '#{I18n.locale}'"
    @env = ENV["USER_PASSWD"]
  end
end
