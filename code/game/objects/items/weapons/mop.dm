/obj/item/mop
	desc = "The world of janitalia wouldn't be complete without a mop."
	name = "mop"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mop"
	force = 3
	throwforce = 5
	throw_speed = 3
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("mopped", "bashed", "bludgeoned", "whacked")
	resistance_flags = FLAMMABLE
	var/mopping = 0
	var/mopcount = 0
	var/mopcap = 5
	var/mopspeed = 30

/obj/item/mop/New()
	..()
	create_reagents(mopcap)
	GLOB.janitorial_equipment += src

/obj/item/mop/Destroy()
	GLOB.janitorial_equipment -= src
	return ..()


/obj/item/mop/proc/wet_mop(obj/target, mob/user)
	if(target.reagents.total_volume < 1)
		to_chat(user, "[target] is out of water!</span>")
		if(istype(target, /obj/structure/mopbucket))
			mopbucket_insert(user, target)
		if(!istype(target, /obj/item/reagent_containers/glass/bucket))
			janicart_insert(user, target)
		return

	target.reagents.trans_to(src, 5)
	to_chat(user, "<span class='notice'>You wet [src] in [target].</span>")
	playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)


/obj/item/mop/proc/clean(turf/simulated/A)
	if(reagents.has_reagent("water", 1) || reagents.has_reagent("cleaner", 1) || reagents.has_reagent("holywater", 1))
		A.clean_blood()
		for(var/obj/effect/O in A)
			if(O.is_cleanable())
				qdel(O)
	reagents.reaction(A, REAGENT_TOUCH, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.
	reagents.remove_any(1)			//reaction() doesn't use up the reagents

/obj/item/mop/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return

	if(reagents.total_volume < 1)
		to_chat(user, "<span class='warning'>Your mop is dry!</span>")
		return

	var/turf/simulated/T = get_turf(A)

	if(istype(A, /obj/item/reagent_containers/glass/bucket) || istype(A, /obj/structure/janitorialcart) || istype(A, /obj/structure/mopbucket))
		return

	if(istype(T))
		var/obj/effect/temp_visual/bubbles/E = new /obj/effect/temp_visual/bubbles(T, mopspeed)
		user.visible_message("[user] begins to clean [T] with [src].", "<span class='notice'>You begin to clean [T] with [src]...</span>")

		if(do_after(user, mopspeed, T))
			to_chat(user, "<span class='notice'>You finish mopping.</span>")
			clean(T)
		qdel(E)

/obj/effect/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap))
		return
	else
		return ..()


/obj/item/mop/proc/janicart_insert(mob/user, obj/structure/janitorialcart/cart)
	cart.mymop = src
	cart.put_in_cart(src, user)


/obj/item/mop/proc/mopbucket_insert(mob/user, obj/structure/mopbucket/bucket)
	bucket.mymop = src
	bucket.put_in_cart(src, user)


/obj/item/mop/wash(mob/user, atom/source)
	reagents.add_reagent("water", 5)
	to_chat(user, "<span class='notice'>You wet [src] in [source].</span>")
	playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	return 1

/obj/item/mop/advanced
	desc = "The most advanced tool in a custodian's arsenal. Just think of all the viscera you will clean up with this!"
	name = "advanced mop"
	mopcap = 10
	icon_state = "advmop"
	item_state = "advmop"
	origin_tech = "materials=3;engineering=3"
	force = 6
	throwforce = 8
	throw_range = 4
	mopspeed = 20
	var/refill_enabled = TRUE //Self-refill toggle for when a janitor decides to mop with something other than water.
	var/refill_rate = 1 //Rate per process() tick mop refills itself
	var/refill_reagent = "water" //Determins what reagent to use for refilling, just in case someone wanted to make a HOLY MOP OF PURGING

/obj/item/mop/advanced/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/item/mop/advanced/attack_self(mob/user)
	refill_enabled = !refill_enabled
	if(refill_enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(user, "<span class='notice'>You set the condenser switch to the '[refill_enabled ? "ON" : "OFF"]' position.</span>")
	playsound(user, 'sound/machines/click.ogg', 30, 1)

/obj/item/mop/advanced/process()

	if(reagents.total_volume < mopcap)
		reagents.add_reagent(refill_reagent, refill_rate)

/obj/item/mop/advanced/examine(mob/user)
	. = ..()
	. += "<span class='notice'>The condenser switch is set to <b>[refill_enabled ? "ON" : "OFF"]</b>.</span>"

/obj/item/mop/advanced/Destroy()
	if(refill_enabled)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/mop/advanced/cyborg

/obj/item/mop/advanced/cyborg/janicart_insert(mob/user, obj/structure/janitorialcart/J)
	return
