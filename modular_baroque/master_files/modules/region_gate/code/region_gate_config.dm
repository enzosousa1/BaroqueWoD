/datum/config_entry/flag/region_gate_enabled
	default = FALSE

/datum/config_entry/flag/region_gate_reject_unknown
	default = TRUE

/datum/config_entry/flag/region_gate_admin_bypass
	default = TRUE

/datum/config_entry/number/region_gate_rate_minute
	default = 40
	min_val = 0

/datum/config_entry/number/region_gate_http_timeout
	default = 5
	min_val = 1

/datum/config_entry/string/region_gate_api_base
	default = "http://ip-api.com/json"