
local svc_CollectionService = game:GetService("CollectionService")
local svc_ReplicatedStorage = game:GetService("ReplicatedStorage")
local svc_ServerScriptService = game:GetService("ServerScriptService")
local svc_Players = game:GetService("Players")

local uiEvent = svc_ReplicatedStorage:WaitForChild("UIEvent")
local table_GoldFolder = svc_ReplicatedStorage.Gold:GetChildren()

local part_GoldRef = table_GoldFolder[1]
local fold_GoldWorkspaceRef = game.Workspace:FindFirstChild("Gold")
local part_GoldSpawner = svc_CollectionService:GetTagged("GoldSpawner")[1]

local srp_SaveLoadManager = require(svc_ServerScriptService.SaveLoadManager)

local random = Random.new()

local INT_GOLD_POOL_SIZE = 20
local INT_GOLD_VALUE = 10
local DICT_GOLD_IMPULSE_BOUNDS = {
	minX = -72,
	maxX = 72,
	minZ = -72,
	maxZ = 72,
}


local function processGoldTouch(part_gold, int_goldValue, plr_player)
	-- Temporarily "destroy" gold chunk
	part_gold.Parent = nil

	-- Update gold value in session table
	local int_userID = plr_player.UserId
	local uiValue = srp_SaveLoadManager:fn_AddGold(int_userID, int_goldValue)

	-- Update player UI and play collection sound
	uiEvent:FireClient(plr_player, {gold = uiValue, doTween = true, showAlert = false})

	-- Regenerate gold chunk after delay
	part_gold.CanCollide = false
	part_gold.Anchored = true
	part_gold.CFrame = CFrame.new(part_GoldSpawner.Position.X,part_GoldSpawner.Position.Y, part_GoldSpawner.Position.Z)
	part_gold.Parent = fold_GoldWorkspaceRef
end



-- Initially connect all gold chunks to touch detection
for i = 1, INT_GOLD_POOL_SIZE do
	local part_goldClone = part_GoldRef:Clone()
	part_goldClone.Parent = fold_GoldWorkspaceRef
	part_goldClone:SetAttribute("Debounce", false)

	svc_CollectionService:RemoveTag(part_goldClone, "GoldRef")
	svc_CollectionService:AddTag(part_goldClone, "Gold")

	part_goldClone.CanCollide = false
	part_goldClone.Anchored = true
	part_goldClone.CFrame = CFrame.new(part_GoldSpawner.Position.X,part_GoldSpawner.Position.Y, part_GoldSpawner.Position.Z)

	part_goldClone.Touched:Connect(function(part_touched)
		if part_GoldRef:GetAttribute("Debounce") then return end
		if not part_touched.Parent:IsA("Model") then return end

		part_goldClone:SetAttribute("Debounce", true)

		local plr_player = svc_Players:GetPlayerFromCharacter(part_touched.Parent)

		if plr_player then
			processGoldTouch(part_goldClone, INT_GOLD_VALUE, plr_player)
		end
	end)


	part_goldClone.TouchEnded:Connect(function()
		part_GoldRef:SetAttribute("Debounce", false)
	end)
end


print("waiting")
wait(5)
print("done")
wait(1)

for _, part_gold in svc_CollectionService:GetTagged("Gold") do
	local offsetX = random:NextInteger(DICT_GOLD_IMPULSE_BOUNDS.minX, DICT_GOLD_IMPULSE_BOUNDS.maxX)
	local offsetZ = random:NextInteger(DICT_GOLD_IMPULSE_BOUNDS.minZ, DICT_GOLD_IMPULSE_BOUNDS.maxZ)

	part_gold.Anchored = false
	part_gold:ApplyImpulse(Vector3.new(offsetX, part_gold:GetMass() * 125, offsetZ))
	part_gold.CanCollide = true
end
