#################################################################################
# Policy rule definition for DenyAllOutBoundNSG.
# Denies all outbound traffic from NSG.
# This policy is not currently being assigned as there were issues with it 
# blocking legitimate Azure Management traffic. 
#################################################################################

resource "azurerm_policy_definition" "DenyAllOutBoundNSG" {
  name         = "Allow_Azure_firewall_policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "DenyAllOutBound"
  description  = "Explicit block of all inbound traffic."
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
        "count": {
          "field": "Microsoft.Network/networkSecurityGroups/securityRules[*]",
          "where": {
            "field": "Microsoft.Network/networkSecurityGroups/securityRules[*].priority",
            "equals": "4096"
          }
        },
        "equals": 0
      },
      "then": {
        "effect": "append",
        "details": [
          {
            "field": "Microsoft.Network/networkSecurityGroups/securityRules[*]",
            "value": {
              "name": "DenyAllInBound",
              "type": "Microsoft.Network/networkSecurityGroups/securityRules",
              "properties": {
                "protocol": "*",
                "access": "Allow",
                "direction": "Inbound",
                "sourcePortRange": "*",
                "destinationPortRange": "*",
                "priority": 4096,
                "sourceAddressPrefixes": [],
                "destinationAddressPrefixes": [],
                "sourceAddressPrefix": "*",
                "destinationAddressPrefix": "*"
              }
            }
          },
          {
            "field": "Microsoft.Network/networkSecurityGroups/securityRules[*]",
            "value": {
              "name": "DenyAllOutBound",
              "type": "Microsoft.Network/networkSecurityGroups/securityRules",
              "properties": {
                "protocol": "*",
                "access": "Allow",
                "direction": "Outbound",
                "sourcePortRange": "*",
                "destinationPortRange": "*",
                "priority": 4096,
                "sourceAddressPrefixes": [],
                "destinationAddressPrefixes": [],
                "sourceAddressPrefix": "*",
                "destinationAddressPrefix": "*"
              }
            }
          }
        ]
      }
    }
  

POLICY_RULE
}