local CollectionService = game:GetService("CollectionService")
local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local Binder = require("Binder")
local Gold = require("Gold")


local GoldSpawner = {}
GoldSpawner.__index = GoldSpawner
GoldSpawner.TAG_NAME_SPAWNER = "GoldSpawner"
GoldSpawner.TAG_NAME_GOLDREF = "GoldRef"
GoldSpawner.TAG_NAME_GOLD = "Gold"
GoldSpawner.SIZE = 20
GoldSpawner.GoldPieces = {}

local random = Random.new()

local GOLD_IMPULSE_BOUNDS = {
	minX = -72,
	maxX = 72,
	minZ = -72,
	maxZ = 72,
}


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

local function PrepareGoldForLaunch(goldPiece, x, y ,z )
	goldPiece.CanCollide = false
	goldPiece.Anchored = true
	goldPiece.CFrame = CFrame.new(x, y ,z)
end

function GoldSpawner:Init()
	for i = 1, GoldSpawner.SIZE do
		local goldClone = GoldSpawner.GoldRef:Clone()
		goldClone.Parent = GoldSpawner.Workspace

		table.insert(GoldSpawner.GoldPieces, goldClone)

		CollectionService:RemoveTag(goldClone, GoldSpawner.TAG_NAME_GOLDREF)
		CollectionService:AddTag(goldClone, GoldSpawner.TAG_NAME_GOLD)

		PrepareGoldForLaunch(goldClone, self.instance.Position.X, self.instance.Position.Y, self.instance.Position.Z)
	end
end

function GoldSpawner:LaunchGold()
	for _, goldPiece in GoldSpawner.GoldPieces do
		PrepareGoldForLaunch(goldPiece, CFrame.new(self.instance.Position.X, self.instance.Position.Y, self.instance.Position.Z))

		local offsetX = random:NextInteger(GOLD_IMPULSE_BOUNDS.minX, GOLD_IMPULSE_BOUNDS.maxX)
		local offsetZ = random:NextInteger(GOLD_IMPULSE_BOUNDS.minZ, GOLD_IMPULSE_BOUNDS.maxZ)

		goldPiece.Anchored = false
		goldPiece:ApplyImpulse(Vector3.new(offsetX, goldPiece:GetMass() * 125, offsetZ))
		goldPiece.CanCollide = true
	end
end

local Binder = Binder.new(GoldSpawner.TAG_NAME_SPAWNER, GoldSpawner)
Binder:Start()




return GoldSpawner