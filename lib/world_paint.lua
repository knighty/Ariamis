local Biomes = require("biomes")
local PresetPainter = require("lib/preset_painter")
local Noise = require ("lib/noise_source")

local WorldPaint = {}

local scale = 1

local noiseTemperature = 1
local noiseHumidity = 2
local noiseElevation = 3
local noiseElevationVariation = 4
local noiseAux = 5
local noiseRiver = 6
local noiseOcean = 7

local worldNoiseSources = {
	{
		type = "perlin",
		parameters = {
			scale = 1024 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 0,
		}
	},
	{
		type = "perlin",
		parameters = {
			scale = 1024 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 23235.23523,
		}
	},
	{
		type = "perlin",
		parameters = {
			scale = 512 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 83235,
		}
	},
	{
		type = "perlin",
		parameters = {
			scale = 512 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 53235,
		}
	},
	{
		type = "perlin",
		parameters = {
			scale = 256 * scale,
			persistence = 0.5,
			contrast = 3.5,
			seed = 73235,
		}
	},
	{
		type = "perlin",
		parameters = {
			scale = 512 * scale,
			persistence = 0.35,
			contrast = 5,
			midpoint = 0.5,
			seed = 0.5,
		}
	},
}

local adjust = {
	type = "perlin",
	parameters = {
		scale = 32,
		persistence = 0.5,
		contrast = 2.5,
		seed = 7378324,
	}
}

local worldNoise = {}

function WorldPaint.GetBiomeAt(x,y)
	for _,worldNoiseSource in pairs(worldNoiseSources) do
		-- make river more squiggly where there's lots of elevation variation
		if _ == noiseRiver then
			worldNoiseSource.parameters.persistence = 0.2 + (worldNoise[noiseElevationVariation]) * 0.3
		end
		worldNoise[_] = Noise.GetNoise(worldNoiseSource, x, y)
	end
	if worldNoise[noiseElevation] < 0.4 then
		worldNoise[noiseOcean] = 1 - (worldNoise[noiseElevation]) * 1/0.4
	else
		worldNoise[noiseOcean] = 0
	end
	worldNoise[noiseElevation] = math.max(0, (worldNoise[noiseElevation] - 0.4) * 1/0.6)
	
	-- river gets wider near the coast
	--worldNoise[noiseRiver] = math.max(0, math.min(1, worldNoise[noiseRiver] + math.pow(1 - worldNoise[noiseElevation], 2) * 0.1))
	
	-- Select biome
	local selectedBiome = nil
	for _,biome in pairs(Biomes.GetBiomes()) do
		if selectedBiome == nil and biome.preset then
			local canPlace = true
			for noiseIndex,layer in pairs(biome.numericLayers) do
				if worldNoise[noiseIndex] < layer[1] then
					canPlace = false
				end
				if worldNoise[noiseIndex] > layer[2] then
					canPlace = false
				end
			end
			if canPlace then
				selectedBiome = biome
			end
		end
	end

	return selectedBiome
end

function WorldPaint.PaintChunk(surface, xPos, yPos, w, h)
	local chunkSize = 32
	local paintBiomes = {}	
	
	local entities = surface.find_entities({left_top = {x = xPos, y = yPos}, right_bottom = {x = xPos + w, y = yPos + h}})
	for _,entity in pairs(entities) do
		if entity.type ~= "character" then
			entity.destroy()
		end
	end
		
	for y = yPos, yPos + h do
		for x = xPos, xPos + w do			
			surface.destroy_decoratives({position = {x = x, y = y}})
			local adjustNoise = (Noise.GetNoise(adjust, x, y) * 0.5 + 0.5) * 0.01
			local selectedBiome = WorldPaint.GetBiomeAt(x,y)
			
			if paintBiomes[selectedBiome] == nil then
				paintBiomes[selectedBiome] = {}
			end
			
			paintBiomes[selectedBiome][#paintBiomes[selectedBiome] + 1] = {x, y}
		end
	end
	
	for biome, positions in pairs(paintBiomes) do
		PresetPainter.Paint(surface, biome.preset.layers, {}, { positions = positions })
	end
end

function GetWorldGenQueueState()
	if global.worldGenQueueState == nil then
		global.worldGenQueueState = {
			queue = {},
			tickState = 0,
			startIndex = 1,
			endIndex = 1
		}
	end
	return global.worldGenQueueState
end

function WorldPaint.OnTick(event)
	local queueState = GetWorldGenQueueState()
	if event.tick % 1 == 0 then
		if queueState.queue[queueState.startIndex] ~= nil then
			local item = queueState.queue[queueState.startIndex]
			local surface = game.get_surface(item.surfaceIndex)
			if surface.valid then
				local x = item.position.x * 32 + (queueState.tickState % 4) * 8
				local y = item.position.y * 32 + (math.floor(queueState.tickState / 4)) * 8
				WorldPaint.PaintChunk(surface, x, y, 8, 8)

				queueState.tickState = queueState.tickState + 1

				if queueState.tickState == 16 then
					queueState.tickState = 0
					queueState.queue[queueState.startIndex] = nil
					queueState.startIndex = queueState.startIndex + 1
					--game.players[1].print("Queue: " .. queueIndexStart .. " / " .. queueIndexEnd)
				end
			else
				queueState.tickState = 0
				queueState.queue[queueState.startIndex] = nil
				queueState.startIndex = queueState.startIndex + 1
			end
		end
	end
end

function OnChunkGenerated(event)
	local queueState = GetWorldGenQueueState()
	queueState.queue[queueState.endIndex] = {surfaceIndex = event.surface.index, position = event.position}
	queueState.endIndex = queueState.endIndex + 1
end

local currentBiome = nil
function OnPlayerChangedPosition(event)
	local player = game.get_player(event.player_index)
	local biome = WorldPaint.GetBiomeAt(player.position.x, player.position.y)
	if currentBiome ~= biome then
		currentBiome = biome
		if biome.name ~= nil then
			player.surface.create_entity{name = "flying-text", position = {player.position.x-1.3,player.position.y-0.5}, text = biome.name, color = {r=1,g=0.6,b=0.6}}
		end
	end
end

--script.on_event(defines.events.on_chunk_generated, OnChunkGenerated)
--script.on_event(defines.events.on_tick, WorldPaint.OnTick)
--script.on_event(defines.events.on_player_changed_position, OnPlayerChangedPosition)