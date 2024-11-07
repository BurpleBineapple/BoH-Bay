/datum/species/customhuman
	name = SPECIES_HUMAN2
	name_plural = SPECIES_HUMAN2
	icobase = 'modular_mithra/icons/mob/human_races/species/custom_human/body.dmi'
	deform = 'modular_mithra/icons/mob/human_races/species/custom_human/deformed_body.dmi'
	husk_icon = 'modular_mithra/icons/mob/human_races/species/custom_human/husk.dmi'
//	preview_icon = 'modular_mithra/icons/mob/human_races/species/custom_human/preview.dmi' No preview icon yet. I dunno if this breaks things - YES IT DOES.
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = TRUE

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE //Used only for custom species. Should not be selectable as a race by itself

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)

	description = "If you see this, you're either an admin or something has gone wrong"

	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	sexybits_location = BP_GROIN //this is possibly my favorite variable just because of how out of place it is.


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
		)
	)

/datum/species/customhuman/get_bodytype(mob/living/carbon/human/H)
	return SPECIES_HUMAN
