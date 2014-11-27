json.array!(@weafam_settings) do |weafam_setting|
  json.extract! weafam_setting, :id, :certain_koeff
  json.url weafam_setting_url(weafam_setting, format: :json)
end
