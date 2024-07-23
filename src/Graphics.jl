module Graphics

using ..Types
using CairoMakie

export plot_world 

function plot_world(world::Types.World)
	fig = Figure()
	ax = Axis(fig[1, 1], title="Node and Spring Visualization", xlabel="X Position", ylabel="Y Position")	
	# Plot nodes
	node_xs = [node.position.x for node in world.nodes]
	node_ys = [node.position.y for node in world.nodes]
	
	scatter!(ax, node_xs, node_ys, color=:blue, markersize=10, label="Nodes")
	
	# Plot springs
	for spring in world.springs
		node1 = world.nodes[spring.connections[1]]
		node2 = world.nodes[spring.connections[2]]
	
		lines!(ax, [node1.position.x, node2.position.x], [node1.position.y, node2.position.y], color=:red, linewidth=2)
	end

	xlims!(ax, -3, 3)  # Set x-axis limits from -2 to 2
	ylims!(ax, -3, 3)  # Set y-axis limits from -2 to 2

	fig
end

end
