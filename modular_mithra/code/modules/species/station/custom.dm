/*
	THE GLORIOUS CUSTOM SPECIES PORT, code copypasta'd from Virgo. Direct all complaints to Toriate.
*/

/datum/species
	var/base_species = null // Unused outside of certain stuff
	var/selects_bodytype = FALSE // Allows the species to choose from body types intead of being forced to be just one.
	var/modular_tail
	var/default_ears

/mob/living/carbon/human/proc/get_display_species()

/datum/species/custom
	name = SPECIES_CUSTOM
	name_plural = SPECIES_CUSTOM
	selects_bodytype = TRUE
	base_species = SPECIES_HUMAN
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)

	description = "This is a genemodded species - either human or some of established ones. It can also work as \
	subspecies or hybrid of some sorts. Here you can assign various gene traits to them as you wish, to create \
	a (hopefully) balanced genemodder. You will see the options to customize them on the Genemods tab once \
	you select and set this species as your species, so please, look into here if you select this."

	min_age = 18
	max_age = 200
	health_hud_intensity = 2

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_LIPS | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	sexybits_location = BP_GROIN //hit here to dick kickem

	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)

	traits = list()

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_HUMAN_MARTIAN,
			CULTURE_HUMAN_MARSTUN,
			CULTURE_HUMAN_LUNAPOOR,
			CULTURE_HUMAN_LUNARICH,
			CULTURE_HUMAN_VENUSIAN,
			CULTURE_HUMAN_VENUSLOW,
			CULTURE_HUMAN_BELTER,
			CULTURE_HUMAN_KUIPERI,
			CULTURE_HUMAN_KUIPERO,
			CULTURE_HUMAN_MAGNITKA,
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_CETIN,
			CULTURE_HUMAN_CETIS,
			CULTURE_HUMAN_CETII,
			CULTURE_HUMAN_SPACER,
			CULTURE_HUMAN_OFFWORLD,
			CULTURE_HUMAN_THEIA,
			CULTURE_HUMAN_CONFED_TERRA,
			CULTURE_HUMAN_CONFED_ZEMLYA,
			CULTURE_HUMAN_CONFED_SESTRIS,
			CULTURE_HUMAN_CONFED_PUTKARI,
			CULTURE_HUMAN_CONFED_ALTAIR,
			CULTURE_HUMAN_CONFED_PENGLAI,
			CULTURE_HUMAN_CONFED_PROVIDENCE,
			CULTURE_HUMAN_CONFED_VALY,
			CULTURE_HUMAN_CONFEDO,
			CULTURE_HUMAN_FOSTER,
			CULTURE_HUMAN_PIRXL,
			CULTURE_HUMAN_PIRXB,
			CULTURE_HUMAN_PIRXF,
			CULTURE_HUMAN_TADMOR,
			CULTURE_HUMAN_IOLAUS,
			CULTURE_HUMAN_BRAHE,
			CULTURE_HUMAN_EOS,
			CULTURE_HUMAN_GAIAN,
			CULTURE_HUMAN_OTHER
		),
		TAG_FACTION = list(
			FACTION_SOL_CENTRAL,
			FACTION_FLEET,
		//	FACTION_CORPORATE,
			FACTION_INDIE_CONFED,
		//	FACTION_EXPEDITIONARY,
			FACTION_SPACECOPS,
			FACTION_NANOTRASEN,
			FACTION_MARINES,
			FACTION_XYNERGY,
			FACTION_HEPHAESTUS,
			FACTION_FREETRADE,
			FACTION_PCRC,
			FACTION_DAIS,
			FACTION_OTHER,
			FACTION_SKRELL_QERRVOAL,
			FACTION_SKRELL_QALAOA,
			FACTION_SKRELL_YIITALANA,
			FACTION_SKRELL_KRRIGLI,
			FACTION_SKRELL_QONPRRI,
			//FACTION_UNATHI_POLAR,
			//FACTION_UNATHI_DESERT,
			//FACTION_UNATHI_SAVANNAH,
			//FACTION_UNATHI_DIAMOND_PEAK,
			//FACTION_UNATHI_SALT_SWAMP,
			FACTION_UNATHI_YEOSA,
			FACTION_SERGAL_GOLD_RING,
			FACTION_SERGAL_SHIGU,
			FACTION_SERGAL_REONO
		),
		TAG_RELIGION = list(
			RELIGION_OTHER,
			RELIGION_JUDAISM,
			RELIGION_HINDUISM,
			RELIGION_BUDDHISM,
			RELIGION_JAINISM,
			RELIGION_SIKHISM,
			RELIGION_ISLAM,
			RELIGION_CHRISTIANITY,
			RELIGION_BAHAI_FAITH,
			RELIGION_AGNOSTICISM,
			RELIGION_DEISM,
			RELIGION_ATHEISM,
			RELIGION_THELEMA,
			RELIGION_SPIRITUALISM,
			RELIGION_SHINTO,
			RELIGION_TAOISM,
			RELIGION_SERGAL_ANIMISM,
			RELIGION_SERGAL_GOLD_RING,
			RELIGION_UNATHI_VINE,
			RELIGION_UNATHI_PRECURSOR,
			RELIGION_UNATHI_STRATAGEM,
			RELIGION_UNATHI_LIGHTS
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_MARS,
			HOME_SYSTEM_LUNA,
			HOME_SYSTEM_EARTH,
			HOME_SYSTEM_VENUS,
			HOME_SYSTEM_CERES,
			HOME_SYSTEM_KUIPERB,
			HOME_SYSTEM_KUIPERD,
			HOME_SYSTEM_TAU_CETI,
			HOME_SYSTEM_MAGNITKA,
			HOME_SYSTEM_HELIOS,
			HOME_SYSTEM_TERRA,
			HOME_SYSTEM_SAFFAR,
			HOME_SYSTEM_PIRX,
			HOME_SYSTEM_TADMOR,
			HOME_SYSTEM_BRAHE,
			HOME_SYSTEM_IOLAUS,
			HOME_SYSTEM_FOSTER,
			HOME_SYSTEM_CASTILLA,
			HOME_SYSTEM_GAIA,
			HOME_SYSTEM_MAGNITKA,
			HOME_SYSTEM_OTHER
		)
	)

