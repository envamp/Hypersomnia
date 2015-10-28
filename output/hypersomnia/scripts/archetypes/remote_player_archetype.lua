function create_remote_player(owner_scene, crosshair_sprite)
	local light_filter = create_query_filter({"STATIC_OBJECT"})

	local player = owner_scene.world_object:create_entity_group  {
		-- body also acts as torso
		body = {
			render = {
				layer = render_layers.PLAYERS,
				model = blank_green
			},
		
			transform = {
			},
			
			animate = {
			
			},
					
			physics = {
				body_type = Box2D.b2_dynamicBody,
				
				body_info = {
					filter = filters.REMOTE_CHARACTER,
					shape_type = physics_info.RECT,
					rect_size = vec2(37, 37),
					
					angular_damping = 5,
					--linear_damping = 18,
					--max_speed = 3300,
					
					fixed_rotation = true,
					density = 0.1,
					angled_damping = true
				},
			},
			
			lookat = {
				target = "crosshair",
				look_mode = lookat_component.POSITION,
				
				easing_mode = lookat_component.EXPONENTIAL,
				smoothing_average_factor = 0.5,	
				averages_per_sec = 80	
			},
			
			gun = {}, 
			
			movement = {
				input_acceleration = vec2(10000, 10000),
				max_accel_len = 10000,
				max_speed_animation = 1000,
				air_resistance = 0.5,
				braking_damping = 18,
				receivers = {
					{ target = "body", stop_at_zero_movement = false }, 
					{ target = "legs", stop_at_zero_movement = true  }
				}
			},
		 
			children = {
				"legs",
				"crosshair"
			},

			visibility = {
				interval_ms = 1,
				visibility_layers = {
					[visibility_layers.BASIC_LIGHTING] = {
						square_side = 4000,
						color = rgba(0, 255, 255, 10),
						ignore_discontinuities_shorter_than = -1,
						filter = light_filter
					}
				}
			}
		},
		
		crosshair = { 
			transform = {
				pos = vec2(0, 0),
				rotation = 0
			},
			
			render = {
				layer = render_layers.CROSSHAIRS,
				model = crosshair_sprite
			},
			
			crosshair = {
				sensitivity = config_table.sensitivity,
				should_blink = false
			},
			
			chase = {
				target = "body",
				relative = true
			}
		},
		
		legs = {
			transform = { 
				rotation = 0
			},
		
			render = {
				layer = render_layers.LEGS,
				model = nil
			},
		
			chase = {
				target = "body"
			},
		
			lookat = {
				target = "body",
				look_mode = lookat_component.VELOCITY
			},
		
			animate = {
			
			}
		}
	}
	
	player.body.animate.available_animations = owner_scene.torso_sets["basic"]["barehands"].set
	player.legs.animate.available_animations = owner_scene.legs_sets["basic"].set

	return player
end


world_archetype_callbacks.REMOTE_PLAYER = {
	creation = function(self)
		local entity_group = create_remote_player(self.owner_scene, self.owner_scene.crosshair_sprite)
	
		local new_entity = components.create_components {
			cpp_entity = entity_group.body,
			interpolation = {},
			
			orientation = {
				receiver = true,
				crosshair_entity = entity_group.crosshair
			},
			
			health = {},
			
			wield = {
				wield_offsets = npc_wield_offsets
			},
			
			label = {
				position = components.label.positioning.OVER_HEALTH_BAR,
				default_font = self.owner_scene.font_by_name["kubasta"],
				
				text = {}
			},

			particle_response = {
				response = self.owner_scene.particles.npc_response
			},
			
			light = {
				color = rgba(255, 255, 0, 255)
			}
		}
		
				
		new_entity.wield.on_item_wielded = function(this, picked, old_item, wielding_key)
			return character_wielding_procedure(self.owner_scene, entity_group, false, this, picked, old_item, wielding_key)
		end
		
		new_entity.wield.on_item_unwielded = function(this, unwielded, wielding_key)
			return character_unwielding_procedure(self.owner_scene, entity_group, false, this, unwielded, wielding_key)
		end
		
		return new_entity
	end
}

