local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")

-- Initially connect all gold chunks to touch detection
for _, chunk in pairs(CollectionService:GetTagged("Gold")) do
	chunk.Touched:Connect(function(otherPart)
		local partParent = otherPart.Parent
		local humanoid = partParent:FindFirstChildWhichIsA("Humanoid")

		if humanoid and chunk.CanCollide then
			-- Make chunk non-collidable and invisible
			chunk.CanCollide = false
			chunk.Transparency = 1

			-- Play collection sound
			local sound = SoundService:FindFirstChild("GoldSound")
			if sound then
				-- Clone sound
				local clone = sound:Clone()
				clone.Name = sound.Name .. "Clone"
				clone.Parent = sound.Parent
				-- Destroy cloned sound once it finishes playing
				clone.Ended:Connect(function()
					clone:Destroy()
				end)
				-- Play the cloned sound
				clone:Play()
			end
		end
	end)
end