module Types

export Pos, Node, Spring, World, Base

mutable struct Pos
	x::Float64
	y::Float64
end

function Base.:+(a::Pos, b::Pos)
    return Pos(a.x + b.x, a.y + b.y)
end

function Base.:-(a::Pos, b::Pos)
    return Pos(a.x - b.x, a.y - b.y)
end

function Base.:*(p::Pos, scalar::Float64)
    return Pos(p.x * scalar, p.y * scalar)
end

mutable struct Node
	position::Pos
	velocity::Pos
	opt_position::Pos
end

mutable struct Spring
	connections::Tuple
	stiffness::Float64
	relax_length::Float64
end

mutable struct World
	nodes::Vector{Node}
	springs::Vector{Spring}
	optimization_threshold::Float64
	timestep_length::Float64
	drag::Float64
end

end
