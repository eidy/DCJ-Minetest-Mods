--Currency--
--by Devyn Collier Johnson (DevynCJohnson@Gmail.com)
--WTFPL 2014

--1 MU

minetest.register_craftitem("currency:1mineunit", {
	description = "One Mineunit",
	inventory_image = "1mineunit.png",
})

minetest.register_craft({
	output = "currency:1mineunit",
	type = "shapeless",
	recipe = {"default:copper_ingot", "default:copper_ingot"},
})

--10 MU

minetest.register_craftitem("currency:10mineunit", {
	description = "Ten Mineunits",
	inventory_image = "10mineunit.png",
})

minetest.register_craft({
	output = "currency:10mineunit",
	type = "shapeless",
	recipe = {"default:bronze_ingot", "default:bronze_ingot"},
})

--100 MU

minetest.register_craftitem("currency:100mineunit", {
	description = "One Hundred Mineunits",
	inventory_image = "100mineunit.png",
})

minetest.register_craft({
	output = "currency:100mineunit",
	type = "shapeless",
	recipe = {"default:gold_ingot", "default:gold_ingot"},
})

--1000 MU

minetest.register_craftitem("currency:1000mineunit", {
	description = "One Thousand Mineunits",
	inventory_image = "1000mineunit.png",
})

minetest.register_craft({
	output = "currency:1000mineunit",
	type = "shapeless",
	recipe = {"default:mese_crystal", "default:mese_crystal"},
})

--Convert Back (Melt)

minetest.register_craft({
	output = "default:copper_ingot 2",
	type = "cooking",
	recipe = "currency:1mineunit",
})

minetest.register_craft({
	output = "default:bronze_ingot 2",
	type = "cooking",
	recipe = "currency:10mineunit",
})

minetest.register_craft({
	output = "default:gold_ingot 2",
	type = "cooking",
	recipe = "currency:100mineunit",
})

minetest.register_craft({
	output = "default:mese_crystal 2",
	type = "cooking",
	recipe = "currency:1000mineunit",
})
