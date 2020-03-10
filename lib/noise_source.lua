require "perlin"
local Debugger = require ("lib/debugger")

local NoiseSource = {}

local min = math.min
local max = math.max
local abs = math.abs
local log = math.log
local floor = math.floor

function NoiseSource.GetNoise(noiseSource, x, y, strength)



	-- No Noise
	--if noiseSource.type == "none" then
	--	return 1
	--end

	-- Perlin Noise
	--if noiseSource.type == "perlin" then
	
		local parameters = noiseSource.parameters
	
		local inverseScale = 1 / parameters.scale
		local octaves = log(parameters.scale)/log(2)
		local seed = parameters.seed or 0
		local perlin = perlinOctaves(x * inverseScale + seed,y * inverseScale + seed, 0, floor(octaves), parameters.persistence or 0.5)
		
		-- Contrast
		perlin = (parameters.contrast or 1) * perlin
		
		-- Clamp
		perlin = max(-1,min(1,perlin))
		
		-- Compress into 0 -> 1
		perlin = perlin * 0.5 + 0.5 
		
		-- Convert 0 -> 1 into range based from the midpoint
		perlin = 1 - abs( (parameters.midpoint or 1) - perlin ) 
	
		return perlin
		
	--end


end

return NoiseSource