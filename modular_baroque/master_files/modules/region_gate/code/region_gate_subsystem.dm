SUBSYSTEM_DEF(region_gate)
	name = "Region Gate"
	ss_flags = SS_NO_INIT|SS_NO_FIRE

	var/list/whitelisted_ckeys = list()
	var/list/cached_queries = list()
	var/rate_limit_minute = 0

/datum/controller/subsystem/region_gate/proc/is_enabled()
	return CONFIG_GET(flag/region_gate_enabled)

/datum/controller/subsystem/region_gate/proc/is_whitelisted(ckey)
	return whitelisted_ckeys[ckey(ckey)]

/datum/controller/subsystem/region_gate/proc/is_rate_limited()
	var/static/minute_key
	var/expected_minute_key = floor(REALTIMEOFDAY / 1 MINUTES)

	if(minute_key != expected_minute_key)
		minute_key = expected_minute_key
		rate_limit_minute = 0

	if(rate_limit_minute >= CONFIG_GET(number/region_gate_rate_minute))
		return TRUE
	return FALSE

/**
 * Resolves the ISO country code for an IP address.
 *
 * Returns a status string on failure, or the two-letter country code on success.
 *
 * Arguments:
 * * address - IPv4/IPv6 address string.
 */
/datum/controller/subsystem/region_gate/proc/query_country_code(address)
	if(!length(address))
		return REGION_GATE_QUERY_ERROR

	var/cached = cached_queries[address]
	if(cached)
		return cached

	if(is_rate_limited())
		return REGION_GATE_QUERY_RATE_LIMITED

	rate_limit_minute += 1

	var/api_base = CONFIG_GET(string/region_gate_api_base)
	var/url = "[api_base]/[address]?fields=status,country,countryCode"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, url, timeout_seconds = CONFIG_GET(number/region_gate_http_timeout))
	request.execute_blocking()
	var/datum/http_response/response = request.into_response()

	if(response.errored || response.status_code != 200)
		cached_queries[address] = REGION_GATE_QUERY_ERROR
		return REGION_GATE_QUERY_ERROR

	var/list/data
	try
		data = json_decode(response.body)
	catch
		cached_queries[address] = REGION_GATE_QUERY_ERROR
		return REGION_GATE_QUERY_ERROR

	if(!length(data) || data["status"] != "success" || !data["countryCode"])
		cached_queries[address] = REGION_GATE_QUERY_ERROR
		return REGION_GATE_QUERY_ERROR

	var/country_code = uppertext(data["countryCode"])
	cached_queries[address] = country_code
	return country_code

/**
 * Evaluates whether a client connection should be rejected by the region gate.
 *
 * Returns TRUE when the connection must be rejected.
 *
 * Arguments:
 * * player - The connecting client.
 */
/datum/controller/subsystem/region_gate/proc/should_reject_connection(client/player)
	if(region_gate_is_exempt(player))
		return FALSE

	var/country_result = query_country_code(player.address)
	var/reject_unknown = CONFIG_GET(flag/region_gate_reject_unknown)

	if(country_result == REGION_GATE_QUERY_RATE_LIMITED)
		log_access("REGION_GATE: [player.ckey] could not be checked due to rate limiting.")
		if(reject_unknown)
			return TRUE
		message_admins("REGION_GATE: [key_name_admin(player)] could not be checked due to rate limiting.")
		return FALSE

	if(country_result == REGION_GATE_QUERY_ERROR)
		log_access("REGION_GATE: [player.ckey] could not be geolocated ([player.address]).")
		if(reject_unknown)
			return TRUE
		message_admins("REGION_GATE: [key_name_admin(player)] could not be geolocated ([player.address]).")
		return FALSE

	if(region_gate_is_country_allowed(country_result))
		return FALSE

	log_access("REGION_GATE: [player.ckey] blocked from [country_result] ([player.address]).")
	message_admins("REGION_GATE: [key_name_admin(player)] was blocked from [country_result] ([player.address]).")
	return TRUE