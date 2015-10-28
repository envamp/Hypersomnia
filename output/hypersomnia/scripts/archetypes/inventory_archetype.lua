world_archetype_callbacks.INVENTORY = {
	creation = function(self)
		return components.create_components {
			inventory = {},
			wield = {},
			item = {}
		}
	end,
	
	construction = function(self, new_entity, is_object_new)
		-- nothing to do if we're recreating
		if not is_object_new then return end
		
		if new_entity.item.wielder_id == self.controlled_character_id then
			new_entity.cpp_entity = self.owner_scene.world_object:create_entity ( {
				input = {
					custom_intents.SELECT_ITEM_1,
					custom_intents.SELECT_ITEM_2,
					custom_intents.SELECT_ITEM_3,
					custom_intents.SELECT_ITEM_4,
					custom_intents.SELECT_ITEM_5,
					custom_intents.SELECT_ITEM_6,
					
					custom_intents.PICK_REQUEST,
					custom_intents.HOLSTER_ITEM,
					custom_intents.SELECT_LAST_ITEM,
					custom_intents.DROP_REQUEST
				}
			})
			
			new_entity.inventory.draw_as_owner = true
		end
	end,
	
	post_construction = function(self, new_entity, is_object_new)
		if new_entity.item.is_wielded then
			self.owner_entity_system:post_table("item_wielder_change", {
				wield = true,
				subject = self.object_by_id[new_entity.item.wielder_id],
				item = new_entity,
				wielding_key = new_entity.item.remote_wielding_key
			})
		else
			new_entity.item.on_drop(new_entity)
		end
	end
}