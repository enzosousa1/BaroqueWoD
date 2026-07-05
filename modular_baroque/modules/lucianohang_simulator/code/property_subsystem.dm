SUBSYSTEM_DEF(property)
	name = "Property"
	dependencies = list(/datum/controller/subsystem/mapping)
	ss_flags = SS_NO_FIRE

	var/datum/json_database/property_database
	var/list/datum/wod_property/properties_by_id = list()

/datum/controller/subsystem/property/Initialize()
	ensure_database()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/property/proc/ensure_database()
	if(property_database)
		return
	property_database = new(WOD_PROPERTY_DB_PATH)

/**
 * Registers a property discovered during mapload and restores any saved ownership.
 * Called from the mapping helper's LateInitialize.
 */
/datum/controller/subsystem/property/proc/register_property(datum/wod_property/property)
	ensure_database()
	if(!property?.property_id)
		return

	if(properties_by_id[property.property_id])
		stack_trace("Duplicate property id registered: [property.property_id]")
		qdel(property)
		return

	properties_by_id[property.property_id] = property

	var/list/saved_data = property_database.get_key(property.property_id)
	if(length(saved_data))
		property.owner = new
		property.owner.import(saved_data)
		property.apply_owned_state()
	else
		property.apply_unowned_state()

/// Writes or clears the ownership record for a property.
/datum/controller/subsystem/property/proc/persist_property(datum/wod_property/property)
	if(!property?.property_id)
		return

	if(!GLOB.canon_event)
		return

	if(property.is_owned())
		property_database.set_key(property.property_id, property.owner.export())
	else
		var/list/data = property_database.get()
		data -= property.property_id
		property_database.replace(data)

/// Generates a stable persistence id from helper coordinates and current map.
/datum/controller/subsystem/property/proc/generate_property_id(atom/reference)
	var/map_name = SSmapping.current_map?.map_name || "unknown_map"
	var/id = "property_[map_name]_[reference.z]_[reference.x]_[reference.y]"
	return SANITIZE_FILENAME(replacetext(id, " ", "_"))

/// Returns the lock id used by all doors in a property.
/datum/controller/subsystem/property/proc/generate_lock_id(property_id)
	return "[WOD_PROPERTY_LOCK_PREFIX][property_id]"