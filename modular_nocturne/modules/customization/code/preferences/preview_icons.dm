/// Preview tint colors for matrixed mutant accessory layers.
#define MUTANT_PREVIEW_LAYER_COLORS list(COLOR_RED, COLOR_VIBRANT_LIME, COLOR_BLUE)

/// Resolves an icon state for character-setup previews.
/// Supports Nocturne (_2/_3) and Baroque (_primary/_secondary/_tertiary) naming.
/proc/resolve_mutant_accessory_preview_state(icon_file, state_prefix, layer_index)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/suffix_options
	switch(layer_index)
		if(1)
			suffix_options = list("", "_primary")
		if(2)
			suffix_options = list("_2", "_secondary")
		if(3)
			suffix_options = list("_3", "_tertiary")
		else
			return null

	for(var/suffix in suffix_options)
		var/state = "[state_prefix][suffix]"
		if(icon_exists(icon_file, state))
			return state
	return null

/// Blends one matrixed accessory preview layer onto a target icon.
/proc/blend_mutant_accessory_preview_layer(datum/universal_icon/target, icon_file, state_prefix, layer_index, dir = SOUTH, shift_direction = null, tint_color = null, apply_default_tint = TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/state = resolve_mutant_accessory_preview_state(icon_file, state_prefix, layer_index)
	if(!state)
		return FALSE

	var/datum/universal_icon/layer_icon = uni_icon(icon_file, state, dir)
	if(!isnull(shift_direction))
		layer_icon.shift(shift_direction, 0)

	if(!isnull(tint_color))
		layer_icon.blend_color(tint_color, ICON_MULTIPLY)
	else if(apply_default_tint && layer_index <= length(MUTANT_PREVIEW_LAYER_COLORS))
		layer_icon.blend_color(MUTANT_PREVIEW_LAYER_COLORS[layer_index], ICON_MULTIPLY)

	target.blend_icon(layer_icon, ICON_OVERLAY)
	return TRUE

/// Blends all three matrixed accessory preview layers for a given state prefix.
/proc/blend_mutant_accessory_preview_layers(datum/universal_icon/target, icon_file, state_prefix, dir = SOUTH, shift_direction = null)
	for(var/layer_index in 1 to 3)
		blend_mutant_accessory_preview_layer(target, icon_file, state_prefix, layer_index, dir, shift_direction)

#undef MUTANT_PREVIEW_LAYER_COLORS