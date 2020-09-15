# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def validations
    Settings.validations
  end
end
