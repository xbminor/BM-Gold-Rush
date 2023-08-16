local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local random = Random.new()
local heartbeatCount = 0
local flickerSources = {}

-- Collect flicker sources
local lightSourcesCollected = CollectionService:GetTagged("LightSource")
for c = 1, #lightSourcesCollected do
	local light = lightSourcesCollected[c]
	flickerSources[light] = true
end

-- Flicker loop
RunService.Heartbeat:Connect(function()
	heartbeatCount = heartbeatCount + 1
	if heartbeatCount >= 8 then
		heartbeatCount = 0
		for light, _ in pairs(flickerSources) do
			local currentBrightness = light.Brightness
			local newBrightness
			repeat
				local flux = random:NextInteger(-1, 1)
				newBrightness = light:GetAttribute("CoreBrightness") + (flux * 0.7)
			until newBrightness ~= currentBrightness
			light.Brightness = newBrightness
		end
	end
end)