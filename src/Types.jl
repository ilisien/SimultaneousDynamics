module Types

export Pos, Node, Spring, World, Base

"""
	mutable struct Pos

Represents a set of x and y coordinates.

# Fields
- `x::Float64`: The x-coordinate in the set.
- `y::Float64`: The y-coordinate in the set.
"""
mutable struct Pos
	x::Float64
	y::Float64
end

"""
	Base.:+(a::Pos, b::Pos) -> Pos

Adds two `Pos` structures by summing their x and y values.

# Parameters
- `a::Pos`: The first position.
- `b::Pos`: The second position.

# Returns
- `Pos`: A new `Pos` structure with summed coordinates.
"""
function Base.:+(a::Pos, b::Pos)
    return Pos(a.x + b.x, a.y + b.y)
end

"""
	Base.:-(a::Pos,b::Pos) -> Pos

Subtracts the coordinates of one `Pos` structure from another.

# Parameters
- `a::Pos`: The position to subtract from.
- `b::Pos`: The position to subtract.

# Returns
- `Pos`: A new `Pos` structure with the difference of the coordinates.
"""
function Base.:-(a::Pos, b::Pos)
    return Pos(a.x - b.x, a.y - b.y)
end

"""
    Base.:*(p::Pos, scalar::Float64) -> Pos

Multiplies the coordinates of a `Pos` structure by a scalar value.

# Parameters
- `p::Pos`: The position to scale.
- `scalar::Float64`: The scalar value.

# Returns
- `Pos`: A new `Pos` structure with scaled coordinates.
"""
function Base.:*(p::Pos, scalar::Float64)
    return Pos(p.x * scalar, p.y * scalar)
end

"""
    mutable struct Node

Represents a node in the spring system.

# Fields
- `position::Pos`: The current position of the node.
- `velocity::Pos`: The current velocity of the node.
- `opt_position::Pos`: The optimized position of the node after an optimization step.
- `fixed::Bool`: Indicates whether the node is fixed in place (cannot move).
- `ext_force::Pos`: The external force applied to the node.

# Constructors
- `Node(position::Pos; velocity::Pos=Pos(0.0, 0.0), opt_position::Pos=Pos(0.0, 0.0), fixed::Bool=false, ext_force::Pos=Pos(0.0, 0.0))`: Create a `Node` with optional default values for `velocity`, `opt_position`, `fixed`, and `ext_force`.
"""
mutable struct Node
	position::Pos
	velocity::Pos
	opt_position::Pos
	fixed::Bool
	ext_force::Pos

	Node(position::Pos;
		 velocity::Pos=Pos(0.0,0.0),
		 opt_position::Pos=Pos(0.0,0.0),
		 fixed::Bool=false,
		 ext_force::Pos=Pos(0.0,0.0)) = new(position, velocity, opt_position, fixed, ext_force)
end

"""
    mutable struct Spring

Represents a spring connecting two nodes.

# Fields
- `connections::Tuple`: A tuple of two integers indicating the indices of the connected nodes.
- `stiffness::Float64`: The stiffness coefficient of the spring.
- `relax_length::Float64`: The natural (relaxed) length of the spring.
"""
mutable struct Spring
	connections::Tuple
	stiffness::Float64
	relax_length::Float64
end

"""
    mutable struct World

Represents the entire simulation world.

# Fields
- `nodes::Vector{Node}`: A vector containing all the nodes in the simulation.
- `springs::Vector{Spring}`: A vector containing all the springs in the simulation.
- `optimization_threshold::Float64`: A threshold value for determining when to stop optimizing the node positions.
- `timestep_length::Float64`: The length of each simulation timestep.
- `drag::Float64`: A drag coefficient to simulate resistance in the system.
"""
mutable struct World
	nodes::Vector{Node}
	springs::Vector{Spring}
	optimization_threshold::Float64
	timestep_length::Float64
	drag::Float64
end

end
