local noise = require("noise")
local NoiseUtilities = require("lib/noise_utilities")
local tne = noise.to_noise_expression

local max = 1
local min = 0
local very_low = 0.15
local low = 0.3
local medium = 0.5
local high = 0.7
local very_high = 0.85

local Biomes = {
}

-- Beach threshold is affected by how rough the terrain is. The more rough, the less beach
local beachAmount = noise.clamp(tne(1) - noise.var("ta_wn_elevationVariation") * 1.1, 0, 1) * noise.clamp(-very_low + noise.var("ta_wn_temperature"), 0, 1)
local beachThreshold = beachAmount * 0.1

riverWidth = 0.1 * (noise.var("ta_wn_elevation") ^ 2)
local riverThreshold = noise.clamp(0.96 + riverWidth, 0, 2)

function modulate(min, max, amount)
	return min + (max - min) * amount
end

local world = "ariamis"

local oreNoiseSource = {type="perlin",parameters={contrast=2.4,scale=256,midpoint=0.5,persistence=0.35,octaves=4}}

local x = noise.var("x")
local y = noise.var("y")

local oreNoise = NoiseUtilities.NoiseSourceToExpression(oreNoiseSource)
local oreNoiseX = NoiseUtilities.NoiseSourceToExpression(oreNoiseSource, {x = x + 6})
local oreNoiseX2 = NoiseUtilities.NoiseSourceToExpression(oreNoiseSource, {x = x - 6})
local oreNoiseY = NoiseUtilities.NoiseSourceToExpression(oreNoiseSource, {y = y + 6})
local oreNoiseY2 = NoiseUtilities.NoiseSourceToExpression(oreNoiseSource, {y = y - 6})

local highEnough = NoiseUtilities.ToBinary(tne(oreNoise) - 0.95)
local borderX = NoiseUtilities.ToBinary(oreNoise - oreNoiseX)
local borderX2 = NoiseUtilities.ToBinary(oreNoise - oreNoiseX2)
local borderY = NoiseUtilities.ToBinary(oreNoise - oreNoiseY)
local borderY2 = NoiseUtilities.ToBinary(oreNoise - oreNoiseY2)

local oreNoiseFinal = highEnough * NoiseUtilities.Saturate(borderX * borderX2 + borderY * borderY2)

local richnessSource = {type="perlin",parameters={contrast=2.8,scale=512,midpoint=1,persistence=0.3,octaves=4}}
local richness = NoiseUtilities.NoiseSourceToExpression(richnessSource) ^ 3
local veinThreshold = 0.99

