variable "policyset_definition_category" {
  type        = string
  description = "The category to use for all PolicySet defintions"
  default     = "Custom"
}

variable "MG_Name" {
  type        = string
  description = "The Management group to apply the policy to"
  default     = ""
}

variable "log_analytics_id" {
  type        = string
  description = "Resource ID for the OMS workspace - used for log governance policies"
  default     = "/subscriptions/c9f5af22-0a95-4d13-8e3c-81adc8f1b160/resourcegroups/rg-intl-management-01-euwest-monitoring-g5s4/providers/microsoft.operationalinsights/workspaces/log-intl-management-01-euwest-monitoring-s89q"
}

variable "custom_policies_RBAC_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the RBAC governance policyset"
  default     = []
}

variable "builtin_policies_RBAC_governance" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the iam_governance policyset"
  default = [
    "Audit usage of custom RBAC rules",
    "Custom subscription owner roles should not exist",
    "Deprecated accounts should be removed from your subscription",
    "Deprecated accounts with owner permissions should be removed from your subscription",
    "External accounts with write permissions should be removed from your subscription",
    "External accounts with read permissions should be removed from your subscription",
    "External accounts with owner permissions should be removed from your subscription",
    "There should be more than one owner assigned to your subscription",
    "A maximum of 3 owners should be designated for your subscription",
    "MFA should be enabled on accounts with read permissions on your subscription",
    "MFA should be enabled accounts with write permissions on your subscription",
    "MFA should be enabled on accounts with owner permissions on your subscription",
  ]
}

data "azurerm_policy_definition" "builtin_policies_RBAC_governance" {
  count        = length(var.builtin_policies_RBAC_governance)
  display_name = var.builtin_policies_RBAC_governance[count.index]
}

variable "custom_policies_network_governance" {
  type        = list(map(string))
  description = "List of custom policy definitions for the monitoring network policyset"
  default     = []
}

variable "TagNameAndValueFromSet" {
  type        = list(string)
  description = "List of custom policy definitions for the monitoring network policyset"
  default     = []
}

variable "addTagToRG" {
  type        = list(string)
  description = "List of custom policy definitions for the monitoring network policyset"
  default     = []
}

variable "inheritTagFromRG" {
  type        = list(string)
  description = "List of custom policy definitions for the monitoring network policyset"
  default     = []
}

variable "RequireTagOnResource" {
  type        = list(string)
  description = "List of custom policy definitions for the tag_governance policyset"
  default     = []
}

variable "custom_policies_storage_accounts" {
  type        = list(map(string))
  description = "List of custom policy definitions for the storage policy set"
  default     = []
}

variable "builtin_policies_VM_governance" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the iam_governance policyset"
  default = [
    "Audit VMs that do not use managed disks",
    "Network interfaces should not have public IPs",
    "Managed disks should disable public network access",
    "Dependency agent should be enabled for listed virtual machine images",
    "Dependency agent should be enabled in virtual machine scale sets for listed virtual machine images",
    "Audit Linux machines that have accounts without passwords",
    "Audit Linux machines that allow remote connections from accounts without passwords",
    "Audit Linux machines that do not have the passwd file permissions set to 0644",
    "Audit Windows machines that do not store passwords using reversible encryption",
    "Audit Windows machines that do not have the password complexity setting enabled",
    "Audit Windows machines that do not have a maximum password age of 70 days",
    "Audit Windows machines that do not have a minimum password age of 1 day",
    "Audit Windows machines that do not restrict the minimum password length to 14 characters",
    "Audit Windows machines that allow re-use of the previous 24 passwords",
    "System updates should be installed on your machines",
    "Vulnerabilities in security configuration on your machines should be remediated",
    "Virtual machines should encrypt temp disks, caches, and data flows between Compute and Storage resources",
    "Add system-assigned managed identity to enable Guest Configuration assignments on virtual machines with no identities",
    "Add system-assigned managed identity to enable Guest Configuration assignments on VMs with a user-assigned identity",
    "Deploy the Windows Guest Configuration extension to enable Guest Configuration assignments on Windows VMs",
    "Deploy the Linux Guest Configuration extension to enable Guest Configuration assignments on Linux VMs",
    "Vulnerabilities in security configuration on your virtual machine scale sets should be remediated",
    "Log Analytics agent should be installed on your virtual machine for Azure Security Center monitoring",
    "[Preview]: Log Analytics Extension should be enabled for listed virtual machine images"
  ]
}

