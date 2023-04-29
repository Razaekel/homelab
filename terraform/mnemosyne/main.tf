locals {
  system_pool  = "main"
  TiB_in_bytes = 1024 * 1024 * 1024 * 1024
}

resource "truenas_dataset" "backups" {
  # Required Items
  # ---------------

  # Name of the dataset
  # Must be unique. Cannot be changed after the dataset is created.
  name = "backups"

  # Name of the Pool that the dataset is to be stored on.
  # (e.g. System Dataset Pool)
  #
  # pool = "Tank"
  pool = local.system_pool

  # ---------------
  # Optional Items
  # ---------------

  # Parent dataset for this dataset (if nested)
  parent = ""

  # Notes about the dataset
  #comments = ""

  # Sync
  #
  # Set how data writes should be synchronized
  #
  # Options:
  # "inherit" - Inherit settings from the parent dataset.
  # "standard" - uses settings requested by the client software.
  # "always" - always waits for writes to complete.
  # "disabled" - never waits for writes to complete.
  #
  # Default = "standard"
  #sync = "standard"

  # Compression level for the dataset
  # See https://www.truenas.com/docs/scale/scaletutorials/storage/datasets/datasetsscale/#setting-dataset-compression-levels for a partial list of options
  #
  # Default = "inherit"
  #compression = "lz4"

  # Enable Atime
  # 
  # Options:
  # "inherit" - Inherit settings from the parent dataset.
  # "on" - Update access times for files when they are read.
  # "off" - Prevent producing log traffic when files are read. Can result in significant performance gains.
  #
  # Default = "inherit"
  atime = "off"

  # Quota for this dataset
  #
  # Specify a maximum allowed space for this dataset. 0 to disable.
  #
  # Default = 0
  ref_quota_bytes = 0

  # Quota warning alert, at %
  #
  # Quota warning % for this dataset
  # 
  # Default = 80
  #ref_quota_warning = "80"

  # Quota critical alert, at %
  #
  # Quota critical % for this dataset
  # 
  # Default = 95
  #ref_quota_warning = "95"

  # Quota for this dataset and all children
  #
  # Define a maximum size for both this dataset and all children. 0 to disable.
  #
  # Default = 0
  quota_bytes = 10 * local.TiB_in_bytes

  # Quota warning alert, at %
  #
  # Quota warning % for this dataset
  # 
  # Default = 80
  #quota_warning = "80"

  # Quota critical alert, at %
  #
  # Quota critical % for this dataset
  # 
  # Default = 95
  #quota_warning = "95"

  # ZFS Deduplication
  #
  #Transparently reuse a single copy of duplicated data to save space. Deduplication can improve storage capacity, but is RAM intensive. Compressing data is generally recommended before using deduplication. Deduplicating data is a one-way process. Deduplicated data cannot be undeduplicated!.
  #
  # Options:
  # "inherit" - Inherit setting from the parent dataset.
  # "on"
  # "verify"
  # "off"
  #
  # Default = "inherit"
  #deduplication = "inherit"

  # Read Only
  #
  # Options:
  # "inherit" - Inherit setting from the parent dataset.
  # "on" - Prevent the dataset from being modified.
  # "off"
  #
  # Default = "inherit"
  #readonly = "inherit"

  # Exec
  #exec = ""

  # Snapshot Directory
  #snap_dir

  # Copies
  #copies = 1

  # Record Size
  #record_size = ""

  # ACL Type

  # ACL Mode
  #
  # Determine how chmod behaves when adjusting ACLs.
  #
  # Options:
  # "inherit" - Inherit setting from the parent dataset.
  # "passthrough" - Only update ACLs that are related to the file or directory mode.
  # "restricted" - Do not allow chmod to make changes to files or directories with a non-trivial ACL. An ACL is trivial if it can be fully expressed as a file mode without losing any access rules. Setting the ACL Mode to Restricted is typically used to optimize a dataset for SMB sharing, but can require further optimizations. For example, configuring an rsync task with this dataset could require adding --no-perms in the task Auxiliary Parameters field.
  # "discard" - 
  #
  # Default = "inherit"
  acl_mode = "restricted"

  # Case Sensitivity
  #case_sensitivity = ""

  # Metadata (Special) Small Block Size
}

resource "truenas_dataset" "pbs" {
  name = "pbs"
  pool = local.system_pool

  parent = truenas_dataset.backups.name
}

resource "truenas_share_nfs" "nfs_share_pbs" {
  paths   = ["${truenas_dataset.backups.mount_point}/pbs"]
  comment = "Proxmox Backup Server Storage"

  mapall_user = "root"
}

resource "truenas_dataset" "pve" {
  name = "pve"
  pool = local.system_pool

  parent = truenas_dataset.backups.name
}

resource "truenas_share_nfs" "nfs_share_pve" {
  paths   = ["${truenas_dataset.backups.mount_point}/pve"]
  comment = "Proxmox VE Backup Storage"

  mapall_user = "root"
}

resource "truenas_dataset" "veeam" {
  name = "veeam"
  pool = local.system_pool

  parent = truenas_dataset.backups.name
}

resource "truenas_dataset" "nick" {
  name = "nick"
  pool = local.system_pool

  quota_bytes = 10 * local.TiB_in_bytes
}

resource "truenas_share_smb" "smb_share_nick" {
  path = truenas_dataset.nick.mount_point

  name = "nick"

  acl           = true
  auxsmbconf    = "case sensitive=yes\npreserve case=yes\nshort preserve case=yes"
  browsable     = true
  durablehandle = true
  enabled       = true
  purpose       = "DEFAULT_SHARE"
  shadowcopy    = true
  streams       = true
}

resource "truenas_dataset" "users" {
  name = "users"
  pool = local.system_pool

  quota_bytes = 1 * local.TiB_in_bytes
}

resource "truenas_dataset" "media" {
  name = "media"
  pool = local.system_pool
}

resource "truenas_share_smb" "smb_share_media" {
  path = truenas_dataset.media.mount_point

  name = "media"

  #acl           = false
  auxsmbconf    = "case sensitive=yes\npreserve case=yes\nshort preserve case=yes"
  browsable     = false
  durablehandle = false
  enabled       = true
  purpose       = "NO_PRESET"
  shadowcopy    = true
  streams       = false
}
