/obj/machinery/point_defense/point_defense_cannon
	name = "\improper 'Bardiche' PDC"
	desc = "A massive autocannon, designed to intercept threats to vessel integrity. <br>\
	BARDICHE stands for: Ballistic Artillery Denial and Interception System, Compact, High-Endurance. <br>\
	A mouthful to be sure, but you'll not care when it saves your life."
	icon = 'modular_boh/icon/boh/structures/pdc_cannon.dmi'
	icon_state = "turret_loaded"

	var/obj/machinery/point_defense/point_defense_computer/mainframe

	var/range = 35 //tiles
	var/cooldown = 1 SECOND
	var/last_fired
	var/rotation_speed = 0.25 SECONDS
	var/intercepting = FALSE
	var/dispersion = 3 //What our bullet spread is - this gets smaller as the missile gets closer.

	var/working_sound = 'modular_boh/sounds/machines/pdc/pdc_fire.ogg'
	var/datum/sound_token/sound_token
	var/sound_id

	var/aiming_sound = 'modular_boh/sounds/machines/pdc/pdc_aim.ogg'

	var/dispersion_datum_type = /datum/pdc_dispersion_datum/normal //We use subtypesof to grab all our target datums.
	var/dispersion_list = list() //Handled in initialize

	id_tag = "default"


/obj/machinery/point_defense/point_defense_cannon/Initialize()
	..()

	for(var/D in subtypesof(dispersion_datum_type)) //Generate our dispersion list.
		var/datum/pdc_dispersion_datum/S = new D
		dispersion_list += S

/obj/machinery/point_defense/point_defense_cannon/Destroy()
	. = ..()
	mainframe.pdcs -= src

/obj/machinery/point_defense/point_defense_cannon/Process()
	scan_for_targets()
	update_icon()

/obj/machinery/point_defense/point_defense_cannon/proc/update_sound()
	if(!working_sound)
		return
	if(!sound_id)
		sound_id = "[type]_[sequential_id(/obj/machinery/computer/ship/sensors)]"

	if(intercepting)
		var/turf/parent_ship_defender = GetConnectedZlevels(get_z(src))
		var/volume = 15
		if(!sound_token)
			sound_token = GLOB.sound_player.PlayLoopingSound(parent_ship_defender, sound_id, working_sound, volume = volume, range = 10, TRUE)
		sound_token.SetVolume(volume)

	else if(sound_token)
		QDEL_NULL(sound_token)

/obj/machinery/point_defense/point_defense_cannon/proc/scan_for_targets()
	for(var/obj/structure/missile/M in view(range))
		if(!istype(M, /obj/structure/missile))
			return

		var/obj/structure/missile/IM = M

		if(!IM.active)
			return

		intercept(IM)

/obj/machinery/point_defense/point_defense_cannon/proc/get_sensor_loss_dispersion() //If we've lost sensors on the mainframe, accuracy suffers considerably.
	var/sensor_strength = mainframe.sensor_integrity

	if(sensor_strength == 100)
		return

	if(sensor_strength <= 75)
		return 1

	if(sensor_strength <= 50)
		return 2

	if(sensor_strength <= 25)
		return 3

/obj/machinery/point_defense/point_defense_cannon/proc/space_los(target)
	for(var/turf/T in getline(src,target))
		if(T.density)
			return FALSE
	return TRUE

/obj/machinery/point_defense/point_defense_cannon/proc/switch_dispersion(obj/O)
	var/dist = get_dist(src, O)

	for(var/datum/pdc_dispersion_datum/D in dispersion_list)
		var/datum/pdc_dispersion_datum/S = D
		if(dist <= S.distance)
			dispersion = S.spread

/obj/machinery/point_defense/point_defense_cannon/proc/intercept(obj/structure/missile/M)
	if(inoperable()) //Broken or no power.
		return

	if(!space_los(M))
		return //No line of sight!

	if(world.time < last_fired + cooldown)
		return //Cooldown is in effect.

	if(!mainframe)
		return //shit just got real, the mainframe's gone.

	if(mainframe.sensor_integrity == 0) //Sensors are offline, PDCs can not target anything.
		return

	if(intercepting)
		return

	var/turf/parent_ship_aiming = GetConnectedZlevels(get_z(src))
	if(parent_ship_aiming)
		playsound(parent_ship_aiming, aiming_sound, 10, FALSE, 0, 0, 0)

	intercepting = TRUE

	var/Angle = round(Get_Angle(src,M))
	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)
	addtimer(new Callback(src, .proc/finish_intercept, M), rotation_speed)
	animate(src, transform = rot_matrix, rotation_speed, easing = SINE_EASING)

	set_dir(transform.get_angle() > 0 ? NORTH : SOUTH)


	last_fired = world.time


/obj/machinery/point_defense/point_defense_cannon/proc/finish_intercept(var/obj/structure/missile/M, miss_chance)
	addtimer(new Callback(src, .proc/do_bullet, M), 1)


/obj/machinery/point_defense/point_defense_cannon/proc/do_bullet(var/obj/structure/missile/target) //This is it's own proc so we can stagger it.
	if(!target) //Target is null or destroyed.
		intercepting = FALSE
		return

	if(!intercepting)
		return

	if(!space_los(target))
		intercepting = FALSE
		return

	if(!mainframe.storage)
		intercepting = FALSE
		return

	if(!mainframe.can_use_ammo())
		intercepting = FALSE
		return

	switch_dispersion(target)

	mainframe.use_ammo()

	dispersion += get_sensor_loss_dispersion()

	update_sound()
	var/Angle = round(Get_Angle(src,target))
	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)
	animate(src, transform = rot_matrix, 1, easing = SINE_EASING) //We want to always face our target.

	var/list/turfs_around_target = list()

	if(QDELETED(target))
		intercepting = FALSE
		return

	for(var/turf/T in orange(dispersion, target))
		turfs_around_target += T

	var/bullet_launch_loc = pick(turfs_around_target)

	var/obj/item/projectile/bullet/rifle/B = new(get_turf(src)) //Make a new bullet.
	B.step_delay = 0.2
	B.launch(bullet_launch_loc)//YEET
	addtimer(new Callback(src, .proc/do_bullet, target), 0.1 SECONDS) //Does this create a loop? Yes. The loop is only broken when the target is dead or intercepting is false.
