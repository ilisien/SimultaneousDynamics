module Functions

using ..Types

export optimization_step!, step!

"""
    sqdist(p1::Pos, p2::Pos) -> Float64

Calculates the squared distance between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.

# Returns
- `Float64`: The squared distance between `p1` and `p2`.
"""
sqdist(p1::Pos,p2::Pos) = (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2

"""
    sqrtdist(p1::Pos, p2::Pos) -> Float64

Calculates the Euclidean distance between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.

# Returns
- `Float64`: The Euclidean distance between `p1` and `p2`.
"""
sqrtdist(p1::Pos,p2::Pos) = sqrt(sqdist(p1,p2))

"""
Calculates the mean of the given vector.

# Methods

## `mean(v::Vector{Pos}) -> Float64`
Calculates the mean of the absolute values of the coordinates in a vector of positions.

- **Parameters**
  - `v::Vector{Pos}`: A vector of `Pos` objects, each with `x` and `y` coordinates.

- **Returns**
  - `Float64`: The mean of the absolute values of the coordinates.

## `mean(v::Vector{Float64}) -> Float64`
Calculates the mean of a vector of floating-point numbers.

- **Parameters**
  - `v::Vector{Float64}`: A vector of floating-point numbers.

- **Returns**
  - `Float64`: The mean of the values in the vector.
"""
mean(v::Vector{Pos}) = sum([abs((p.x + p.y) / 2) for p in v]) / length(v)

mean(v::Vector{Float64}) = sum(v) / length(v)

"""
    spring_force(p1::Pos, p2::Pos, k::Float64, L::Float64) -> Pos

Calculates the spring force exerted between two positions.

# Parameters
- `p1::Pos`: The first position.
- `p2::Pos`: The second position.
- `k::Float64`: The stiffness coefficient of the spring.
- `r::Float64`: The natural (relaxed) length of the spring.

# Returns
- `Pos`: The force exerted by the spring as a position.
"""
function spring_force(p1::Pos,p2::Pos,k::Float64,r::Float64)
	d = sqrtdist(p1,p2)
	dl = d - r
	u = Pos((p2.x - p1.x) / d, (p2.y - p1.y) / d)
	F = k * dl
	return Pos(F * u.x, F * u.y)
end

"""
    optimization_step!(world::Types.World)

Performs an optimization step on the world to update the positions and velocities of the nodes.

# Parameters
- `world::Types.World`: The world containing nodes and springs to be optimized.
"""
function optimization_step!(world::Types.World)
	for node in world.nodes
		node.opt_position = node.position + node.velocity * world.timestep_length
	end
	
	forces = [n.ext_force for n in world.nodes]

	for spring in world.springs
		force = spring_force(world.nodes[spring.connections[1]].opt_position,world.nodes[spring.connections[2]].opt_position,spring.stiffness,spring.relax_length)
		forces[spring.connections[1]] += force
		forces[spring.connections[2]] -= force
	end
	
	for (i,node) in enumerate(world.nodes)
		if !(node.fixed)
			node.velocity = forces[i] * world.drag
		end
	end
end

"""
    step!(world::Types.World)

Performs a simulation step on the world to update the positions and velocities of the nodes based on the forces applied.

# Parameters
- `world::Types.World`: The world containing nodes and springs to be simulated.
"""
function step!(world::Types.World)
	old_velocities = [Pos(0.0,0.0) for _ in world.nodes]
	mean_velocity_diff = 100.0
	osteps = 0

	while mean_velocity_diff >= world.optimization_threshold
		optimization_step!(world)
		new_velocities = [n.velocity for n in world.nodes]
		mean_velocity_diff = mean([sqrtdist(new_velocities[i],old_velocities[i]) for i in 1:length(world.nodes)])
		old_velocities = new_velocities
		osteps += 1
	end

	for node in world.nodes
		node.position += node.velocity * world.timestep_length
	end
end

end
