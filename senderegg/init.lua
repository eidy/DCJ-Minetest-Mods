minetest.register_craftitem("senderegg:senderman", {
	description = "Spawn Senderman",
	inventory_image = "senderman_egg.png",
	wield_image = inventory_image,
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "senderman:senderman")
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "sendereg:senderman",
	type = "shapeless".
	recipe = {
		{"spawneggs:egg", "default:nyancat"},
	},
})
