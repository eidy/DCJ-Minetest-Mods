dofile(minetest.get_modpath("senderman").."/api.lua")

mobs:register_mob("senderman:senderman", {
	type = "monster",
	hp_max = 30,
	collisionbox = {-0.5, -0.01, -0.5, 0.5, 5.4, 0.5},
	visual = "mesh",
	mesh = "sender_man.x",
	textures = {"sender_man.png"},
	visual_size = {x=8,y=8},
	makes_footstep_sound = false,
	view_range = 20,
	walk_velocity = 2,
	run_velocity = 6,
	damage = 4,
	drops = {
		{name = "default:nyancat",
		chance = 1,
		min = 3,
		max = 5,},
	},
	light_resistant = true,
	armor = 80,
	drawtype = "front",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 0,
	attack_type = "dogfight",
	jump = true,
	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	}
})

mobs:register_spawn("senderman:senderman", {"default:stone", "default:dirt", "default:sand", "default:gravel", "default:clay", "default:cobble", "default:mossycobble", "default:dirt_with_grass", "default:desert_sand", "default:desert_stone"}, 20, -1, 4000, 3, 31000)

if minetest.setting_get("log_mods") then
	minetest.log("action", "senderman is watching")
end
