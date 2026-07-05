/* // DARKPACK TODO - Gas should be handled as a reagent
/datum/reagent/gasoline
	name = "Gasoline"
	color = "#b85614"

/obj/item/reagent_containers/cup/gas_can
	name = "gas can"
	desc = "Stores gasoline or pure fire death."
	icon_state = "gasoline"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	list_reagents = list(/datum/reagent/gasoline = 200)
*/

/obj/item/gas_can
	name = "gas can"
	desc = "Stores gasoline or pure fire death."
	icon_state = "gasoline"
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	var/stored_gasoline = 0

/obj/item/gas_can/examine(mob/user)
	. = ..()
	. += "<b>Gas</b>: [stored_gasoline]/1000"

/obj/item/gas_can/full
	custom_price = 250 // ECONOMY
	stored_gasoline = 1000

/obj/item/gas_can/rand

/obj/item/gas_can/rand/Initialize(mapload)
	. = ..()
	stored_gasoline = rand(0, 500)

/obj/item/gas_can/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/darkpack_car) || istype(interacting_with, /obj/structure/fuelstation) || istype(interacting_with, /mob/living/carbon/human))
		return NONE
	if(istype(get_turf(interacting_with), /turf/open/floor))
		if(locate(/obj/effect/decal/cleanable/gasoline) in get_turf(interacting_with))
			return ITEM_INTERACT_BLOCKING
		if(stored_gasoline < 50)
			return ITEM_INTERACT_BLOCKING
		stored_gasoline = max(0, stored_gasoline-50)
		new /obj/effect/decal/cleanable/gasoline(get_turf(interacting_with))
		playsound(get_turf(src), 'modular_darkpack/modules/cars/sounds/gas_splat.ogg', 50, TRUE)
		return ITEM_INTERACT_SUCCESS

