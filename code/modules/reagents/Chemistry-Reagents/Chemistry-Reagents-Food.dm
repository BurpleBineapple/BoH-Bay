/datum/reagent/nutriment
	name = "Nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	var/nutriment_factor = 10 // Per unit
	var/hydration_factor = 0 // Per unit
	var/injectable = 0
	color = "#664330"
	value = 0.1

/datum/reagent/nutriment/mix_data(list/newdata, newamount)

	if(!islist(newdata) || !length(newdata))
		return

	//add the new taste data
	LAZYINITLIST(data)
	for(var/taste in newdata)
		if(taste in data)
			data[taste] += newdata[taste]
		else
			data[taste] = newdata[taste]

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(!totalFlavor)
		return
	for(var/taste in data)
		if(data[taste]/totalFlavor < 0.1)
			data -= taste

/datum/reagent/nutriment/affect_blood(mob/living/carbon/M, removed)
	if(!injectable)
		M.adjustToxLoss(0.2 * removed)
		return
	affect_ingest(M, removed)

/datum/reagent/nutriment/affect_ingest(mob/living/carbon/M, removed)
	if (protein_amount)
		handle_protein(M, src)
	M.heal_organ_damage(0.5 * removed, 0) //what

	adjust_nutrition(M, removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/datum/reagent/nutriment/proc/adjust_nutrition(mob/living/carbon/M, removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if (HAS_TRAIT(M, /singleton/trait/boon/cast_iron_stomach))
		removed *= 0.1 // Unathi get most of their nutrition from meat.
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/datum/reagent/nutriment/glucose
	name = "Glucose"
	color = "#ffffff"
	scannable = 1

	injectable = 1

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "Animal Protein"
	taste_description = "some sort of protein"
	color = "#440000"
	protein_amount = 1

/datum/reagent/nutriment/protein/adjust_nutrition(mob/living/carbon/M, removed)
	if (HAS_TRAIT(M, /singleton/trait/malus/animal_protein))
		return
	if (HAS_TRAIT(M, /singleton/trait/boon/cast_iron_stomach))
		removed *= 2.25
	M.adjust_nutrition(nutriment_factor * removed)

/datum/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"

//vegetamarian alternative that is safe for skrell to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.

/datum/reagent/nutriment/softtofu
	name = "plant protein"
	description = "A gooey pale bean paste."
	taste_description = "healthy sadness"
	color = "#ffffff"

//Fats
//=========================
/datum/reagent/nutriment/triglyceride
	name = "triglyceride"
	description = "More commonly known as fat, the third macronutrient, with over double the energy content of carbs and protein"

	reagent_state = SOLID
	nutriment_factor = 27//The caloric ratio of carb/protein/fat is 4:4:9
	color = "#cccccc"
	taste_description = "fat"

/datum/reagent/nutriment/triglyceride/oil
	//Having this base class incase we want to add more variants of oil
	name = "Oil"
	description = "Oils are liquid fats."
	reagent_state = LIQUID
	color = "#c79705"
	touch_met = 1.5
	var/lastburnmessage = 0
	taste_description = "some sort of oil"
	taste_mult = 0.1

/datum/reagent/nutriment/triglyceride/oil/initialize_data(newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list("temperature" = T20C)

/datum/reagent/nutriment/triglyceride/oil/touch_turf(turf/simulated/T)
	if(volume >= 3)
		T.wet_floor()
	new /obj/decal/cleanable/liquid_fuel(T, volume)
	remove_self(volume)
	return

//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/triglyceride/oil/mix_data(newdata, newamount)

	if (!data)
		data = list()

	var/ouramount = volume - newamount
	if (ouramount <= 0 || !data["temperature"] || !volume)
		//If we get here, then this reagent has just been created, just copy the temperature exactly
		data["temperature"] = newdata["temperature"]

	else
		//Our temperature is set to the mean of the two mixtures, taking volume into account
		var/total = (data["temperature"] * ouramount) + (newdata["temperature"] * newamount)
		data["temperature"] = total / volume

	return ..()


//Calculates a scaling factor for scalding damage, based on the temperature of the oil and creature's heat resistance
/datum/reagent/nutriment/triglyceride/oil/proc/heatdamage(mob/living/carbon/M)
	var/threshold = 360//Human heatdamage threshold
	var/datum/species/S = M.get_species(1)
	if (S && istype(S))
		threshold = S.heat_level_1

	//If temperature is too low to burn, return a factor of 0. no damage
	if (data["temperature"] < threshold)
		return 0

	//Step = degrees above heat level 1 for 1.0 multiplier
	var/step = 60
	if (S && istype(S))
		step = (S.heat_level_2 - S.heat_level_1)*1.5

	. = data["temperature"] - threshold
	. /= step
	. = min(., 2.5)//Cap multiplier at 2.5

/datum/reagent/nutriment/triglyceride/oil/affect_touch(mob/living/carbon/M, alien, removed)
	var/dfactor = heatdamage(M)
	if (dfactor)
		M.take_organ_damage(0, removed * 1.5 * dfactor)
		data["temperature"] -= (6 * removed) / (1 + volume*0.1)//Cools off as it burns you
		if (lastburnmessage+100 < world.time	)
			to_chat(M, SPAN_DANGER("Searing hot oil burns you, wash it off quickly!"))
			lastburnmessage = world.time

/datum/reagent/nutriment/triglyceride/oil/corn
	name = "Corn Oil"
	description = "An oil derived from corn."
	taste_description = "corn oil"

/datum/reagent/nutriment/honey
	name = "Honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"
	sugar_amount = 1

/datum/reagent/nutriment/flour
	name = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#ffffff"

/datum/reagent/nutriment/flour/touch_turf(turf/simulated/T)
	if(istype(T))
		new /obj/decal/cleanable/flour(T)
		if(T.wet > 1)
			T.wet = min(T.wet, 1)
		else
			T.wet = 0

/datum/reagent/nutriment/batter
	name = "Batter"
	description = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	reagent_state = LIQUID
	nutriment_factor = 3
	color = "#ffd592"
	protein_amount = 0.4

/datum/reagent/nutriment/batter/touch_turf(turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/decal/cleanable/pie_smudge(T)
		if(T.wet > 1)
			T.wet = min(T.wet, 1)
		else
			T.wet = 0

/datum/reagent/nutriment/batter/cakebatter
	name = "Cake Batter"
	description = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"
	protein_amount = 0.3

/datum/reagent/nutriment/coffee
	name = "Coffee Powder"
	description = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"

/datum/reagent/nutriment/coffee/instant
	name = "Instant Coffee Powder"
	description = "A bitter powder made by processing coffee beans."

/datum/reagent/nutriment/tea
	name = "Tea Powder"
	description = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/datum/reagent/nutriment/tea/instant
	name = "Instant Tea Powder"

/datum/reagent/nutriment/coco
	name = "Coco Powder"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"

/datum/reagent/nutriment/instantjuice
	name = "Juice Powder"
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/datum/reagent/nutriment/instantjuice/grape
	name = "Grape Juice Powder"
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/datum/reagent/nutriment/instantjuice/orange
	name = "Orange Juice Powder"
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/datum/reagent/nutriment/instantjuice/watermelon
	name = "Watermelon Juice Powder"
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/datum/reagent/nutriment/instantjuice/apple
	name = "Apple Juice Powder"
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/datum/reagent/nutriment/soysauce
	name = "Soysauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"

/datum/reagent/nutriment/ketchup
	name = "Ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"

/datum/reagent/nutriment/barbecue
	name = "Barbecue Sauce"
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#4f330f"

/datum/reagent/nutriment/garlicsauce
	name = "Garlic Sauce"
	description = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	reagent_state = LIQUID
	nutriment_factor = 4
	color = "#d8c045"

/datum/reagent/nutriment/rice
	name = "Rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#ffffff"

/datum/reagent/nutriment/rice/chazuke
	name = "Chazuke"
	description = "Green tea over rice. How rustic!"
	taste_description = "green tea and rice"
	taste_mult = 0.4
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#f1ffdb"

/datum/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801e28"

/datum/reagent/nutriment/cornoil
	name = "Corn Oil"
	description = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	reagent_state = LIQUID
	nutriment_factor = 20
	color = "#302000"

/datum/reagent/nutriment/cornoil/touch_turf(turf/simulated/T)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/hotspot) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 3)
		T.wet_floor()

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"

/datum/reagent/nutriment/mint
	name = "Mint"
	description = "Also known as Mentha."
	taste_description = "sweet mint"
	reagent_state = LIQUID
	color = "#07aab2"

/datum/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#bbeda4"
	overdose = REAGENTS_OVERDOSE
	value = 0.11

/datum/reagent/lipozine/affect_blood(mob/living/carbon/M, removed)
	M.adjust_nutrition(-10)

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = "Table Salt"
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#ffffff"
	overdose = REAGENTS_OVERDOSE
	value = 0.11

/datum/reagent/blackpepper
	name = "Black Pepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	reagent_state = SOLID
	color = "#000000"
	value = 0.1

/datum/reagent/enzyme
	name = "Universal Enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365e30"
	overdose = REAGENTS_OVERDOSE
	value = 0.2

/datum/reagent/frostoil
	name = "Chilly Oil"
	description = "An oil harvested from a mutant form of chili peppers, it has a chilling effect on the body."
	taste_description = "arctic mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#07aab2"
	value = 0.2

/datum/reagent/frostoil/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(/datum/reagent/capsaicin, 5)

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#b31008"
	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10
	value = 0.2

/datum/reagent/capsaicin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/capsaicin/affect_ingest(mob/living/carbon/M, removed)
	if(IS_METABOLICALLY_INERT(M) || M.HasTrait(/singleton/trait/boon/cast_iron_stomach))
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] < agony_dose)
		if(prob(5) || M.chem_doses[type] == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, EFFECT_PAIN, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(/datum/reagent/frostoil, 5)

/datum/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "scorching agony"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 5 // Get rid of it quickly
	color = "#b31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15

/datum/reagent/capsaicin/condensed/affect_touch(mob/living/carbon/M, removed)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/partial_mouth_covered = 0
	var/stun_probability = 50
	var/no_pain = 0
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null
	var/obj/item/partial_face_protection = null

	var/permeability = GET_TRAIT_LEVEL(M, /singleton/trait/general/permeable_skin)
	var/effective_strength = 5 + (3 * permeability)

	var/list/protection
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		protection = list(H.head, H.glasses, H.wear_mask)
		if(!H.can_feel_pain())
			no_pain = 1 //TODO: living-level can_feel_pain() proc
	else
		protection = list(M.wear_mask)

	for(var/obj/item/I in protection)
		if(I)
			if(I.body_parts_covered & EYES)
				eyes_covered = 1
				eye_protection = I.name
			if((I.body_parts_covered & FACE) && !(I.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name
			else if(I.body_parts_covered & FACE)
				partial_mouth_covered = 1
				partial_face_protection = I.name

	if(eyes_covered)
		if(!mouth_covered)
			to_chat(M, SPAN_WARNING("Your [eye_protection] protects your eyes from the pepperspray!"))
	else
		to_chat(M, SPAN_WARNING("The pepperspray gets in your eyes!"))
		M.mod_confused(2)
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
			M.eye_blind = max(M.eye_blind, effective_strength)
		else
			M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
			M.eye_blind = max(M.eye_blind, effective_strength * 2)

	if(mouth_covered)
		to_chat(M, SPAN_WARNING("Your [face_protection] protects you from the pepperspray!"))
	else if(!no_pain)
		if(partial_mouth_covered)
			to_chat(M, SPAN_WARNING("Your [partial_face_protection] partially protects you from the pepperspray!"))
			stun_probability *= 0.5
		to_chat(M, SPAN_DANGER("Your face and throat burn!"))
		if(M.stunned > 0  && !M.lying)
			M.Weaken(4)
		if(prob(stun_probability))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
			M.Stun(3)

/datum/reagent/capsaicin/condensed/affect_ingest(mob/living/carbon/M, removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] == metabolism)
		to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
	else
		M.apply_effect(6, EFFECT_PAIN, 0)
		if(prob(5))
			to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
			M.custom_emote(2, "[pick("coughs.","gags.","retches.")]")
			M.Stun(2)
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(/datum/reagent/frostoil, 5)

/datum/reagent/nutriment/vinegar
	name = "Vinegar"
	description = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	reagent_state = LIQUID
	color = "#e8dfd0"
	taste_mult = 3

/datum/reagent/nutriment/mayo
	name = "Mayonnaise"
	description = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	reagent_state = LIQUID
	color = "#efede8"
	taste_mult = 2
	protein_amount = 0.7

/*
	Coatings are used in cooking. Dipping food items in a reagent container with a coating in it
	allows it to be covered in that, which will add a masked overlay to the sprite.

	Coatings have both a raw and a cooked image. Raw coating is generally unhealthy
	Generally coatings are intended for deep frying foods
*/

/datum/reagent/nutriment/coating
	nutriment_factor = 6 //Less dense than the food itself, but coatings still add extra calories
	var/messaged = 0
	var/icon_raw
	var/icon_cooked
	var/coated_adj = "coated"
	var/cooked_name = "coating"
	taste_description = "some sort of frying coating"

/datum/reagent/nutriment/coating/affect_ingest(mob/living/carbon/M, alien, removed)

	//We'll assume that the batter isnt going to be regurgitated and eaten by someone else. Only show this once
	if (data["cooked"] != 1)
		if (!messaged)
			to_chat(M, SPAN_WARNING("This raw [name] tastes disgusting!"))
			nutriment_factor *= 0.5
			messaged = 1

		//Raw coatings will sometimes cause vomiting
		if (ishuman(M) && prob(1))
			var/mob/living/carbon/human/H = M
			H.vomit()
	..()

/datum/reagent/nutriment/coating/initialize_data(newdata) // Called when the reagent is created.
	..()
	if (!data)
		data = list()
	else
		if (isnull(data["cooked"]))
			data["cooked"] = 0
		return
	data["cooked"] = 0
	if (holder && holder.my_atom && istype(holder.my_atom,/obj/item/reagent_containers/food/snacks))
		data["cooked"] = 1
		name = cooked_name

		//Batter which is part of objects at compiletime spawns in a cooked state


//Handles setting the temperature when oils are mixed
/datum/reagent/nutriment/coating/mix_data(newdata, newamount)
	if (!data)
		data = list()

	data["cooked"] = newdata["cooked"]


/datum/reagent/nutriment/coating/batter
	name = "batter mix"
	cooked_name = "batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "battered"
	taste_description = "batter"

/datum/reagent/nutriment/coating/batter/touch_turf(turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/decal/cleanable/pie_smudge(T)
		if(T.wet > 1)
			T.wet = min(T.wet, 1)
		else
			T.wet = 0

/datum/reagent/nutriment/coating/beerbatter
	name = "beer batter mix"
	cooked_name = "beer batter"
	color = "#f5f4e9"
	reagent_state = LIQUID
	icon_raw = "batter_raw"
	icon_cooked = "batter_cooked"
	coated_adj = "beer-battered"
	taste_description = "beer-batter"

/datum/reagent/nutriment/coating/beerbatter/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	M.add_chemical_effect(CE_ALCOHOL, removed*0.02) //Very slightly alcoholic

// Synnono's Cooking Expansion

/datum/reagent/spacespice
	name = "Exotic Spices"
	description = "An exotic blend of spices for cooking. It must flow."
	reagent_state = SOLID
	color = "#e08702"
	taste_description = "spices"
	taste_mult = 1.5

/datum/reagent/browniemix
	name = "Brownie Mix"
	description = "A dry mix for making delicious brownies."
	reagent_state = SOLID
	color = "#441a03"
	taste_description = "chocolate"
