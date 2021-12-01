variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

variable "MG_Name" {
  type        = string
  description = "The Management group to apply the policy to"
  default     = ""
}

variable "mandatory_tag_map" {
  type        = map(string)
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default = {
    "NonClientData"      = " \"Y\", \"N\"",
    "ClientData"         = " \"Y\", \"N\"",
    "SecurityCompliance" = " \"Y\", \"N\""
  }
}

variable "mandatory_tag_keys" {
  type        = list(any)
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG'"
  default = [
    "ClientData",
    "NonClientData",
    "SecurityCompliance",
    "Application",
    "FinanceProjectName",
    "ServiceName"
  ]
}

variable "mandatory_tag_value" {
  type        = string
  description = "Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default     = "TBC"
}

