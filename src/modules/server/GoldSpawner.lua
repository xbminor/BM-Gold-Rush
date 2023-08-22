local CollectionService = game:GetService("CollectionService")
local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local Binder = require("Binder")

local GoldSpawner = {}
GoldSpawner.__index = GoldSpawner
GoldSpawner.TAG_NAME_SPAWNER = "GoldSpawner"
GoldSpawner.TAG_NAME_GOLDREF = "GoldRef"
GoldSpawner.TAG_NAME_GOLD = "Gold"
GoldSpawner.SIZE = 20

GoldSpawner.GoldRef = CollectionService:GetTagged(GoldSpawner.TAG_NAME_GOLDREF)[1]
GoldSpawner.Workspace = game.Workspace:FindFirstChild(GoldSpawner.TAG_NAME_SPAWNER .."Folder") or Instance.new("Folder", game.Workspace)
GoldSpawner.Workspace.Name = GoldSpawner.TAG_NAME_SPAWNER .."Folder"

function GoldSpawner.new(instance)
	local self = {}
	setmetatable(self, GoldSpawner)

	self._maid = Maid.new()
	self.instance = instance

	self:Init()

	return self
end


function GoldSpawner:Destroy()
	self._maid:DoCleaning()
end


function GoldSpawner:Init()
	for i = 1, GoldSpawner.SIZE do
		local goldClone = GoldSpawner.GoldRef:Clone()
		goldClone.Parent = GoldSpawner.Workspace

		CollectionService:RemoveTag(goldClone, GoldSpawner.TAG_NAME_GOLDREF)
		CollectionService:AddTag(goldClone, GoldSpawner.TAG_NAME_GOLD)

		goldClone.CanCollide = false
		goldClone.Anchored = true
		goldClone.CFrame = CFrame.new(self.instance.Position.X,self.instance.Position.Y, self.instance.Position.Z)
	end
end


local Binder = Binder.new(GoldSpawner.TAG_NAME_SPAWNER, GoldSpawner)
Binder:Start()



return GoldSpawner