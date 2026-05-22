#######################################
# PURPOSE:
# This Template will create:
# 1. Set Number of Linux, Windows, and Windows Appliances for VMware to Azure Site Recovery
# 2. Storage Account, Resource Group, and Recovery Service Vault

#######################################
# NOTES:
#
# See Packer Images for how the Linux Images work
# - Ubuntu 2204 / 2404 Tested
# - Root / Ubuntu users are enabled but need to have password set on 1st login
# - Hostname will need to be set on image
#
# The Customization Block for Linux VMs sometimes does work, as a result it's commented out