/obj/item/gas_can/afterattack(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(stored_gasoline < 50)
			return
		stored_gasoline = max(0, stored_gasoline-50)
		H.fire_stacks = min(10, H.fire_stacks+10)
		playsound(get_turf(H), 'modular_darkpack/modules/cars/sounds/gas_splat.ogg', 50, TRUE)
		user.visible_message(span_warning("[user] covers [target] in something flammable!"))

/obj/effect/decal/cleanable/gasoline
	name = "gasoline"
	desc = "I HOPE YOU DIE IN A FIRE!!!"
	icon = 'modular_darkpack/modules/cars/icons/water.dmi'
	icon_state = "water"
	base_icon_state = "water"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SPILL
	canSmoothWith = SMOOTH_GROUP_SPILL + SMOOTH_GROUP_WALLS
	resistance_flags = UNACIDABLE | ACID_PROOF
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	beauty = -50
	alpha = 64
	color = "#c6845b"

/obj/effect/decal/cleanable/gasoline/update_icon(updates=ALL)
	. = ..()
	if((updates & UPDATE_SMOOTHING) && (smoothing_flags & USES_SMOOTHING))
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/*
/obj/effect/decal/cleanable/gasoline/Crossed(atom/movable/AM, oldloc)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.on_fire)
			var/obj/effect/abstract/turf_fire/F = locate() in get_turf(src)
			if(!F)
				new /obj/effect/abstract/turf_fire(get_turf(src))
	. = ..()
*/

/obj/effect/decal/cleanable/gasoline/Initialize(mapload)
	. = ..()
	var/turf/open/my_turf = get_turf(src)
	if(istype(my_turf))
		my_turf.flammability += 5
	if(smoothing_flags & USES_SMOOTHING)
		QUEUE_SMOOTH(src)
		QUEUE_SMOOTH_NEIGHBORS(src)

/obj/effect/decal/cleanable/gasoline/Destroy()
	var/turf/open/my_turf = get_turf(src)
	if(istype(my_turf))
		my_turf.flammability -= 5 // Technicly no validtiy for if its the same turf we started on. Making something less flamible is a nothing burger tho
	QUEUE_SMOOTH_NEIGHBORS(src)
	return ..()

/obj/effect/decal/cleanable/gasoline/fire_act(exposed_temperature, exposed_volume)
	var/turf/open/gas_turf = get_turf(src)
	if(isopenturf(gas_turf))
		gas_turf.ignite_turf(30 + gas_turf.flammability)
	addtimer(CALLBACK(src, PROC_REF(ignite_others)), 0.5 SECONDS)
	. = ..()

/obj/effect/decal/cleanable/gasoline/proc/ignite_others()
	for(var/obj/effect/decal/cleanable/gasoline/oil in range(1, get_turf(src)))
		if(prob(25))
			continue
		oil.fire_act()

/obj/effect/decal/cleanable/gasoline/attackby(obj/item/tool, mob/living/user)
	var/attacked_by_hot_thing = tool.get_temperature()
	if(attacked_by_hot_thing)
		visible_message(span_warning("[user] tries to ignite [src] with [tool]!"), span_warning("You try to ignite [src] with [tool]."))
		log_combat(user, src, (attacked_by_hot_thing < 480) ? "tried to ignite" : "ignited", tool)
		fire_act(attacked_by_hot_thing)
		return
	return ..()

#define FUEL_UNITS_PER_DOLLAR 20
#define FUEL_NOZZLE_HOSE_LENGTH 6

/obj/structure/fuelstation
	name = "fuel station"
	desc = "Fuel your car here. 50 dollars per 1000 units."
	icon = 'modular_darkpack/modules/deprecated/icons/props.dmi'
	icon_state = "fuelstation"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/stored_money = 0
	var/obj/item/fuel_noozzle/attached_nozzle

/obj/structure/fuelstation/Initialize(mapload)
	. = ..()
	if(mapload && !attached_nozzle)
		attach_nozzle(new /obj/item/fuel_noozzle(src))

/obj/structure/fuelstation/Destroy()
	if(attached_nozzle)
		qdel(attached_nozzle)
	return ..()

/obj/structure/fuelstation/proc/attach_nozzle(obj/item/fuel_noozzle/nozzle)
	if(!nozzle || attached_nozzle)
		return FALSE
	attached_nozzle = nozzle
	nozzle.set_connected_pump(src)
	nozzle.disconnect_hose()
	nozzle.forceMove(src)
	return TRUE

/obj/structure/fuelstation/proc/detach_nozzle()
	if(!attached_nozzle)
		return
	attached_nozzle = null

/obj/structure/fuelstation/proc/try_fill_gas_can(obj/item/gas_can/can, mob/living/user)
	if(!can || can.stored_gasoline >= 1000)
		return FALSE
	if(!stored_money)
		to_chat(user, span_warning("[src] has no credit loaded."))
		return FALSE
	var/gas_to_dispense = min(stored_money * FUEL_UNITS_PER_DOLLAR, 1000 - can.stored_gasoline)
	var/money_to_spend = round(gas_to_dispense / FUEL_UNITS_PER_DOLLAR)
	if(money_to_spend < 1)
		return FALSE
	gas_to_dispense = money_to_spend * FUEL_UNITS_PER_DOLLAR
	can.stored_gasoline = min(1000, can.stored_gasoline + gas_to_dispense)
	stored_money = max(0, stored_money - money_to_spend)
	playsound(loc, 'modular_darkpack/master_files/sounds/effects/gas_fill.ogg', 50, TRUE)
	to_chat(user, span_notice("You fill [can]."))
	say("Gas filled.")
	return TRUE

/obj/structure/fuelstation/click_alt(mob/user)
	if(stored_money > 0)
		say("Money refunded.")
		var/money_to_spawn = min(stored_money, /obj/item/stack/dollar::max_amount)
		new /obj/item/stack/dollar(loc, money_to_spawn)
		stored_money -= money_to_spawn
		return CLICK_ACTION_SUCCESS

/obj/structure/fuelstation/examine(mob/user)
	. = ..()
	. += "<b>Balance</b>: [stored_money] [MONEY_NAME]"
	if(attached_nozzle)
		. += "The fuel nozzle is holstered on the pump."
	else
		. += "The fuel nozzle is not on the pump."

/obj/structure/fuelstation/attack_hand(mob/living/user, list/modifiers)
	if(attached_nozzle)
		if(!user.put_in_hands(attached_nozzle))
			to_chat(user, span_warning("You need a free hand to take the fuel nozzle."))
			return CLICK_ACTION_BLOCKING
		detach_nozzle()
		user.visible_message(
			span_notice("[user] takes the fuel nozzle from [src]."),
			span_notice("You take the fuel nozzle from [src]."),
		)
		playsound(src, 'modular_darkpack/master_files/sounds/effects/gas_fill.ogg', 25, TRUE)
		say("Nozzle removed.")
		return CLICK_ACTION_SUCCESS
	return ..()

/obj/structure/fuelstation/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(iscash(tool))
		stored_money += tool.get_item_credit_value()
		to_chat(user, span_notice("You insert [tool.get_item_credit_value()] [MONEY_NAME] into [src]."))
		qdel(tool)
		say("Payment received.")
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/fuel_noozzle))
		var/obj/item/fuel_noozzle/nozzle = tool
		if(attached_nozzle)
			to_chat(user, span_warning("There is already a nozzle on [src]."))
			return ITEM_INTERACT_BLOCKING
		if(nozzle.connected_pump && nozzle.connected_pump != src)
			to_chat(user, span_warning("This nozzle belongs to another pump."))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(nozzle, src))
			return ITEM_INTERACT_BLOCKING
		attach_nozzle(nozzle)
		user.visible_message(
			span_notice("[user] holsters the fuel nozzle on [src]."),
			span_notice("You holster the fuel nozzle on [src]."),
		)
		say("Fuel nozzle attached.")
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/gas_can))
		return try_fill_gas_can(tool, user) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	return NONE

