/obj/item/smartphone
	var/datum/instaflog_account/instaflog_account
	/// Body identity that owns the InstaFlog session on this phone.
	var/instaflog_bound_identity = ""
	var/instaflog_posts_this_round = 0
	COOLDOWN_DECLARE(instaflog_post_cooldown)
	COOLDOWN_DECLARE(instaflog_comment_cooldown)
	COOLDOWN_DECLARE(instaflog_like_cooldown)
	COOLDOWN_DECLARE(instaflog_follow_cooldown)
	COOLDOWN_DECLARE(instaflog_login_cooldown)

/obj/item/smartphone/proc/instaflog_resolve_user(mob/user)
	return isliving(user) ? user : null

/obj/item/smartphone/proc/instaflog_bind_session(mob/living/user)
	var/identity = instaflog_get_character_identity(user)
	if(!identity)
		to_chat(user, span_warning("Apenas personagens humanos podem usar o InstaFlog."))
		return FALSE
	instaflog_bound_identity = identity
	return TRUE

/obj/item/smartphone/proc/instaflog_is_logged_in()
	return !!instaflog_account

/obj/item/smartphone/proc/instaflog_require_session(mob/living/user, silent = FALSE)
	if(!instaflog_is_logged_in())
		if(!silent)
			to_chat(user, span_warning("Você precisa estar logado no InstaFlog."))
		return FALSE
	if(!instaflog_get_character_identity(user))
		if(!silent)
			to_chat(user, span_warning("Apenas personagens humanos podem usar o InstaFlog."))
		return FALSE
	return TRUE

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

/datum/controller/subsystem/phones/proc/sync_instaflog_profile(datum/instaflog_account/account, ckey = null, persist = TRUE)
	if(!account?.username)
		return
	var/list/existing_profile = instaflog_profiles[account.username]
	var/list/profile_data = account.serialize()
	if(ckey)
		profile_data["owner_ckey"] = ckey
	if(islist(existing_profile?["followers"]))
		var/list/followers = existing_profile["followers"]
		profile_data["followers"] = followers.Copy()
	else
		profile_data["followers"] = list()
	if(islist(existing_profile?["following"]))
		var/list/following = existing_profile["following"]
		profile_data["following"] = following.Copy()
	else
		profile_data["following"] = list()
	if(existing_profile)
		profile_data["password"] = existing_profile["password"]
		profile_data["password_hash"] = existing_profile["password_hash"]
		profile_data["password_salt"] = existing_profile["password_salt"]
		profile_data["created_round"] = existing_profile["created_round"]
	instaflog_profiles[account.username] = profile_data
	if(persist)
		SSinstaflog.save_profile(account.username)

/datum/controller/subsystem/phones/proc/format_instaflog_profiles(datum/instaflog_account/viewer = null)
	var/list/formatted = list()
	var/list/viewer_following = list()
	if(viewer?.username)
		var/list/viewer_profile = instaflog_profiles[viewer.username]
		if(islist(viewer_profile?["following"]))
			viewer_following = viewer_profile["following"]
	for(var/username in instaflog_profiles)
		var/list/profile = instaflog_profiles[username]
		if(!profile)
			continue
		var/post_count = 0
		for(var/datum/instaflog_post/post as anything in instaflog_posts)
			if(post?.username == username)
				post_count++
		var/list/followers = profile["followers"]
		var/list/following = profile["following"]
		var/list/entry = instaflog_strip_sensitive_profile_data(profile) | list(
			"post_count" = post_count,
			"followers" = islist(followers) ? followers.Copy() : list(),
			"following" = islist(following) ? following.Copy() : list(),
			"follower_count" = islist(followers) ? length(followers) : 0,
			"following_count" = islist(following) ? length(following) : 0,
		)
		if(viewer?.username && username != viewer.username)
			entry["is_followed_by_viewer"] = (username in viewer_following)
		formatted[username] = entry
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
	var/logged_in = instaflog_is_logged_in()
	data["instaflog_registered"] = logged_in
	data["instaflog_logged_in"] = logged_in
	data["instaflog_account"] = logged_in ? instaflog_account?.serialize() : null
	data["instaflog_posts"] = SSphones.format_instaflog_posts(logged_in ? instaflog_account : null, user)
	data["instaflog_profiles"] = SSphones.format_instaflog_profiles(logged_in ? instaflog_account : null)
	var/list/following = list()
	if(logged_in && instaflog_account?.username)
		var/list/my_profile = SSphones.instaflog_profiles[instaflog_account.username]
		if(islist(my_profile?["following"]))
			following = my_profile["following"]
	data["instaflog_following"] = following
	return data

