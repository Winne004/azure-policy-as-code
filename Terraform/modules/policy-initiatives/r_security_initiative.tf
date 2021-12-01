resource "azurerm_policy_set_definition" "security_governance" {

  name                  = "security_governance"
  policy_type           = "Custom"
  display_name          = "Test: Security Governance"
  description           = "Contains common Security Governance policies"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }

  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_security_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}
