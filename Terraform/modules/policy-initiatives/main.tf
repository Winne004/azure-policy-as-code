#################################################################################
# Initiative definition for Tagging_policies.
# 
# A catch-all for all tagging policies.  

# Includes custom tagging policy defintions only 
#################################################################################

resource "azurerm_policy_set_definition" "Tagging_policies" {

  name                  = "Tagging_policies_sets"
  policy_type           = "Custom"
  display_name          = "Test: Tagging Policies"
  description           = "Contains Tagging Governance policies"
  management_group_name = var.MG_Name

  metadata = <<METADATA
    {
    "category": "${var.policyset_definition_category}"
    }
METADATA

  dynamic "policy_definition_reference" {
    for_each = var.TagNameAndValueFromSet
    content {
      policy_definition_id = policy_definition_reference.value
      reference_id         = policy_definition_reference.value
    }
  }

  dynamic "policy_definition_reference" {
    for_each = var.addTagToRG
    content {
      policy_definition_id = policy_definition_reference.value
      reference_id         = policy_definition_reference.value
    }
  }

  dynamic "policy_definition_reference" {
    for_each = var.inheritTagFromRG
    content {
      policy_definition_id = policy_definition_reference.value
      reference_id         = policy_definition_reference.value
    }
  }

  dynamic "policy_definition_reference" {
    for_each = var.RequireTagOnResource
    content {
      policy_definition_id = policy_definition_reference.value
      reference_id         = policy_definition_reference.value
    }
  }
}

#################################################################################
# Initiative definition for iam_governance.
# 
# A catch-all for all tagging policies.  

# Includes custom and built-in IAM policy defintions  
#################################################################################

resource "azurerm_policy_set_definition" "iam_governance" {

  name                  = "iam_governance"
  policy_type           = "Custom"
  display_name          = "Test: Identity and Access Management Governance"
  description           = "Contains common Identity and Access Management Governance policies"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }

  )

  dynamic "policy_definition_reference" {
    for_each = var.custom_policies_RBAC_governance
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_RBAC_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}

#################################################################################
# Initiative definition for VM_governance.
# 
# A catch-all for all IAM policies.  

# Includes built-in VM policy defintions only 
#################################################################################

resource "azurerm_policy_set_definition" "VM_governance" {

  name                  = "VM_governance"
  policy_type           = "Custom"
  display_name          = "Test: Virtual Machine Resource Governance"
  description           = "Contains common Virtual Machine Resource Governance policies"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }

  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_VM_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}

#################################################################################
# Initiative definition for data_sovereignty.
# 
# A catch-all for all data sovereignty policies.  

# Includes built-in data_sovereignty policy defintions only
# These policies are parameterised at an initiative level with 
# listOfAllowedLocations. These value control geos that resources can be deployed 
# to. 
#################################################################################

resource "azurerm_policy_set_definition" "data_sovereignty" {

  name                  = "data_sovereignty"
  policy_type           = "Custom"
  display_name          = "Test: data sovereignty policies"
  description           = "Contains data sovereignty policies"
  management_group_name = var.MG_Name

  parameters = <<PARAMETERS
{
    "listOfAllowedLocations": {
        "type": "array",
        "defaultValue": [
            "westeurope",
            "northeurope"
        ],
        "allowedValues": [
            "westeurope",
            "northeurope"
        ]
    }
}
    
  PARAMETERS

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_data_sovereignty
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
      parameter_values = jsonencode({
        listOfAllowedLocations = { value = "[parameters('listOfAllowedLocations')]" }
        }
      )
    }
  }
}

#################################################################################
# Initiative definition for Storage_and_database.
# 
# A catch-all for all Storage_and_database policies 

# Includes built-in & custom Storage_and_database policy defintions 
#################################################################################

resource "azurerm_policy_set_definition" "Storage_and_database" {

  name                  = "Storage_and_database"
  policy_type           = "Custom"
  display_name          = "Test: Storage and database policies"
  description           = "Contains policies controlling how storage and databases are used at DLA"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_storage_and_databases
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
  dynamic "policy_definition_reference" {
    for_each = var.custom_policies_storage_accounts
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }
}

#################################################################################
# Initiative definition for network_governance.
# 
# A catch-all for all network_governance policies 

# Includes built-in & custom Storage_and_database policy defintions 
#################################################################################

resource "azurerm_policy_set_definition" "network_governance" {

  name                  = "network_governance"
  policy_type           = "Custom"
  display_name          = "Test: Network Governance"
  description           = "Contains common Network Governance policies"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = var.custom_policies_network_governance
    content {
      policy_definition_id = policy_definition_reference.value["policyID"]
      reference_id         = policy_definition_reference.value["policyID"]
    }
  }

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_network_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}

#################################################################################
# Initiative definition for Secrets_Management_governance.
# 
# A catch-all for all Secrets_Management_governance policies 

# Includes built-in Storage_and_database policy defintions only 
#################################################################################

resource "azurerm_policy_set_definition" "Secrets_Management_governance" {

  name                  = "secrets_management_governance"
  policy_type           = "Custom"
  display_name          = "Test: Secrets Management Governance"
  description           = "Contains common secrets management governance policies"
  management_group_name = var.MG_Name

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_secrets_management_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}

#################################################################################
# Initiative definition for development_and_automation_governance.
# 
# A catch-all for all development_and_automation_governance policies 

# Includes built-in development_and_automation_governance policy defintions only 
#################################################################################

