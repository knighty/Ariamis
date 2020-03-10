local noise = require("noise")
local tne = noise.to_noise_expression

local NoiseUtilities = {}

function NoiseUtilities.GetOctavesForScale(scale, adjust)
	adjust = adjust or 0
	
	local octaves = 1 + math.floor(math.log(scale) / math.log(2))
	return math.max(1, octaves + adjust)
end

local octaveNoiseCache = {}
local octaveNoiseCacheHits = 0
local octaveNoiseCacheAccesses = 0

function NoiseUtilities.GetOctaveNoiseCacheHitRate()
	return octaveNoiseCacheHits / octaveNoiseCacheAccesses
end

function NoiseUtilities.GetOctaveNoise(scale, persistence, seed, octaves, opts)
	local hasOpts = opts ~= nil
	if opts == nil then opts = {} end
	if opts.x == nil then opts.x = noise.var("x") end
	if opts.y == nil then opts.y = noise.var("y") end
	--opts.x = opts.x or noise.var("x")
	--opts.y = opts.y or noise.var("y")

    octaves = octaves or NoiseUtilities.GetOctavesForScale(scale)
	local noiseExpression = nil
    local persistenceIsNumber = type(persistence) == "number"
	
	local cacheKey = nil
	if persistenceIsNumber and hasOpts == false then
		cacheKey = scale .. "_" .. persistence .. "_" .. (seed or 0) .. "_" .. octaves
	end

	if octaveNoiseCache[cacheKey] then
		octaveNoiseCacheAccesses = octaveNoiseCacheAccesses + 1
		octaveNoiseCacheHits = octaveNoiseCacheHits + 1
		return octaveNoiseCache[cacheKey]
	else
		local maxValue = 0
		local amplitude = 1

		if persistenceIsNumber == false then
			maxValue = tne(0)
			amplitude = tne(1)
		end

		local frequency = 1
		for i=1,octaves do
			local octaveExpression = tne{
				type = "function-application",
				function_name = "factorio-basis-noise",
				arguments = {
					x = opts.x + 1000,
					y = opts.y + 1000,
					seed0 = tne(noise.var("map_seed")),
					seed1 = tne((seed or 0) % 255),-- tne((123 + layerIndex * 100 + paintIndex) % 255),
					input_scale = tne(frequency / scale),
					output_scale = tne(1)
				}
			}

			if noiseExpression then
				noiseExpression = noiseExpression + octaveExpression * tne(amplitude)
			else
				noiseExpression = octaveExpression
			end

			maxValue = maxValue + amplitude

			frequency = frequency * 2
			amplitude = amplitude * persistence
		end

		noiseExpression = noiseExpression / maxValue

		noiseExpression = noise.delimit_procedure(noiseExpression)
		
		if cacheKey then
			octaveNoiseCache[cacheKey] = noiseExpression
			octaveNoiseCacheAccesses = octaveNoiseCacheAccesses + 1
		end

		return noiseExpression
	end
end

function NoiseUtilities.DeclareNoiseExpression(name, expression, intendedProperty)
    data:extend({
        {
            type = "noise-expression",
            name = name,
			expression = expression,
			intended_property = intendedProperty
        }
    })

	return noise.var(name)
end

function NoiseUtilities.NoiseSourceToExpression(source, opts)
	local parameters = source.parameters
	
	-- Apply contrast
	local expression = noise.clamp(NoiseUtilities.GetOctaveNoise(parameters.scale, parameters.persistence or 0.5, parameters.seed or 0, parameters.octaves, opts) * tne((parameters.contrast or 1) * 0.3), -1, 1)-- ^ 1.16

	-- Compress into 0 -> 1 range
	expression = expression * 0.5 + 0.5

	-- Apply midpoint
	if parameters.midpoint and parameters.midpoint ~= 1 then
		expression = tne(1) - noise.absolute_value( tne(parameters.midpoint) - expression )
	end

	return expression
end

function NoiseUtilities.Saturate(expression)
	return noise.clamp(expression, 0, 1)
end

function NoiseUtilities.ToBinary(expression)
	return noise.clamp(expression, 0, 0.0001) / 0.0001
end

local function random_penalty(source, random_penalty_amplitude, opts, seed)
	if opts == nil then opts = {} end
	seed = seed or 0
	if random_penalty_amplitude == nil then random_penalty_amplitude = 1 end
	return tne{
		type = "function-application",
		function_name = "random-penalty",
		arguments =	{
			x = noise.var("x"),
			y = noise.var("y"),
			source = tne(source),
			seed = tne(seed),
			amplitude = tne(random_penalty_amplitude)
		}
	}
end

function NoiseUtilities.SeededRandom(amplitude, seed)
	return random_penalty(amplitude, amplitude, nil, seed)
end

return NoiseUtilities