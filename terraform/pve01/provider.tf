provider "proxmox" {
  # Hostname (or FQDN) for the proxmox host on which the commands will be executed.
  # Add /api2/json at the end for the API.
  #
  # Required
  #
  pm_api_url = "https://${var.hostname}:8006/api2/json"

  # The user
  # Authentication realm must be included (e.g. user@pam or user@pve)
  #
  # Optional (to be used with pm_password)
  #
  # pm_user = "user"

  # User password
  #
  # Optional (to be used with pm_user)
  #
  # pm_password = "password"

  # API token ID is in the form of <username>@pam!token_id
  #
  # Optional (must use pm_token_id_secret wth this)
  #
  # pm_api_token_id = "terraform@pve!mytoken"
  pm_api_token_id = var.api_token.id

  # Full token ID Secret
  #
  # Optional (must be used with pm_api_token_id)
  #
  # pm_api_token_secret = "afcd8f45-acc1-4d0f-bb12-a70b0777ec11" # Secret shown as example only
  pm_api_token_secret = var.api_token.secret

  # 2FA OTP code
  #
  # Optional
  #
  # pm_otp = ""

  # Disable TLS verification while connecting to the proxmox host server
  # Leave tls_insecure set to true unless you have your proxmox SSL certificate situation fully sorted out (if you do, you will know)
  #
  # Optional (default = false)
  #
  pm_tls_insecure = true

  # Allow simultaneous Proxmox processes (e.g. creating resources)
  #
  # Optional (default = 4)
  #
  # pm_parallel = 4

  # Enable debug logging
  #
  # Optional (default = false)
  #
  # pm_log_enable = true
}