resource "azurerm_policy_set_definition" "development_and_automation_governance" {

  name         = "development_and_automation_governance"
  policy_type  = "Custom"
  display_name = "Test: Development and Automation Governance"
  description  = "Contains common Development and Automation governance policies"

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )

  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_development_and_automation
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
    }
  }
}

#################################################################################
# Initiative definition for dlogging_governance.
# 
# A catch-all for all logging_governance policies 

# Includes built-in logging_governance policy defintions only. 
# These policies are parameterised at an initiative level with 
# listOfResourceTypes & logAnalytics. 

# listOfResourceTypes is an array of all resoruce types in Azure. 
# The list of providers will need to be periodically updated. 
# The current list was taken from here: 
# https://github.com/Azure/azure-policy/blob/master/built-in-policies/policySetDefinitions/Regulatory%20Compliance/SWIFTv2020_audit.json

# An output of Az providers can be created using the Az CLI command: 
# az provider list -o table 

# logAnalytics is a string of the Resource ID for the desired Log analytics 
# workspace. 

# I.E., something similar to: 
# /subscriptions/c9f5af22-0a95-4d13-8e3c-81adc8f1b160/resourcegroups/rg-intl-management-01-euwest-evergreen-update-compliance-9d43/providers/microsoft.operationalinsights/workspaces/log-intl-management-01-euwest-evergreen-update-compliance-9d43
#################################################################################

resource "azurerm_policy_set_definition" "logging_governance" {

  name                  = "logging_governance"
  policy_type           = "Custom"
  display_name          = "Test: Logging Governance"
  description           = "Contains common Logging Governance policies"
  management_group_name = var.MG_Name
  # removed the following as they do not work as intended: "Microsoft.Compute/virtualMachines" / "Microsoft.Compute/virtualMachineScaleSets",
  # https://docs.microsoft.com/en-us/answers/questions/170261/security-center-regulatory-compliance-34audit-diag.html
  parameters = <<PARAMETERS
{
    "listOfResourceTypes": {
        "type": "array",
        "defaultValue": [
            "Microsoft.AnalysisServices/servers",
            "Microsoft.ApiManagement/service",
            "Microsoft.Network/applicationGateways",
            "Microsoft.Automation/automationAccounts",
            "Microsoft.ContainerInstance/containerGroups",
            "Microsoft.ContainerRegistry/registries",
            "Microsoft.ContainerService/managedClusters",
            "Microsoft.Batch/batchAccounts",
            "Microsoft.Cdn/profiles/endpoints",
            "Microsoft.CognitiveServices/accounts",
            "Microsoft.DocumentDB/databaseAccounts",
            "Microsoft.DataFactory/factories",
            "Microsoft.DataLakeAnalytics/accounts",
            "Microsoft.DataLakeStore/accounts",
            "Microsoft.EventGrid/eventSubscriptions",
            "Microsoft.EventGrid/topics",
            "Microsoft.EventHub/namespaces",
            "Microsoft.Network/expressRouteCircuits",
            "Microsoft.Network/azureFirewalls",
            "Microsoft.HDInsight/clusters",
            "Microsoft.Devices/IotHubs",
            "Microsoft.KeyVault/vaults",
            "Microsoft.Network/loadBalancers",
            "Microsoft.Logic/integrationAccounts",
            "Microsoft.Logic/workflows",
            "Microsoft.DBforMySQL/servers",
            "Microsoft.Network/networkInterfaces",
            "Microsoft.Network/networkSecurityGroups",
            "Microsoft.DBforPostgreSQL/servers",
            "Microsoft.PowerBIDedicated/capacities",
            "Microsoft.Network/publicIPAddresses",
            "Microsoft.RecoveryServices/vaults",
            "Microsoft.Cache/redis",
            "Microsoft.Relay/namespaces",
            "Microsoft.Search/searchServices",
            "Microsoft.ServiceBus/namespaces",
            "Microsoft.SignalRService/SignalR",
            "Microsoft.Sql/servers/databases",
            "Microsoft.Sql/servers/elasticPools",
            "Microsoft.StreamAnalytics/streamingjobs",
            "Microsoft.TimeSeriesInsights/environments",
            "Microsoft.Network/trafficManagerProfiles",
            "Microsoft.Network/virtualNetworks",
            "Microsoft.Network/virtualNetworkGateways"
        ]
    },
    "logAnalytics": {
        "type": "String",
        "defaultvalue": "${var.log_analytics_id}"
    },
      "logAnalyticsWorkspaceId": {
      "type": "String",
      "defaultvalue": "${var.log_analytics_id}"
    }
}
PARAMETERS

  metadata = jsonencode(
    {
      "category" : "${var.policyset_definition_category}"
    }
  )
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9"
    reference_id         = "Audit diagnostic setting"
    parameter_values = jsonencode(
      {
        "ListOfResourceTypes" : { "value" : "[parameters('ListOfResourceTypes')]" }
      }
    )
  }
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/f47b5582-33ec-4c5c-87c0-b010a6b2e917"
    reference_id         = "Virtual machines should be connected to a specified workspace"
    parameter_values = jsonencode(
      {
        "logAnalyticsWorkspaceId" : { "value" : "[parameters('logAnalyticsWorkspaceId')]" }
      }
    )
  }
  dynamic "policy_definition_reference" {
    for_each = data.azurerm_policy_definition.builtin_policies_logging_governance
    content {
      policy_definition_id = policy_definition_reference.value["id"]
      reference_id         = policy_definition_reference.value["display_name"]
      parameter_values = jsonencode(
        {
          "logAnalytics" : { "value" : "[parameters('logAnalytics')]" }
        }
      )
    }
  }
}