/obj/item/smartphone/proc/login_instaflog_account(list/params, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!user)
		return FALSE
	if(!COOLDOWN_FINISHED(src, instaflog_login_cooldown))
		to_chat(user, span_warning("Aguarde antes de tentar novamente."))
		return FALSE

	var/username = sanitize_instaflog_username(params["username"])
	if(!username)
		to_chat(user, span_warning("Nome de usuário inválido."))
		return FALSE

	var/password = trim(params["password"])
	if(!validate_instaflog_password(password, user))
		return FALSE

	var/list/record = SSinstaflog.get_account_record(username)
	if(!record)
		to_chat(user, span_warning("Conta não encontrada."))
		COOLDOWN_START(src, instaflog_login_cooldown, INSTAFLOG_LOGIN_COOLDOWN)
		return FALSE
	if(!instaflog_verify_password_record(password, record))
		to_chat(user, span_warning("Senha incorreta."))
		COOLDOWN_START(src, instaflog_login_cooldown, INSTAFLOG_LOGIN_COOLDOWN)
		return FALSE

	if(!length(record["password"]))
		instaflog_migrate_password_to_plaintext(record, password)
		SSphones.instaflog_profiles[username] = sanitize_instaflog_profile_record(record)
		SSinstaflog.save_profile(username)

	instaflog_account = SSinstaflog.load_account_datum(username)
	if(!instaflog_bind_session(user))
		to_chat(user, span_warning("Não foi possível iniciar a sessão no InstaFlog."))
		instaflog_account = null
		return FALSE

	COOLDOWN_START(src, instaflog_login_cooldown, INSTAFLOG_LOGIN_COOLDOWN)
	to_chat(user, span_notice("Bem-vindo de volta, @[username]!"))
	log_phone("[key_name(user)] logged into InstaFlog as @[username]")
	return TRUE

/obj/item/smartphone/proc/register_instaflog_account(list/params, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!user)
		return FALSE
	if(!COOLDOWN_FINISHED(src, instaflog_login_cooldown))
		to_chat(user, span_warning("Aguarde antes de tentar novamente."))
		return FALSE

	var/username = sanitize_instaflog_username(params["username"])
	if(!username)
		to_chat(user, span_warning("Nome de usuário inválido. Use apenas letras, números e sublinhados."))
		return FALSE
	if(SSinstaflog.account_exists(username))
		to_chat(user, span_warning("Este nome de usuário já está em uso."))
		return FALSE

	var/password = trim(params["password"])
	var/confirm_password = trim(params["confirm_password"])
	if(!validate_instaflog_password(password, user, confirm_password))
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

	var/list/profile_data = list(
		"username" = username,
		"display_name" = display_name,
		"bio" = bio,
		"city" = city,
		"profile_photo_url" = url_validation["url"],
		"profile_photo_usable" = url_validation["usable"],
		"password" = password,
		"owner_ckey" = user.ckey,
		"created_round" = GLOB.round_id,
		"followers" = list(),
		"following" = list(),
	)
	if(!SSinstaflog.create_account_record(profile_data))
		to_chat(user, span_warning("Não foi possível criar a conta."))
		return FALSE

	instaflog_account = SSinstaflog.load_account_datum(username)
	if(!instaflog_bind_session(user))
		to_chat(user, span_warning("Conta criada, mas não foi possível iniciar a sessão."))
		instaflog_account = null
		return FALSE

	COOLDOWN_START(src, instaflog_login_cooldown, INSTAFLOG_LOGIN_COOLDOWN)
	to_chat(user, span_notice("Conta @[username] criada com sucesso!"))
	log_phone("[key_name(user)] registered InstaFlog account @[username] ([display_name])")
	return TRUE

