#include "hypersomnia_world.h"

#include "game_framework/all_component_includes.h"
#include "game_framework/all_system_includes.h"
#include "game_framework/all_message_includes.h"

using namespace components;
using namespace messages;

hypersomnia_world::hypersomnia_world(augs::overworld& overworld) : world(overworld) {
	register_messages_components_systems();
}

void hypersomnia_world::register_messages_components_systems() {
	register_component<animation>();
	register_component<animation_response>();
	register_component<behaviour_tree>();
	register_component<camera>();
	register_component<chase>();
	register_component<children>();
	register_component<crosshair>();
	register_component<damage>();
	register_component<gun>();
	register_component<input>();
	register_component<lookat>();
	register_component<movement>();
	register_component<particle_emitter>();
	register_component<particle_group>();
	register_component<pathfinding>();
	register_component<physics>();
	register_component<render>();
	register_component<steering>();
	register_component<transform>();
	register_component<visibility>();
	register_component<sprite>();
	register_component<polygon>();
	register_component<tile_layer>();
	register_component<car>();
	register_component<driver>();

	register_system<input_system>();
	register_system<steering_system>();
	register_system<movement_system>();
	register_system<animation_system>();
	register_system<crosshair_system>();
	register_system<lookat_system>();
	register_system<physics_system>();
	register_system<visibility_system>();
	register_system<pathfinding_system>();
	register_system<gun_system>();
	register_system<particle_group_system>();
	register_system<particle_emitter_system>();
	register_system<render_system>();
	register_system<camera_system>();
	register_system<chase_system>();
	register_system<damage_system>();
	register_system<destroy_system>();
	register_system<behaviour_tree_system>();
	register_system<car_system>();
	register_system<driver_system>();

	register_message_queue<intent_message>();
	register_message_queue<damage_message>();
	register_message_queue<destroy_message>();
	register_message_queue<animation_message>();
	register_message_queue<animation_response_message>();
	register_message_queue<collision_message>();
	register_message_queue<particle_burst_message>();
	register_message_queue<shot_message>();
	register_message_queue<raw_window_input_message>();
	register_message_queue<unmapped_intent_message>();
	register_message_queue<crosshair_intent_message>();
}

void hypersomnia_world::draw() {
	get_system<render_system>().calculate_and_set_interpolated_transforms();
	
	/* read-only message generation */

	get_system<animation_system>().response_requests_to_animation_messages();

	get_system<input_system>().acquire_raw_window_inputs();
	get_system<input_system>().post_input_intents_for_rendering_time();

	// supposed to be read-only
	get_system<crosshair_system>().generate_crosshair_intents();

	// the need for this disappears once the virtue of rendering-time systems is reading, and reading only. (also posting entropic messages
	// that the logic systems deterministically get ahold of)
	// get_system<input_system>().replay_rendering_time_events_passed_to_last_logic_step();

	/* application of messages */
	get_system<animation_system>().handle_animation_messages();
	get_system<animation_system>().progress_animation_states();

	get_system<crosshair_system>().animate_crosshair_sizes();
	get_system<movement_system>().animate_movement();

	get_system<chase_system>().update_transforms();
	get_system<camera_system>().resolve_cameras_transforms_and_smoothing();
	get_system<lookat_system>().update_rotations();

	get_system<camera_system>().render_all_cameras();
	get_system<render_system>().restore_actual_transforms();

	get_system<input_system>().acquire_events_from_rendering_time();
}

void hypersomnia_world::perform_logic_step() {
	get_system<input_system>().post_input_intents_for_logic_step();
	get_system<input_system>().post_rendering_time_events_for_logic_step();

	get_system<render_system>().set_current_transforms_as_previous_for_interpolation();

	get_system<crosshair_system>().apply_crosshair_intents_to_crosshair_transforms();

	get_system<camera_system>().react_to_input_intents();

	get_system<driver_system>().process_vehicle_ownership();
	get_system<driver_system>().issue_commands_to_steered_vehicles();

	get_system<car_system>().react_to_drivers_intents();
	get_system<car_system>().apply_movement_forces();

	get_system<movement_system>().set_movement_flags_from_input();

	get_system<movement_system>().apply_movement_forces();
	get_system<lookat_system>().update_physical_motors();
	get_system<physics_system>().step_and_set_new_transforms();

	get_system<destroy_system>().delete_queued_entities();
}