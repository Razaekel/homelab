# resource is formatted to be "[type]" "[entity_name]" so in this case we are looking to create a proxmox_vm_qemu entity named test_server
# Options for [type]: proxmox_lxc, proxmox_vm_qemu
resource "proxmox_vm_qemu" "test_server" {
  # number of VMs to create. Set to 0 and 'terraform apply' to destroy VMs.
  count = 1 # just want 1 for now

  # count.index starts at 0, so + 1 means this VM will be named test-vm-1 in proxmox
  #
  # Required
  #
  name = "test-vm-${count.index + 1}"

  # this now reaches out to the vars file. I could've also used this var above in the pm_api_url setting but wanted to spell it out up there. target_node is different than api_url.

  # Describes the VM
  # desc = var.description

  # Target_node is which node hosts the template and thus also which node will host the new VM.
  # It can be different than the host you use to communicate with the API.
  # The variable contains the contents "prox-1u".
  #
  # Required
  #
  target_node = var.target_host

  # Identify the template that will be cloned to create the VMs.
  # clone = "debian-11-cloudinit-template"
  clone = var.template_name

  # Basic VM settings here.

  # agent refers to qemu-guest-agent.
  agent    = 1
  os_type  = "cloud-init"
  qemu_os  = "other"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 1024
  scsihw   = "virtio-scsi-single"
  bootdisk = "scsi0"

  vga {
    type = "serial0"
  }

  # if you want two NICs, just copy this whole network section and duplicate it
  # The first instance will become 'net0', the second will be 'net1', and so on
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    slot = 0
    # set disk size here. leave it small for testing because expanding the disk takes time.
    size     = "10G"
    type     = "scsi"
    storage  = "local-zfs"
    iothread = 1
  }

  # not sure exactly what this is for. presumably something about MAC addresses and ignore network changes during the life of the VM
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # the ${count.index + 1} thing appends text to the end of the ip address 
  # in this case, since we are only adding a single VM, the IP will be 10.98.1.91 since count.index starts at 0. this is how you can create multiple VMs and have an IP assigned to each (.91, .92, .93, etc.)
  ipconfig0 = "ip=192.168.0.${count.index + 50}/24,gw=192.168.0.1"

  # sshkeys set using variables. the variable contains the text of the key.
  sshkeys = var.ssh_key
}

# resource "proxmox_vm_qemu" "pbs" {
#   name = "pbs"

#   target_node = var.target_host

#   # iso = "proxmox-backup-server_2.2-1.iso"

#   # vmid = 100

#   bios = "seabios"

#   onboot   = true
#   oncreate = false
#   startup  = "order=any"

#   boot = "order=scsi0"

#   agent   = 1
#   os_type = "ubuntu"
#   qemu_os = "l26"
#   cores   = 2
#   sockets = 1
#   cpu     = "host"
#   memory  = 2048
#   scsihw  = "virtio-scsi-single"
#   # bootdisk = "scsi0"

#   full_clone             = false
#   define_connection_info = false

#   vga {
#     type = "default"
#   }

#   network {
#     model    = "virtio"
#     bridge   = "vmbr0"
#     firewall = true
#   }

#   disk {
#     slot     = 0
#     size     = "32G"
#     type     = "scsi"
#     storage  = "local-zfs"
#     iothread = 1
#     ssd      = 1
#   }

#   lifecycle {
#     ignore_changes = [
#       network,
#     ]
#   }

#   ipconfig0 = "ip=192.168.0.70/24,gw=192.168.0.1"
# }
