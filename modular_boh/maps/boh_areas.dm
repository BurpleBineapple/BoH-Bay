/////////
// BoH Areas
/////////

/area/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR
	req_access = list(access_bar)

/area/crew_quarters/bar/storage
	name = "\improper Service Storage"
	req_access = list(access_bar, access_kitchen)

/area/crew_quarters/public_office
	name = "public_office"
	icon_state = "crew_quarters"

/area/crew_quarters/recreation
	name = "\improper Recreation"

/area/crew_quarters_boh/cabin_main
	name = "\improper Cabin Primary"
	icon_state = "crew_quarters"
	area_flags = AREA_FLAG_RAD_SHIELDED
	sound_env = MEDIUM_SOFTFLOOR

/area/crew_quarters_boh/cabin_main/c1
	name = "\improper Cabin One"
	icon_state = "Sleep"

/area/crew_quarters_boh/cabin_main/officerbunk
	name = "\improper Officer Quarters"
	icon_state = "Sleep"
	req_access = list(access_bridge)
	sound_env = SMALL_SOFTFLOOR
	area_flags = AREA_FLAG_RAD_SHIELDED

/area/crew_quarters/head/aux
	name = "\improper First Deck Auxiliary Storage"

/area/maintenance/aux_med
	name = "\improper Aux. Medical"
	icon_state = "disposal"

//Psionic Advisor
/area/crew_quarters/heads/office/psiadvisor
	name = "\improper Psionic Advisor"
	icon_state = "heads"
	req_access = list(access_psiadvisor)

// Reps

/area/crew_quarters/heads/office/solrep
	icon_state = "heads_sol"
	name = "\improper Command - Rep's Office"
	req_access = list(access_representative)

/area/crew_quarters/heads/office/solrep/backroom
	icon_state = "heads_sol"
	name = "\improper Command - Rep's Backroom"
	req_access = list(access_representative)

/area/crew_quarters/heads/office/sea/marine
	name = "\improper Command - Marine SEA's Office"

// Medical

/area/chapel/crematorium
	name = "\improper Crematorium"
	icon_state = "chapel"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_crematorium)

/area/medical/triage
	name = "\improper Triage"
	icon_state = "medbay"
	req_access = list(access_medical)

/area/medical/reslab
	name = "\improper Resuscitation Lab"
	req_access = list(access_surgery)

/area/medical/virology
	name = "\improper Virology"

/area/crew_quarters/safe_room/medical
	name = "\improper Medical Safe Room"

//Infantry

/area/infantry
	name = "\improper Infantry Lounge"
	icon_state = "green"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_infantry)

/area/infantry/infcom
	name = "\improper Squad Leader's Cabin"
	req_access = list(access_infcom)

/area/infantry/inftech
	name = "\improper Infantry Technician's Cabin"
	req_access = list(access_inftech)

/area/command/disperser/odst
	name = "\improper Drop-Pod Bays"
	icon_state = "disperser"
	req_access = list(access_infantry)

//Engineering

/area/engineering/engineering_monitoring
	name = "\improper Engineering Monitoring Room"
	icon_state = "engine_monitoring"
	req_access = list(access_engine)

/area/engineering/locker_room
	name = "\improper Engineering Locker Room"
	icon_state = "engineering_locker"
	req_access = list(access_engine)

//Operations storage

/area/operations_storage
	name = "\improper Operations Storage Hallway"
	icon_state = "yellow"
	sound_env = SMALL_ENCLOSED

/area/operations_storage/medical
	name = "\improper Medical Operations Storage"
	icon_state = "green"
	req_access = list(access_medical)

/area/operations_storage/security
	name = "\improper Security Operations Storage"
	icon_state = "red"
	req_access = list(access_security)

/area/operations_storage/science
	name = "\improper Research Operations Storage"
	icon_state = "purple"
	req_access = list(access_research)

/area/operations_storage/engineering
	name = "\improper Engineering Operations Storage"
	icon_state = "orange"
	req_access = list(access_engine)

/area/operations_storage/robotics
	name = "\improper Robotics Operations Storage"
	icon_state = "pink"
	req_access = list(access_robotics)

/area/storage/expedition
	name = "Auxiliary Expedition Storage"
	icon_state = "storage"
	sound_env = SMALL_ENCLOSED
	req_access = list(list(access_mining, access_xenoarch))

//Pool
/area/pool
	name = "\improper Pool"
	icon_state = "fitness"

//SMC attache
/area/command/msea
	name = "\improper Solarian Marine Corps Attache Office"
	icon_state = "heads_sea"
	req_access = list(access_senadv)

// AI
/area/turret_protected/ai_foyer
	name = "\improper AI Chamber Foyer"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

/area/turret_protected/ai_outer_chamber
	name = "\improper Outer AI Chamber"
	icon_state = "checkpoint"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

