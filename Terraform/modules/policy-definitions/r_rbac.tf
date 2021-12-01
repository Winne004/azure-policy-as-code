#################################################################################
# Policy rule definition for auditRoleAssignmentType_user.
# This policy checks for any Role Assignments of Type [User] 
# Useful for catching individual IAM assignments to resources/RGs which are out 
# of compliance with DLA RBAC standards e.g. not using Groups for RBAC
#################################################################################

resource "azurerm_policy_definition" "auditRoleAssignmentType_user" {
  name                  = "auditRoleAssignmentType_user"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Audit user role assignments"
  description           = "This policy checks for any Role Assignments of Type [User] - useful to catch individual IAM assignments to resources/RGs which are out of compliance with the RBAC standards e.g. using Groups for RBAC."
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
          "field": "type",
          "equals": "Microsoft.Authorization/roleAssignments"
        },
        {
          "field": "Microsoft.Authorization/roleAssignments/principalType",
          "equals": "[parameters('principalType')]"
        }
      ]
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
    "principalType": {
      "type": "String",
      "metadata": {
        "displayName": "principalType",
        "description": "Which principalType to audit against e.g. 'User'"
      },
      "allowedValues": [
        "User",
        "Group",
        "ServicePrincipal"
      ],
      "defaultValue": "User"
    }
  }
PARAMETERS

}
