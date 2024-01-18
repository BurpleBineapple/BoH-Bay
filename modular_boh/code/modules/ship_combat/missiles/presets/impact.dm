// Immovable rod LITE. Cleanly cleaves through a set amount of dense objects
/obj/structure/missile/impact
	name = "HBM67 missile"
	overmap_name = "breacher missile"
	desc = "A breacher missile developed by Haephestus Industries. It is widely known and feared for eating through hulls like butter, often making it through multiple wall sections before coming to a halt."

	equipment = list(
		/obj/item/missile_equipment/thruster,
		/obj/item/missile_equipment/autoarm
	)

	// how many pieces of dense objects can this missile still punch through
	var/inertia = 4

// This doesn't have a detonation mechanism, it simply punches through hulls.
// Note if changing the equipment list: this overrides Bump, so detonate() and thus on_trigger() isn't called on the equipment
/obj/structure/missile/impact/Bump(var/atom/obstacle)
	if(!active)
		return

	// cleaves through anything that isn't a shield while it still has inertia left
	if(inertia)
		if(istype(obstacle, /obj/shield))
			inertia = 0
		else
			qdel(obstacle)
			inertia--

		if(!inertia)
			walk(src, 0)
			active = FALSE
			qdel(src)

/obj/structure/missile/impact/armed
	active = TRUE

//OP version. Explodes when it runs out of steam, acting as a delayed fuse.
/obj/structure/missile/impact/super
	name = "HBM68 missile"
	overmap_name = "breacher missile"
	inertia = 12

/obj/structure/missile/impact/super/Bump(var/atom/obstacle)
	if(!active)
		return

	if(inertia)
		if(istype(obstacle, /obj/shield))
			inertia = 0
		else
			qdel(obstacle)
			inertia--

		if(!inertia)
			walk(src, 0)
			active = FALSE
			explosion(get_turf(src), 4, 8, 12, 16)
			qdel(src)

/obj/structure/missile/impact/super/armed
	active = TRUE
