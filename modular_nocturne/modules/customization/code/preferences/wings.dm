// regenerate_organs override

/datum/species/regenerate_organs(mob/living/carbon/target, datum/species/old_species, replace_current = TRUE, list/excluded_zones, visual_only = FALSE, replace_missing = TRUE)
	. = ..()
	if(target.dna.features[FEATURE_WINGS_NOCTURNE] && can_regenerate_mutant_feature(FEATURE_WINGS_NOCTURNE))
		if(target.dna.features[FEATURE_WINGS_NOCTURNE] != /datum/sprite_accessory/nocturne/wings/none::name && target.dna.features[FEATURE_WINGS_NOCTURNE] != /datum/sprite_accessory/blank::name)
			var/obj/item/organ/replacement = SSwardrobe.provide_type(/obj/item/organ/wings/mutant)
			replacement.Insert(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
			return .
	var/obj/item/organ/old_part = target.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS)
	if(old_part && old_part.type == /obj/item/organ/wings/mutant) // only delete if this the mutant wings
		old_part.Remove(target, special = TRUE, movement_flags = DELETE_IF_REPLACED)
		old_part.moveToNullspace()

// wings toggle

/datum/preference/toggle/nocturne_toggle/wings
	savefile_key = "has_wings_nocturne"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	feature_key = FEATURE_WINGS_NOCTURNE

// actual wing options

/datum/preference/choiced/nocturne_feature/wings
	savefile_key = "feature_wings_nocturne"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Wings"
	should_generate_icons = TRUE
	// relevant_organ = /obj/item/organ/wings/mutant
	category = PREFERENCE_CATEGORY_CLOTHING
	feature_key = FEATURE_WINGS_NOCTURNE
	toggle_pref = /datum/preference/toggle/nocturne_toggle/wings

/datum/preference/choiced/nocturne_feature/wings/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = /datum/preference/tri_color/wings_color::savefile_key
	return data

/datum/preference/choiced/nocturne_feature/wings/create_default_value()
	return SPRITE_ACCESSORY_NONE

/datum/preference/choiced/nocturne_feature/wings/icon_for(value)
	return generate_wings_icon(get_accessory_for_value(value))

/datum/preference/choiced/nocturne_feature/wings/proc/generate_wings_icon(datum/sprite_accessory/sprite_accessory)
	var/static/datum/universal_icon/body
	if (isnull(body))
		body = uni_icon('icons/mob/human/human.dmi', "human_basic", NORTH)
	var/datum/universal_icon/final_icon = body.copy()

	if(!isnull(sprite_accessory) && sprite_accessory.icon_state != "none")
		blend_mutant_accessory_preview_layers(final_icon, sprite_accessory.icon, "m_wings_[sprite_accessory.icon_state]_BEHIND", NORTH, NORTH)
		blend_mutant_accessory_preview_layers(final_icon, sprite_accessory.icon, "m_wings_[sprite_accessory.icon_state]_ADJ", NORTH, NORTH)
		blend_mutant_accessory_preview_layers(final_icon, sprite_accessory.icon, "m_wings_[sprite_accessory.icon_state]_FRONT", NORTH, NORTH)

	final_icon.crop(0, 0, 32, 32)
	final_icon.scale(32, 32)

	return final_icon

// wing colors

/datum/preference/tri_color/wings_color
	priority = PREFERENCE_PRIORITY_BODY_TYPE
	savefile_key = "wings_nocturne_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES

/datum/preference/tri_color/wings_color/create_default_value()
	return list(sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"),
	sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]"))

/datum/preference/tri_color/wings_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_WINGS_NOCTURNE_COLORS] = value

/datum/preference/tri_color/wings_color/is_valid(value)
	if (!..(value))
		return FALSE
	return TRUE
