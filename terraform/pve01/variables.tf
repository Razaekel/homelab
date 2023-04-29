variable "hostname" {
  type        = string
  description = "Hostname, FQDN, or IP for for the proxmox host on which the commands will be executed."
  nullable    = false
  default     = "pve"
}

variable "api_token" {
  type = object({
    id     = string
    secret = string
  })
  sensitive = true
  nullable  = false
}

variable "target_host" {
  type        = string
  description = "Target_host is which node hosts the template and thus also which node will host the new VM. It can be different than the host you use to communicate with the API."
  nullable    = false
  default     = "pve"
}

variable "template_name" {
  type        = string
  description = "Identify the template that will be cloned to create the VMs."
  nullable    = false
  default     = "debian-11-cloudinit-template"
}

variable "ssh_key" {
  type      = string
  nullable  = false
  sensitive = true
}
