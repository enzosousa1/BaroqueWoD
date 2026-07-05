/obj/item/smartphone
	var/datum/instaflog_account/instaflog_account
	/// Body identity that owns the InstaFlog session on this phone.
	var/instaflog_bound_identity = ""
	var/instaflog_posts_this_round = 0
	COOLDOWN_DECLARE(instaflog_post_cooldown)
	COOLDOWN_DECLARE(instaflog_comment_cooldown)
	COOLDOWN_DECLARE(instaflog_like_cooldown)

/obj/item/smartphone/proc/instaflog_resolve_user(mob/user)
	return isliving(user) ? user : null

/obj/item/smartphone/proc/instaflog_bind_session(mob/living/user)
	var/identity = instaflog_get_character_identity(user)
	if(!identity)
		to_chat(user, span_warning("Apenas personagens humanos podem usar o InstaFlog."))
		return FALSE
	instaflog_bound_identity = identity
	return TRUE

/obj/item/smartphone/proc/instaflog_session_belongs_to(mob/living/user)
	if(!instaflog_account || !length(instaflog_bound_identity))
		return FALSE
	var/identity = instaflog_get_character_identity(user)
	return identity && identity == instaflog_bound_identity

/obj/item/smartphone/proc/instaflog_require_session(mob/living/user, silent = FALSE)
	if(instaflog_session_belongs_to(user))
		return TRUE
	if(!silent)
		to_chat(user, span_warning("Este telefone não está logado no InstaFlog com o seu personagem."))
	return FALSE

/proc/sanitize_instaflog_username(username)
	if(isnull(username))
		return null
	username = LOWER_TEXT(trim("[username]"))
	if(!length(username))
		return null
	username = replacetext(username, " ", "_")
	var/static/regex/invalid_instaflog_username_chars = regex(@"[^a-z0-9_]", "g")
	username = invalid_instaflog_username_chars.Replace(username, "")
	if(!length(username))
		return null
	return copytext_char(username, 1, INSTAFLOG_MAX_USERNAME + 1)

/proc/validate_instaflog_profile_url(url)
	if(!istext(url) || !length(trim(url)))
		return list("valid" = TRUE, "url" = "", "usable" = TRUE)
	url = trim(url)
	if(!findtext(url, GLOB.is_http_protocol))
		return list("valid" = FALSE, "url" = url, "usable" = FALSE)
	return list("valid" = TRUE, "url" = copytext_char(url, 1, INSTAFLOG_MAX_PROFILE_URL + 1), "usable" = TRUE)

/proc/instaflog_announce(body, author = "SF Chronicle Nightly", profile_photo_url = null)
	var/datum/instaflog_post/post = new()
	post.post_id = SSphones.instaflog_next_post_id++
	post.body = trim(body)
	post.date = server_timestamp("Day, Month DD, YYYY", ic_time = TRUE)
	post.time = server_timestamp("hh:mm", ic_time = TRUE)
	post.timestamp = world.time
	post.import_author(author, photo_url = profile_photo_url)
	SSphones.instaflog_posts += post

/datum/controller/subsystem/phones/proc/sync_instaflog_profile(datum/instaflog_account/account, ckey = null)
	if(!account?.username)
		return
	var/list/profile_data = account.serialize()
	if(ckey)
		profile_data["owner_ckey"] = ckey
	instaflog_profiles[account.username] = profile_data

/datum/controller/subsystem/phones/proc/format_instaflog_profiles()
	var/list/formatted = list()
	for(var/username in instaflog_profiles)
		var/list/profile = instaflog_profiles[username]
		if(!profile)
			continue
		var/post_count = 0
		for(var/datum/instaflog_post/post as anything in instaflog_posts)
			if(post?.username == username)
				post_count++
		formatted[username] = profile | list("post_count" = post_count)
	return formatted

/datum/controller/subsystem/phones/proc/format_instaflog_posts(datum/instaflog_account/viewer = null, mob/living/viewer_mob = null)
	var/list/formatted = list()
	var/post_count = length(instaflog_posts)
	var/start_index = max(1, post_count - INSTAFLOG_MAX_UI_POSTS + 1)
	for(var/i in start_index to post_count)
		var/datum/instaflog_post/post = instaflog_posts[i]
		if(!post)
			continue
		if(!post.post_id)
			post.post_id = instaflog_next_post_id++
		if(!post.timestamp)
			post.timestamp = i
		formatted += list(post.serialize(viewer, viewer_mob))
	return formatted

/datum/controller/subsystem/phones/proc/find_instaflog_post(post_id)
	if(!post_id)
		return null
	for(var/datum/instaflog_post/post as anything in instaflog_posts)
		if(post?.post_id == post_id)
			return post
	return null

/obj/item/smartphone/proc/get_instaflog_gallery_photo(photo_id)
	if(!photo_id || photo_id < 1 || photo_id > length(gallery_photos))
		return null
	return gallery_photos[photo_id]

