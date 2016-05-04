module LogsHelper
  def get_selected_action_type(selected_action_type, option_key)
     (selected_action_type.to_s === option_key.to_s) ? 'selected="selected"' : ""
  end
end