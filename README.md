# DBM Feenix 2.4.3 - Black Temple

I worked on adjusting the DBM Timers for Feenix 2.4.3 Archangel Server in my Time playing on there, since I've stopped doing so there will most likely be not that much of a progress from now on but feel free to keep working on my code or at least report Issues feature here on GitHub (if you support enough Material for me to fix things without playing myself I might do that).


# Changelist
For people who aren't into coding and doesn't want to check the Changes in Detail I'll list here the major changes made prior to this first GitHub upload:

Najentus:
- changed the Timer for the Next Tidal Shields (after the first one) from 58s to 60s
- added a Timer for the Impaling Spines (every 20s, ~22s after combat start)

Supremus:
- reworked the entire code because apparently the emotes did not trigger correctly and I dont know why
- added a chase bar which shows how long he chases a person in phase2(it is 10s each)

Bloodboil:
- increased the "Normal Phase"(Inc) timer from 28 to 29.5s
- increased the first Fel Rage timer from 57.5 to 59.5s
- increased the other Fel Rage timer from 57 to 60 (this is more accurate but it can not be 100% accurate)
- added Sync for the Fel Rage timer
- it seems like the Fel Rage timer did not trigger correctly after a Fel Rage phase so I replaced the mechanism completely
- changed the Arcing Smash value from 4s to 10s and changed the name to "Arcing Smash CD" since it will not be used every 10s but has a 10s CD
- the bloodboil timer will now stop after each 5th Bloodboil
- it seems as if the bloodboil timer starts after a Rel Rage 1s to early so increased the first timer from 10s to 11s
- changed the bloodboil timer so it will display the number of the upcoming bloodboil like hydross/gruul timers ("Bloodboil #2" etc.)

Gorefiend:
- added a Timer to display when the first Shadow of Death comes
- changed the combat trigger from a yell to combat start since the yell seem not to trigger every time

RoS:
- lowered the Fixate Timer from 5.5 to 5s
- ^ nvm, commented the Fixate timer out since I noticed it is bugged anyways
- reworked the Next Enrage timer and alerts, a emote did not trigger it seems
- added locales to trigger the end of phase1 and phase2
- changed the timer in p2 for runeshield for the first one from 13.5s to 15.5s and for others from 14.5s to 50s
- changed the timer in p2 for deaden for the first one from 28s to 27s and for others from 31.5s to 30s
- changed the timer in p2 for mana drain from 160s to 135s ( afaik this cant be predicted 100% accurate but this should be more accurate )
- added a timer for p3 for the first Seethe (5s after combat start)
- added a timer for p3 for the Seethe duration (10s) and an announcement, added a locale for triggering that
- added a timer for p1 for souldrain which comes every 20-30s
- added a timer for p3 for the first Soul Screem (10s after combat start)
- added trigger to end Timers after P1 and P2

Mother:
- added a 15s timer which displays the "Prismatic Aura" Update
- added a Timer for "Fatal Attraction", it should only appear for people who got the debuff but I am not sure if others will get that synced
- added a Timer for the First Beam (9s)

Council:
- fixed the timer for the "Next CoH Heal" Warning, it will now be visible every 19.5s. timer resets on every cast to be more precise cus after some time it will get off
- fixed the Icon of Devotion Aura
- changed the timer for vanish from 31s to 27s
- added a timer for the Next Melee Shield (BoP) or Spell Shield, after 30s every 60s. (those shields share CD)
* note for Council: Spells will not be casted every rotation(every time my timer hits), but if they will be casted the timer should be on time.
eg. another spell is casted when my CoH timer hits, CoH will not be postponed by that rather than skipped an entire rotation from my research

Illidan: (not 100% finished)
- reduced the Shadow Demons Timer from 34 to 31s - tested and working
- added a Timer for the combat to begin (9s from the DBM trigger) - tested and working
- added a Timer for the first Shadowfiend (34.5s after DBM trigger) - tested and working
- added a Timer for the first Draw Soul (62.5s after DBM trigger) and others 32s after  - tested and partially working (only the first one works so far, need more research)
- added a Timer for the first Flame Crash (38.5s after DBM trigger)  - tested and working
- added a local to trigger Phase2 properly "I will not be touched by rabble such as you!" - tested and working
- added a Timer in p2 when the elementals spawn (15s after trigger) - tested and working
- changed the Timer of Next Barrage(the first one) from 81s to 87s, the others from 44s to 73s - tested and working
- changed the trigger for Phase3 from counting synched to counting local because it did trigger on the first elemental death before,
this way it should only Sync when one client registers both down which everyone should get - tested and seems to work perfectly
- changed the Timer in Demon Form for Flame Burst from 20s to 21s - tested and working
- changed the Timer in Demon Form for Next (Normal) Phase from 74s to 77s - seems not to be 100% accurate, need more research
- changed the Timer for soft Enrage from 40s to 41s and make it hide if he switches to DemonForm in phase4 - not tested yet
- the event SPELL_CAST_START wasn't registered but UNIT_SPELLCAST_START instead - changed that
