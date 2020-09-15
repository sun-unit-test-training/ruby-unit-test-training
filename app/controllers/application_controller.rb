class ApplicationController < ActionController::Base
  def validations
    Settings.validations
  end
end
