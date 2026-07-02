/**
 * True Faith cross effects.
 * Effects scale with the wielder's Faith dots and whether the target is Kindred.
 */

/obj/item/card/hunter/proc/apply_faith_to_human(mob/living/carbon/human/target, mob/living/user, at_range = FALSE)
	if(target.stat == DEAD || user.stat == DEAD)
		return FALSE
	if(!isliving(user))
		return FALSE

	var/mob/living/living_user = user
	var/faith_level = living_user.st_get_stat(STAT_FAITH)
	if(faith_level < 1)
		return FALSE

	if(at_range && get_dist(get_turf(living_user), get_turf(target)) > FAITH_CROSS_MAX_RANGE)
		to_chat(living_user, span_warning("They are too far away for your faith to reach."))
		return FALSE

	if(!COOLDOWN_FINISHED(src, detonation_timer))
		to_chat(living_user, span_warning("Your faith still needs a moment to gather strength."))
		return FALSE

	var/distance = at_range ? get_dist(get_turf(src), get_turf(target)) : 0
	var/is_kindred = isvampire(target)

	brandish_cross(living_user, target, distance)

	if(is_kindred)
		apply_faith_against_kindred(target, living_user, faith_level, distance)
	else
		apply_faith_against_mortal(target, living_user, faith_level, distance)

	COOLDOWN_START(src, detonation_timer, FAITH_CROSS_COOLDOWN)
	return TRUE

/obj/item/card/hunter/proc/brandish_cross(mob/living/user, mob/living/target, distance)
	do_sparks(rand(3, 6), FALSE, user)
	playsound(get_turf(user), 'modular_darkpack/modules/jobs/sounds/cross.ogg', clamp(100 - (distance * 8), 40, 100), FALSE, 8, 0.9)
	user.visible_message(
		span_notice("[user] brandishes [src] toward [target]!"),
		span_notice("You brandish [src] toward [target]!"),
		ignored_mobs = target,
	)
	target.show_message(span_warning(span_bold("A holy symbol is thrust toward you!")), MSG_VISUAL)

/obj/item/card/hunter/proc/faith_potency_multiplier(distance)
	return max(1 / max(1, distance), 0.25)

/obj/item/card/hunter/proc/apply_faith_against_kindred(mob/living/carbon/human/target, mob/living/user, faith_level, distance)
	var/potency = faith_potency_multiplier(distance)

	switch(faith_level)
		if(1)
			to_chat(user, span_notice("Your faith stirs — something unholy recoils from [target]."))
			to_chat(target, span_warning("A chill runs down your spine as [user] brandishes a holy symbol toward you!"))
			target.adjust_temp_blindness(ceil(1 * potency))
		if(2)
			target.show_message(span_userdanger("Holy fire sears your unliving flesh!"), MSG_VISUAL)
			user.visible_message(span_warning("[target] flinches away from [user]'s cross!"))
			target.ignite_mob()
			if(target.flash_act(affect_silicon = TRUE))
				target.emote("scream")
		if(3)
			target.show_message(span_userdanger("The cross blazes with true faith!"), MSG_VISUAL)
			user.visible_message(span_warning("[target] reels from the wrath of [user]'s faith!"))
			target.apply_damage(2 TTRPG_DAMAGE, AGGRAVATED)
			target.ignite_mob()
			if(target.flash_act(affect_silicon = TRUE))
				target.emote("scream")
			if(HAS_TRAIT(target, TRAIT_REPELLED_BY_HOLINESS))
				lightningbolt(target)
				to_chat(target, span_userdanger("The gods have punished you for your sins!"))
		if(4)
			target.show_message(span_userdanger("Divine judgment falls upon you!"), MSG_VISUAL)
			user.visible_message(span_danger("[target] is wracked by the power of [user]'s faith!"))
			target.apply_damage(3 TTRPG_DAMAGE, AGGRAVATED)
			target.adjust_fire_stacks(ceil(2 * potency))
			target.ignite_mob()
			if(target.flash_act(affect_silicon = TRUE))
				target.emote("scream")
			lightningbolt(target)
		if(5 to INFINITY)
			target.show_message(span_userdanger("The light of true faith threatens to unmake you!"), MSG_VISUAL)
			user.visible_message(span_danger("[target] is engulfed by the searing radiance of [user]'s faith!"))
			target.apply_damage(3 TTRPG_DAMAGE, AGGRAVATED)
			target.adjust_fire_stacks(ceil(3 * potency))
			target.ignite_mob()
			target.Paralyze(max(15 / max(1, distance), 8) * potency)
			target.Knockdown(max(120 / max(1, distance), 50) * potency)
			if(target.flash_act(affect_silicon = TRUE))
				target.emote("scream")
			lightningbolt(target)

/obj/item/card/hunter/proc/apply_faith_against_mortal(mob/living/carbon/human/target, mob/living/user, faith_level, distance)
	switch(faith_level)
		if(1)
			to_chat(user, span_notice("Your faith finds no unholy taint upon [target]."))
			to_chat(target, span_notice("A warm stillness settles over you for a brief moment."))
		if(2)
			to_chat(target, span_notice("You feel blessed by the gesture."))
			to_chat(user, span_notice("You offer a quiet blessing upon [target]."))
			target.heal_ordered_damage(1 TTRPG_DAMAGE, list(BRUTE, BURN, TOX))
		if(3)
			to_chat(user, span_notice("[target] stands before you as an unremarkable soul."))
			to_chat(target, span_notice("A gentle warmth settles in your chest."))
			target.heal_ordered_damage(2 TTRPG_DAMAGE, list(BRUTE, BURN, TOX))
		if(4)
			to_chat(target, span_notice("A profound sense of peace washes over you."))
			to_chat(user, span_notice("Your faith pours forth in a radiant benediction."))
			target.heal_ordered_damage(2 TTRPG_DAMAGE, list(BRUTE, BURN, TOX, OXY))
		if(5 to INFINITY)
			to_chat(target, span_notice("For a heartbeat, the world feels utterly, perfectly right."))
			to_chat(user, span_boldnotice("Your faith shines with blinding clarity."))
			target.heal_ordered_damage(2 TTRPG_DAMAGE, list(BRUTE, BURN, TOX, OXY, BRAIN))
