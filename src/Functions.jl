module Functions

using ..Types

export optimization_step!, step!

sqdist(p1::Pos,p2::Pos) = (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2

function spring_force(p1::Pos,p2::Pos,k::Float64,L::Float64)
	
end

function optimization_step!(world::Types.World)
	for node in world.nodes
		node.opt_position.x = node.position.x + world.timestep_length * node.velocity.x
		node.opt_position.y = node.position.y + world.timestep_length * node.velocity.y
	end
	
	forces = [Pos(0.0,0.0) for _ in 1:length(world.nodes)]

	for spring in world.springs
		forces[spring.connections[1]] += 
	end

end
