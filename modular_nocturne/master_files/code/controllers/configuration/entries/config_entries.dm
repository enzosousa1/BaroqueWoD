/// Config entry for enabling flavortext min character count, good to disable for debugging purposes
// DISABLE THIS instead of setting flavor_text_character_requirement to 0 or I'll chop your arms off
/datum/config_entry/flag/min_flavor_text
	default = FALSE

/// Config entry for enabling flavortext min character count, good to disable for debugging purposes
// NEVER set this value to 0!!
/datum/config_entry/number/flavor_text_character_requirement
	default = 150


/// Defines whether or not the whitelist (if configured using USEWHITELIST) uses the SQL system.
/datum/config_entry/flag/sql_whitelist
	protection = CONFIG_ENTRY_LOCKED

/// Message that gets displayed to non-whitelisted players when they try to join the server
/// while it has an active whitelist. The \n allows the message to be displayed on a separate line,
/// to make it more readable in the BYOND window.
/datum/config_entry/string/missing_whitelist_message
	default = "\nReason: You are not on the white list for this server"

/datum/config_entry/string/servertagline
	config_entry_value = "We forgot to set the server's tagline in config.txt"

/datum/config_entry/string/discord_link
	config_entry_value = "We forgot to set the server's discord link in config.txt"
