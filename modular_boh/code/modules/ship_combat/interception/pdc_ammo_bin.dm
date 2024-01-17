/obj/machinery/point_defense/ammo_storage
	name = "munition lift"
	desc = "One of the main munition lifts for the ship's 'Bardiche' defense grid. From here, an autoloader handles the rest. \
	Complex. Expensive. Somehow the two former while simple enough that even you can handle it. Just how SolGov likes it."

	var/ammo = 300 //How much ammo we have
	var/max_ammo = 300
	var/obj/machinery/point_defense/point_defense_computer/mainframe
	var/orientation

	var/individual_shell_sound = 'modular_boh/sounds/machines/pdc/indiv_pdc_reload.ogg'
	var/full_lift_sound = 'modular_boh/sounds/machines/pdc/indiv_pdc_reload.ogg'

/obj/machinery/point_defense/ammo_storage/Destroy()
	. = ..()
	mainframe.storage = null

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

	if(ammo == max_ammo)
		overlays += image('modular_boh/icon/boh/structures/pdc_mainframe.dmi', "pdc_ammo_[orientation]")
		return

/obj/machinery/point_defense/ammo_storage/proc/add_ammo()
	ammo = initial(ammo)//You wasted an entire box to refill that singular missing casing. L
	playsound(src, full_lift_sound, 10, FALSE, 0, 0, 0)
	update_icon()

/obj/machinery/point_defense/ammo_storage/proc/can_add_ammo()
	if(ammo < max_ammo)
		return TRUE
	else
		return FALSE

/obj/machinery/point_defense/ammo_storage/proc/remove_ammo(amount)
	if(ammo)
		ammo -= amount
	ammo = clamp(ammo, 0, max_ammo)

	playsound(src, individual_shell_sound, 10, FALSE, 0, 0, 0)

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

/obj/machinery/point_defense/ammo_storage/attackby(obj/item/W, mob/user)
	if(!can_add_ammo())
		return
	if(!do_after(user, 2 SECONDS, src))
		add_ammo()
		return
	to_chat(user, SPAN_NOTICE("You finish feeding the material into a hopper."))

// The ammo container itself, used for one-time reloads. Really should just have it be handled elsewhere.
/obj/item/pdc_ammo_can
	name = "Munition Bin"
	icon = 'modular_boh/icon/boh/structures/pdc_mainframe.dmi'
	icon_state = "pdc_ammo"
	w_class = ITEM_SIZE_NO_CONTAINER
	desc = "An incredibly heavy, though secure box, containing enough material for the ship's point defence grid to produce additional shells. \
	Much easier than lugging around massive cartridges, though stupidly expensive. Don't break anything, or it'll come out of your savings."
	var/linked

/obj/item/pdc_ammo_can/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.get_organ(BP_R_HAND)
		if (user.hand)
			temp = H.get_organ(BP_L_HAND)
		if(!temp)
			to_chat(user, SPAN_WARNING("You need two hands to pick this up!"))
			return

	if(user.get_inactive_hand())
		to_chat(user, SPAN_WARNING("You need your other hand to be empty"))
		return
	return ..()

/obj/item/pdc_ammo_can/pickup(mob/user)
	var/obj/item/pdc_ammo_can/offhand/O = new(user)
	O.SetName("[name] - second hand")
	O.desc = "Your second grip on the [name]."
	O.linked = src
	user.put_in_inactive_hand(O)
	linked = O
	return

/obj/item/pdc_ammo_can/dropped(mob/user as mob)
	qdel(linked)
	return ..()

//Offhand
/obj/item/pdc_ammo_can/offhand
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "offhand"
	name = "second hand"

/obj/item/pdc_ammo_can/offhand/dropped(mob/user as mob)
	..()
	user.drop_from_inventory(linked)
	return
