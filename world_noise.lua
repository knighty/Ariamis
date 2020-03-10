local noise = require("noise")
local NoiseUtilities = require("lib/noise_utilities")

local tne = noise.to_noise_expression

local WorldNoise = {}

local scale = 1

-- Declare our world noise sources
local worldNoiseSources = {
	temperature = {
        type = "perlin",
        intendedProperty = "temperature",
		parameters = {
			scale = 1536 * scale,
			persistence = 0.5,
			contrast = 2.5,
			seed = 0,
			octaves = NoiseUtilities.GetOctavesForScale(1024 * scale, -5)
		}
	},
	humidity = {
        type = "perlin",
        intendedProperty = "humidity",
		parameters = {
			scale = 1024 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 12,
			octaves = NoiseUtilities.GetOctavesForScale(512 * scale, -5)
		}
    },
    elevationVariation = {
		type = "perlin",
		parameters = {
			scale = 512 * scale,
			persistence = 0.3,
			contrast = 3,
			seed = 24,
			octaves = NoiseUtilities.GetOctavesForScale(1024 * scale, -5)
		}
	},
	elevation = {
        type = "perlin",
        intendedProperty = "elevation",
		parameters = {
			scale = 1024 * 2 * scale,
			persistence = 0.3,
			contrast = 3,
			seed = 36,
			octaves = NoiseUtilities.GetOctavesForScale(1024 * 2 * scale, -4)
		}
    },
    aux = {
		type = "perlin",
		parameters = {
			scale = 256 * scale,
			persistence = 0.5,
			contrast = 3,
			seed = 48,
			octaves = NoiseUtilities.GetOctavesForScale(256 * scale, -2)
		}
	},
	auxLarge = {
		type = "perlin",
		parameters = {
			scale = 1024 * scale,
			persistence = 0.5,
			contrast = 3,
			seed = 52,
			octaves = NoiseUtilities.GetOctavesForScale(1024 * scale, -5)
		}
	},
	river = {
		type = "perlin",
		parameters = {
			scale = 1200,
			persistence = 0.4,
			contrast = 15,
			midpoint = 0.5,
			seed = 64,
			octaves = NoiseUtilities.GetOctavesForScale(1200, -5)
		}
	},
	floodBasin = {
		type = "perlin",
		parameters = {
			scale = 1200,
			persistence = 0.4,
			contrast = 3,
			midpoint = 0.5,
			seed = 64,
			octaves = NoiseUtilities.GetOctavesForScale(1200, -5)
		}
	},
	volcano = {
        type = "perlin",
        intendedProperty = "elevation",
		parameters = {
			scale = 1024 * 2 * scale,
			persistence = 0.4,
			contrast = 3,
			seed = 76,
			octaves = NoiseUtilities.GetOctavesForScale(1024 * scale, -5)
		}
    },
}

local worldNoiseExpressions = {}

function WorldNoise.GetNoise(name)
	return worldNoiseExpressions[name]
end

function WorldNoise.DeclareWorldNoiseSource(name, fn, intendedProperty)
	worldNoiseExpressions[name] = NoiseUtilities.DeclareNoiseExpression("ta_wn_" .. name, fn(worldNoiseExpressions), intendedProperty)
end

local oceanThreshold = 0.45

-- Elevation variation
WorldNoise.DeclareWorldNoiseSource("elevationVariation", function(worldNoiseExpressions)
	return NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.elevationVariation)
end)

-- Elevation
WorldNoise.DeclareWorldNoiseSource("elevation", function(worldNoiseExpressions)
	local noiseSource = worldNoiseSources.elevation
	noiseSource.parameters.persistence = 0.3 + noise.clamp(worldNoiseExpressions.elevationVariation * 0.3, 0, 0.2)
	noiseExpression = NoiseUtilities.NoiseSourceToExpression(noiseSource)

	noiseExpression = (noiseExpression - oceanThreshold) * (1/ (1 - oceanThreshold))
	noiseExpression = NoiseUtilities.Saturate(noiseExpression)

	return noiseExpression
end)

NoiseUtilities.DeclareNoiseExpression("elevation", noise.var("ta_wn_elevation") * 100)

-- Aux
WorldNoise.DeclareWorldNoiseSource("aux", function(worldNoiseExpressions)
	return NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.aux)
end)

-- Aux
WorldNoise.DeclareWorldNoiseSource("auxLarge", function(worldNoiseExpressions)
	return NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.auxLarge)
end)

