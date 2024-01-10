/////////////////////////////
// Helpers for DNA2
/////////////////////////////


// DNA Gene activation boundaries, see dna2.dm.
// Returns a list object with 4 numbers.
/proc/GetDNABounds(block)
	var/list/BOUNDS=dna_activity_bounds[block]
	if(!istype(BOUNDS))
		return DNA_DEFAULT_BOUNDS
	return BOUNDS

// Give Random Bad Mutation to M
/proc/randmutb(mob/living/M)
	if(!M) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.should_have_organ(BP_HEART))
			return
	M.dna.check_integrity()
	var/block = pick(GLOB.GLASSESBLOCK,GLOB.COUGHBLOCK,GLOB.FAKEBLOCK,GLOB.NERVOUSBLOCK,GLOB.CLUMSYBLOCK,GLOB.TWITCHBLOCK,GLOB.HEADACHEBLOCK,GLOB.BLINDBLOCK,GLOB.DEAFBLOCK,GLOB.HALLUCINATIONBLOCK)
	M.dna.SetSEState(block, 1)

// Give Random Good Mutation to M
/proc/randmutg(mob/living/M)
	if(!M) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.should_have_organ(BP_HEART))
			return
	M.dna.check_integrity()
	var/block = pick(GLOB.FERALBLOCK,GLOB.XRAYBLOCK,GLOB.FIREBLOCK,GLOB.TELEBLOCK,GLOB.NOBREATHBLOCK,GLOB.REMOTEVIEWBLOCK,GLOB.REGENERATEBLOCK,GLOB.INCREASERUNBLOCK,GLOB.REMOTETALKBLOCK,GLOB.MORPHBLOCK,GLOB.BLENDBLOCK,GLOB.NOPRINTSBLOCK,GLOB.SHOCKIMMUNITYBLOCK,GLOB.SMALLSIZEBLOCK)
	M.dna.SetSEState(block, 1)

// Random Appearance Mutation
/proc/randmuti(mob/living/M)
	if(!M) return
	M.dna.check_integrity()
	M.dna.SetUIValue(rand(1,DNA_UI_LENGTH),rand(1,4095))

// Scramble UI or SE.
/proc/scramble(UI, mob/M, prob)
	if(!M)	return
	M.dna.check_integrity()
	if(UI)
		for(var/i = 1, i <= DNA_UI_LENGTH-1, i++)
			if(prob(prob))
				M.dna.SetUIValue(i,rand(1,4095),1)
		M.dna.UpdateUI()
		M.UpdateAppearance()

	else
		for(var/i = 1, i <= DNA_SE_LENGTH-1, i++)
			if(prob(prob))
				M.dna.SetSEValue(i,rand(1,4095),1)
		M.dna.UpdateSE()
		domutcheck(M, null)
	return

// I haven't yet figured out what the fuck this is supposed to do.
/proc/miniscramble(input,rs,rd)
	var/output
	output = null
	if (input == "C" || input == "D" || input == "E" || input == "F")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"6",prob((rs*10));"7",prob((rs*5)+(rd));"0",prob((rs*5)+(rd));"1",prob((rs*10)-(rd));"2",prob((rs*10)-(rd));"3")
	if (input == "8" || input == "9" || input == "A" || input == "B")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if (input == "4" || input == "5" || input == "6" || input == "7")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if (input == "0" || input == "1" || input == "2" || input == "3")
		output = pick(prob((rs*10));"8",prob((rs*10));"9",prob((rs*10));"A",prob((rs*10));"B",prob((rs*10)-(rd));"C",prob((rs*10)-(rd));"D",prob((rs*5)+(rd));"E",prob((rs*5)+(rd));"F")
	if (!output) output = "5"
	return output

