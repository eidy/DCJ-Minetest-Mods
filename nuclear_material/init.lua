--Nuclear Materials--
--by Devyn Collier Johnson (DevynCJohnson@Gmail.com)
--WTFPL 2014

--Uranium Lump

minetest.register_craftitem("nuclear_material:uranium_lump", {
	description = "Uranium Lump",
	inventory_image = "uranium_lump.png",
})

minetest.register_craft({
	type = "fuel",
	recipe = "nuclear_material:uranium_lump",
	burntime = "20",
})

--Uranium Ore

minetest.register_node("nuclear_material:uranium_ore", {
	description = "Uranium Ore",
	tiles = {"default_stone.png^uranium_mineral.png"},
	light_source = 2,
	is_ground_content = true,
	groups = {cracky=3},
	drop = 'nuclear_material:uranium_lump',
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	type = "cooking",
	recipe = "nuclear_material:uranium_lump",
	output = "nuclear_material:uranium_ore",
})

minetest.register_ore({
	ore_type = "scatter",
	ore = "nuclear_material:uranium_ore",
	wherein = "default:stone",
	clust_scarcity = 15*15*15,
	clust_num_ores = 5,
	clust_size = 9,
	height_min = -31000,
	height_max = -10,
})

--Uranium Block

minetest.register_node("nuclear_material:uranium_block", {
	description = "Uranium Block",
	tiles = {"uranium_block.png"},
	light_source = 2,
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "nuclear_material:uranium_block",
	recipe = {
		{"nuclear_material:uranium_lump", "nuclear_material:uranium_lump"},
		{"nuclear_material:uranium_lump", "nuclear_material:uranium_lump"},
	},
})


--Nuclear Bomb

local NUKE_RANGE = 30

minetest.register_node("nuclear_material:nuclearbomb", {
	description = "Nuclear Bomb",
	tiles = {"nuclear_bomb_top.png","nuclear_bomb_top.png","nuclear_bomb_side.png","nuclear_bomb_side.png","nuclear_bomb_side.png","nuclear_bomb_side.png"},
	dug_item = '',
	diggable = false,
	is_ground_content = true,
	groups = {cracky=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_punch = function(pos, node, puncher)
		minetest.remove_node(pos)
		spawn_tnt(pos, node.name)
		nodeupdate(pos)
	end,
	mesecons = {
		effector = {
			action_on = function(pos, node)
				minetest.remove_node(pos)
				spawn_tnt(pos, node.name)
				nodeupdate(pos)
			end,
			action_off = function(pos, node) end,
			action_change = function(pos, node) end,
		},
	},
})

minetest.register_craft({
	output = "nuclear_material:nuclearbomb",
	recipe = {
		{"default:steelblock", "default:steelblock", "default:steelblock"},
		{"default:steelblock", "nuclear_material:uranium_lump", "default:steelblock"},
		{"default:steelblock", "default:steelblock", "default:steelblock"},
	},
})

local BOMB = {
	physical = true,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "cube",
	textures = {"nuclear_bomb_top.png","nuclear_bomb_top.png","nuclear_bomb_side.png","nuclear_bomb_side.png","nuclear_bomb_side.png","nuclear_bomb_side.png"},
	timer = 0,
	health = 1,
	blinktimer = 0,
	blinkstatus = true,
}

local BOMBNODE = "nuclear_material:nuclearbomb"

function spawn_tnt(pos, entname)
	minetest.sound_play("nuke_ignite", {pos = pos,gain = 1.0,max_hear_distance = 20,})
	return minetest.add_entity(pos, entname)
end

function activate_if_tnt(nname, np, tnt_np, tntr)
	if nname == BOMBNODE then
		local e = spawn_tnt(np, nname)
		e:setvelocity({x=(np.x - tnt_np.x)*3+(tntr / 4), y=(np.y - tnt_np.y)*3+(tntr / 3), z=(np.z - tnt_np.z)*3+(tntr / 4)})
	end
end

function do_tnt_physics(tnt_np,tntr)
	local objs = minetest.get_objects_inside_radius(tnt_np, tntr)
	for k, obj in pairs(objs) do
		local oname = obj:get_entity_name()
		local v = obj:getvelocity()
		local p = obj:getpos()
		if oname == BOMBNODE then
			obj:setvelocity({x=(p.x - tnt_np.x) + (tntr / 2) + v.x, y=(p.y - tnt_np.y) + tntr + v.y, z=(p.z - tnt_np.z) + (tntr / 2) + v.z})
		else
			if v ~= nil then
				obj:setvelocity({x=(p.x - tnt_np.x) + (tntr / 4) + v.x, y=(p.y - tnt_np.y) + (tntr / 2) + v.y, z=(p.z - tnt_np.z) + (tntr / 4) + v.z})
			else
				if obj:get_player_name() ~= nil then
					obj:set_hp(obj:get_hp() - 1)
				end
			end
		end
	end
end

function BOMB:on_activate(staticdata)
	self.object:setvelocity({x=0, y=4, z=0})
	self.object:setacceleration({x=0, y=-10, z=0})
	self.object:settexturemod("^[brighten")
end

function BOMB:on_step(dtime)
	self.timer = self.timer + dtime
	self.blinktimer = self.blinktimer + dtime
	if self.timer>5 then
		self.blinktimer = self.blinktimer + dtime
		if self.timer>8 then
			self.blinktimer = self.blinktimer + dtime
			self.blinktimer = self.blinktimer + dtime
		end
	end
	if self.blinktimer > 0.5 then
		self.blinktimer = self.blinktimer - 0.5
		if self.blinkstatus then
			self.object:settexturemod("")
		else
			self.object:settexturemod("^[brighten")
		end
		self.blinkstatus = not self.blinkstatus
	end
	if self.timer > 10 then
		local pos = self.object:getpos()
		pos.x = math.floor(pos.x+0.5)
		pos.y = math.floor(pos.y+0.5)
		pos.z = math.floor(pos.z+0.5)
		do_tnt_physics(pos, NUKE_RANGE)
		minetest.sound_play("nuke_explode", {pos = pos,gain = 1.0,max_hear_distance = 16,})
		if minetest.get_node(pos).name == "default:water_source" or minetest.get_node(pos).name == "default:water_flowing" then
			self.object:remove()
			return
		end
		for x=-NUKE_RANGE,NUKE_RANGE do
		for y=-NUKE_RANGE,NUKE_RANGE do
		for z=-NUKE_RANGE,NUKE_RANGE do
			if x*x+y*y+z*z <= NUKE_RANGE * NUKE_RANGE + NUKE_RANGE then
				local np={x=pos.x+x,y=pos.y+y,z=pos.z+z}
				local n = minetest.get_node(np)
				if n.name ~= "air" then
					minetest.remove_node(np)
				end
				activate_if_tnt(n.name, np, pos, NUKE_RANGE)
			end
		end
		end
		end
		self.object:remove()
	end
end

function BOMB:on_punch(hitter)
	self.health = self.health - 1
	if self.health <= 0 then
		self.object:remove()
		hitter:get_inventory():add_item("main", BOMBNODE)
	end
end

minetest.register_entity(BOMBNODE, BOMB)
