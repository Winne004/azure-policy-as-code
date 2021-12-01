#################################################################################
# Policy rule definition for FileandBlobEncryptionNotSet.
# 
# will audit a user from creating a resource if it does not include a specified 
# tag name and a value from a pre-determined set of value. 
# Values are set using the mandatory_tag_map in variables.tf
# mandatory_tag_map is a map where the key is tag name and the values are allowed
# tag values. E.G.: 
# default = {"Terraform"    = " \"Y\", \"N\""} 
#################################################################################

resource "azurerm_policy_definition" "RequireTagNameAndValueFromSet" {
  for_each = var.mandatory_tag_map

  name         = "RequireTagNameAndValueFromSet_${each.key}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require Tag name And Value from sets - ${each.key}"
  description  = "This custom Azure Policy will audit a user from creating a resource if it does not include a specified tag name and a value from a pre-determined set of values"


  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }
METADATA

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Resources/subscriptions/resourceGroups"
          },
      { "not": {
        "field": "[concat('tags[', parameters('tagName'), ']')]",
        "in": "[parameters('tagValue')]"
      }}
      ]
    },
    "then": {
      "effect": "audit" 
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
     {
    "tagName": {
      "type": "String",
      "metadata": {
        "displayName": "Tag Name",
        "description": "Name of the tag, such as 'Environment'"
      },
      "defaultValue": "${each.key}"
    },
    "tagValue": {
      "type": "array",
      "metadata": {
        "displayName": "Tag Value",
        "description": "Value of the tag"
      },
      "defaultValue": [${each.value}],
      "allowedValues":  
        [${each.value}]
      
      
    }
  }
PARAMETERS 

}

#################################################################################
# Policy rule definition for addTagToRG.
# 
# Enforces existence of tags on resource 

# Values are set using the mandatory_tag_keys in variables.tf
# mandatory_tag_keys is a list  of mandatory tag keys
#################################################################################

resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)

  name         = "addTagToRG_${var.mandatory_tag_keys[count.index]}"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Require tag ${var.mandatory_tag_keys[count.index]} on resource group"
  description  = "Enforces existence of  ${var.mandatory_tag_keys[count.index]} tag on resource groups."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "type",
            "equals" : "Microsoft.Resources/subscriptions/resourceGroups"
          },
          {
            "field" : "[concat('tags[', parameters('tagName'), ']')]",
            "exists" : "false"
          }
        ]
      },
      "then" : {
        "effect" : "deny"
      }
    }
  )

  parameters = jsonencode(
    {
      "tagName" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
          "description" : "Name of the tag, such as ${var.mandatory_tag_keys[count.index]}"
        },
        "defaultValue" : "${var.mandatory_tag_keys[count.index]}"
      }
    }
  )
}

#################################################################################
# Policy rule definition for inheritTagFromRG.
# 
# Enforces existence of tags on resources 

# Adds the specified mandatory tag ${var.mandatory_tag_keys[count.index]} with its 
# value from the parent resource group when any resource missing this tag is 
# created or updated. Existing resources can be remediated by triggering a 
# remediation task. If the tag exists with a different value it will not be 
# changed.

# As above, Values are set using the mandatory_tag_keys in variables.tf
# mandatory_tag_keys is a list  of mandatory tag keys.  
#################################################################################

resource "azurerm_policy_definition" "inheritTagFromRG" {
  count = length(var.mandatory_tag_keys)

  name                  = "inheritTagFromRG_${var.mandatory_tag_keys[count.index]}_if_missing"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group if missing"
  description           = "Adds the specified mandatory tag ${var.mandatory_tag_keys[count.index]} with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "allOf" : [
          {
            "field" : "[concat('tags[', parameters('tagName'), ']')]",
            "exists" : "false"
          },
          {
            "value" : "[resourceGroup().tags[parameters('tagName')]]",
            "notEquals" : ""
          }
        ]
      },
      "then" : {
        "effect" : "modify",
        "details" : {
          "roleDefinitionIds" : [
            "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
          ],
          "operations" : [
            {
              "operation" : "add",
              "field" : "[concat('tags[', parameters('tagName'), ']')]",
              "value" : "[resourceGroup().tags[parameters('tagName')]]"
            }
          ]
        }
      }
    }
  )
  parameters = jsonencode(
    {
      "tagName" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
          "description" : "Name of the tag, such as '${var.mandatory_tag_keys[count.index]}'"
        },
        "defaultValue" : "${var.mandatory_tag_keys[count.index]}"
      }
    }
  )
}

resource "azurerm_policy_definition" "RequireTagOnResources" {
  count = length(var.mandatory_tag_keys)

  name         = "Require_${var.mandatory_tag_keys[count.index]}_on_resource"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Require ${var.mandatory_tag_keys[count.index]} on resource"
  description  = "Enforces existence of a tag. Does not apply to resource groups."

  metadata = jsonencode(
    {
      "category" : "${var.policy_definition_category}",
      "version" : "1.0.0"
    }
  )
  policy_rule = jsonencode(
    {
      "if" : {
        "field" : "[concat('tags[', parameters('tagName'), ']')]",
        "exists" : "false"
      },
      "then" : {
        "effect" : "deny"
      }
    }
  )
  parameters = jsonencode(
    {
      "tagName" : {
        "type" : "String",
        "metadata" : {
          "displayName" : "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
          "description" : "Name of the tag, such as '${var.mandatory_tag_keys[count.index]}'"
        },
        "defaultValue" : "${var.mandatory_tag_keys[count.index]}"
      }
    }
  )
}