/datum/species/custom/get_bodytype()
	var/datum/species/real = all_species[base_species]
	return real.name

/datum/species/custom/get_icobase(mob/living/carbon/human/H, get_deform)
	var/datum/species/real = all_species[base_species]
	return real.get_icobase(H, get_deform)

/datum/species/custom/get_race_key(mob/living/carbon/human/H)
	var/datum/species/real = all_species[base_species]
	return real.race_key

/datum/species/custom/post_organ_rejuvenate(obj/item/organ/org, mob/living/carbon/human/H)	//This is required so custom species do not revert to humans on rejuvenate.
	var/obj/item/organ/external/E = org
	if(H && istype(E))
		E.custom_species_override = H.species.base_species
		E.species = H.species
		if(!BP_IS_ROBOTIC(E))	//Check if the limb is robotic
			E.force_icon = H.species.get_icobase()

/datum/species/custom/proc/produceCopy(datum/species/to_copy,list/traits,mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = all_species[to_copy]

	var/datum/species/custom/new_copy = new()

	//Initials so it works with a simple path passed, or an instance
	new_copy.base_species = to_copy.name
	new_copy.icobase = to_copy.icobase
	new_copy.deform = to_copy.deform
	new_copy.tail = to_copy.tail
	new_copy.tail_animation = to_copy.tail_animation
	new_copy.modular_tail = to_copy.modular_tail
	new_copy.tail_hair = to_copy.tail_hair
	new_copy.limb_blend = to_copy.limb_blend
	new_copy.tail_blend = to_copy.tail_blend
	new_copy.primitive_form = to_copy.primitive_form
	new_copy.appearance_flags = to_copy.appearance_flags
	new_copy.flesh_color = to_copy.flesh_color
	new_copy.base_color = to_copy.base_color
	new_copy.blood_mask = to_copy.blood_mask
	new_copy.damage_mask = to_copy.damage_mask
	new_copy.damage_overlays = to_copy.damage_overlays
	new_copy.traits = traits
	new_copy.move_trail = move_trail

	//If you had traits, apply them
	if(new_copy.traits)
		for(var/trait in new_copy.traits)
			var/datum/trait/T = all_traits[trait]
			T.apply(new_copy,H)

	//Set up a mob
	H.species = new_copy

	if(new_copy.holder_type)
		H.holder_type = new_copy.holder_type

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy

// Stub species overrides for shoving trait abilities into

//Called when face-down in the water or otherwise over their head.
// Return: TRUE for able to breathe fine in water.
///datum/species/custom/can_drown()
//	return ..()

//Called during handle_environment in Life() ticks.
// Return: Not used.
/datum/species/custom/handle_environment_special(mob/living/carbon/human/H)
	return ..()

//Called when spawning to equip them with special things.
/datum/species/custom/equip_survival_gear(mob/living/carbon/human/H)
	/* Example, from Vox:
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_back)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H), slot_r_hand)
		H.internal = H.back
	else
		H.equip_to_slot_or_del(new /obj/item/tank/vox(H), slot_r_hand)
		H.equip_to_slot_or_del(new /obj/item/storage/box/vox(H.back), slot_in_backpack)
		H.internal = H.r_hand
	H.internal = locate(/obj/item/tank) in H.contents
	if(istype(H.internal,/obj/item/tank) && H.internals)
		H.internals.icon_state = "internal1"
	*/
	return ..()

/datum/species/custom/get_bodytype(mob/living/carbon/human/H)
	return SPECIES_HUMAN
