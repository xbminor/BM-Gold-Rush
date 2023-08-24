local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")


local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local Binder = require("Binder")


local Gold = {}
Gold.__index = Gold
Gold.TAG_NAME_GOLD = "Gold"
Gold.VALUE = 10

function Gold.new(instance)
	local self = {}
	setmetatable(self, Gold)
	self.instance = instance

	self._maid = Maid.new()
	self._maid:GiveTask(self.instance.Touched:Connect(function(...) self:OnTouched(...) end))

	return self
end

function Gold:Destroy()
	self._maid:DoCleaning()
end

local function ProcessGold(goldInstance, value, player)
		-- Temporarily "destroy" gold chunk
		goldInstance.Parent = nil

		-- Update gold value in session table
		local userID = player.UserId
		--local uiValue = srp_SaveLoadManager:fn_AddGold(int_userID, int_goldValue)

		-- Update player UI and play collection sound
		--uiEvent:FireClient(plr_player, {gold = uiValue, doTween = true, showAlert = false})

		-- Regenerate gold chunk after delay
		goldInstance.CanCollide = false
		goldInstance.Anchored = true
end

function Gold:OnTouched(touchedPart)
	if not touchedPart.Parent:IsA("Model") then return end

	local player = Players:GetPlayerFromCharacter(touchedPart.Parent)

	if player then
		ProcessGold(self.instance, Gold.VALUE, player)
	end
end



local Binder = Binder.new(Gold.TAG_NAME_GOLD, Gold)
Binder:Start()

return Gold