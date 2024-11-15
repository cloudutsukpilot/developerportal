variable "aad_groups" {
    description = "A map of Azure AD group configurations with related attributes for each group."
    type = map(object({
        display_name     = string
        description      = string
        owners           = list(string)
        members          = list(string)
        security_enabled = bool
    }))
}