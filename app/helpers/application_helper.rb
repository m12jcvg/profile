module ApplicationHelper
  def default_button_class
    Config.maintenance_mode? ? "disabled-button" : "primary-button"
  end

  def secondary_button_class
    Config.maintenance_mode? ? "disabled-button" : "secondary-button"
  end
end
