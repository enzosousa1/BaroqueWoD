/obj/effect/mapping_helpers/property
	name = "property mapping helper"
	icon = 'modular_baroque/modules/lucianohang_simulator/icons/mapping_helpers.dmi'
	icon_state = "property_cam"
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/mapping_helpers/property/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return INITIALIZE_HINT_QDEL

	return INITIALIZE_HINT_LATELOAD

/obj/effect/mapping_helpers/property/LateInitialize()
	var/area/discovered_area = get_area(src)
	if(!discovered_area)
		log_mapping("[src] failed to find an area at [AREACOORD(src)]")
		qdel(src)
		return

	var/list/obj/structure/vampdoor/found_doors = list()
	var/obj/structure/sign/city/forrent/found_sign

	for(var/atom/area_atom as anything in discovered_area)
		if(istype(area_atom, /obj/structure/vampdoor))
			found_doors += area_atom
		else if(istype(area_atom, /obj/structure/sign/city/forrent) && !found_sign)
			found_sign = area_atom

	if(!found_sign)
		log_mapping("[src] failed to find a for-rent sign in [discovered_area] at [AREACOORD(src)]")
		qdel(src)
		return

	if(!length(found_doors))
		log_mapping("[src] found no vampdoors in [discovered_area] at [AREACOORD(src)]")

	var/datum/wod_property/property = new
	property.property_id = SSproperty.generate_property_id(src)
	property.lock_id = SSproperty.generate_lock_id(property.property_id)
	property.property_area = discovered_area
	property.property_doors = found_doors
	property.rent_sign = found_sign
	found_sign.linked_property = property

	SSproperty.register_property(property)
	qdel(src)