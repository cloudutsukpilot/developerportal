variable "role_assignments" {
  description = "A map of roles to be assigned to each scope."
  type = map(object({
    scope                = string
    role_definition_name = string
    principal_id         = string
  }))
}