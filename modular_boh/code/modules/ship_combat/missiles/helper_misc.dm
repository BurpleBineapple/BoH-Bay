/obj/overmap/visitable/ship
	var/ship_target = null
	var/planet_target = null
	var/missile_target
	var/planet_x = 1
	var/planet_y = 1
	var/coord_target_x = 10
	var/coord_target_y = 10


/obj/overmap/visitable/ship/proc/check_target(obj/overmap/target)
	if(target in view(7, src))
		return TRUE
	return FALSE

/obj/overmap/visitable/ship/proc/get_target(target_type)
	if(target_type == TARGET_SHIP)
		if(ship_target && check_target(ship_target))
			return ship_target

	if(target_type == TARGET_MISSILE)
		if(missile_target && check_target(missile_target))
			return missile_target

	if(target_type == TARGET_POINT)
		return list(coord_target_x, coord_target_y)

	if(target_type == TARGET_PLANET)
		if(planet_target && check_target(planet_target))
			return list(planet_target, planet_x, planet_y)
		else
			return list(null, planet_x, planet_y)

	if(target_type == TARGET_PLANETCOORD)
		return list(planet_x, planet_y)

	return null

/obj/overmap/visitable/ship/proc/set_target(target_type, obj/overmap/target, target_x, target_y)
	if(target_type == TARGET_SHIP)
		if(target && check_target(target))
			ship_target = target

	if(target_type == TARGET_MISSILE)
		if(target && check_target(target))
			missile_target = target

	if(target_type == TARGET_POINT)
		coord_target_x = target_x
		coord_target_y = target_y

	if(target_type == TARGET_PLANET)
		if(planet_target && check_target(target))
			planet_target = target
			planet_x = target_x
			planet_y = target_y
		else
			planet_x = target_x
			planet_y = target_y

/proc/random_missile_dir()
	return pick(list(NORTH, EAST, SOUTH, WEST, NORTH|EAST, NORTH|WEST, SOUTH|EAST, SOUTH|WEST))