data "azurerm_policy_definition" "builtin_policies_VM_governance" {
  count        = length(var.builtin_policies_VM_governance)
  display_name = var.builtin_policies_VM_governance[count.index]
}

variable "builtin_policies_network_governance" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the iam_governance policyset"
  default = [
    "Web Application should only be accessible over HTTPS",
    "Bot Service endpoint should be a valid HTTPS URI",
    "Function App should only be accessible over HTTPS",
    "API App should only be accessible over HTTPS",
    "Kubernetes clusters should be accessible only over HTTPS",
    "All network ports should be restricted on network security groups associated to your virtual machine",
    "Only secure connections to your Azure Cache for Redis should be enabled"
  ]
}

data "azurerm_policy_definition" "builtin_policies_network_governance" {
  count        = length(var.builtin_policies_network_governance)
  display_name = var.builtin_policies_network_governance[count.index]
}

variable "builtin_policies_storage_and_databases" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the storage_account policyset"
  default = [
    "Secure transfer to storage accounts should be enabled",
    "[Preview]: Storage account public access should be disallowed",
    "Storage accounts should use private link",
    "Public network access on Azure SQL Database should be disabled",
    "Azure SQL Database should have the minimal TLS version of 1.2",
    "Private endpoint connections on Azure SQL Database should be enabled",
    "Azure SQL Managed Instance should have Azure Active Directory Only Authentication enabled",
    "Transparent Data Encryption on SQL databases should be enabled",
    "Public network access should be disabled for PostgreSQL flexible servers",
    "Private endpoint should be enabled for MySQL servers",
    "Public network access should be disabled for MySQL flexible servers",
    "Enforce SSL connection should be enabled for PostgreSQL database servers",
    "Enforce SSL connection should be enabled for MySQL database servers",
    "SQL databases should have vulnerability findings resolved",
    "Auditing on SQL server should be enabled",
    "An Azure Active Directory administrator should be provisioned for SQL servers",
    "Storage accounts should restrict network access",
    "Storage accounts should be migrated to new Azure Resource Manager resources"
  ]
}

data "azurerm_policy_definition" "builtin_policies_storage_and_databases" {
  count        = length(var.builtin_policies_storage_and_databases)
  display_name = var.builtin_policies_storage_and_databases[count.index]
}

variable "builtin_policies_data_sovereignty" {
  type        = list(any)
  description = "Allowed locations"
  default = [
    "Allowed locations",
    "Allowed locations for resource groups"
    # Excludes resources with 'Global' location 
  ]
}

data "azurerm_policy_definition" "builtin_policies_data_sovereignty" {
  count        = length(var.builtin_policies_data_sovereignty)
  display_name = var.builtin_policies_data_sovereignty[count.index]
}

variable "builtin_policies_allowed_resources" {
  type        = list(any)
  description = "Allowed Resources"
  default = [
    "Allowed virtual machine size SKUs",
  ]
}

data "azurerm_policy_definition" "builtin_policies_allowed_resources" {
  count        = length(var.builtin_policies_allowed_resources)
  display_name = var.builtin_policies_allowed_resources[count.index]
}

variable "builtin_policies_secrets_management_governance" {
  type        = list(any)
  description = "Allowed Resources"
  default = [
    "Key vaults should have purge protection enabled",
    "Key vaults should have soft delete enabled",
    "[Preview]: Azure Key Vault should disable public network access",
    "[Preview]: Private endpoint should be configured for Key Vault",
    "Resource logs in Key Vault should be enabled"
  ]
}

data "azurerm_policy_definition" "builtin_policies_secrets_management_governance" {
  count        = length(var.builtin_policies_secrets_management_governance)
  display_name = var.builtin_policies_secrets_management_governance[count.index]
}

variable "builtin_policies_development_and_automation" {
  type        = list(any)
  description = "Allowed Resources"
  default = [
    "Remote debugging should be turned off for Function Apps",
    "Remote debugging should be turned off for Web Applications",
    "Remote debugging should be turned off for API Apps",
    "Automation account variables should be encrypted",
    "Private endpoint connections on Automation Accounts should be enabled",
    "Diagnostic logs in App Services should be enabled",
    "Service Fabric clusters should only use Azure Active Directory for client authentication",
    "Service Fabric clusters should have the ClusterProtectionLevel property set to EncryptAndSign"

  ]
}

data "azurerm_policy_definition" "builtin_policies_development_and_automation" {
  count        = length(var.builtin_policies_development_and_automation)
  display_name = var.builtin_policies_development_and_automation[count.index]
}

