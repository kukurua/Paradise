/obj/item/implant/gorilla_rampage //Dumb path but easier to search for admins
	name = "magillitis serum bio-chip"
	desc = "An experimental biochip which causes irreversable rapid muscular growth in Hominidae. Side-affects may include hypertrichosis, violent outbursts, and an unending affinity for bananas."
	icon_state = "gorilla_rampage"
	implant_state = "implant-syndicate"
	origin_tech = "combat=5;biotech=5;syndicate=2"
	activated = BIOCHIP_ACTIVATED_ACTIVE
	implant_data = /datum/implant_fluff/gorilla_rampage
	uses = 1


/obj/item/implant/gorilla_rampage/activate(cause)
	if(!iscarbon(imp_in))
		return

	var/mob/living/carbon/target = imp_in
	target.visible_message(
		span_userdanger("[target] swells and their hair grows rapidly. Uh oh!."),
		span_userdanger("You feel your muscles swell and your hair grow as you return to monke."),
		span_italics("You hear angry gorilla noises."),
	)
	target.gorillize("Enraged", message = FALSE)


/obj/item/implanter/gorilla_rampage
	name = "bio-chip implanter (magillitis serum)"
	imp = /obj/item/implant/gorilla_rampage


/obj/item/implantcase/gorilla_rampage
	name = "bio-chip case - 'magillitis serum'"
	desc = "A glass case containing a magillitis bio-chip."
	imp = /obj/item/implant/gorilla_rampage

