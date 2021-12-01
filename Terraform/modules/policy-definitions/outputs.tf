output "auditRoleAssignmentType_user_policy_id" {
  value       = azurerm_policy_definition.auditRoleAssignmentType_user.id
  description = "The policy definition id for auditRoleAssignmentType_user"
}



output "DenyAllOutBoundNSG_policy_ID" {
  value       = azurerm_policy_definition.DenyAllOutBoundNSG.id
  description = "The policy definition id for DenyAllOutBoundNSG_policy_ID"
}

output "FileandBlobEncryptionNotSet_policy_ID" {
  value       = azurerm_policy_definition.FileandBlobEncryptionNotSet.id
  description = "The policy defintion ID for the FileandBlobEncryptionNotSet_policy_ID"
}

###

# Tagging outputs - All output a list of strings 

### 

output "RequireTagNameAndValueFromSet_policy_ID" {
  value       = [for k, v in azurerm_policy_definition.RequireTagNameAndValueFromSet : v.id]
  description = "List of strings of the policy definition IDs for RequireTagNameAndValueFromSet_policy_ID"
}

output "addTagToRG_policy_ids" {
  value       = [for k, v in azurerm_policy_definition.addTagToRG : v.id]
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = [for k, v in azurerm_policy_definition.inheritTagFromRG : v.id]
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "RequireTagOnResourcePolicyIDs" {
  value       = [for k, v in azurerm_policy_definition.RequireTagOnResources : v.id]
  description = "The policy definition ids for RequireTagOnResources policies"
}