// HELLO I MAKE BELL CURVES AROUND YOUR DESIRED TARGET
// So a shitty way of replacing gaussian noise.
// input: YOUR TARGET
// rs: RAD STRENGTH
// rd: DURATION
/proc/miniscrambletarget(input,rs,rd)
	var/output = null
	switch(input)
		if("0")
			output = pick(prob((rs*10)+(rd));"0",prob((rs*10)+(rd));"1",prob((rs*10));"2",prob((rs*10)-(rd));"3")
		if("1")
			output = pick(prob((rs*10)+(rd));"0",prob((rs*10)+(rd));"1",prob((rs*10)+(rd));"2",prob((rs*10));"3",prob((rs*10)-(rd));"4")
		if("2")
			output = pick(prob((rs*10));"0",prob((rs*10)+(rd));"1",prob((rs*10)+(rd));"2",prob((rs*10)+(rd));"3",prob((rs*10));"4",prob((rs*10)-(rd));"5")
		if("3")
			output = pick(prob((rs*10)-(rd));"0",prob((rs*10));"1",prob((rs*10)+(rd));"2",prob((rs*10)+(rd));"3",prob((rs*10)+(rd));"4",prob((rs*10));"5",prob((rs*10)-(rd));"6")
		if("4")
			output = pick(prob((rs*10)-(rd));"1",prob((rs*10));"2",prob((rs*10)+(rd));"3",prob((rs*10)+(rd));"4",prob((rs*10)+(rd));"5",prob((rs*10));"6",prob((rs*10)-(rd));"7")
		if("5")
			output = pick(prob((rs*10)-(rd));"2",prob((rs*10));"3",prob((rs*10)+(rd));"4",prob((rs*10)+(rd));"5",prob((rs*10)+(rd));"6",prob((rs*10));"7",prob((rs*10)-(rd));"8")
		if("6")
			output = pick(prob((rs*10)-(rd));"3",prob((rs*10));"4",prob((rs*10)+(rd));"5",prob((rs*10)+(rd));"6",prob((rs*10)+(rd));"7",prob((rs*10));"8",prob((rs*10)-(rd));"9")
		if("7")
			output = pick(prob((rs*10)-(rd));"4",prob((rs*10));"5",prob((rs*10)+(rd));"6",prob((rs*10)+(rd));"7",prob((rs*10)+(rd));"8",prob((rs*10));"9",prob((rs*10)-(rd));"A")
		if("8")
			output = pick(prob((rs*10)-(rd));"5",prob((rs*10));"6",prob((rs*10)+(rd));"7",prob((rs*10)+(rd));"8",prob((rs*10)+(rd));"9",prob((rs*10));"A",prob((rs*10)-(rd));"B")
		if("9")
			output = pick(prob((rs*10)-(rd));"6",prob((rs*10));"7",prob((rs*10)+(rd));"8",prob((rs*10)+(rd));"9",prob((rs*10)+(rd));"A",prob((rs*10));"B",prob((rs*10)-(rd));"C")
		if("10")//A
			output = pick(prob((rs*10)-(rd));"7",prob((rs*10));"8",prob((rs*10)+(rd));"9",prob((rs*10)+(rd));"A",prob((rs*10)+(rd));"B",prob((rs*10));"C",prob((rs*10)-(rd));"D")
		if("11")//B
			output = pick(prob((rs*10)-(rd));"8",prob((rs*10));"9",prob((rs*10)+(rd));"A",prob((rs*10)+(rd));"B",prob((rs*10)+(rd));"C",prob((rs*10));"D",prob((rs*10)-(rd));"E")
		if("12")//C
			output = pick(prob((rs*10)-(rd));"9",prob((rs*10));"A",prob((rs*10)+(rd));"B",prob((rs*10)+(rd));"C",prob((rs*10)+(rd));"D",prob((rs*10));"E",prob((rs*10)-(rd));"F")
		if("13")//D
			output = pick(prob((rs*10)-(rd));"A",prob((rs*10));"B",prob((rs*10)+(rd));"C",prob((rs*10)+(rd));"D",prob((rs*10)+(rd));"E",prob((rs*10));"F")
		if("14")//E
			output = pick(prob((rs*10)-(rd));"B",prob((rs*10));"C",prob((rs*10)+(rd));"D",prob((rs*10)+(rd));"E",prob((rs*10)+(rd));"F")
		if("15")//F
			output = pick(prob((rs*10)-(rd));"C",prob((rs*10));"D",prob((rs*10)+(rd));"E",prob((rs*10)+(rd));"F")

	if(!input || !output) //How did this happen?
		output = "8"

	return output

// /proc/updateappearance has changed behavior, so it's been removed
// Use mob.UpdateAppearance() instead.