/area/turret_protected/ai_data_chamber
	name = "\improper AI Data Chamber"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

/area/turret_protected/ai
	name = "\improper AI Chamber"
	icon_state = "ai_chamber"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)

/area/turret_protected/ai_upload
	name = "\improper AI Upload Chamber"
	icon_state = "ai_upload"
	ambience = list('sound/ambience/ambimalf.ogg')
	req_access = list(access_ai_upload)

/area/turret_protected/ai_upload_foyer
	name = "\improper  AI Upload Access"
	icon_state = "ai_foyer"
	ambience = list('sound/ambience/ambimalf.ogg')
	sound_env = SMALL_ENCLOSED
	req_access = list(access_ai_upload)

/area/engineering/drone_fabrication
	name = "\improper Engineering Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED
	req_access = list(access_robotics)

//

/area/security/solitary
	name = "\improper Security - Solitary Holding"
	icon_state = "security"
	req_access = list(access_brig)

/area/command/bridge_quarters
	name = "\improper Bridge - Officer Quarters"
	icon_state = "crew_quarters"
	req_access = list(access_bridge)

/area/hallway/primary/thirddeck/ofd
	name = "\improper Third Deck OFD Hallway"
	icon_state = "apmaint"

//Anti Boarding
/area/security/antiboarding
	name = "\improper Security - Anti-Boarding Control Room"
	icon_state = "security"
	req_access = list(access_brig)
//

/area/security/brig/perma
	name = "\improper Permanent Brig"
	icon_state = "brig"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_brig)

/area/security/brig/psionic
	name = "\improper Psionic Holding"
	icon_state = "misclab"
	area_flags = AREA_FLAG_RAD_SHIELDED
	req_access = list(access_brig)
	ambience = list('sound/ambience/spookyspace1.ogg')

//Anom
/area/rnd/anom_storage
	name = "\improper Anomaly LTS"
	icon_state = "misclab"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_xenoarch)

/area/rnd/anom_storage/gas
	name = "\improper LTS Gas Runoff"
	icon_state = "misclab"

/area/rnd/anom_storage/living
	name = "\improper Biological LTS"
	icon_state = "security"

// Gunship

/area/aquila/head
	name = "\improper SGGS Byakhee - Cannon"

/area/aquila/secure_storage
	name = "\improper SGGS Byakhee - Secure Storage"
	req_access = list(access_aquila)

/area/aquila/mess
	name = "\improper SGGS Byakhee - Mess Hall"

/area/aquila/passenger
	name = "\improper SGGS Byakhee - Passenger Compartment"

/area/aquila/maintenance
	name = "\improper SGGS Byakhee - Maintenance"
	req_access = list(access_solgov_crew)

// Science

/area/shuttle/petrov/security
	name = "\improper NTRL Polyp - Security Office"
	icon_state = "checkpoint1"
	req_access = list(access_petrov_control)

/area/rnd/breakroom
	name = "\improper Research Break Room"
	icon_state = "researchbreak"
	req_access = list(list(access_research, access_nanotrasen))

// Tcomms
/area/tcommsat/storage
	name = "\improper Telecoms Storage"
	icon_state = "tcomsatstore"

// Other

/area/turbolift/missiles_lift
	name = "\improper Missiles Lift"
	icon_state = "shuttle3"
	base_turf = /turf/simulated/open

/area/quartermaster/hangar/top
	name = "\improper Hangar Upper Walkway"
	req_access = list()

/area/quartermaster/flightcontrol
	name = "\improper Flight Control Tower"
	icon_state = "hangar"
	req_access = list(access_hangar)

/area/command/gunnery
	name = "\improper Weapon Mounts"
	icon = 'icons/boh/area.dmi'
	icon_state = "guntemp"
	req_access = list(access_gunnery)

/////////
// Combat
/////////

/area/command/gunnery
	name = "\improper Weapon Mounts"
	icon = 'icons/boh/area.dmi'
	icon_state = "guntemp"
	req_access = list(access_gunnery)

/area/command/gunnery/missiles
	name = "\improper Missile Pod Exterior"
	icon_state = "kosmag1"

/area/command/gunnery/missiles/inside
	name = "\improper Missile Pod Interior"
	icon_state = "kosmag2"

/area/command/gunnery/missiles/storage
	name = "\improper Weapon Mounts"
	icon = 'icons/boh/area.dmi'
	icon_state = "guntemp"

/area/command/gunnery/missiles/storage/lower
	name = "\improper Weapon Mounts"
	icon = 'icons/boh/area.dmi'

/area/command/gunnery/mim
	name = "\improper Tactical Operations Center"
	icon_state = "guntemp"

/area/command/gunnery/mim/door
	name = "\improper Tactical Operations Center Door"
	icon_state = "guntemp"
