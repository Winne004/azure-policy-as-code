#################################################################################
# Sets GitLab managed Terraform State
# GitLab uses the Terraform HTTP backend to securely store the state files in 
# local storage (the default) 
#################################################################################

terraform {
  backend "http" {
  }
}

provider "azurerm" {
  features {}
}

#################################################################################
# Call module to define policies
# This must be done before they can be grouped into a policy set 
#################################################################################
module "policy_definitions" {
  source = "./modules/policy-definitions"

}

#################################################################################
# Call module to define policy_sets (initiatives)
# This must be done before they can be assigned
#################################################################################
module "policy_initiatives" {
  source = "./modules/policy-initiatives"

  TagNameAndValueFromSet = module.policy_definitions.RequireTagNameAndValueFromSet_policy_ID # Already a list of strings
  addTagToRG             = module.policy_definitions.addTagToRG_policy_ids                   # Already a list of strings
  inheritTagFromRG       = module.policy_definitions.inheritTagFromRG_policy_ids             # Already a list of strings
  RequireTagOnResource   = module.policy_definitions.RequireTagOnResourcePolicyIDs

  custom_policies_RBAC_governance = [
    {
      policyID = module.policy_definitions.auditRoleAssignmentType_user_policy_id
    }
  ]

  custom_policies_storage_accounts = [
    {
      policyID = module.policy_definitions.FileandBlobEncryptionNotSet_policy_ID
    },
  ]
}
#################################################################################
# Placeholder for network governance custom policies
# This must be done before they can be assigned
#################################################################################
/*   custom_policies_network_governance = [
    {
      policyID = module.policy_definitions.DenyAllOutBoundNSG_policy_ID
    },
  ] 
  
# Above won't work with Azure Network traffic  */
