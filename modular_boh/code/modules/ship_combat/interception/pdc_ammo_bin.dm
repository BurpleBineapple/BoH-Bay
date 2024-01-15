/obj/machinery/point_defense/ammo_storage
	name = "point defense ammo storage"
	desc = "One of the centralized ammo storages for the ship's point defense mainframe."

	var/ammo = 300 //How much ammo we have
	var/max_ammo = 300
	var/obj/machinery/point_defense/point_defense_cannon/pdc //The point defense cannon we're linked to.
	var/orientation

/obj/machinery/point_defense/ammo_storage/Destroy()
	. = ..()
	pdc.storage = null

/obj/machinery/point_defense/ammo_storage/on_update_icon()
	if(!icon_state)
		icon_state = "pdc_[orientation]"

	overlays.Cut()

	if(!ammo)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]_empty")

	if(ammo <= max_ammo * 0.25)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]3")

	if(ammo <= max_ammo * 0.50)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]2")

	if(ammo <= max_ammo * 0.75)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]1")

	if(ammo == 100)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]")
		return

/obj/machinery/point_defense/ammo_storage/proc/remove_ammo(amount)
	if(ammo)
		ammo -= amount
	ammo = clamp(ammo, 0, max_ammo)
	update_icon()

/obj/machinery/point_defense/ammo_storage/proc/can_remove_ammo(amount)
	if(ammo >= amount)
		return TRUE
	else
		return FALSE

/obj/machinery/point_defense/ammo_storage/left
	orientation = "left"

/obj/machinery/point_defense/ammo_storage/right
	orientation = "right"
