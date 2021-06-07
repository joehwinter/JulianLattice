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

function createLattice(size :: Int64, parts :: Vector)
	lattice = initaliseLattice(size,parts)
	for part in parts
		if part.infected == true
			lattice[part.x,part.y] =  -1
	    else
			lattice[part.x,part.y] = 1
		end
	end
	return lattice 
end

function createLattice(lattice :: Matrix, parts :: Vector)
	size = length(lattice[1:end,1]) -2
	lattice = initaliseLattice(size,parts)
	for part in parts
		if part.infected == true
			lattice[part.x,part.y] =  -1
	    else
			lattice[part.x,part.y] = 1
		end
	end
	return lattice 
end

function collision(part:: particle, lattice:: Matrix)
	dirVectors = ([0,1],[1,1],[1,0],[1,-1],[0,-1],[-1,-1],[-1,0],[-1,1])
	collQuery = [false,false,false,false,false,false,false,false]
	infection = false 
	NBH = [part.pos + dirVector for dirVector in dirVectors]
	allowedNBH = []
	for i in 1:8
		if lattice[NBH[i][1],NBH[i][2]] == 0 
		elseif lattice[NBH[i][1],NBH[i][2]] == -1
			infection = true
			collQuery[i] = true
		else 
			collQuery[i] = true
		end
	end 
	
	for i in 1:8
		if collQuery[i] == false
			push!(allowedNBH,NBH[i])
		end
	end
	return (allowedNBH, infection)

end

function move!(part:: particle, lattice:: Matrix)
	coldata = collision(part,lattice)
	if coldata[2] == true
		part= particle(rand(coldata[1]),true)
	else
		part= particle(rand(coldata[1]),part.infected)
	end
return part 
end 

function dynamics!(lattice, parts)
	for i in 1:length(parts)
		parts[i] = move!(parts[i],lattice)
		lattice = createLattice(lattice, parts)
	end 
return (lattice,parts)
end

function initaliseParticles(size,num,initPercent)
	parts = []
	infParts = [] 
	nonInfParts = [] 

	for i in  1:round(num * initPercent)
		push!(parts, particle(rand(2:size-1, (2)),true))
		push!(infParts, last(parts))
	end 
	
	for i in  1:(num - round(num * initPercent))
		push!(parts, particle(rand(2:size-1, (2)),false))
		push!(nonInfParts, last(parts))
	end 

	return (parts,nonInfParts,infParts)
end

function initaliseLattice(size,parts)
	lattice = zeros( Int64, size +2 , size +2)
	for i in 1:(size+2)
		lattice[1,i] = 1 
		lattice[size+2,i] = 1
		lattice[i,1] = 1
		lattice[i,size+2] = 1
	end
return lattice
end

function sim!(lattice,parts,n)
	if  n == 0
		return (lattice,parts)
	else
		println(n)
		step = sim!(lattice,parts,n-1)
		return dynamics!(step[1],step[2])
		

	end
end

function AnimatedSim(lattice, parts)

end


#Initialising Packages
using Colors,Plots


#input variables 
size = 100 
num = 30 
initPercent = .30

#initialisation 
partLists = initaliseParticles(size,num,initPercent)
parts = partLists[1]
nonInfParts = partLists[2]
infParts = partLists[3]
lattice = createLattice(size,parts)


anim = @animate for i in 1:500
	global lattice
	global parts
	heatmap(lattice,color = :redsblues)
	dyn = dynamics!(lattice, parts)
	lattice = dyn[1]
	parts = dyn[2]
end
gif(anim, "lattice_100.gif", fps =30)







