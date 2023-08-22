local ServerScriptService = game:GetService("ServerScriptService")
local Loader = ServerScriptService:FindFirstChild("LoaderUtils", true).Parent
local Packages = require(Loader).bootstrapGame(ServerScriptService.NevermoreEngine)

local ServiceBag = require(Packages.ServiceBag).new()

ServiceBag:GetService(Packages.GoldService)

ServiceBag:Init()
ServiceBag:Start()



require(Packages.GoldSpawner)