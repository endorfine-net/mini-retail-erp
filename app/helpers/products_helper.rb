module ProductsHelper
  def get_selected_collection_season(season_id, option_key)
    return (season_id.to_i == option_key.to_i)? 'selected="selected"' : ""
  end
  
  def getColorPreviewBox(color)
    secondary_color = (!color.secondary.blank?)? color.secondary : color.primary
    previewBox = '<div class="colorPreview" style="'
    previewBox += 'background-color: #' + color.primary + '; '
    previewBox += 'border-bottom-color: #' + secondary_color + ';">'
    previewBox += color.alias
    previewBox += '</div>'
  end
  
  def getColorPreviewBoxShort(color)
    secondary_color = (!color.secondary.blank?)? color.secondary : color.primary
    previewBox = '<div class="colorPreview" style="'
    previewBox += 'background-color: #' + color.primary + '; '
    previewBox += 'border-bottom-color: #' + secondary_color + ';">'
    previewBox += color.code
    previewBox += '</div>'
  end
  
end