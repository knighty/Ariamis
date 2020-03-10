
--[[
    Implemented as described here:
    http://flafla2.github.io/2014/08/09/perlinnoise.html
]]--

p = {}

-- Hash lookup table as defined by Ken Perlin
-- This is a randomly arranged array of all numbers from 0-255 inclusive
local permutation = {151,160,137,91,90,15,
  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

-- p is used to hash unit cube coordinates to [0, 255]
for i=0,255 do
    -- Convert to 0 based index table
    p[i] = permutation[i+1]
    -- Repeat the array to avoid buffer overflow in hash function
    p[i+256] = permutation[i+1]
end

local xR2 = { -1, -1, -1, 0, 0, 1, 1, 1 }
local yR2 = { -1, 0, 1, -1, 1, -1, 0, 1 }

local xR = {}
local yR = {}

for i = 0, 7 do
	xR[i] = xR2[i + 1]
	yR[i] = yR2[i + 1]
end

--[[local gradients = {}
for j=0,255 do
	for i=0,255 do
		local A   = p[i] + j
		local AA  = p[A]
		local AAA = p[AA]
		
		gradients[j * 512 + i] = xR[band(AAA,7) + 1]
		gradients[j * 512 + i + 1] = yR[band(AAA,7) + 1]
	end
end--]]

local floor = math.floor
local band = bit32.band
	
-- Return range: [-1, 1]
function noise(x, y)
	local floorX = floor(x)
	local floorY = floor(y)

	-- Calculate the "unit cube" that the point asked will be located in
	local xi = band(floorX,255)
	local yi = band(floorY,255)

	-- Next we calculate the location (from 0 to 1) in that cube
	x = x - floorX
	y = y - floorY

	-- We also fade the location to smooth the result
	local u = x * x * x * (x * (x * 6 - 15) + 10)
	local v = y * y * y * (y * (y * 6 - 15) + 10)

	-- Hash all 8 unit cube coordinates surrounding input coordinate
	local A   = p[xi  ] + yi
	local AA  = p[A   ]
	local AB  = p[A+1 ]
	local AAA = p[ AA ]
	local ABA = p[ AB ]

	local B   = p[xi+1] + yi
	local BA  = p[B   ]
	local BB  = p[B+1 ]
	local BAA = p[ BA ]
	local BBA = p[ BB ]
	
	local xm1 = x - 1
	local ym1 = y - 1

	local grad1h = band(AAA,7)
	local grad1 = x * xR[grad1h] + y * yR[grad1h]
	
	local grad2h = band(BAA,7)
	local grad2 = xm1 * xR[grad2h] + y * yR[grad2h]
	
	local grad3h = band(ABA,7)
	local grad3 = x * xR[grad3h] + ym1 * yR[grad3h]
	
	local grad4h = band(BBA,7)
	local grad4 = xm1 * xR[grad4h] + ym1 * yR[grad4h] 

	local gradX1 = grad1 + u * (grad2 - grad1)
	local gradX2 = grad3 + u * (grad4 - grad3)

	return gradX1 + v * (gradX2 - gradX1)
end

function grad(hash, x, y)
	local h = band(hash,7) + 1                              
    
	return x * xR[h] + y * yR[h]
end

--[[local perlinLookupTable = {}
local perlinLookupSize = 512
local perlinLookupScale = 16

for y=0,perlinLookupSize-1 do
	for x=0,perlinLookupSize-1 do
		perlinLookupTable[x + y * perlinLookupSize] = perlin:noise(x/perlinLookupScale, y/perlinLookupScale)
	end
end

function perlinLookup(x,y)
	x = math.floor(x * perlinLookupScale)
	y = math.floor(y * perlinLookupScale)
	local ix = x % perlinLookupSize
	local iy = y % perlinLookupSize
	return perlinLookupTable[ iy * perlinLookupSize+ ix ]
end]]--

function perlinOctaves(x,y,z,octaves,persistence) 
    local total = 0
    local frequency = 1
    local amplitude = 1
    local maxValue = 0
    for i=1,octaves do
		local noise = noise(x * frequency, y * frequency)
        total = total + noise * amplitude
        
        maxValue = maxValue + amplitude
        
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end
    
    return total/maxValue;
end