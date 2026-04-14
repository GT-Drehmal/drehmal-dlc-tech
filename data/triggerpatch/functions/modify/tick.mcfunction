# TODO: Where do we call this

# DESIRED EFFECT: the @e selectors should be global. @p maybe only for the player?
#
# ~~"Global" selectors will use one shared trigger (if that's even possible)~~
#     (This is not possible. A trigger a scoreboard objective, not a player)
# In that case we can just do one for every player (oh boy)
#     and reset @a on each trigger.
# Might be worth to modify players:leave as well to get rid of any edge case
# (such as: 2 players activate trigger simultaneously,
#     one leaves before trigger could be cleared.
#     when they join back command will run a second time)
# 
# To reduce the number of objectives needed we should make use of /trigger set,
#     as seen in finality.
# Looking at the list, I think the most straightforward method would be to
#     to have trigger values represent m/h/c/l/b
#     and the triggered objective will represent the relevant function.

# (~~I'm still not sure why we're using @p in some cases and @e in others~~
#     maybe because @e is intended for the invisible armor stand
#     that's holding the item to be modified?)

# > When to enable triggers? <
#     Intuitively, any time a menu is presented the trigger should be enabled for the player 
#         who's seeing the menu. It seems that menus are always presented to @p[tag=selector]
#         and **executed at the position of @e[type=armor_stand,distance=..5,tag=display,tag=!invalid]
#         and the distance restraint is relative to... 26475.47 141.08 -56.00 (core:main)
#     The way dlc:modify/main implemented this is... a little bit messy, but it makes sense.
#     So I think it still makes sense to enable the *relevant* triggers in each of the 
#         "menu" type functions in dlc:modify.
# > But when do we disable it? <
#     The lazy (?) answer is that we never disable them (unless a player leaves the server)
#     Because in the original implementation it's already possible to interact with the
#         same menu item twice, thus double-running the /execute command.
#     The only thing that's preventing everyone from doing so is the screen clear, which would
#         give the same amount of protection for our implementation too.
# > But do we want to do better? <
#     We could put in a system to only run the /execute if the player running the trigger
#         is also the player with the `selector` tag.
#     We have to analyze the implications, however. Intuitively this would work, since 
#         if a player doesn't have an "active" menu open, they shouldn't be allowed
#         to interact with the station.
#     Might be worth to ask Elmer/tworoundcats about this?

# ======================
# Legend
# ======================
# m  = Mainhand       1
# h  = Helmet         2
# c  = Chestplate     3
# l  = Leggings       4
# b  = Boots          5
# hp = Max Health
# sp = movement SPeed
# ar = Armor
# as = Attack Speed
# at = ATtack damage
# b  = flat value
# p  = percentage value

# ====================================================
# Original /execute selectors and their corresponding 
# triggers + handler functions
# ====================================================

# HANDLER: triggerpatch:modify/retrieve
# TRIGGER: tgr.mdfy.retrieve (1-6)
# @p[tag=selector]
#     dlc:modify/retrieve
#     dlc:modify/retrieve_c
#     dlc:modify/retrieve_l
#     dlc:modify/retrieve_h
#     dlc:modify/retrieve_b
#     dlc:modify/retrieve_c_wings

# HANDLER: triggerpatch:modify/charge
# TRIGGER: tgr.mdfy.charge
# @p[tag=selector]
#     dlc:modify/charge/1

# HANDLER for all of following: triggerpatch:modify/submenu
# TRIGGER: tgr.mdfy.hp (1-5)
# * Why @p?? just use @s at this point
# *     or more likely intended to be @p to the station?
# *     but player might execute this from anywhere, this doesn't make sense
# @p
#     dlc:modify/hp_m
#     dlc:modify/hp_l
#     dlc:modify/hp_h
#     dlc:modify/hp_c
#     dlc:modify/hp_b
# 
# TRIGGER: tgr.mdfy.sp
# @p
#     dlc:modify/sp_m
#     dlc:modify/sp_l
#     dlc:modify/sp_h
#     dlc:modify/sp_c
#     dlc:modify/sp_b
# 
# TRIGGER: tgr.mdfy.ar
# @p
#     dlc:modify/ar_m
#     dlc:modify/ar_l
#     dlc:modify/ar_h
#     dlc:modify/ar_c
#     dlc:modify/ar_b
# 
# TRIGGER: tgr.mdfy.as
# @p
#     dlc:modify/as_m
#     dlc:modify/as_l
#     dlc:modify/as_h
#     dlc:modify/as_c
#     dlc:modify/as_b
# 
# TRIGGER: tgr.mdfy.at
# @p
#     dlc:modify/at_m
#     dlc:modify/at_l
#     dlc:modify/at_h
#     dlc:modify/at_c
#     dlc:modify/at_b