function Biomes.GetBiomes()
	if Biomes.biomes == nil then
		if world == "moon" then
			Biomes.biomes = {
				lunar = {
					layers = {},
					preset={layers={
						{name="New Layer",paints={
							{type="resource",radius=16,brushStrength=1,noiseStrength=1,threshold=veinThreshold,noiseSource={type="perlin",parameters={contrast=2.4000000000000004,scale=1024,midpoint=0.5,persistence=0.4}},resource="iron-ore",richness=richness * 10000},
							--{type="resource",radius=16,brushStrength=1,noiseStrength=1,threshold=(1 - oreNoiseFinal),noiseSource={type="perlin",parameters={contrast=1,scale=1,midpoint=1}},resource="iron-ore",richness=200000}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=veinThreshold,noiseSource={type="perlin",parameters={contrast=2.4000000000000004,scale=1024,midpoint=0.5,persistence=0.4}},tile="mineral-beige-dirt-2"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="stone-decal-white",minimum=1,maximum=2,frequency=0.30000000000000004},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.58999999999999995,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},entity="rock-huge-white",frequency=0.2},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.49000000000000004,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.35000000000000004,decorative="rock-medium-white",minimum=1,maximum=2}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=veinThreshold * 0.99,noiseSource={type="perlin",parameters={contrast=2.3999999999999999,scale=1024,midpoint=0.5,persistence=0.4}},tile="mineral-beige-dirt-4"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="sand-decal-white",minimum=1,maximum=2,frequency=0.30000000000000004},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},entity="rock-huge-white",frequency=0.15},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.3,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.3,decorative="rock-medium-white",minimum=1,maximum=4},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.2,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.4,decorative="rock-small-white",minimum=1,maximum=4}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.45,noiseSource={type="perlin",parameters={contrast=2.5,scale=112,midpoint=1}},tile="mineral-beige-dirt-5"},
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=1,noiseSource={type="perlin",parameters={contrast=2.5,scale=112,midpoint=1}},tile="mineral-beige-dirt-1"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="crater1-large",frequency=0.05,minimum=1,maximum=1}
						},enabled=false},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.91,noiseSource={type="perlin",parameters={contrast=2.4000000000000004,scale=28,midpoint=0.5,persistence=0.5,octaves=2}},tile="mineral-beige-dirt-5"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.3,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.5,decorative="rock-medium-white",minimum=1,maximum=4},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.2,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.7,decorative="rock-small-white",minimum=1,maximum=4},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.1,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},frequency=0.8,decorative="rock-tiony-white",minimum=1,maximum=4},
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=1,scale=128,midpoint=1}},tile="mineral-beige-dirt-2"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},decorative="hairy-grass-blue",minimum=1,maximum=6,frequency=1},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},decorative="hairy-grass-mauve",minimum=1,maximum=6,frequency=1},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="sand-decal-purple",minimum=1,maximum=1,frequency=0.30000000000000004},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.65,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},entity="tree-grassland-i",frequency=0.7},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.65,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},entity="tree-wetland-l",frequency=0.7}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="mineral-beige-dirt-6"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="crater1-large",minimum=1,maximum=1,frequency=0.05},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.45,noiseSource={type="perlin",parameters={contrast=2.8000000000000004,scale=32,midpoint=1}},decorative="crater4-small",minimum=1,maximum=1,frequency=0.30000000000000004},
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.8-0.05,noiseSource={type="perlin",parameters={contrast=2.5,scale=64,midpoint=1,persistence=0.3,octaves=3}},tile="mineral-beige-dirt-2"},
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.8,noiseSource={type="perlin",parameters={contrast=2.5,scale=64,midpoint=1,persistence=0.3,octaves=3}},tile="mineral-beige-dirt-5"},
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Lunar",created=55,author=1}
				}
			}
		else
			Biomes.biomes = {
				glacier = {
					layers = {
						temperature = {min, low, 1.5},
						ocean = {min, very_low, 3},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=modulate(0, 1, noise.clamp(noise.var("ta_wn_ocean") * 32, 0, 1)),noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},tile="frozen-snow-2"},
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=modulate(0, 1, noise.clamp(noise.var("ta_wn_ocean") * 32, 0, 1)) - 0.25,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},tile="water"}
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=103,midpoint=1}},tile="frozen-snow-5"},						
							--{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46999999999999993,noiseSource={type="perlin",parameters={contrast=3.3000000000000003,scale=12,midpoint=1}},tile="frozen-snow-6"},
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=modulate(1, 0, noise.clamp(noise.var("ta_wn_ocean") * 3, 0, 1) * noise.clamp(noise.var("ta_wn_temperature") * 5, 0, 1)),noiseSource={type="perlin",parameters={contrast=5,scale=24,midpoint=0.5,persistence=0.35,seed=121}},tile="deepwater"}
						},enabled=true}
					},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				--[[oceanFoam = {
					layers = {
						ocean = {low, low + 0.01},
					},
					preset = {layers={{name="New Layer",paints={
						{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=256,midpoint=0.5,persistence=0.30000000000000004}},tile="water"},
						{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=1,frequency=0.2},
					},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},--]]
				ocean = {
					layers = {
						ocean = {min, max},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=noise.clamp(1 - noise.var("ta_wn_ocean") * 16, 0, 1),noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=32,midpoint=1,persistence=0.6}},tile="deepwater"}
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=256,midpoint=0.5,persistence=0.30000000000000004}},tile="water"}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				river = {
					layers = {
						temperature = {min, max},
						river = {riverThreshold, max},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.95,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=64,midpoint=0.5,persistence=0.30000000000000004}},tile="water-mud"},
							--{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=1,frequency=0.1},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="rock-medium",minimum=1,maximum=2,frequency=0.2},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="rock-small",minimum=1,maximum=2,frequency=0.3},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="rock-tiny",minimum=1,maximum=2,frequency=0.5},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="green-pita-mini",minimum=1,maximum=4,frequency=0.5},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=1,frequency=0.2},
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=1,midpoint=1,persistence=0.30000000000000004}},tile="water-mud"},
							--{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=1,frequency=0.05},
							--{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-rock-medium",minimum=1,maximum=2,frequency=0.1},
						},enabled=true}
					},masks={},brush={radius=0.1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},	
				riverBankReeds = {
					layers = {
						river = {riverThreshold - 0.005, max},
						temperature = {low, high},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=1,midpoint=1,persistence=0.30000000000000004}},tile="water-mud"},						
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=9,frequency=0.75},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=3,frequency=0.75}
						},enabled=true}
					},masks={},brush={radius=0.1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				riverBank = {
					layers = {
						river = {riverThreshold - 0.01, max},
						temperature = {low, high},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=1,midpoint=1,persistence=0.30000000000000004}},tile="dirt-4"},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=1,frequency=0.7},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=6,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=9,frequency=0.5},
							{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=6,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=3,frequency=0.60000000000000009},
							{type="entity",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=6,midpoint=1}},minimum=1,maximum=9,frequency=0.4,entity="tree-wetland-i"}
						},enabled=true}
					},masks={},brush={radius=0.1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Riverbank Grassy",created=816,author=1}
				},
				
				--[[riverBankHot = {
					layers = {
						river = {0.97, max},
						temperature = {high, max},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=1,midpoint=1,persistence=0.30000000000000004}},tile="water-mud"},
							--{type="decorative",radius=16,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=1,midpoint=1}},decorative="river-decal",minimum=1,maximum=2,frequency=0.6},
						},enabled=true}
					},masks={},brush={radius=0.1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},]]
				--[[volcanicBeach = {
					layers = {
						temperature = {high, max},
						ocean = {min + 0.001, low},
					},
					preset = Import("eNq9lsGO2jAQhl8F5WyjBAiwWvm017aHVuoVGWcgFo5Nx85ShHj3TgiwhIVdQbPkhDHM/N/8M3Yy1zFOSdOZiE0ARKntRGLQXlqRsCWChyA2Rq4BvdhYbdjGygJE9ANWnW/V1xFb0p8C7W7Cekk7QRuIGMpMl170e2yKpc9/BQQ7DzkFtU57OFmHnLLkzmQi7qbxU+MZ7n/tSlQg9gmWgEbbKi+SlLBTppwNKH0Qve5T3HgGzBMfiCTus0JnS0diRbLdskqniF6dUdJqxR1KOweegwy8H9E+WDk1kImAJWy/FnuQ3sN5B1gSEUkdPQNFO0G/fqA6/tis20UfJJ8pniH8KcGqdV2LQltdlAWlK+Tf3ache5MrInRqwQsgzQU/YL6BgQ06rB8P1R9eh+qn5015ibFWTtbgmpM6eGwX3tGC6eVRGw4uNSQRA0rDg7Q807ibsnY8G7wb+VtRku6oGeJg6jhpohwsquzhKwhG2oxTxU/NHjbLkoxbnLnRHS4lTbTkgNYkOx2wKbqV5bnU1IhziuKjC/06bkI3k8RP7UE/EFlJXEK4ztxrMI/SL2PuDs4Kmj6kCruT1RfSGD41Ui0+8z1p8zoZNe/+cXvE5/fNe+NnppzNOB28n3d6emT+rzedFvy9cvz24lveB86umC1R+wXl2dY4YrPn2+N8P0au1z+rYIfFy/E8ZT6XFYHSqKhIW1ZfXL/3IjovzpmIKSQRlDkZjwY0PkyWIXdYiX5GCCXazuQZbPYPLAe3Nw==")
				},]]--
				shoreLine = {
					layers = {
						elevation = {min, min + (beachThreshold - min) * 0.1},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.50999999999999996,noiseSource={type="perlin",parameters={contrast=3.6000000000000001,scale=39,midpoint=1}},tile="sand-2"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},entity="tree-palm-a",frequency=0.4},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9,scale=36,midpoint=1}},decorative="green-carpet-grass",frequency=0.2,maximum=1,minimum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},decorative="rock-medium",frequency=0.1,maximum=5,minimum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},decorative="rock-small",frequency=0.2,maximum=5,minimum=1}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.6000000000000001,scale=39,midpoint=1}},tile="sand-2"},
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				beach = {
					layers = {
						elevation = {min, beachThreshold},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.50999999999999996,noiseSource={type="perlin",parameters={contrast=3.6000000000000001,scale=39,midpoint=1}},tile="sand-3"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},entity="tree-palm-a",frequency=0.4},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9,scale=36,midpoint=1}},decorative="green-carpet-grass",frequency=0.2,maximum=1,minimum=1},
							--{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46999999999999993,noiseSource={type="perlin",parameters={contrast=2.9,scale=16,midpoint=1}},decorative="green-pita",frequency=0.2,maximum=3,minimum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},decorative="rock-medium",frequency=0.1,maximum=5,minimum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},decorative="rock-small",frequency=0.2,maximum=5,minimum=1}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="sand-1"}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				--[[beachSnow = {
					layers = {
						ocean = {beach_threshold, low},
						temperature = {low - 0.05, low},
						elevationVariation = {min, very_high},
					},
					preset = {layers={{name="New Layer",paints={nil,nil,nil,{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.50999999999999996,noiseSource={type="perlin",parameters={contrast=3.6000000000000001,scale=39,midpoint=1}},tile="frozen-snow-1"},{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.79000000000000004,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=32,midpoint=1}},entity="tree-palm-a",frequency=0.60000000000000009},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9,scale=36,midpoint=1}},decorative="brown-carpet-grass",frequency=0.5,maximum=3,minimum=1},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46999999999999993,noiseSource={type="perlin",parameters={contrast=2.9,scale=16,midpoint=1}},decorative="green-pita",frequency=0.45,maximum=3,minimum=1},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.25,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},decorative="rock-small-brown",frequency=0.5,maximum=5,minimum=1}},enabled=true},{name="New Layer",paints={{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="sand-2"}},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Beach Snow",created=1873979,author=1}
				},--]]
				beachEdge = {
					layers = {
						elevation = {beachThreshold, beachThreshold + (beachThreshold * 1.1 - beachThreshold)}
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.6000000000000001,scale=39,midpoint=1}},tile="sand-3"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9,scale=36,midpoint=1}},decorative="green-carpet-grass",frequency=1,maximum=1,minimum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.15,noiseSource={type="perlin",parameters={contrast=2.9,scale=16,midpoint=1}},decorative="green-pita",frequency=0.70000000000000009,maximum=1,minimum=1},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.25,noiseSource={type="perlin",parameters={contrast=2.9,scale=12,midpoint=1}},frequency=0.35000000000000004,maximum=5,minimum=1,entity="tree-palm-a"}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Beach Edge",created=1867426,author=1}
				},

				-- Volcanic lands
				volcanicLowlands = {
					layers = {
						volcano = {medium, max}
					},
					margin = 2,
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.95,noiseSource={type="perlin",parameters={contrast=5.5,scale=256,midpoint=0.5,persistence=0.4}},tile="water-shallow"}
						},enabled=false},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(1, 0.5, noise.var("ta_wn_volcano")),noiseSource={type="perlin",parameters={contrast=2,scale=64,midpoint=1}},tile="volcanic-orange-heat-3"},
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.8,noiseSource={type="perlin",parameters={contrast=4.6999999999999993,scale=14,midpoint=0.5,persistence=0.3}},tile="water-shallow"},
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(1, 0.5, noise.var("ta_wn_volcano")) - 0.05,noiseSource={type="perlin",parameters={contrast=2,scale=64,midpoint=1}},tile="water-shallow"},
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(0.8, 0.45, noise.var("ta_wn_volcano")),noiseSource={type="perlin",parameters={contrast=2.5,scale=103,midpoint=1}},tile="volcanic-orange-heat-1"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2,scale=13,midpoint=1}},frequency=0.45,minimum=1,maximum=6,decorative="rock-medium-volcanic"},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2,scale=36,midpoint=1}},frequency=0.35000000000000004,minimum=1,maximum=6,entity="dry-tree"}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=64,midpoint=1}},tile="mineral-black-dirt-2"},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.49000000000000004,noiseSource={type="perlin",parameters={contrast=1.7000000000000002,scale=81,midpoint=1}},entity="tree-wetland-e",frequency=0.65000000000000018},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="brown-hairy-grass",minimum=1,maximum=8,frequency=0.60000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="brown-carpet-grass",minimum=1,maximum=2,frequency=0.75000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="rock-small-black",minimum=1,maximum=4,frequency=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.57999999999999998,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=13,midpoint=1}},decorative="brown-fluff-dry",minimum=1,maximum=4,frequency=0.5},
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.56000000000000005,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=20,midpoint=1}},tile="volcanic-orange-heat-1"}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Volcanic Lowlands",created=1947539,author=1}
				},

				-- Humid hot environments are either lush deserts or savannah
				lushDesert = {
					layers = {
						humidity = {medium, max, 1.25},
						temperature = {high, max, 1.25},
						auxLarge = {medium, max, 1.5},
					},
					margin = 1,
					preset = {layers={{name="New Layer",paints={{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.56000000000000005,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=32,midpoint=1}},tile="red-desert-0"},{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=1.7000000000000002,scale=21,midpoint=1}},entity="tree-08",frequency=0.45},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-pita",minimum=1,maximum=8,frequency=0.45},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="brown-carpet-grass",minimum=1,maximum=2,frequency=0.65},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="red-croton",minimum=1,maximum=8,frequency=0.70000000000000009},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=13,midpoint=1}},decorative="red-pita",minimum=1,maximum=8,frequency=0.65000000000000018}},enabled=true},{name="New Layer",paints={{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.40999999999999996,noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1,persistence=0.5}},tile="red-desert-2"},{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.5000000000000002,scale=32,midpoint=1}},entity="sand-rock-big",frequency=0.15000000000000002},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.32000000000000002,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},frequency=0.4,decorative="sand-rock-small",minimum=1,maximum=8}},enabled=true},{name="New Layer",paints={{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.9000000000000002,scale=32,midpoint=1}},tile="sand-2"},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46999999999999993,noiseSource={type="perlin",parameters={contrast=2,scale=16,midpoint=1}},decorative="brown-hairy-grass",frequency=0.65000000000000018,minimum=1,maximum=8}},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Lush Desert",created=310374,author=1}
				},
				savannah = {
					layers = {
						humidity = {medium, max, 1.25},
						temperature = {high, max, 1.25},
						auxLarge = {min, medium, 1.5},
					},
					margin = 1,
					preset={layers={
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=1,scale=128,midpoint=1}},tile="sand-1"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.5,scale=16,midpoint=1,seed=12}},decorative="carpet-grass-yellow",minimum=1,maximum=2,frequency=0.8},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.5,scale=16,midpoint=1,seed=12}},decorative="garballo",minimum=1,maximum=5,frequency=1},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.5,scale=16,midpoint=1,seed=12}},decorative="green-pita",minimum=1,maximum=5,frequency=0.5},
							--{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.4,noiseSource={type="perlin",parameters={contrast=2.5,scale=7,midpoint=1,seed=12}},decorative="red-desert-bush",minimum=1,maximum=6,frequency=0.8},
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5,scale=128,midpoint=1}},tile="sand-3"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},decorative="light-mud-decal",minimum=1,maximum=2,frequency=0.4},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.5,scale=16,midpoint=1}},entity="tree-desert-e",frequency=0.3},--tree-grassland-a
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.6,noiseSource={type="perlin",parameters={contrast=2.5,scale=16,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=8,frequency=1},
						},enabled=true},
					},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Savannah",created=64964,author=1}
						
				},

				-- Dry hot environment is desert
				dryDesert = {
					layers = {
						humidity = {min, medium, 1.5},
						temperature = {high, max, 1.7},
					},
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.54000000000000004,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="sand-2"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.82999999999999989,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=16,midpoint=1}},entity="dead-tree-desert",frequency=0.35000000000000004},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.85999999999999996,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=16,midpoint=1}},frequency=0.70000000000000009,decorative="green-hairy-grass",minimum=1,maximum=3},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.85999999999999996,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=16,midpoint=1}},frequency=0.45,decorative="brown-carpet-grass",minimum=1,maximum=2},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.40999999999999996,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=25,midpoint=1}},frequency=0.60000000000000009,decorative="rock-tiny",minimum=1,maximum=4},
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.44,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="sand-3"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.89,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},decorative="green-pita",minimum=1,maximum=2,frequency=0.55},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.89,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},minimum=1,maximum=2,frequency=0.75000000000000009,decorative="rock-medium"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.82,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},minimum=1,maximum=4,frequency=0.75000000000000009,decorative="garballo"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.89,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},minimum=1,maximum=9,frequency=0.2,entity="rock-huge"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.83,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},minimum=1,maximum=9,frequency=0.3,entity="rock-big"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.89,noiseSource={type="perlin",parameters={contrast=3.0000000000000004,scale=23,midpoint=0.5}},decorative="brown-hairy-grass",minimum=1,maximum=3,frequency=0.70000000000000009}
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="sand-1"}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Dry Desert",created=90234,author=1}
				},
				--[[alpine_forest = {
					layers = {
						temperature = {very_low, low}
					},
					preset = {layers={[3]={name="New Layer",paints={{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=64,midpoint=1}},tile="grass-2"},{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=1.7000000000000002,scale=81,midpoint=1}},entity="tree-snow-a",frequency=0.70000000000000009},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-pita",minimum=1,maximum=8,frequency=0.60000000000000009},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=2,frequency=0.75000000000000009},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-bush-mini",minimum=1,maximum=8,frequency=1},{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.57999999999999998,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=13,midpoint=1}},decorative="lichen",minimum=1,maximum=8,frequency=0.5},{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.56000000000000005,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=20,midpoint=1}},tile="frozen-snow-2"}},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Alpine Forest",created=1852401,author=1}
				},--]]

				-- Ice forest in cool places
				iceForest = {
					layers = {
						temperature = {min, low, 1.5},
					},
					preset={layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(0.1, 0.9, (noise.var("ta_wn_temperature") / low) ),noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=103,midpoint=1}},tile="frozen-snow-5"},
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=3.3000000000000003,scale=19,midpoint=1}},tile="frozen-snow-6"},
							{type="tile",radius=32,brushStrength=0,noiseStrength=1,threshold=0.8,noiseSource={type="perlin",parameters={contrast=4.6999999999999993,scale=14,midpoint=0.5,persistence=0.3}},tile="water-mud"},
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(0.1, 0.9, (noise.var("ta_wn_temperature") / low)) - 0.1,noiseSource={type="perlin",parameters={contrast=2.9,scale=103,midpoint=1}},tile="frozen-snow-2"}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=64,midpoint=1}},tile="mineral-tan-dirt-2"},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=1.7000000000000002,scale=81,midpoint=1}},entity="tree-snow-a",frequency=0.70000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=2,frequency=0.75000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-bush-mini",minimum=1,maximum=8,frequency=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.57999999999999998,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=13,midpoint=1}},decorative="lichen",minimum=1,maximum=8,frequency=0.5},
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=modulate(-1, 1, noise.var("ta_wn_temperature") / (low * 1.25)),noiseSource={type="perlin",parameters={contrast=2.5,scale=32,midpoint=1}},tile="frozen-snow-1"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},entity="rock-huge-white",frequency=0.1}
						},enabled=true}
					},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Ice Forest",created=45,author=1}
				},
				mountains = {
					layers = {
						elevation = {high, max, 1.25},
					},
					preset={layers={
					{name="New Layer",paints={
						{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.2 + noise.var("ta_wn_mountain") * 0.6,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=43,midpoint=1}},tile="mineral-tan-dirt-3"},
						{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.34000000000000004,noiseSource={type="perlin",parameters={contrast=1,scale=21,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=8,frequency=0.95},
						{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.3,noiseSource={type="perlin",parameters={contrast=1,scale=21,midpoint=1}},entity="tree-wetland-e",frequency=0.5},
						{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.3,noiseSource={type="perlin",parameters={contrast=1,scale=21,midpoint=1}},entity="tree-dryland-j",frequency=0.5},--tree-wetland-o
						{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.75000000000000007,noiseSource={type="perlin",parameters={contrast=2.5,scale=14,midpoint=1}},decorative="flower-bush-green-yellow",minimum=1,maximum=3,frequency=0.8}
					},enabled=true},{name="New Layer",paints={
						{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.2 + noise.var("ta_wn_mountain") * 0.6 - 0.1,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=43,midpoint=1}},tile="mineral-tan-dirt-2"},
						{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5,scale=1,midpoint=1}},decorative="sand-decal",frequency=0.35,minimum=1,maximum=2},
						{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=1,midpoint=1}},entity="dry-tree",frequency=0.5}
					},enabled=true},{name="New Layer",paints={
						{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=32,midpoint=1}},tile="mineral-tan-dirt-1"},
						{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.19,noiseSource={type="perlin",parameters={contrast=2.5,scale=12,midpoint=1}},decorative="rock-small-beige",frequency=0.3,minimum=1,maximum=6},
						{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.65999999999999996,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=14,midpoint=1}},entity="rock-huge-brown",frequency=0.60000000000000009},
						{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.65999999999999996,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=14,midpoint=1}},frequency=0.7,decorative="pita-yellow",minimum=1,maximum=3}
					},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}}
				},
				wetlands = {
					layers = {
						elevation = {min, medium},
						temperature = {low, high},
						humidity = {very_high, max, 2},
						aux = {medium, max}
					},
					margin = 1.25,
					preset={layers=
						{{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.54000000000000004,noiseSource={type="perlin",parameters={contrast=2.5,scale=28,midpoint=1}},tile="grass-3"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=1,midpoint=1}},frequency=0.4,decorative="green-carpet-grass",minimum=1,maximum=3},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=48,midpoint=1}},entity="tree-wetland-i",frequency=0.5},
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0.62000000000000002,noiseSource={type="perlin",parameters={contrast=2.7000000000000002,scale=25,midpoint=1}},tile="grass-2"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.17999999999999998,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=25,midpoint=1}},entity="tree-02",frequency=0.3},						
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.17999999999999998,noiseSource={type="perlin",parameters={contrast=2.2000000000000002,scale=17,midpoint=1}},frequency=0.45,decorative="puddle-decal",minimum=1,maximum=3},
						},enabled=true},
						{name="New Layer",paints={
							{type="tile",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=1,midpoint=1}},tile="vegetation-green-grass-2"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.19,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=16,midpoint=1}},decorative="wetland-decal",minimum=1,maximum=2,frequency=0.4},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=16,midpoint=1}},decorative="green-pita-mini",minimum=1,maximum=3,frequency=0.95},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=16,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=3,frequency=0.5},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0.34000000000000004,noiseSource={type="perlin",parameters={contrast=2.3000000000000003,scale=19,midpoint=1}},entity="tree-desert-g",frequency=0.2}
						},enabled=true},
					},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Wetlands",created=535,author=1}
				},
				deciduousForest = {
					layers = {
						elevation = {min, high, 1.25},
						humidity = {medium, max, 1.25},
						temperature = {low, high, 1.25},
						aux =  {min,low, 1.5},
					},
					preset = {layers={
						[1]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.98000000000000007,noiseSource={type="perlin",parameters={contrast=6.2999999999999998,scale=256,midpoint=0.5,persistence=0.4}},tile="red-desert-0"},
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.99000000000000004,noiseSource={type="perlin",parameters={contrast=4,scale=256,midpoint=0.5,persistence=0.4}},tile="dirt-3"}
						},enabled=true},[3]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.31000000000000001,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=30,midpoint=1}},tile="grass-2"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.56999999999999993,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="red-croton",minimum=1,maximum=8,frequency=0.60000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="carpet-grass-orange",minimum=1,maximum=1,frequency=0.5},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="bush-mini-yellow",minimum=1,maximum=8,frequency=0.65},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.27000000000000002,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=71,midpoint=1}},entity="tree-wetland-b",frequency=0.5},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.27000000000000002,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=71,midpoint=1}},entity="tree-grassland-k",frequency=0.5}
						},enabled=true},[5]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.9000000000000002,scale=32,midpoint=1}},tile="grass-1"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.56999999999999993,noiseSource={type="perlin",parameters={contrast=2.5,scale=3,midpoint=1}},decorative="green-carpet-grass",frequency=0.8,minimum=1,maximum=3}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Deciduous Forest",created=2112303,author=1}
				},
				greenForest = {
					layers = {
						elevation = {min, high, 1.25},
						humidity = {medium, max, 1.25},
						temperature = {low, high, 1.25},
						aux =  {high,max, 1.5},
					},
					preset = {name="Forest - Green",created=0,author="knighty",locked=true,layers={
						{name="Forest",enabled=true,paints={
							{type="tile",tile="grass-2",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2,scale=32,midpoint=1}}},
							{type="decorative",decorative="green-carpet-grass",minimum=1,maximum=2,radius=32,frequency=0.9,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1,scale=4,midpoint=1}}},						
							{type="decorative",decorative="green-bush-mini",minimum=1,maximum=8,radius=32,frequency=0.6,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2,scale=10,midpoint=1}}},
							{type="decorative",decorative="rock-medium",minimum=1,maximum=8,radius=32,frequency=0.25,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2,scale=8,midpoint=1}}},
							{type="entity",entity="tree-02",radius=32,frequency=0.4,brushStrength=0,noiseStrength=1,threshold=0.1,noiseSource={type="perlin",parameters={contrast=4,scale=48,midpoint=1}}},
							{type="entity",entity="tree-08",radius=32,frequency=0.4,brushStrength=0,noiseStrength=1,threshold=0.1,noiseSource={type="perlin",parameters={contrast=4,scale=48,midpoint=1}}},
							{type="decorative",decorative="green-hairy-grass",minimum=1,maximum=2,radius=32,frequency=0.5,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5,scale=48,midpoint=0}}},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.5,scale=48,midpoint=0}},decorative="flower-bush-blue-pink",minimum=1,maximum=3,frequency=0.2},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.5,scale=48,midpoint=0}},decorative="flower-bush-green-yellow",minimum=1,maximum=3,frequency=0.2},
						}}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"}},
				},	
				moors = {
					layers = {
						elevation = {min, medium},
						humidity = {low, high},
						temperature = {low, medium},
					},
					margin = 1.25,
					preset = {layers={
						{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.40999999999999996,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=64,midpoint=1}},tile="grass-2"},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0.56999999999999993,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=71,midpoint=1}},entity="tree-02",frequency=0.70000000000000009},
							--{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.7,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-pita",minimum=1,maximum=8,frequency=0.5},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=2,frequency=0.75000000000000009},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.46000000000000005,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},decorative="green-bush-mini",minimum=1,maximum=8,frequency=0.5},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.57999999999999998,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=21,midpoint=1}},decorative="lichen",minimum=1,maximum=3,frequency=0.5},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0.8,noiseSource={type="perlin",parameters={contrast=2.5,scale=14,midpoint=1}},decorative="flower-bush-green-yellow",minimum=1,maximum=3,frequency=0.8}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.42999999999999998,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=54,midpoint=1}},tile="grass-3"},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},entity="rock-huge",frequency=0.1},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5,scale=1,midpoint=1}},decorative="red-desert-decal",frequency=0.06,minimum=1,maximum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.32000000000000002,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=8,midpoint=1}},frequency=0.4,decorative="rock-small",minimum=1,maximum=8},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.19,noiseSource={type="perlin",parameters={contrast=2.6000000000000001,scale=8,midpoint=1}},frequency=0.8,decorative="brown-hairy-grass",minimum=0,maximum=8},
							{type="entity",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.5000000000000002,scale=32,midpoint=1}},entity="dry-tree",frequency=0.3},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.54000000000000004,noiseSource={type="perlin",parameters={contrast=2.3000000000000003,scale=8,midpoint=1}},frequency=0.70000000000000009,decorative="green-croton",minimum=1,maximum=8}
						},enabled=true},{name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.9000000000000002,scale=32,midpoint=1}},tile="grass-1"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.21000000000000001,noiseSource={type="perlin",parameters={contrast=2.5,scale=20,midpoint=1}},decorative="green-hairy-grass",frequency=0.75000000000000009,minimum=1,maximum=6}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Moors",created=1844855,author=1}
				},
				--[[flood_plain = {
					layers = {
						elevation = {low, very_low},
						elevationVariation = {min, low},
					}
				},--]]
				--[[swamp = {
					layers = {
						temperature = {medium, very_high},
						humidity = {high, max},
					},
					preset = Import("eNrdld1ymzAQhV/Fw7Xs4cfQeDK6ym3bi+YBPBvYGk1B0NVS1+Pxu3fxX4wdJyFx0rRcIUCrc/TpLFk1KKoUisFULxmJwNgpEBsHVgeqJnTIelnAAsnp5dJCidr7ivPB5/aRp2qZwO0bXtTyhk2BniLITON0kKg7alx+y4R2xrkUtJVxeDDmXFbIqyLT/mgSTzpXsv26aihFvV2gRiqMbdclkcJrVWllmcCxjkZjv3ONlRNvqMM4UaXJ6krEykqxkjLOOEYrlf1R5B9NW61U60R7GWI9B1lmOCNE663UVkeGaUXA5tdL7fY2F2y9ROG9lUCE3ivR3lrkMAdDCxEMznnyrTVlU8r0En6v70L1nfBnI94X4j2MpQZauCsw00wNisU3pRx1IF99BMr/G+HofZFenfDojzTploifiXSPcL0Xw0DwWVNcCmHwhghToBr5EYadlCbx/ly+ilTQ2eVgfLnwBf7zQP1zWesHKn7fdnox34cpCv8qmNHkzAFL+pHqxOeo9U8ebJo702jZ8OKlGYte3Q3DY73noG2EygES+8M5cgE2G5ZPWL8c21F80rX7Wz3XTsZP0a4Nw0N5jDv2P53YP4rnSia6H6JptbGul7u92Jj5slexGX8DO8Pd4OYgVjm0blNDqaRZfkPr0N/Ooaw9lRJK28t06IdhINag4byi1tg1ITdkB9NrtNkfldUJGg==")
				},]]--
				mountainTop = {
					layers = {
						elevationVariation = {high, max},
						elevation = {very_high, max}
					}
				},
				steppe = {
					layers = {
					},
					preset = {layers=
						{[2]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.90999999999999996,noiseSource={type="perlin",parameters={contrast=10,scale=256,midpoint=0.5}},tile="grass-2"},
							{type="entity",radius=32,brushStrength=1,noiseStrength=1,threshold=0.55,noiseSource={type="perlin",parameters={contrast=2,scale=32,midpoint=1}},entity="tree-07",frequency=0.60000000000000009},
							{type="entity",radius=32,brushStrength=1,noiseStrength=1,threshold=0.55,noiseSource={type="perlin",parameters={contrast=2,scale=26,midpoint=1}},entity="tree-02",frequency=0.60000000000000009}
						},enabled=true},[3]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0.37000000000000002,noiseSource={type="perlin",parameters={contrast=2.5000000000000004,scale=64,midpoint=1}},tile="red-desert-0"},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.95,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=39,midpoint=0.5}},decorative="brown-hairy-grass",minimum=1,maximum=8,frequency=0.4},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.9000000000000004,scale=8,midpoint=1}},decorative="green-carpet-grass",minimum=1,maximum=2,frequency=0.8},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.49000000000000004,noiseSource={type="perlin",parameters={contrast=2.1000000000000001,scale=21,midpoint=1}},decorative="green-croton",minimum=1,maximum=8,frequency=0.45},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.74000000000000004,noiseSource={type="perlin",parameters={contrast=2.4000000000000004,scale=32,midpoint=1}},decorative="green-hairy-grass",minimum=1,maximum=8,frequency=0.70000000000000009}
						},enabled=true},[5]={name="New Layer",paints={
							{type="tile",radius=32,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=1.9000000000000002,scale=32,midpoint=1}},tile="mineral-tan-dirt-4"},
							{type="entity",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=3.2000000000000002,scale=21,midpoint=1}},minimum=1,maximum=9,frequency=0.07,entity="rock-huge"},
							{type="decorative",radius=16,brushStrength=1,noiseStrength=1,threshold=0,noiseSource={type="perlin",parameters={contrast=2.5,scale=1,midpoint=1}},decorative="red-desert-decal",frequency=0.25,minimum=1,maximum=1},
							{type="decorative",radius=32,brushStrength=0,noiseStrength=1,threshold=0.5,noiseSource={type="perlin",parameters={contrast=2.5,scale=11,midpoint=1}},decorative="green-hairy-grass",frequency=0.9,minimum=1,maximum=6}
						},enabled=true}},masks={},brush={radius=1,noiseMidpoint=1,noiseRange=1,noiseContrast=1,shape="circle"},name="Steppe",created=930779,author=1}
				},
				mountaindsfsdTop = {
					layers = {
						elevationVariation = {high, max},
						elevation = {very_high, max}
					}
				},
			}
		end

		if false then
			Biomes.biomes = {
				Biomes.biomes["glacier"],
				Biomes.biomes["deepOcean"],
				Biomes.biomes["ocean"],
				Biomes.biomes["river"],
				--Biomes.biomes["riverBank"],
				--Biomes.biomes["riverBankReeds"],
				Biomes.biomes["beach"],
				Biomes.biomes["beachEdge"],
				Biomes.biomes["iceForest"],
				Biomes.biomes["deciduousForest"],
				Biomes.biomes["moors"],
				Biomes.biomes["volcanicLowlandsCool"],
				Biomes.biomes["volcanicLowlands"],
				Biomes.biomes["steppe"],
			}
		end
		
		local layerIndexes = {
			temperature = 1,			
			humidity = 2,
			elevation = 3,
			elevationVariation = 4,
			aux = 5,
			river = 6,
			ocean = 7,
		}
		
		-- Copy to faster keys
		--[[for biomeName,biome in pairs(Biomes.biomes) do
			biome.numericLayers = {}
			biome.name = biomeName
			for layerIndex,layer in pairs(biome.layers) do				
				biome.numericLayers[layerIndexes[layerIndex] ] = layer			
			end
		end--]]
	end
	
	return Biomes.biomes
end

return Biomes