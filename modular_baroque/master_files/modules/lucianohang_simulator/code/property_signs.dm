/obj/structure/sign/city/forrent
	name = "for rent sign"
	desc = "A sign that indicates a property is available for rent."
	icon = 'modular_baroque/master_files/modules/lucianohang_simulator/icons/decals.dmi'
	icon_state = "forrent"
	anchored = TRUE
	var/price = 5000
	var/datum/wod_property/linked_property

/obj/structure/sign/city/forrent/proc/update_available_visual()
	name = "for rent sign"
	desc = "A sign that indicates a property is available for purchase. Listed at [MONEY_SYMBOL][price]."
	icon_state = "forrent"

/obj/structure/sign/city/forrent/proc/update_owned_visual(datum/wod_property_owner/owner_data)
	name = "sold sign"
	desc = "This property has been sold."
	icon_state = "forrent"
	if(owner_data?.owner_name)
		desc += " Owned by [owner_data.owner_name]."

/obj/structure/sign/city/forrent/examine(mob/user)
	. = ..()
	if(!linked_property)
		return
	if(linked_property.is_owned())
		. += span_notice("This property is owned by [linked_property.owner.get_display_name()].")
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(linked_property.owner?.matches_buyer(human_user))
				. += span_notice("Alt-click to retrieve your keys.")
	else
		. += span_notice("Listed for [MONEY_SYMBOL][price]. Click to purchase.")

/obj/structure/sign/city/forrent/attack_hand(mob/living/user)
	. = ..()
	if(!linked_property || !ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	INVOKE_ASYNC(src, PROC_REF(interact_async), human_user)

/obj/structure/sign/city/forrent/click_alt(mob/user)
	. = ..()
	if(!linked_property?.is_owned() || !ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	if(!linked_property.owner?.matches_buyer(human_user))
		to_chat(human_user, span_warning("You do not own this property."))
		return

	linked_property.award_keys(human_user, include_spare_prompt = TRUE)
	return CLICK_ACTION_SUCCESS

/obj/structure/sign/city/forrent/proc/interact_async(mob/living/carbon/human/user)
	if(!linked_property)
		to_chat(user, span_warning("This sign is not linked to a property."))
		return

	if(linked_property.is_owned())
		if(linked_property.owner?.matches_buyer(user))
			to_chat(user, span_notice("You already own this property. Alt-click the sign to retrieve your keys."))
		else
			to_chat(user, span_warning("This property is no longer for sale."))
		return

	var/datum/bank_account/paying_account = get_paying_account(user)
	if(!paying_account)
		to_chat(user, span_warning("You need a bank account or debit card to purchase this property."))
		return

	var/confirm = tgui_alert(
		user,
		"Purchase [linked_property.get_display_name()] for [MONEY_SYMBOL][price]?",
		"Property Purchase",
		list("Buy", "Cancel"),
	)
	if(confirm != "Buy")
		return

	linked_property.try_purchase(user, paying_account, price)

/// Resolves the buyer's bank account from their character or held debit card.
/obj/structure/sign/city/forrent/proc/get_paying_account(mob/living/carbon/human/user)
	var/list/held_items = list()
	if(user.get_active_held_item())
		held_items += user.get_active_held_item()
	if(user.get_inactive_held_item())
		held_items += user.get_inactive_held_item()

	for(var/obj/item/held_item as anything in held_items)
		if(is_creditcard(held_item))
			var/obj/item/card/credit/creditcard = held_item
			if(creditcard.registered_account)
				return creditcard.registered_account

	if(user.account_id)
		return SSeconomy.bank_accounts_by_id["[user.account_id]"]

	return null
