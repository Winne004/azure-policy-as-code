resource "azurerm_policy_set_definition" "Kubernetes_initiative" {

  name                  = "Kubernetes_initiative"
  policy_type           = "Custom"
  display_name          = "Test: Kubernetes Governance Initiative"
  description           = "Contains sensible Kubernetes policies for testing"
  management_group_name = var.MG_Name

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }
METADATA

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_kubernetes_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}
