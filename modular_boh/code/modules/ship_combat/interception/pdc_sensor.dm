//If the mainframe suffers from sensor loss or damage, interception success chance goes with it.

/obj/machinery/point_defense/point_defense_sensor
	name = "interception grid node"
	desc = "An advanced computer, capable of tracking and relaying targets to the 'Bardiche' grid as required."
	icon_state = "commdish"

	var/obj/machinery/point_defense/point_defense_computer/mainframe
	var/health = 100
	var/max_health = 100

	id_tag = "default"

/obj/machinery/point_defense/point_defense_sensor/Destroy()
	. = ..()
	mainframe.sensors -= src

/obj/machinery/point_defense/point_defense_sensor/proc/report_status()
	if(inoperable())
		return FALSE
	else
		return TRUE

/obj/machinery/point_defense/point_defense_sensor/Process()
	update_health()

/obj/machinery/point_defense/point_defense_sensor/proc/update_health()
	if(health <= 0)
		set_broken(TRUE, MACHINE_BROKEN_HEALTH)
		health = clamp(health, 0, max_health) //clamp it to 0 if we're negative.
	if(health > 0 && (stat & MACHINE_BROKEN_HEALTH))
		set_broken(FALSE, MACHINE_BROKEN_HEALTH)

/obj/machinery/point_defense/point_defense_sensor/ex_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(severity == 1)
		health = 0
		set_broken(TRUE, MACHINE_BROKEN_HEALTH)
	else
		health -= rand(5,15)
		update_health()
