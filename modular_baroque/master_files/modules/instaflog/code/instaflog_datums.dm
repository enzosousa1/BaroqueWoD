/datum/instaflog_account
	var/username = ""
	var/display_name = ""
	var/bio = ""
	var/city = ""
	var/profile_photo_url = ""
	var/profile_photo_usable = TRUE

/datum/instaflog_account/proc/serialize()
	return list(
		"username" = username,
		"display_name" = display_name,
		"bio" = bio,
		"city" = city,
		"profile_photo_url" = profile_photo_url,
		"profile_photo_usable" = profile_photo_usable,
	)

/datum/instaflog_comment
	var/body = ""
	var/username = ""
	var/display_name = ""
	var/date = ""
	var/time = ""

/datum/instaflog_comment/proc/serialize()
	return list(
		"body" = body,
		"username" = username,
		"display_name" = display_name,
		"date" = date,
		"time" = time,
	)

/datum/instaflog_post
	var/post_id = 0
	var/body = ""
	var/date = ""
	var/time = ""
	var/timestamp = 0
	var/author_real_name = ""
	var/author_unique_identity = ""
	var/username = ""
	var/display_name = ""
	var/profile_photo_url = ""
	var/profile_photo_usable = TRUE
	var/city = ""
	var/image_base64 = ""
	var/list/liked_by = list()
	var/list/datum/instaflog_comment/comments = list()

/datum/instaflog_post/Destroy(force)
	for(var/datum/instaflog_comment/comment as anything in comments)
		qdel(comment)
	comments.Cut()
	return ..()

/datum/instaflog_post/proc/import_account(datum/instaflog_account/account)
	if(!account)
		return
	username = account.username
	display_name = account.display_name
	profile_photo_url = account.profile_photo_url
	profile_photo_usable = account.profile_photo_usable
	city = account.city

/datum/instaflog_post/proc/import_author(author_name, author_display = null, photo_url = null, author_city = null, photo_usable = TRUE)
	username = author_name
	display_name = author_display || author_name
	profile_photo_url = photo_url
	profile_photo_usable = photo_usable
	city = author_city

/datum/instaflog_post/proc/liked_by_user(datum/instaflog_account/account)
	return account && (account.username in liked_by)

/datum/instaflog_post/proc/set_author(mob/living/author)
	if(!author)
		return
	author_real_name = author.real_name
	author_unique_identity = instaflog_get_character_identity(author) || ""

/datum/instaflog_post/proc/is_author(mob/living/viewer)
	if(!viewer || !isliving(viewer))
		return FALSE
	var/viewer_identity = instaflog_get_character_identity(viewer)
	if(length(author_unique_identity))
		return length(viewer_identity) \
			&& viewer_identity == author_unique_identity \
			&& viewer.real_name == author_real_name
	if(!length(author_real_name))
		return FALSE
	return viewer.real_name == author_real_name

/datum/instaflog_post/proc/can_delete(mob/living/viewer)
	if(!viewer || !isliving(viewer))
		return FALSE
	if(viewer.client && is_admin(viewer.client))
		return TRUE
	return is_author(viewer)

/datum/instaflog_post/proc/serialize(datum/instaflog_account/viewer = null, mob/living/viewer_mob = null)
	var/list/serialized_comments = list()
	for(var/datum/instaflog_comment/comment as anything in comments)
		if(!comment)
			continue
		serialized_comments += list(comment.serialize())
	return list(
		"post_id" = post_id,
		"body" = body,
		"date" = date,
		"time" = time,
		"timestamp" = timestamp,
		"username" = username,
		"display_name" = display_name,
		"profile_photo_url" = profile_photo_url,
		"profile_photo_usable" = profile_photo_usable,
		"city" = city,
		"image" = image_base64,
		"like_count" = length(liked_by),
		"liked_by_me" = liked_by_user(viewer),
		"can_delete" = can_delete(viewer_mob),
		"comments" = serialized_comments,
	)