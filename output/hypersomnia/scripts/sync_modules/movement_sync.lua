sync_modules.movement = inherits_from ()

function sync_modules.movement:constructor()
	self.position = b2Vec2()
	self.velocity = b2Vec2()
 end

function sync_modules.movement:read_stream(object, input)
	local body = object.cpp_entity.physics.body
	
	input:name_property("position")
	self.position = input:Readb2Vec2()
	input:name_property("velocity")
	self.velocity = input:Readb2Vec2()
end


function sync_modules.movement:read_state(input)
	print "reading_state"
end

function sync_modules.movement:update_game_object(object)
	
end


-- SERVER CODE

function sync_modules.movement:write_stream(object, output)
	local body = object.cpp_entity.physics.body
	
	output:name_property("position")
	output:Writeb2Vec2(body:GetPosition())
	output:name_property("velocity")
	output:Writeb2Vec2(body:GetLinearVelocity())
end

function sync_modules.movement:write_state(object, output)

end