/obj/item/smartphone/proc/get_instaflog_gallery_photo_base64(photo_id)
	var/datum/phone_gallery_photo/entry = get_instaflog_gallery_photo(photo_id)
	var/datum/picture/picture = entry?.picture
	if(!picture?.picture_image)
		return null
	return icon2base64(picture.picture_image)

/obj/item/smartphone/proc/get_instaflog_ui_data(mob/living/user)
	var/list/data = list()
	var/session_active = instaflog_session_belongs_to(user)
	data["instaflog_registered"] = session_active
	data["instaflog_account"] = session_active ? instaflog_account?.serialize() : null
	data["instaflog_posts"] = SSphones.format_instaflog_posts(session_active ? instaflog_account : null, user)
	data["instaflog_profiles"] = SSphones.format_instaflog_profiles()
	data["show_instaflog_registration"] = !session_active || user.st_get_stat(STAT_TECHNOLOGY) >= 3
	return data

/obj/item/smartphone/proc/create_instaflog_account(list/params, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!user)
		return FALSE

	var/username = sanitize_instaflog_username(params["username"])
	if(!username)
		to_chat(user, span_warning("Nome de usuário inválido. Use apenas letras, números e sublinhados."))
		return FALSE

	var/display_name = sanitize_instaflog_text(params["display_name"], INSTAFLOG_MAX_DISPLAY_NAME)
	if(!validate_instaflog_text(display_name, user, "nome de exibição"))
		return FALSE

	var/bio = sanitize_instaflog_text(params["bio"], INSTAFLOG_MAX_BIO)
	if(length(bio) && !validate_instaflog_text(bio, user, "biografia"))
		return FALSE

	var/city = sanitize_instaflog_text(params["city"], INSTAFLOG_MAX_CITY)
	if(length(city) && !validate_instaflog_text(city, user, "cidade"))
		return FALSE

	var/list/url_validation = validate_instaflog_profile_url(params["profile_photo_url"])
	if(!url_validation["valid"])
		to_chat(user, span_warning("Foto de perfil inválida. Use apenas links http:// ou https://."))
		return FALSE

	var/list/existing_profile = SSphones.instaflog_profiles[username]
	if(existing_profile)
		var/existing_owner = existing_profile["owner_ckey"]
		if(existing_owner && existing_owner != user.ckey)
			to_chat(user, span_warning("Este nome de usuário já está em uso."))
			return FALSE

	if(!instaflog_account)
		instaflog_account = new()
	instaflog_account.username = username
	instaflog_account.display_name = display_name
	instaflog_account.bio = bio
	instaflog_account.city = city
	instaflog_account.profile_photo_url = url_validation["url"]
	instaflog_account.profile_photo_usable = url_validation["usable"]

	SSphones.sync_instaflog_profile(instaflog_account, user.ckey)
	if(!instaflog_bind_session(user))
		to_chat(user, span_warning("Não foi possível vincular a conta ao seu personagem."))
		return FALSE
	log_phone("[key_name(user)] [params["updating"] ? "updated" : "registered"] InstaFlog account @[username] ([display_name])")
	return TRUE

/obj/item/smartphone/proc/submit_instaflog_post(body, gallery_photo_id = null, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_require_session(user))
		return FALSE

	if(!COOLDOWN_FINISHED(src, instaflog_post_cooldown))
		to_chat(user, span_warning("Aguarde antes de postar novamente."))
		return FALSE
	if(instaflog_posts_this_round >= INSTAFLOG_MAX_POSTS_PER_ROUND)
		to_chat(user, span_warning("Você atingiu o limite de postagens desta rodada."))
		return FALSE

	body = sanitize_instaflog_text(body, INSTAFLOG_MAX_POST_BODY)
	if(!validate_instaflog_text(body, user, "postagem"))
		return FALSE

	var/datum/phone_gallery_photo/gallery_entry = null
	var/photo_index = 0
	if(gallery_photo_id)
		photo_index = text2num(gallery_photo_id)
		gallery_entry = get_instaflog_gallery_photo(photo_index)
		if(!gallery_entry?.picture?.picture_image)
			to_chat(user, span_warning("Foto da galeria inválida."))
			return FALSE

	var/datum/instaflog_post/post = new()
	post.post_id = SSphones.instaflog_next_post_id++
	post.body = body
	post.date = server_timestamp("Day, Month DD, YYYY", ic_time = TRUE)
	post.time = server_timestamp("hh:mm", ic_time = TRUE)
	post.timestamp = world.time
	post.import_account(instaflog_account)
	post.set_author(user)

	if(gallery_entry?.picture)
		var/image_payload = get_instaflog_gallery_photo_base64(photo_index)
		if(length(image_payload) > INSTAFLOG_MAX_IMAGE_BASE64)
			to_chat(user, span_warning("A imagem é grande demais para publicar."))
			return FALSE
		post.image_base64 = image_payload
		instaflog_handle_photo_masquerade(gallery_entry.picture, user)

	SSphones.instaflog_posts += post
	SSphones.trim_instaflog_feed()
	instaflog_posts_this_round++
	COOLDOWN_START(src, instaflog_post_cooldown, INSTAFLOG_POST_COOLDOWN)
	log_phone("[key_name(user)] flogged on InstaFlog as @[instaflog_account.username]: [post.body]", list("username" = instaflog_account.username, "body" = post.body))
	return TRUE

