-- initialize gameplay libraries
dofile "hypersomnia\\scripts\\game\\input.lua"
dofile "hypersomnia\\scripts\\game\\layers.lua"
dofile "hypersomnia\\scripts\\game\\camera.lua"

-- archetypes
dofile "hypersomnia\\scripts\\archetypes\\basic_player.lua"

-- resource handling utilities
dofile "hypersomnia\\scripts\\resources\\animations.lua"

dofile "hypersomnia\\scripts\\client_screen.lua"

-- main loop

local file_watcher_object = file_watcher()
file_watcher_object:add_directory("hypersomnia\\scripts", false)

local client_scenes = {
	client_screen:create(rect_xywh(config_table.resolution_w/2, config_table.resolution_h/2, config_table.resolution_w/2, config_table.resolution_h/2)),
	client_screen:create(rect_xywh(0, 0, config_table.resolution_w/2, config_table.resolution_h/2)),
	client_screen:create(rect_xywh(config_table.resolution_w/2, 0, config_table.resolution_w/2, config_table.resolution_h/2)),
	client_screen:create(rect_xywh(0, config_table.resolution_h/2, config_table.resolution_w/2, config_table.resolution_h/2))
}

while true do
	GL.glClear(GL.GL_COLOR_BUFFER_BIT)
	
	for i=1, #client_scenes do
		client_scenes[i]:loop()
	end
	
	if call_once_after_loop ~= nil then
		call_once_after_loop()
		call_once_after_loop = nil
	end
	       
	local files_to_reload = file_watcher_object:get_modified_files()
	   
	for i=0, files_to_reload:size()-1 do 
		if files_to_reload:at(i) == "hypersomnia\\scripts\\commands.lua" then
			dofile "hypersomnia\\scripts\\commands.lua"
		end
	end
	
	global_gl_window:swap_buffers()
end

