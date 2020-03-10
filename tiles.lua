-- Go through each biome

local NoiseUtilities = require("lib/noise_utilities")
local PreviewBiomePlacer = require("biome_placers/preview")
local WorldNoiseBiomePlacer = require("biome_placers/world_noise_placer")
local noise = require("noise")
local Biomes = require("biomes")
local tne = noise.to_noise_expression

local WorldNoiseProcessor = {}

function WorldNoiseProcessor.CreateControls()
	data:extend{
		{
			type = "autoplace-control",
			name = "Humidity",
			order = "z-a",
			category = "terrain",
			richness = true,
		},
		{
			type = "noise-expression",
			name = "control-setting:humidity:frequency:multiplier",
			expression = noise.to_noise_expression(1)
		},
		{
			type = "noise-expression",
			name = "control-setting:humidity:bias",
			expression = noise.to_noise_expression(0)
		},
	}
end

WorldNoiseProcessor.BiomePlacer = WorldNoiseBiomePlacer

WorldNoiseProcessor.BiomePlacer.Init()

function WorldNoiseProcessor.GetBiomeExpression(index, biome)
	return WorldNoiseProcessor.BiomePlacer.GetBiomeExpression(index, biome)
end

-- Iterate over biomes
local previousBiomesExpression = tne(0)
local previousBiomeStack = {}
local biomeIndex = 0
local biomeMode = "layerExpression"

-- Accumulate resources
local resourceExpression = tne(0)
for _,resource in pairs(data.raw.resource) do
	resource.autoplace.probability_expression = tne(0)
	resource.autoplace.richness_expression = tne(0)
    if resource.autoplace.probability_expression then
        --resourceExpression = resourceExpression + NoiseUtilities.ToBinary(resource.autoplace.probability_expression)
    end
end

