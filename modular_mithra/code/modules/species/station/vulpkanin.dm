/datum/species/vulpkanin
	name = SPECIES_VULP
	name_plural = SPECIES_VULP
	icobase = 'modular_mithra/icons/mob/human_races/species/vulpkanin/body.dmi'
	//deform = 'modular_mithra/icons/mob/human_races/species/vulpkanin/deformed_body.dmi' They don't have deformed icons. Hopefully this doesn't cause problems
	husk_icon = 'modular_mithra/icons/mob/human_races/species/vulpkanin/husk.dmi'
	preview_icon = 'modular_mithra/icons/mob/human_races/species/vulpkanin/preview.dmi'
	modular_tail = 'modular_mithra/icons/mob/human_races/species/vulpkanin/tail.dmi'
	tail = "vulptail"
	limb_blend = ICON_MULTIPLY
	tail_blend = ICON_MULTIPLY
	default_ears = /datum/sprite_accessory/ears/vulp
	hidden_from_codex = FALSE

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/claws)

	description = "Vulpkanin is a catch-all term for all sorts of canid-like genemods. Vulpkanin genemods, initially patented by VeyMed, were made popular about the middle of the 22nd century, and have only increased in number since. It's such a prolific type of genemod that there are entire communities of naturally-reproducing, self-sustaining populations. You could be from anywhere- Sol space, or the Frontier, or maybe even the UCG, as looked down upon as you would be."

	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_IS_ICONBASE
	appearance_flags = SPECIES_APPEARANCE_HAS_HAIR_COLOR | SPECIES_APPEARANCE_HAS_UNDERWEAR | SPECIES_APPEARANCE_HAS_SKIN_COLOR | SPECIES_APPEARANCE_HAS_EYE_COLOR

	sexybits_location = BP_GROIN //this is possibly my favorite variable just because of how out of place it is. - cebu | what the hell does it even do -tori | Basically it just defines where you can hit them for massive (pain) damage. An entire variable dedicated to nutshots. -cebu


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

/datum/species/vulpkanin/proc/handle_coco(mob/living/carbon/human/M, datum/reagent/nutriment/coco, efficiency = 1)
	var/effective_dose = efficiency * M.chem_doses[coco.type]
	if(effective_dose < 5)
		return
	M.druggy = max(M.druggy, 10)
	M.add_chemical_effect(CE_PULSE, -1)
	if(effective_dose > 15 && prob(7))
		M.emote(pick("twitch", "drool"))
	if(effective_dose > 20 && prob(10))
		M.SelfMove(pick(GLOB.cardinal))
