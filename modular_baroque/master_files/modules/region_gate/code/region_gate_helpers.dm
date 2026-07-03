/// ISO 3166-1 alpha-2 codes for Spanish-speaking countries.
GLOBAL_LIST_INIT(region_gate_spanish_country_codes, list(
	"AR", // Argentina
	"BO", // Bolivia
	"CL", // Chile
	"CO", // Colombia
	"CR", // Costa Rica
	"CU", // Cuba
	"DO", // Dominican Republic
	"EC", // Ecuador
	"SV", // El Salvador
	"GQ", // Equatorial Guinea
	"GT", // Guatemala
	"HN", // Honduras
	"MX", // Mexico
	"NI", // Nicaragua
	"PA", // Panama
	"PY", // Paraguay
	"PE", // Peru
	"PR", // Puerto Rico
	"ES", // Spain
	"UY", // Uruguay
	"VE", // Venezuela
))

/// ISO 3166-1 alpha-2 codes for Portuguese-speaking countries.
GLOBAL_LIST_INIT(region_gate_portuguese_country_codes, list(
	"BR", // Brazil
	"PT", // Portugal
	"AO", // Angola
	"MZ", // Mozambique
	"CV", // Cape Verde
	"GW", // Guinea-Bissau
	"ST", // Sao Tome and Principe
	"TL", // East Timor
))

/**
 * Returns whether a country code belongs to an allowed Spanish- or Portuguese-speaking region.
 *
 * Arguments:
 * * country_code - Two-letter ISO country code. Case-insensitive.
 */
/proc/region_gate_is_country_allowed(country_code)
	if(!country_code)
		return FALSE
	country_code = uppertext(country_code)
	return (country_code in GLOB.region_gate_spanish_country_codes) || (country_code in GLOB.region_gate_portuguese_country_codes)

/**
 * Returns whether a client should bypass the region gate check.
 *
 * Arguments:
 * * player - The connecting client.
 */
/proc/region_gate_is_exempt(client/player)
	if(!player)
		return TRUE
	if(player.is_localhost())
		return TRUE
	if(!CONFIG_GET(flag/region_gate_enabled))
		return TRUE
	if(CONFIG_GET(flag/region_gate_admin_bypass) && (GLOB.admin_datums[player.ckey] || GLOB.deadmins[player.ckey] || player.holder))
		return TRUE
	if(SSregion_gate.is_whitelisted(player.ckey))
		return TRUE
	return FALSE