// Simpler. Don't specify UI in order for the mob to use its own.
/mob/proc/UpdateAppearance(list/UI=null)
	if(istype(src, /mob/living/carbon/human))
		if(UI!=null)
			src.dna.UI=UI
			src.dna.UpdateUI()
		dna.check_integrity()
		var/mob/living/carbon/human/H = src

		H.head_hair_color = rgb(
			dna.GetUIValueRange(DNA_UI_HAIR_R, 255),
			dna.GetUIValueRange(DNA_UI_HAIR_G, 255),
			dna.GetUIValueRange(DNA_UI_HAIR_B, 255)
		)

		H.facial_hair_color = rgb(
			dna.GetUIValueRange(DNA_UI_BEARD_R, 255),
			dna.GetUIValueRange(DNA_UI_BEARD_G, 255),
			dna.GetUIValueRange(DNA_UI_BEARD_B, 255)
		)

		H.skin_color = rgb(
			dna.GetUIValueRange(DNA_UI_SKIN_R, 255),
			dna.GetUIValueRange(DNA_UI_SKIN_G, 255),
			dna.GetUIValueRange(DNA_UI_SKIN_B, 255)
		)

		H.eye_color = rgb(
			dna.GetUIValueRange(DNA_UI_EYES_R, 255),
			dna.GetUIValueRange(DNA_UI_EYES_G, 255),
			dna.GetUIValueRange(DNA_UI_EYES_B, 255)
		)

		H.update_eyes()

		H.skin_tone   = 35 - dna.GetUIValueRange(DNA_UI_SKIN_TONE, 220) // Value can be negative.

		if(H.gender != NEUTER)
			if (dna.GetUIState(DNA_UI_GENDER))
				H.gender = FEMALE
			else
				H.gender = MALE

		//Body markings
		for(var/tag in dna.body_markings)
			var/obj/item/organ/external/E = H.organs_by_name[tag]
			if(E)
				var/list/marklist = dna.body_markings[tag]
				E.markings = marklist.Copy()

		//Base skin and blend
		for(var/obj/item/organ/external/E in H.organs)
			E.set_dna(E.dna)

		//Hair
		var/hair = dna.GetUIValueRange(DNA_UI_HAIR_STYLE,length(GLOB.hair_styles_list))
		if((0 < hair) && (hair <= length(GLOB.hair_styles_list)))
			H.head_hair_style = GLOB.hair_styles_list[hair]

		//Facial Hair
		var/beard = dna.GetUIValueRange(DNA_UI_BEARD_STYLE,length(GLOB.facial_hair_styles_list))
		if((0 < beard) && (beard <= length(GLOB.facial_hair_styles_list)))
			H.facial_hair_style = GLOB.facial_hair_styles_list[beard]

//MIRTHA CODE BELOW. HESTIA ADDITION FOR GENEMODDERS.
		// Ears
		var/ears = dna.GetUIValueRange(DNA_UI_EAR_STYLE, ear_styles_list.len + 1) - 1
		if(ears <= 1)
			H.ear_style = null
		else if((0 < ears) && (ears <= ear_styles_list.len))
			H.ear_style = ear_styles_list[ear_styles_list[ears]]

		// Ear Color
		H.r_ears  = dna.GetUIValueRange(DNA_UI_EARS_R,    255)
		H.g_ears  = dna.GetUIValueRange(DNA_UI_EARS_G,    255)
		H.b_ears  = dna.GetUIValueRange(DNA_UI_EARS_B, 	  255)
		H.r_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_R,   255)
		H.g_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_G,   255)
		H.b_ears2 = dna.GetUIValueRange(DNA_UI_EARS2_B,	  255)

		//Tail
		var/tail = dna.GetUIValueRange(DNA_UI_TAIL_STYLE, tail_styles_list.len + 1) - 1
		if(tail <= 1)
			H.tail_style = null
		else if((0 < tail) && (tail <= tail_styles_list.len))
			H.tail_style = tail_styles_list[tail_styles_list[tail]]

		//Wing
		var/wing = dna.GetUIValueRange(DNA_UI_WING_STYLE, wing_styles_list.len + 1) - 1
		if(wing <= 1)
			H.wing_style = null
		else if((0 < wing) && (wing <= wing_styles_list.len))
			H.wing_style = wing_styles_list[wing_styles_list[wing]]

		//Wing Color
		H.r_wing   = dna.GetUIValueRange(DNA_UI_WING_R,    255)
		H.g_wing   = dna.GetUIValueRange(DNA_UI_WING_G,    255)
		H.b_wing   = dna.GetUIValueRange(DNA_UI_WING_B,    255)

		// Tail/Taur Color
		H.r_tail   = dna.GetUIValueRange(DNA_UI_TAIL_R,    255)
		H.g_tail   = dna.GetUIValueRange(DNA_UI_TAIL_G,    255)
		H.b_tail   = dna.GetUIValueRange(DNA_UI_TAIL_B,    255)
		H.r_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_R,   255)
		H.g_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_G,   255)
		H.b_tail2  = dna.GetUIValueRange(DNA_UI_TAIL2_B,   255)

		// Technically custom_species is not part of the UI, but this place avoids merge problems.
		H.custom_species = dna.custom_species
		if(istype(H.species,/datum/species/custom))
			var/datum/species/custom/CS = H.species
			var/datum/species/custom/new_CS = CS.produceCopy(dna.base_species,dna.species_traits,src)
			new_CS.blood_color = dna.blood_color
//MIRTHA CODE END

		H.force_update_limbs()
		H.update_body()
		H.update_eyes()
		H.update_hair()

		return 1
	else
		return 0
