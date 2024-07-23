module Types

export Pos, Node, Spring, World

struct Pos
	x::Float64
	y::Float64
end

struct Node
	position::Pos
	velocity::Pos
	opt_position::Pos
end

struct Spring
	connections::Tuple(Int,Int)
	stiffness::Float64
	relax_length::Float64
end

struct World
	nodes::Vector{Node}
	springs::Vector{Spring}
	optimization_threshold::Float64
	timestep_length::Float64
	drag_force::Float64
end

end
