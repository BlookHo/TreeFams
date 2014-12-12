if @name
  json.name   @name.name
  json.sex_id @name.sex_id
  json.id     @name.id
  json.search_name_id @name.search_name_id
  json.parent_name @name.try(:parent_name).try(:name)
else
  json.error "Name not found"
end
