resource "google_tags_tag_value" "value" {
  for_each = { for idx, tag in flatten([
    for tag_key_name, tag in var.tags : [
      for value in tag.values : {
        key_name          = tag_key_name
        key_description   = tag.key_description
        value_name        = value.value_name
        value_description = value.value_description
      }
    ]
  ]) : "${tag.key_name}-${tag.value_name}" => tag }

  parent      = google_tags_tag_key.key[each.value.key_name].id
  short_name  = each.value.value_name
  description = try(each.value.value_description, null)
}