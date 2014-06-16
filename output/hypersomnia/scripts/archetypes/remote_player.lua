remote_player_class = inherits_from(entity_class)

all_remote_players = {}

function remote_player_class:constructor(remote_guid)
	self.guid = remote_guid
	table.insert(all_remote_players, self)
end

function create_remote_player(owner_scene, position, remote_guid)
	local player = owner_scene.world_object:ptr_create_entity_group  {
		-- body also acts as torso
		body = {
			render = {
				layer = render_layers.PLAYERS,
				model = blank_green
			},
		
			transform = {
				pos = position
			},
			
			animate = {
			
			},
					
			physics = {
				body_type = Box2D.b2_dynamicBody,
				
				body_info = {
					filter = filter_characters,
					shape_type = physics_info.RECT,
					rect_size = vec2(37, 37),
					
					angular_damping = 5,
					--linear_damping = 18,
					max_speed = 3300,
					
					fixed_rotation = true,
					density = 0.1
				},
			},
			
			lookat = {
				target = "crosshair",
				look_mode = lookat_component.POSITION
			},
			
			gun = {}, 
	
			particle_emitter = {
				available_particle_effects = npc_effects
			},
			
			movement = {
				input_acceleration = vec2(5000, 5000),
				max_speed_animation = 1000,
				air_resistance = 0.1,
				braking_damping = 18,
				receivers = {
					{ target = "body", stop_at_zero_movement = false }, 
					{ target = "legs", stop_at_zero_movement = true  }
				}
			},
		 
			children = {
				"legs"
			}
		},
		
		legs = {
			transform = { 
				pos = position,
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
	
	player.body:get().animate.available_animations = owner_scene.torso_sets["white"]["barehands"].set
	player.legs:get().animate.available_animations = owner_scene.legs_sets["white"].set

	return owner_scene.world_object:create_entity_table(player.body, remote_player_class, remote_guid)
end
