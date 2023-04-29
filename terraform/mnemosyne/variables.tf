variable "hostname" {
  type        = string
  description = "Hostname, FQDN, or IP for the host"
  nullable    = false
}

variable "api_key" {
  type        = string
  description = " API key as defined in TrueNAS"
  nullable    = false
  sensitive   = true
}