/obj/item/smartphone/proc/toggle_instaflog_like(post_id, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_require_session(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, instaflog_like_cooldown))
		return FALSE
	var/datum/instaflog_post/post = SSphones.find_instaflog_post(text2num(post_id))
	if(!post)
		to_chat(usr, span_warning("Postagem não encontrada."))
		return FALSE
	var/liked_index = post.liked_by.Find(instaflog_account.username)
	if(liked_index)
		post.liked_by.Cut(liked_index, liked_index + 1)
	else
		post.liked_by += instaflog_account.username
	COOLDOWN_START(src, instaflog_like_cooldown, INSTAFLOG_LIKE_COOLDOWN)
	return TRUE

/obj/item/smartphone/proc/add_instaflog_comment(post_id, body, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_require_session(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, instaflog_comment_cooldown))
		to_chat(user, span_warning("Aguarde antes de comentar novamente."))
		return FALSE
	var/datum/instaflog_post/post = SSphones.find_instaflog_post(text2num(post_id))
	if(!post)
		to_chat(user, span_warning("Postagem não encontrada."))
		return FALSE
	if(length(post.comments) >= INSTAFLOG_MAX_COMMENTS_PER_POST)
		to_chat(user, span_warning("Esta postagem atingiu o limite de comentários."))
		return FALSE
	body = sanitize_instaflog_text(body, INSTAFLOG_MAX_COMMENT_BODY)
	if(!validate_instaflog_text(body, user, "comentário"))
		return FALSE
	var/datum/instaflog_comment/comment = new()
	comment.body = body
	comment.username = instaflog_account.username
	comment.display_name = instaflog_account.display_name
	comment.date = server_timestamp("Day, Month DD, YYYY", ic_time = TRUE)
	comment.time = server_timestamp("hh:mm", ic_time = TRUE)
	post.comments += comment
	COOLDOWN_START(src, instaflog_comment_cooldown, INSTAFLOG_COMMENT_COOLDOWN)
	return TRUE

/obj/item/smartphone/proc/delete_instaflog_post(post_id, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!user)
		return FALSE
	var/datum/instaflog_post/post = SSphones.find_instaflog_post(text2num(post_id))
	if(!post)
		to_chat(user, span_warning("Postagem não encontrada."))
		return FALSE
	if(!post.can_delete(user))
		to_chat(user, span_warning("Você só pode apagar postagens feitas por este personagem."))
		return FALSE
	var/post_index = SSphones.instaflog_posts.Find(post)
	if(!post_index)
		return FALSE
	SSphones.instaflog_posts.Cut(post_index, post_index + 1)
	log_phone("[key_name(user)] removed InstaFlog post #[post.post_id] by @[post.username]: [post.body]", list("author" = post.username, "body" = post.body))
	qdel(post)
	return TRUE

/obj/item/smartphone/proc/remove_instaflog_post(post_index)
	if(!usr.client || !is_admin(usr.client))
		to_chat(usr, span_warning("Acesso negado."))
		return FALSE
	if(!post_index || post_index < 1 || post_index > length(SSphones.instaflog_posts))
		to_chat(usr, "Invalid post index.")
		return FALSE
	var/datum/instaflog_post/selected_post = SSphones.instaflog_posts[post_index]
	SSphones.instaflog_posts.Cut(post_index, post_index + 1)
	to_chat(usr, "Flog by [selected_post.display_name] removed.")
	log_phone("[key_name(usr)] removed an InstaFlog post: [selected_post.body] by @[selected_post.username]", list("author" = selected_post.username, "body" = selected_post.body))
	qdel(selected_post)
	return TRUE

/obj/item/smartphone/proc/handle_instaflog_ui_act(action, list/params, datum/tgui/ui)
	var/mob/living/user = instaflog_resolve_user(ui?.user || usr)
	switch(action)
		if("instaflog_register")
			params["updating"] = instaflog_session_belongs_to(user) && !!instaflog_account
			return create_instaflog_account(params, user)
		if("submit_post")
			return submit_instaflog_post(params["body"], params["gallery_photo_id"], user)
		if("instaflog_like")
			return toggle_instaflog_like(params["post_id"], user)
		if("instaflog_comment")
			return add_instaflog_comment(params["post_id"], params["body"], user)
		if("instaflog_delete_post")
			return delete_instaflog_post(params["post_id"], user)
		if("remove_instaflog_post", "remove_endpost")
			return remove_instaflog_post(text2num(params["post_index"]))
	return FALSE