-- Ocean
WorldNoise.DeclareWorldNoiseSource("ocean", function(worldNoiseExpressions)
	local noiseSource = worldNoiseSources.elevation
	noiseSource.parameters.persistence = 0.3 + noise.clamp(worldNoiseExpressions.elevationVariation * 0.3, 0, 0.2)
	elevationExpression = NoiseUtilities.NoiseSourceToExpression(noiseSource)

	local ocean = tne(1) - elevationExpression
	ocean = ocean - (1 - oceanThreshold )
	ocean = ocean * ( 1 / oceanThreshold )

	return ocean
end)

-- River
WorldNoise.DeclareWorldNoiseSource("river", function(worldNoiseExpressions)
	local noiseSource = worldNoiseSources.river

	-- River is more bumpy at high elevation
	noiseSource.parameters.persistence = 0.3 + noise.clamp(worldNoiseExpressions.elevation * 0.2, 0, 0.1)
	noiseExpression = NoiseUtilities.NoiseSourceToExpression(noiseSource)

	-- River gets slightly wider at low elevation
	--noiseExpression = noise.clamp(noiseExpression + ((1 - noise.var("ta_wn_elevation")) * 0.25) ^ 2, 0, 1)
	--noiseExpression = noise.clamp(noiseExpression + (1 - (noise.clamp(noise.var("ta_wn_elevation"), 0.3, 0.301) - 0.3) / 0.001), 0, 1)

	return noiseExpression
end)

-- River Aux
WorldNoise.DeclareWorldNoiseSource("river_aux", function(worldNoiseExpressions)
	local noiseSource = worldNoiseSources.river

	-- River is more bumpy at high elevation
	noiseSource.parameters.persistence = 0.3 + noise.clamp(worldNoiseExpressions.elevation * 0.2, 0, 0.1)
	noiseSource.parameters.octaves = noiseSource.parameters.octaves - 2
	noiseExpression = NoiseUtilities.NoiseSourceToExpression(noiseSource)

	-- River gets slightly wider at low elevation
	--noiseExpression = noise.clamp(noiseExpression + ((1 - noise.var("ta_wn_elevation")) * 0.25) ^ 2, 0, 1)
	--noiseExpression = noise.clamp(noiseExpression + (1 - (noise.clamp(noise.var("ta_wn_elevation"), 0.3, 0.301) - 0.3) / 0.001), 0, 1)

	return noiseExpression
end)

-- River Aux 2
WorldNoise.DeclareWorldNoiseSource("river_aux_2", function(worldNoiseExpressions)
	return NoiseUtilities.Saturate(worldNoiseExpressions.river - worldNoiseExpressions.river_aux)
end)

-- Temperature
WorldNoise.DeclareWorldNoiseSource("temperature", function(worldNoiseExpressions)
	local noiseExpression = NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.temperature)

	-- Modulate with elevation. Higher = cooler
	noiseExpression = NoiseUtilities.Saturate(noiseExpression * (1 + (1 - worldNoiseExpressions.elevation * 2) * 0.2))

	return noiseExpression
end)

-- Humidity
WorldNoise.DeclareWorldNoiseSource("humidity", function(worldNoiseExpressions)
	local noiseExpression = NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.humidity)

	-- Modulate with flood basin. River provides moisture
	local floodBasin = NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.floodBasin)
	floodBasin = NoiseUtilities.Saturate((floodBasin - 0.5) * 2)
	noiseExpression = NoiseUtilities.Saturate(noiseExpression * 0.7 + floodBasin * 0.3)

	-- Modulate with low elevation. Ocean provides moisture
	noiseExpression = NoiseUtilities.Saturate(noiseExpression * 0.75 + (1 - NoiseUtilities.Saturate(worldNoiseExpressions.elevation)) * 0.25)

	return noiseExpression
end)

-- Mountain
WorldNoise.DeclareWorldNoiseSource("mountain", function(worldNoiseExpressions)
	local mountainThreshold = 0.6
	local mountain = noise.clamp(worldNoiseExpressions.elevation - mountainThreshold, 0, 1)
	mountain = mountain / (1 - mountainThreshold)

	return mountain
end)

-- Volcano
WorldNoise.DeclareWorldNoiseSource("volcano", function(worldNoiseExpressions)
	--[[local temperatureThreshold = 0.8
	local volcano = noise.clamp(worldNoiseExpressions.temperature - temperatureThreshold, 0, 1)
	volcano = volcano / (1 - temperatureThreshold)

	return volcano]]

	local volcano = NoiseUtilities.NoiseSourceToExpression(worldNoiseSources.volcano)

	local threshold = 0.8
	volcano = noise.clamp(volcano - threshold, 0, 1)
	volcano = volcano / (1 - threshold)

	return volcano
end)

return WorldNoise