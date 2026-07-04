/// Runtime representation of a purchasable property. All discovery is done at mapload.
/datum/wod_property
	var/property_id
	var/lock_id
	var/area/property_area
	var/list/obj/structure/vampdoor/property_doors = list()
	var/obj/structure/sign/city/forrent/rent_sign
	var/datum/wod_property_owner/owner
	var/purchase_in_progress = FALSE

/datum/wod_property/Destroy()
	property_doors = null
	property_area = null
	rent_sign = null
	QDEL_NULL(owner)
	if(SSproperty)
		SSproperty.properties_by_id -= property_id
	return ..()

/datum/wod_property/proc/is_owned()
	return !isnull(owner)

/datum/wod_property/proc/get_display_name()
	if(property_area)
		return property_area.name
	return "property"

/// Applies the stable lock id to every door in this property and strips conflicting claim helpers.
/datum/wod_property/proc/configure_doors()
	for(var/obj/structure/vampdoor/door as anything in property_doors)
		if(QDELETED(door))
			continue
		door.lock_id = lock_id
		qdel(door.GetComponent(/datum/component/door_ownership))

/// Restores sign visuals and door configuration from cached ownership data.
/datum/wod_property/proc/apply_owned_state()
	configure_doors()
	if(rent_sign)
		rent_sign.update_owned_visual(owner)

/// Clears ownership visuals for an unowned property.
/datum/wod_property/proc/apply_unowned_state()
	configure_doors()
	if(rent_sign)
		rent_sign.update_available_visual()

/**
 * Attempts to purchase this property for the given buyer.
 * Returns TRUE on success.
 */
/datum/wod_property/proc/try_purchase(mob/living/carbon/human/buyer, datum/bank_account/paying_account, price)
	if(purchase_in_progress)
		to_chat(buyer, span_warning("Someone is already finalizing a purchase for this property."))
		return FALSE

	if(is_owned())
		to_chat(buyer, span_warning("This property already has an owner."))
		return FALSE

	if(!paying_account)
		to_chat(buyer, span_warning("You do not have a bank account to pay with."))
		return FALSE

	if(!buyer.mind?.original_character_slot_index)
		to_chat(buyer, span_warning("You need an active character to purchase property."))
		return FALSE

	purchase_in_progress = TRUE
	. = FALSE

	if(is_owned())
		to_chat(buyer, span_warning("This property was just purchased by someone else."))
		purchase_in_progress = FALSE
		return

	if(!paying_account.check_pin(buyer, price, rent_sign))
		purchase_in_progress = FALSE
		return

	if(!paying_account.adjust_money(-price, "Property: [get_display_name()]"))
		to_chat(buyer, span_alert("The transaction is declined - insufficient funds."))
		purchase_in_progress = FALSE
		return

	if(is_owned())
		paying_account.adjust_money(price, "Property: Purchase Refund")
		to_chat(buyer, span_warning("This property was just purchased by someone else. Your payment was refunded."))
		purchase_in_progress = FALSE
		return

	owner = new
	owner.owner_ckey = buyer.ckey
	owner.owner_character_slot = buyer.mind.original_character_slot_index
	owner.owner_account_id = paying_account.account_id
	owner.owner_name = buyer.real_name
	owner.purchase_time = world.time
	owner.price_paid = price

	apply_owned_state()
	award_keys(buyer, include_spare_prompt = TRUE)
	SSproperty.persist_property(src)

	buyer.log_message("purchased property '[property_id]' for [price] [MONEY_NAME].", LOG_GAME)
	to_chat(buyer, span_notice("You are now the owner of [get_display_name()]."))
	playsound(get_turf(rent_sign), 'sound/effects/cashregister.ogg', 50, TRUE)

	purchase_in_progress = FALSE
	return TRUE

/// Awards property keys to a validated owner. Reuses the vamp key system.
/datum/wod_property/proc/award_keys(mob/living/carbon/human/recipient, include_spare_prompt = FALSE)
	var/key_amount = 1
	if(include_spare_prompt)
		var/spare_key = tgui_alert(recipient, "Do I want a spare key?", "Property Keys", list("Yes", "No"))
		if(spare_key == "Yes")
			key_amount = 2

	for(var/i in 1 to key_amount)
		var/obj/item/vamp/keys/key = new /obj/item/vamp/keys(get_turf(recipient))
		key.name = "[get_display_name()] keys"
		key.accesslocks = list(lock_id)
		recipient.put_in_hands(key)

	if(!(LOCK_OWNERSHIP_PROPERTY in recipient.received_ownership_keys))
		recipient.received_ownership_keys += LOCK_OWNERSHIP_PROPERTY

/// Future hook: transfer ownership to another buyer or admin action.
/datum/wod_property/proc/transfer_ownership(datum/wod_property_owner/new_owner)
	owner = new_owner
	apply_owned_state()
	SSproperty.persist_property(src)

/// Future hook: clear ownership for resale, auctions, or admin resets.
/datum/wod_property/proc/clear_ownership()
	QDEL_NULL(owner)
	apply_unowned_state()
	SSproperty.persist_property(src)