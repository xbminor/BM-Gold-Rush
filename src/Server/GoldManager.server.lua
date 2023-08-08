
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local svc_ServerScriptService = game:GetService("ServerScriptService")
local svc_Players = game:GetService("Players")

local uiEvent = ReplicatedStorage:WaitForChild("UIEvent")

local srp_SaveLoadManager = require(svc_ServerScriptService.SaveLoadManager)

local random = Random.new()

local GOLD_VALUE = 10
local GOLD_REGENERATION_BOUNDS = {
	minX = -72,
	maxX = 72,
	minZ = -72,
	maxZ = 72
}
local GOLD_REGEN_DELAY = 2

local dict_PlayerGold = {}

local function processGoldTouch(chunk, chunkValue, player)
	-- Temporarily "destroy" gold chunk
	chunk.Parent = nil

	-- Update gold value in session table
	local int_userID = player.UserId
	srp_SaveLoadManager:fn_AddGold(int_userID, chunkValue)

	-- Update player UI and play collection sound
	local uiValue = srp_SaveLoadManager:fn_GetGold(int_userID)
	uiEvent:FireClient(player, {gold = uiValue, doTween = true, showAlert = false})

	-- Regenerate gold chunk after delay
	wait(GOLD_REGEN_DELAY)
	local nextPositionX = random:NextInteger(GOLD_REGENERATION_BOUNDS.minX, GOLD_REGENERATION_BOUNDS.maxX)
	local nextPositionZ = random:NextInteger(GOLD_REGENERATION_BOUNDS.minZ, GOLD_REGENERATION_BOUNDS.maxZ)
	chunk.CFrame = CFrame.new(nextPositionX, 50, nextPositionZ)
	chunk.Parent = workspace.GoldChunks
	chunk:SetAttribute("DropCollided", false)
end

-- Initially connect all gold chunks to touch detection
for _, chunk in pairs(CollectionService:GetTagged("Gold")) do
	chunk.Touched:Connect(function(otherPart)
		local partParent = otherPart.Parent
		local player = svc_Players:GetPlayerFromCharacter(partParent)
		if player then
			processGoldTouch(chunk, GOLD_VALUE, player)
		end
	end)
end




