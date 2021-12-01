#################################################################################
# Policy rule definition for FileandBlobEncryptionNotSet.
# Source: NewSignature 
# Audits storage accounts with File and Blob Encryption not set
#################################################################################

resource "azurerm_policy_definition" "FileandBlobEncryptionNotSet" {

  name                  = "NS Azure Storage - File and Blob Encryption Not Set - Audit"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "NS: Azure Storage - File and Blob Encryption Not Set - Audit"
  description           = "Audit storage accounts with File and Blob Encryption not set"
  management_group_name = var.MG_Name


  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA


  policy_rule = <<POLICY_RULE
  {
    "if": {
      "allOf": [
        {
          "equals": "Microsoft.Storage/storageAccounts",
          "field": "type"
        },
        {
          "anyof": [
            {
              "field": "Microsoft.Storage/storageAccounts/enableFileEncryption",
              "notEquals": "true"
            },
            {
              "field": "Microsoft.Storage/storageAccounts/enableblobEncryption",
              "notEquals": "true"
            }
          ]
        }
      ]
    },
    "then": {
      "effect": "Audit"
    }
  }
POLICY_RULE

}


