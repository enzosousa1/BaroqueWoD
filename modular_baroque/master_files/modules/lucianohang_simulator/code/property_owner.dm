/// Persistent ownership record for a purchasable property.
/datum/wod_property_owner
	var/owner_ckey
	var/owner_character_slot
	var/owner_account_id
	var/owner_name
	var/purchase_time
	var/price_paid

/datum/wod_property_owner/proc/get_display_name()
	return owner_name || "an unknown owner"

/datum/wod_property_owner/proc/export()
	return list(
		"owner_ckey" = owner_ckey,
		"owner_character_slot" = owner_character_slot,
		"owner_account_id" = owner_account_id,
		"owner_name" = owner_name,
		"purchase_time" = purchase_time,
		"price_paid" = price_paid,
	)

/datum/wod_property_owner/proc/import(list/data)
	owner_ckey = data["owner_ckey"]
	owner_character_slot = data["owner_character_slot"]
	owner_account_id = data["owner_account_id"]
	owner_name = data["owner_name"]
	purchase_time = data["purchase_time"]
	price_paid = data["price_paid"]

/datum/wod_property_owner/proc/matches_buyer(mob/living/carbon/human/buyer)
	if(!buyer?.ckey || !buyer.mind?.original_character_slot_index)
		return FALSE
	if(ckey(buyer.ckey) != ckey(owner_ckey))
		return FALSE
	if(buyer.mind.original_character_slot_index != owner_character_slot)
		return FALSE
	return TRUE