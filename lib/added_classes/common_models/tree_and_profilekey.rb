class TreeAndProfilekey

  #############################################################
  # Иванищев А.В. 2015
  # @note: Common methods for both models: Tree and ProfileKey
  #############################################################

  # @note: ИСПОЛЬЗУЮТСЯ В METHODS: rename profile

  # @note: change name_id in one column
  def self.change_name(rename_data)

    model         = rename_data[:model]
    profile_field = rename_data[:profile_field]
    profile_id    = rename_data[:profile_id]
    name_field    = rename_data[:name_field]
    new_name_id   = rename_data[:new_name_id]

    rows = model.where(profile_field => profile_id)
    rows.each {|one_row| one_row.update_attributes(name_field => new_name_id, updated_at: Time.now)} unless rows.blank?

  end











end