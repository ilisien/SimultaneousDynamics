module Graphics

using ..Types
using CairoMakie

export plot_world 

function plot_world(world::Types.World)
	fig = Figure(size=(2500,1500), padding=(0,0,0,0))
	ax = Axis(fig[1, 1], 
			  aspect=DataAspect(),
			  xlabel="", ylabel="",
			  xticklabelsvisible=false, yticklabelsvisible=false,
			  xticksvisible=false, yticksvisible=false,
			  xgridvisible=false, ygridvisible=false,
			  leftspinevisible=false, rightspinevisible=false,
			  bottomspinevisible=false, topspinevisible=false)	
	# Plot nodes
	node_xs = [node.position.x for node in world.nodes]
	node_ys = [node.position.y for node in world.nodes]
	
	# Plot springs
	for spring in world.springs
		node1 = world.nodes[spring.connections[1]]
		node2 = world.nodes[spring.connections[2]]
	
		lines!(ax, [node1.position.x, node2.position.x], [node1.position.y, node2.position.y], color=:black, linewidth=20)
	end

	scatter!(ax, node_xs, node_ys, color=:red, markersize=40)

	xlims!(ax, -2, 10)
	ylims!(ax, -4, 4)
	hidedecorations!(ax)
	hidespines!(ax)

	return fig
end

end
