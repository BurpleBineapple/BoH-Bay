
/obj/machinery/point_defense
	density = 1
	opacity = 0
	icon = 'modular_boh/icon/boh/structures/pdc_mainframe.dmi'

/obj/machinery/point_defense/point_defense_computer
	name = "\improper 'Bardiche' point defense mainframe"
	desc = "A complicated, large computer that provides rapid targeting for the ship's 'Bardiche' network. <br>\
	BARDICHE stands for: Ballistic Artillery Denial and Interception System, Compact, High-Endurance. <br>\
	A mouthful to be sure, but you'll not care when it saves your life."
	icon_state = "pdc_mainframe"

	var/list/sensors = list()	//Our sensors, generally used for measuring integrity of the PDC network.
	var/list/pdcs = list()		//Our point defense cannons. They're added in the Initialize() call.
	var/list/storage = list()		//Ammo banks for the ship's defense grid.

	var/sensor_integrity = 100			//This also fucks with targeting accuracy.
	var/initial_sensors = 0				//num. Basically used to calculate the health of the sensor network.
	var/sensor_loss_warning = FALSE		//If this is true, we've sent word to the crew that the cannons have little chance of intercepting.

	var/alert_sound = 'sound/effects/caution.ogg'

	id_tag = "default"

/obj/machinery/point_defense/point_defense_computer/Initialize()
	for(var/obj/machinery/point_defense/point_defense_cannon/C in SSmachines.machinery)
		if(C.id_tag == id_tag)
			pdcs += C
			C.mainframe = src

	for(var/obj/machinery/point_defense/point_defense_sensor/S in SSmachines.machinery)
		if(S.id_tag == id_tag)
			sensors += S
			S.mainframe = src

	for(var/obj/machinery/point_defense/ammo_storage/A in SSmachines.machinery)
		if(A.id_tag == id_tag)
			storage += A
			A.mainframe = src

	initial_sensors = sensors.len //Set initial_sensors for sensor health comparison. As long as every sensor in the list reports that it's online, sensor integrity is fine.

	update_sensor_status()

	update_icon()
	..()

/obj/machinery/point_defense/point_defense_computer/Destroy()
	. = ..()
	for(var/obj/machinery/point_defense/point_defense_sensor/M in sensors)
		M.mainframe = null
	for(var/obj/machinery/point_defense/point_defense_cannon/pdc in pdcs)
		pdc.mainframe = null
	for(var/obj/machinery/point_defense/ammo_storage/A in storage)
		A.mainframe = null


/obj/machinery/point_defense/point_defense_computer/Process()
	if(inoperable()) //Broken or no power.
		return
	update_sensor_status()

	update_icon()

/obj/machinery/point_defense/point_defense_computer/on_update_icon()
	overlays.Cut()
	if(stat & (MACHINE_BROKEN_HEALTH|MACHINE_STAT_NOPOWER))
		overlays.Cut()
		return
	if(sensor_integrity <= 0)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "mim_status_offline")
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_screen_offline")

	if(sensor_integrity <= 25)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "mim_status_25")
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_screen_alert")

	if(sensor_integrity <= 50)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "mim_status_50")
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_screen_caution")

	if(sensor_integrity <= 75)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "mim_status_75")
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_screen_norm")

	if(sensor_integrity == 100)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "mim_status_100")
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_screen_norm")

/obj/machinery/point_defense/point_defense_computer/proc/update_sensor_status()
	var/operable_sensors = 0
	for(var/obj/machinery/point_defense/point_defense_sensor/S in sensors)
		if(!S.report_status())
			continue
		operable_sensors++

	if(!operable_sensors) //no div by zero errors pls, just stop here.
		sensor_integrity = 0
		return

	if(operable_sensors != initial_sensors) //Uh oh. Something's broken or unpowered.
		sensor_integrity = round((initial_sensors/operable_sensors)*100)

/obj/machinery/point_defense/point_defense_computer/proc/get_miss_chance()
	if(sensor_integrity == 100)
		return 0 //No extra miss chance.
	else
		var/extra_miss_chance = (100-sensor_integrity) / 2
		return extra_miss_chance

// Ammo Stuff
/obj/machinery/point_defense/point_defense_computer/proc/use_ammo()
	for(var/obj/machinery/point_defense/ammo_storage/A in storage)
		A.remove_ammo()

/obj/machinery/point_defense/point_defense_computer/proc/can_use_ammo()
	for(var/obj/machinery/point_defense/ammo_storage/A in storage)
		A.can_remove_ammo()

// Alerts (message, from, channel)
/obj/machinery/point_defense/point_defense_computer/proc/interception_complete()
	GLOB.global_headset.autosay("Target Lost or Intercepted", "Interception Grid", "Command")
	sleep(3)

	for(var/obj/machinery/point_defense/ammo_storage/A in storage)
		GLOB.global_headset.autosay("Munition level of BARDICHE grid: [round(A.ammo, 0.1)]%", "Interception Grid", "Command")
	sleep(6)

	for(var/obj/machinery/point_defense/point_defense_sensor/S in sensors)
		if(!S.report_status())
			GLOB.global_headset.autosay("Chance of next interception failure: [round(get_miss_chance(), 0.1)]%", "Interception Grid", "Command")

		if(sensor_loss_warning)//They know that it'll be bad. Don't use the fluff text.
			GLOB.global_headset.autosay("Chance of next interception failure: [round(get_miss_chance(), 0.1)]%", "BARDICHE On-Board Targeting", "Command")

		else
			GLOB.global_headset.autosay("Chance of next interception failure: FAILURE TO CONNECT TO GRID", "Interception Grid", "Command")
			sleep(12)
			GLOB.global_headset.autosay("Chance of next interception failure: SENSOR GRID LOST", "Interception Grid", "Command")
			sleep(24)
			GLOB.global_headset.autosay("EMERGENCY. REVERTING TO ON-BOARD TARGETING.", "BARDICHE Grid Targeting", "Common")
			sensor_loss_warning = TRUE
			var/turf/parent_ship_alert = GetConnectedZlevels(get_z(src))
			if(parent_ship_alert)
				playsound(parent_ship_alert, alert_sound, 10, FALSE, 0, 0, 0)
	return
