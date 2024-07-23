module Functions

using ..Types

export optimization_step!, step!

sqdist(p1::Pos,p2::Pos) = (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2

sqrtdist(p1::Pos,p2::Pos) = sqrt(sqdist(p1,p2))

mean(v::Vector{Pos}) = sum([abs((p.x + p.y) / 2) for p in v]) / length(v)

function spring_force(p1::Pos,p2::Pos,k::Float64,L::Float64)
	d = sqrtdist(p1,p2)
	dl = d - L
	u = Pos((p2.x - p1.x) / d, (p2.y - p1.y) / d)
	F = k * dl
	return Pos(F * u.x, F * u.y)
end

function optimization_step!(world::Types.World)
	for node in world.nodes
		node.opt_position = node.position + node.velocity * world.timestep_length
	end
	
	forces = [Pos(0.0,0.0) for _ in 1:length(world.nodes)]

	for spring in world.springs
		force = spring_force(world.nodes[spring.connections[1]].opt_position,world.nodes[spring.connections[2]].opt_position,spring.stiffness,spring.relax_length)
		forces[spring.connections[1]] += force
		forces[spring.connections[2]] -= force
	end
	
	for (i,node) in enumerate(world.nodes)
		node.velocity = forces[i] * world.drag
	end
end

function step!(world::Types.World)
	old_mean_velocity = 0.0
	velocity_diff = 100.0

	while velocity_diff >= world.optimization_threshold
		optimization_step!(world)
		mean_velocity = mean([n.velocity for n in world.nodes])
		velocity_diff = abs(mean_velocity - old_mean_velocity)
		old_mean_velocity = mean_velocity
	end

	for node in world.nodes
		node.position += node.velocity * world.timestep_length
	end
end

end