// BAROQUE EDIT — Fuel nozzle holstered on the pump; hose beam while carried.
/obj/item/fuel_noozzle
	name = "fuel nozzle"
	desc = "A nozzle for dispensing fuel. Keep it close to its pump."
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	icon_state = "fuel_nozzle"
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	/// Pump this hose is tethered to.
	var/obj/structure/fuelstation/connected_pump
	var/datum/beam/hose_beam
	var/max_hose_length = FUEL_NOZZLE_HOSE_LENGTH

/obj/item/fuel_noozzle/Destroy()
	disconnect_hose()
	if(connected_pump?.attached_nozzle == src)
		connected_pump.attached_nozzle = null
	connected_pump = null
	return ..()

/obj/item/fuel_noozzle/examine(mob/user)
	. = ..()
	if(connected_pump)
		. += "It is tethered to [connected_pump] by a rubber fuel hose."
	else
		. += "It is not tethered to a fuel pump."

/obj/item/fuel_noozzle/equipped(mob/user, slot)
	. = ..()
	if(slot in list(ITEM_SLOT_HANDS))
		connect_hose(user)
	else
		disconnect_hose()

/obj/item/fuel_noozzle/dropped(mob/user)
	. = ..()
	disconnect_hose()

/obj/item/fuel_noozzle/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!connected_pump)
		to_chat(user, span_warning("[src] isn't connected to a fuel pump."))
		return ITEM_INTERACT_BLOCKING
	if(istype(interacting_with, /obj/item/gas_can))
		return connected_pump.try_fill_gas_can(interacting_with, user) \
			? ITEM_INTERACT_SUCCESS \
			: ITEM_INTERACT_BLOCKING
	if(istype(interacting_with, /obj/darkpack_car))
		var/obj/darkpack_car/car = interacting_with
		return car.try_refuel_from_nozzle(user, src) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	return NONE

/obj/item/fuel_noozzle/proc/connect_hose(mob/living/holder)
	disconnect_hose()
	if(!connected_pump || !holder)
		return
	hose_beam = connected_pump.Beam(
		holder,
		icon_state = "b_beam",
		maxdistance = max_hose_length,
		beam_color = "#1a1a1a",
		emissive = FALSE,
	)
	RegisterSignal(hose_beam, COMSIG_QDELETING, PROC_REF(on_hose_broken))

/obj/item/fuel_noozzle/proc/disconnect_hose()
	if(hose_beam)
		UnregisterSignal(hose_beam, COMSIG_QDELETING)
		QDEL_NULL(hose_beam)

/obj/item/fuel_noozzle/proc/on_hose_broken()
	SIGNAL_HANDLER
	hose_beam = null
	var/mob/living/holder = get_holder()
	if(holder)
		to_chat(holder, span_warning("The fuel hose snaps taut and yanks the nozzle from your grip!"))
		holder.visible_message(
			span_warning("[holder]'s fuel hose snaps taut!"),
			span_warning("Your fuel hose snaps taut!"),
		)
		holder.dropItemToGround(src)

/obj/item/fuel_noozzle/proc/set_connected_pump(obj/structure/fuelstation/pump)
	if(connected_pump)
		UnregisterSignal(connected_pump, COMSIG_QDELETING)
	connected_pump = pump
	if(pump)
		RegisterSignal(pump, COMSIG_QDELETING, PROC_REF(on_pump_destroyed))

/obj/item/fuel_noozzle/proc/on_pump_destroyed(datum/source)
	SIGNAL_HANDLER
	connected_pump = null
	disconnect_hose()
	var/mob/living/holder = get_holder()
	if(holder)
		to_chat(holder, span_warning("The fuel pump connection goes dead!"))

/obj/item/fuel_noozzle/proc/get_holder()
	if(isliving(loc))
		return loc
	return null

#undef FUEL_UNITS_PER_DOLLAR
#undef FUEL_NOZZLE_HOSE_LENGTH
