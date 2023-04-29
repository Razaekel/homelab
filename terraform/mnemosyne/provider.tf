provider "truenas" {
	# Hostname (or FQDN) for the truenas host on which the commands will be executed.
	# Add "/api/v2.0" for the API.
	#
	# Required
	base_url = "http://${var.hostname}/api/v2.0"

	# API key
	#
	# Required
	api_key = var.api_key
}