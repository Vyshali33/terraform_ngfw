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


# Define a variable for tag configuration
variable "google_tags" {
  type = map(object({
    short_name  = string
    description = string
    values      = list(object({
      short_name  = string
      description = string
    }))
  }))

  default = {
    environment = {
      short_name  = "environment"
      description = "Environment tags"
      values = [
        { short_name = "dev", description = "Development environment" },
        { short_name = "prod", description = "Production environment" },
        { short_name = "staging", description = "Staging environment" }
      ]
    }
    department = {
      short_name  = "costcenter"
      description = "costCenter tags"
      values = [
        { short_name = "solutions", description = "IT department" },
        { short_name = "corporate_sales", description = "Sales department" }
      ]
    }
  }
}

# Create Tag Keys
resource "google_tags_tag_key" "tag_key" {
  for_each = var.google_tags

  parent      = "organizations/your-org-id"  # Replace with your organization ID
  short_name  = each.value.short_name
  description = each.value.description
}

# Create Tag Values for each Tag Key
resource "google_tags_tag_value" "tag_value" {
  for_each = { for key, config in var.google_tags : key => config.values }

  # Iterate through each value for a given key
  dynamic "tag_values" {
    for_each = each.value
    content {
      parent      = google_tags_tag_key.tag_key[each.key].name
      short_name  = tag_values.value.short_name
      description = tag_values.value.description
    }
  }
}