# HANDLER for all of following: triggerpatch:modify/apply
# TRIGGERS: tgr.mdfy.hp_b (1-5), tgr.mdfy.hp_p (1-5)
# @e[tag=valid,tag=!hp]
#     unless players:holding/hp
#         dlc:modify/mainhand/hp_b
#         dlc:modify/mainhand/hp_p
#     unless players:holding/hp_l
#         dlc:modify/leggings/hp_b
#         dlc:modify/leggings/hp_p
#     unless players:holding/hp_h
#         dlc:modify/helmet/hp_b
#         dlc:modify/helmet/hp_p
#     unless players:holding/hp_c
#         dlc:modify/chestplate/hp_b
#         dlc:modify/chestplate/hp_p
#     unless players:holding/hp_b
#         dlc:modify/boots/hp_b
#         dlc:modify/boots/hp_p
# 
# TRIGGERS: tgr.mdfy.sp_b (1-5), tgr.mdfy.sp_p (1-5)
# @e[tag=valid,tag=!sp]
#     unless players:holding/sp
#         dlc:modify/mainhand/sp_b
#         dlc:modify/mainhand/sp_p
#     unless players:holding/sp_l
#         dlc:modify/leggings/sp_b
#         dlc:modify/leggings/sp_p
#     unless players:holding/sp_h
#         dlc:modify/helmet/sp_b
#         dlc:modify/helmet/sp_p
#     unless players:holding/sp_c
#         dlc:modify/chestplate/sp_b
#         dlc:modify/chestplate/sp_p
#     unless players:holding/sp_b
#         dlc:modify/boots/sp_b
#         dlc:modify/boots/sp_p
# 
# TRIGGERS: tgr.mdfy.as_b (1-5), tgr.mdfy.as_p (1-5)
# @e[tag=valid,tag=!as]
#     unless players:holding/as
#         dlc:modify/mainhand/as_b
#         dlc:modify/mainhand/as_p
#     unless players:holding/as_l
#         dlc:modify/leggings/as_b
#         dlc:modify/leggings/as_p
#     unless players:holding/as_h
#         dlc:modify/helmet/as_b
#         dlc:modify/helmet/as_p
#     unless players:holding/as_c
#         dlc:modify/chestplate/as_b
#         dlc:modify/chestplate/as_p
#     unless players:holding/as_b
#         dlc:modify/boots/as_b
#         dlc:modify/boots/as_p
# 
# TRIGGERS: tgr.mdfy.ar_b (1-5), tgr.mdfy.ar_p (1-5)
# @e[tag=valid,tag=!ar]
#     unless players:holding/ar
#         dlc:modify/mainhand/ar_b
#         dlc:modify/mainhand/ar_p
#     unless players:holding/ar_l
#         dlc:modify/leggings/ar_b
#         dlc:modify/leggings/ar_p
#     unless players:holding/ar_h
#         dlc:modify/helmet/ar_b
#         dlc:modify/helmet/ar_p
#     unless players:holding/ar_c
#         dlc:modify/chestplate/ar_b
#         dlc:modify/chestplate/ar_p
#     unless players:holding/ar_b
#         dlc:modify/boots/ar_b
#         dlc:modify/boots/ar_p
# 
# TRIGGERS: tgr.mdfy.at_b (1-5), tgr.mdfy.at_p (1-5)
# @e[tag=valid,tag=!at]
#     unless players:holding/at
#         dlc:modify/mainhand/at_b
#         dlc:modify/mainhand/at_p
#     unless players:holding/at_l
#         dlc:modify/leggings/at_b
#         dlc:modify/leggings/at_p
#     unless players:holding/at_h
#         dlc:modify/helmet/at_b
#         dlc:modify/helmet/at_p
#     unless players:holding/at_c
#         dlc:modify/chestplate/at_b
#         dlc:modify/chestplate/at_p
#     unless players:holding/at_b
#         dlc:modify/boots/at_b
#         dlc:modify/boots/at_p
