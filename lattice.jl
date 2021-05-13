abstract type AbstractParticle end

struct particle <: AbstractParticle
	x :: Int64
	y :: Int64
	pos :: Vector
	infected :: Bool
	function particle(x :: Int64,y :: Int64,infected :: Bool)
		typeof([x,y])
		new(x,y,[x,y],infected)
	end 
	function particle(pos :: Vector, infected :: Bool)
		new(pos[1],pos[2],pos,infected)
	end 
end 

function updateLattice!(lattice :: Matrix, parts :: Vector)
	for i in parts
		if parts[i].infected == true
			lattice[parts[i].x,parts[i].y] = -1 
	    else
			lattice[parts[i].x,parts[i].y] = 1
		end
	end
	return lattice 
end

function collision(part :: particle)
end




#initialise the lattice 
size = 100 
num = 20 
lattice = zeros( Int64, size +2 , size +2)
parts = []
infParts = [] 
nonInfParts = [] 
initPercent = .30

for i in  1:round(num * initPercent)
	push!(parts, particle(rand(1:size, (2)),true))
	push!(infParts, last(parts))
end 

for i in  1:(num - round(num * initPercent))
	push!(parts, particle(rand(1:size, (2)),true))
	push!(nonInfParts, last(parts))
end 

lattice = updateLattice!(lattice, parts)







