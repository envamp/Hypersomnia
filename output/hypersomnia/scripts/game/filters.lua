
filter_nothing = {
	categoryBits = 0,
	maskBits = 0
}

local mask_all = bitor(OBJECTS, STATIC_OBJECTS, BULLETS, ENEMY_BULLETS, CHARACTERS, CORPSES, ITEMS, SHELLS, DOORS)

filter_doors = {
	categoryBits = DOORS,
	maskBits = bitor(SHELLS, OBJECTS, CORPSES, BULLETS, ENEMY_BULLETS, ITEMS)
}

filter_shells = {
	categoryBits = SHELLS,
	maskBits = bitor(SHELLS, STATIC_OBJECTS, OBJECTS, DOORS)
}

filter_static_objects = {
	categoryBits = STATIC_OBJECTS,
	maskBits = mask_all
}

filter_objects = {
	categoryBits = OBJECTS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, BULLETS, ENEMY_BULLETS, CHARACTERS, CORPSES, DOORS)
}

filter_characters = {
	categoryBits = CHARACTERS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, ENEMY_BULLETS, CHARACTERS, DOORS)
}

filter_enemies = {
	categoryBits = CHARACTERS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, BULLETS, CHARACTERS, DOORS)
}

filter_characters_separation = {
	categoryBits = CHARACTERS,
	maskBits = bitor(CHARACTERS)
}

filter_bullets = {
	categoryBits = BULLETS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, CHARACTERS, DOORS)
}

filter_enemy_bullets = {
	categoryBits = ENEMY_BULLETS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, CHARACTERS, DOORS)
}

filter_corpses = {
	categoryBits = CORPSES,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, DOORS)
}

filter_items = {
	categoryBits = ITEMS,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, DOORS)
}

filter_pick_up_items = {
	categoryBits = mask_all,
	maskBits = ITEMS
}

filter_melee = {
	categoryBits = BULLETS,
	maskBits = CHARACTERS
}

filter_enemy_melee = {
	categoryBits = ENEMY_BULLETS,
	maskBits = CHARACTERS
}

filter_melee_obstruction = {
	categoryBits = mask_all,
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, DOORS)
}

filter_pathfinding_visibility = {
	categoryBits = bitor(OBJECTS, STATIC_OBJECTS, BULLETS, CHARACTERS, CORPSES),
	maskBits = bitor(STATIC_OBJECTS)
}

filter_player_visibility = {
	categoryBits = mask_all,
	maskBits = bitor(STATIC_OBJECTS, DOORS)
}

filter_obstacle_visibility = {
	categoryBits = bitor(OBJECTS, STATIC_OBJECTS, BULLETS, CHARACTERS, CORPSES),
	maskBits = bitor(OBJECTS, STATIC_OBJECTS, CHARACTERS)
}