variable "builtin_policies_logging_governance" {
  type        = list(any)
  description = "List of policy definitions (display names) for the logging_governance policyset"
  default = [
    "Configure diagnostic settings for storage accounts to Log Analytics workspace",
    "Deploy Diagnostic Settings for Service Bus to Log Analytics workspace",
    "Deploy Diagnostic Settings for Search Services to Log Analytics workspace",
    "Deploy Diagnostic Settings for Event Hub to Log Analytics workspace",
    "Deploy Diagnostic Settings for Stream Analytics to Log Analytics workspace",
    "Deploy Diagnostic Settings for Data Lake Storage Gen1 to Log Analytics workspace",
    "Deploy Diagnostic Settings for Logic Apps to Log Analytics workspace",
    "Deploy Diagnostic Settings for Key Vault to Log Analytics workspace",
    "Deploy Diagnostic Settings for Batch Account to Log Analytics workspace",
    "Deploy Diagnostic Settings for Data Lake Analytics to Log Analytics workspace",
    "Deploy - Configure diagnostic settings for Azure Kubernetes Service to Log Analytics workspace",
    #"Virtual machines should be connected to a specified workspace"
  ]
}

data "azurerm_policy_definition" "builtin_policies_logging_governance" {
  count        = length(var.builtin_policies_logging_governance)
  display_name = var.builtin_policies_logging_governance[count.index]
}

variable "builtin_policies_kubernetes_governance" {
  type        = list(any)
  description = "List of built-in policy definitions (display names) for the Kubernetes_initiative policyset"
  default = [
    "Authorized IP ranges should be defined on Kubernetes Services",
    "Azure Kubernetes Service Clusters should have local authentication methods disabled",
    "Azure Kubernetes Service Private Clusters should be enabled",
    "Azure Policy Add-on for Kubernetes service (AKS) should be installed and enabled on your clusters",
    "Deploy Azure Policy Add-on to Azure Kubernetes Service clusters",
    "Kubernetes cluster containers should not share host process ID or host IPC namespace",
    "Kubernetes cluster containers should only use allowed capabilities",
    "Kubernetes cluster containers should run with a read only root file system",
    "Kubernetes cluster pod FlexVolume volumes should only use allowed drivers",
    "Kubernetes cluster pod hostPath volumes should only use allowed host paths",
    "Kubernetes cluster pods and containers should only run with approved user and group IDs",
    "Kubernetes cluster pods should only use allowed volume types",
    "Kubernetes cluster pods should only use approved host network and port range",
    "Kubernetes cluster services should only use allowed external IPs",
    "Kubernetes cluster should not allow privileged containers",
    "Kubernetes clusters should be accessible only over HTTPS",
    "Kubernetes clusters should disable automounting API credentials",
    "Kubernetes clusters should not allow container privilege escalation",
    "Kubernetes clusters should not grant CAP_SYS_ADMIN security capabilities",
    "Kubernetes clusters should not use specific security capabilities",
    "Kubernetes Services should be upgraded to a non-vulnerable Kubernetes version",
    "Role-Based Access Control (RBAC) should be used on Kubernetes Services",
    "Temp disks and cache for agent node pools in Azure Kubernetes Service clusters should be encrypted at host"
  ]
}

data "azurerm_policy_definition" "builtin_policies_kubernetes_governance" {
  count        = length(var.builtin_policies_kubernetes_governance)
  display_name = var.builtin_policies_kubernetes_governance[count.index]
}

variable "builtin_policies_security_governance" {
  type        = list(any)
  description = "List of policy definitions (display names) for the security_governance policyset"
  default = [
    "Internet-facing virtual machines should be protected with network security groups",
    "Subnets should be associated with a Network Security Group",
    "Gateway subnets should not be configured with a network security group",
    "Storage accounts should restrict network access",
    "Secure transfer to storage accounts should be enabled",
    "Storage accounts should allow access from trusted Microsoft services",
    "Automation account variables should be encrypted",
    "Azure subscriptions should have a log profile for Activity Log",
    "Email notification to subscription owner for high severity alerts should be enabled",
    "Subscriptions should have a contact email address for security issues",
    "Enable Azure Security Center on your subscription"
  ]
}

data "azurerm_policy_definition" "builtin_policies_security_governance" {
  count        = length(var.builtin_policies_security_governance)
  display_name = var.builtin_policies_security_governance[count.index]
}