resourceExpression = NoiseUtilities.DeclareNoiseExpression("ta_resource_noise_expression", NoiseUtilities.Saturate(tne(1) - resourceExpression))
--previousBiomeStack[#previousBiomeStack + 1] = NoiseUtilities.DeclareNoiseExpression("ta_resource_noise_expression", resourceExpression)

for biomeName, biome in pairs(Biomes.GetBiomes()) do
    biomeIndex = biomeIndex + 1
	if biome.preset then
		-- Get the base biome expression
        local biomeNoiseExpression = WorldNoiseProcessor.GetBiomeExpression(biomeIndex, biome)

        -- Create an expression for this biome on its own
        local biomeExpressionName = "ta_biome_" .. biomeName
        local layerBiomeExpression = NoiseUtilities.DeclareNoiseExpression(biomeExpressionName, biomeNoiseExpression)

        -- Subtract previous biomes if applicable
        if biomeMode == "individualLayers" or biomeMode == "accumulativePartial" or biomeMode == "layerExpression" then
            for _,e in pairs(previousBiomeStack) do
                if type(e) == "string" then
                    layerBiomeExpression = layerBiomeExpression - noise.var(e)
                else
                    layerBiomeExpression = layerBiomeExpression - e
                end
            end
        end

        if biomeMode == "layerExpression" then
            previousBiomeStack[#previousBiomeStack + 1] = biomeExpressionName
        end

        layerBiomeExpression = NoiseUtilities.Saturate(layerBiomeExpression)

        local layerExpressionStack = {}
        for layerIndex,layer in pairs(biome.preset.layers) do
            if layer.enabled then
                local previousPaint = nil

				-- Create an expression representing the previous layers
                local previousLayersExpression = tne(0)
                local hasPreviousLayers = false
                for _,layerExpression in pairs(layerExpressionStack) do
                    previousLayersExpression = previousLayersExpression + layerExpression
                    hasPreviousLayers = true
                end

				local layerExpression = nil

				-- Iterate over each paint in the layer
                for paintIndex,paint in pairs(layer.paints) do

					-- Get the prototype to work on
                    local prototype = nil
                    if paint.tile then
                        prototype = data.raw.tile[paint.tile]
                    elseif paint.decorative then
                        prototype = data.raw["optimized-decorative"][paint.decorative]
                    elseif paint.entity then
                        prototype = data.raw["simple-entity"][paint.entity]
                        if prototype == nil then
                            prototype = data.raw["tree"][paint.entity]
                        end
                    elseif paint.resource then
						prototype = data.raw["resource"][paint.resource]
					end

                    if prototype then
                        -- Create noise expression
                        local paintExpression = nil
  
						if paint.threshold == 0 then
							paintExpression = tne(1)
						else
							paint.noiseSource.parameters.scale = paint.noiseSource.parameters.scale
							paintExpression = NoiseUtilities.NoiseSourceToExpression(paint.noiseSource)

							 -- Apply threshold
							 local threshold = tne(paint.threshold)-- + ( tne(1) - layerBiomeExpression ) * tne( 1.01 - paint.threshold )
							 paintExpression = NoiseUtilities.Saturate(paintExpression - threshold)
						end

                        if paint.tile then
                            paintExpression = NoiseUtilities.ToBinary(paintExpression)
                        end
                        if paint.decorative then
                            paintExpression = paintExpression / (1 - paint.threshold)
							local frequency = math.pow(paint.frequency, 2)
							
							-- This gives us a random value such that `frequency` values are above 0
							-- eg. frequency of 0.5 generates values between -1 and 1, giving 50% of values greater than 0
                            local randProbability = NoiseUtilities.ToBinary( tne(1) - NoiseUtilities.SeededRandom(1 / frequency, layerIndex * 10 + paintIndex))
                            paintExpression = paintExpression * randProbability
                            paintExpression = paintExpression * (paint.maximum / 8) * resourceExpression
                        end
                        if paint.entity then
                            paintExpression = paintExpression / (1 - paint.threshold)
							local frequency = math.pow(paint.frequency, 2)
							local randProbability = NoiseUtilities.ToBinary( tne(1) - NoiseUtilities.SeededRandom(1 / frequency, layerIndex * 10 + paintIndex))
                            paintExpression = paintExpression * randProbability * resourceExpression
                        end

                        -- Multiply by previous paint so we can only paint on previous paints in a layer
                        if previousPaint then
							paintExpression = paintExpression * previousPaint
						-- Otherwise use the layer biome expression as our mask
						else
							paintExpression = paintExpression * layerBiomeExpression

							-- If there are previous layers, subtract them so we don't draw over them
							if hasPreviousLayers then
								paintExpression = noise.clamp(paintExpression - previousLayersExpression * 100, 0, 100)
							end
						end

                        -- Tiles should be binary
                        if paint.tile then
                            paintExpression = NoiseUtilities.ToBinary(paintExpression)
						end

						-- Declare it as a named expression
						paintExpression = NoiseUtilities.DeclareNoiseExpression("ta_" .. biomeName .. "_" .. layerIndex .. "_" .. paint.type .. "_" .. paintIndex, paintExpression)

                        local probabilityExpression = paintExpression

						-- If it's a tile, we need to multiply it by the paint index so it paints over ones already laid in this biome
                        if paint.tile then
                            probabilityExpression = probabilityExpression * (1 + paintIndex) 
						end
						
						if paint.resource then
							probabilityExpression = NoiseUtilities.ToBinary(probabilityExpression)
						end

                        -- Apply the paint rule to the existing prototype autoplace specification
                        if prototype.autoplace and prototype.autoplace.probability_expression then
                            prototype.autoplace.probability_expression = prototype.autoplace.probability_expression + probabilityExpression
                        else
                            prototype.autoplace = {
                                probability_expression = probabilityExpression
							}
						end
						
						if paint.resource then
							local richnessExpression = NoiseUtilities.Saturate(paintExpression / (1 - paint.threshold)) ^ 2 -- Exponentiate for reasons...
							prototype.autoplace.richness_expression = (prototype.autoplace.richness_expression or tne(0)) + richnessExpression * paint.richness
						end

                        -- If the paint is a decorative
                        if paint.decorative then
                            prototype.autoplace.placement_density = 7
                            prototype.autoplace.order = layerIndex * 10 + paintIndex
                            prototype.autoplace.richness_expression = tne(0)
                        end

                        -- If it's an entity
                        if paint.entity then
                            prototype.autoplace.placement_density = 1

                            -- This controls selected variation
                            prototype.autoplace.richness_expression = tne(1)
                        end

                        -- If it's a tile we should set the previousPaint to this one
						if paint.tile then
							if previousPaint == nil then
								previousPaint = paintExpression
							end
							
							--[[
							if string.match(prototype.name, "grass") then
								prototype.map_color = { r = 104, g = 129, b = 80 }
							end

							if string.match(prototype.name, "sand") then
								prototype.map_color = { r = 195, g = 168, b = 109 }
							end

							if string.match(prototype.name, "desert") then
								prototype.map_color = { r = 195, g = 168, b = 109 }
							end

							if string.match(prototype.name, "dirt") then
								prototype.map_color = { r = 99, g = 88, b = 63 }
							end]]

                            -- If it's the first tile, we'll set it as our layer mask
                            if layerExpression == nil then
                                layerExpression = paintExpression
                            end
                        end
                    end
                end

                -- If we have a layer expression, add it to the stack to prevent subsequent layers drawing over it
                if layerExpression then
					local layerExpressionName = "ta_layer_" .. biomeIndex .. "_" .. layerIndex
					layerExpressionStack[#layerExpressionStack + 1] = NoiseUtilities.DeclareNoiseExpression(layerExpressionName, layerExpression)
                end
            end
        end

        if biomeMode == "accumulative" then
            -- Create an expression for the biome by summing together the layers we rendered and adding onto the existing biome expression
            local biomeExpression = tne(0)
            for _,expression in pairs(layerExpressionStack) do
                biomeExpression = biomeExpression + expression
            end
            biomeExpression = NoiseUtilities.ToBinary(biomeExpression)

            previousBiomesExpression = noise.delimit_procedure(previousBiomesExpression + biomeExpression)
        elseif biomeMode == "accumulativePartial" then
            local biomeExpression = tne(0)
            for _,expressionName in pairs(layerExpressionStack) do
                biomeExpression = biomeExpression + noise.var(expressionName)
            end
            biomeExpression = NoiseUtilities.ToBinary(biomeExpression)

			local biomeExpressionName = "ta_biome_placed_" .. biomeName
			NoiseUtilities.DeclareNoiseExpression(biomeExpressionName, biomeExpression)

            previousBiomeStack[#previousBiomeStack + 1] = biomeExpressionName
        elseif biomeMode == "individualLayers" then
            for _,e in pairs(layerExpressionStack) do
                previousBiomeStack[#previousBiomeStack + 1] = e
            end
        end
    end
end

log("Octave Noise Cache Hit Percentage: " .. math.floor(NoiseUtilities.GetOctaveNoiseCacheHitRate() * 100)  .. "%")