/datum/species/vasilissan
	name = SPECIES_VASS
	name_plural = "Vasilissans"
	icobase = 'modular_mithra/icons/mob/human_races/species/vasilissan/body.dmi'
	deform = 'modular_mithra/icons/mob/human_races/species/vasilissan/deformed_body.dmi'
	husk_icon = 'modular_mithra/icons/mob/human_races/species/vasilissan/husk.dmi'
	preview_icon = 'modular_mithra/icons/mob/human_races/species/vasilissan/preview.dmi'
	modular_tail = 'modular_mithra/icons/mob/human_races/species/vasilissan/tail.dmi'
	tail = "spidertail"
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/claws)

	description = "Vasilissans are a race of enlightened, spider-like people. They have the distinction of being one of the only races that was spared from a war upon being discovered. This was due to already being in the atomic era when they were found by the now-defunct NanoTrasen Surveyor Corps. They've integrated rather well into interstellar society, with only a few hiccups in political relations, mostly involving the fact they are spiders."

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	sexybits_location = BP_GROIN //this is possibly my favorite variable just because of how out of place it is. - cebu | what the hell does it even do -tori | Basically it just defines where you can hit them for massive (pain) damage. An entire variable dedicated to nutshots. -cebu  | do these guys even have junk in their groin??? -cebu


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