/obj/item/smartphone/proc/update_instaflog_profile(list/params, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_require_session(user))
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

	instaflog_account.display_name = display_name
	instaflog_account.bio = bio
	instaflog_account.city = city
	instaflog_account.profile_photo_url = url_validation["url"]
	instaflog_account.profile_photo_usable = url_validation["usable"]

	SSphones.sync_instaflog_profile(instaflog_account, user.ckey)
	to_chat(user, span_notice("Perfil atualizado."))
	log_phone("[key_name(user)] updated InstaFlog profile @[instaflog_account.username]")
	return TRUE

/obj/item/smartphone/proc/logout_instaflog_account(mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_is_logged_in())
		return FALSE
	var/username = instaflog_account.username
	instaflog_account = null
	instaflog_bound_identity = ""
	to_chat(user, span_notice("Você saiu do InstaFlog."))
	log_phone("[key_name(user)] logged out of InstaFlog (@[username])")
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
	var/list/liked_by = post.liked_by
	var/liked_index = liked_by.Find(instaflog_account.username)
	if(liked_index)
		liked_by.Cut(liked_index, liked_index + 1)
	else
		liked_by += instaflog_account.username
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

/obj/item/smartphone/proc/toggle_instaflog_follow(target_username, mob/living/user = null)
	user = instaflog_resolve_user(user || usr)
	if(!instaflog_require_session(user))
		return FALSE
	if(!COOLDOWN_FINISHED(src, instaflog_follow_cooldown))
		return FALSE

	target_username = sanitize_instaflog_username(target_username)
	if(!target_username)
		to_chat(user, span_warning("Nome de usuário inválido."))
		return FALSE
	if(target_username == instaflog_account.username)
		to_chat(user, span_warning("Você não pode seguir a si mesmo."))
		return FALSE

	var/list/my_profile = SSphones.instaflog_profiles[instaflog_account.username]
	var/list/their_profile = SSphones.instaflog_profiles[target_username]
	if(!their_profile)
		to_chat(user, span_warning("Perfil não encontrado."))
		return FALSE
	if(!my_profile)
		my_profile = SSinstaflog.get_account_record(instaflog_account.username)
		if(!my_profile)
			to_chat(user, span_warning("Perfil não encontrado."))
			return FALSE
		my_profile = sanitize_instaflog_profile_record(my_profile)
		SSphones.instaflog_profiles[instaflog_account.username] = my_profile

	if(!islist(my_profile["following"]))
		my_profile["following"] = list()
	if(!islist(their_profile["followers"]))
		their_profile["followers"] = list()

	var/list/following = my_profile["following"]
	var/list/followers = their_profile["followers"]
	var/following_index = following.Find(target_username)
	if(following_index)
		following.Cut(following_index, following_index + 1)
		var/follower_index = followers.Find(instaflog_account.username)
		if(follower_index)
			followers.Cut(follower_index, follower_index + 1)
		log_phone("[key_name(user)] unfollowed @[target_username] on InstaFlog", list("username" = instaflog_account.username, "target" = target_username))
	else
		following += target_username
		if(!(instaflog_account.username in followers))
			followers += instaflog_account.username
		log_phone("[key_name(user)] followed @[target_username] on InstaFlog", list("username" = instaflog_account.username, "target" = target_username))

	SSinstaflog.save_profile(instaflog_account.username)
	SSinstaflog.save_profile(target_username)
	COOLDOWN_START(src, instaflog_follow_cooldown, INSTAFLOG_FOLLOW_COOLDOWN)
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
		if("instaflog_login")
			return login_instaflog_account(params, user)
		if("instaflog_register")
			return register_instaflog_account(params, user)
		if("instaflog_update_profile")
			return update_instaflog_profile(params, user)
		if("instaflog_logout")
			return logout_instaflog_account(user)
		if("submit_post")
			return submit_instaflog_post(params["body"], params["gallery_photo_id"], user)
		if("instaflog_like")
			return toggle_instaflog_like(params["post_id"], user)
		if("instaflog_comment")
			return add_instaflog_comment(params["post_id"], params["body"], user)
		if("instaflog_delete_post")
			return delete_instaflog_post(params["post_id"], user)
		if("instaflog_follow")
			return toggle_instaflog_follow(params["username"], user)
		if("remove_instaflog_post", "remove_endpost")
			return remove_instaflog_post(text2num(params["post_index"]))
	return FALSE
