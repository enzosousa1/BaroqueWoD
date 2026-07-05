/**
 * Persistent InstaFlog account storage (followers, profiles, password hashes).
 * Round-local posts remain on SSphones.instaflog_posts.
 */
SUBSYSTEM_DEF(instaflog)
	name = "InstaFlog"
	dependencies = list(/datum/controller/subsystem/phones)
	ss_flags = SS_NO_FIRE

	var/datum/json_database/account_database

/datum/controller/subsystem/instaflog/Initialize()
	account_database = new(INSTAFLOG_DB_PATH)
	load_all_profiles()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/instaflog/proc/load_all_profiles()
	var/list/accounts = account_database.get()
	for(var/username in accounts)
		var/list/record = accounts[username]
		if(!islist(record) || !length(record["password_hash"]))
			continue
		SSphones.instaflog_profiles[sanitize_instaflog_username(username)] = sanitize_instaflog_profile_record(record)

/datum/controller/subsystem/instaflog/proc/get_account_record(username)
	username = sanitize_instaflog_username(username)
	if(!username)
		return null
	return account_database.get_key(username)

/datum/controller/subsystem/instaflog/proc/account_exists(username)
	return !!get_account_record(username)

/datum/controller/subsystem/instaflog/proc/save_profile(username)
	username = sanitize_instaflog_username(username)
	if(!username)
		return
	var/list/profile = SSphones.instaflog_profiles[username]
	if(!profile || !length(profile["password_hash"]))
		return
	account_database.set_key(username, profile)

/datum/controller/subsystem/instaflog/proc/create_account_record(list/profile_data)
	var/username = sanitize_instaflog_username(profile_data["username"])
	if(!username || account_exists(username))
		return FALSE
	profile_data["username"] = username
	SSphones.instaflog_profiles[username] = sanitize_instaflog_profile_record(profile_data)
	save_profile(username)
	return TRUE

/datum/controller/subsystem/instaflog/proc/load_account_datum(username)
	username = sanitize_instaflog_username(username)
	var/list/record = SSphones.instaflog_profiles[username]
	if(!record)
		return null
	var/datum/instaflog_account/account = new()
	account.username = record["username"]
	account.display_name = record["display_name"]
	account.bio = record["bio"]
	account.city = record["city"]
	account.profile_photo_url = record["profile_photo_url"]
	account.profile_photo_usable = record["profile_photo_usable"]
	return account

/proc/sanitize_instaflog_profile_record(list/record)
	var/username = sanitize_instaflog_username(record["username"])
	var/list/safe = list(
		"username" = username,
		"display_name" = record["display_name"] || username,
		"bio" = record["bio"] || "",
		"city" = record["city"] || "",
		"profile_photo_url" = record["profile_photo_url"] || "",
		"profile_photo_usable" = record["profile_photo_usable"] || TRUE,
		"password_hash" = record["password_hash"] || "",
		"password_salt" = record["password_salt"] || "",
		"owner_ckey" = record["owner_ckey"] || "",
		"created_round" = record["created_round"] || 0,
	)
	safe["followers"] = list()
	var/list/followers = record["followers"]
	if(islist(followers))
		for(var/follower in followers)
			var/sanitized_follower = sanitize_instaflog_username(follower)
			if(sanitized_follower && !(sanitized_follower in safe["followers"]))
				safe["followers"] += sanitized_follower
	safe["following"] = list()
	var/list/following = record["following"]
	if(islist(following))
		for(var/followed in following)
			var/sanitized_followed = sanitize_instaflog_username(followed)
			if(sanitized_followed && !(sanitized_followed in safe["following"]))
				safe["following"] += sanitized_followed
	return safe

/proc/instaflog_strip_sensitive_profile_data(list/profile)
	var/list/safe = profile.Copy()
	safe -= list("password_hash", "password_salt")
	return safe
