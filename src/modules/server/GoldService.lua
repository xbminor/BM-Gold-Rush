local PolicyService = game:GetService("PolicyService")
local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")
local RPromise = require("RPromise")
local Promise = require("Promise")
local GoldSpawner = require("GoldSpawner")

local GoldService = {}
GoldService.ServiceName = "GoldService"


function GoldService:Init(serviceBag)
	assert(not self._serviceBag, GoldService.ServiceName .. " is already initialized...")
	self._serviceBag = assert(serviceBag, "No ServiceBag found...")
	self._maid = Maid.new()
end


function GoldService:Start()
--repeat
		GoldService:Intermission()
--	until false
	
end

function GoldService:Destroy()
	self._maid:DoCleaning()
end


function GoldService:Intermission()
	print("Intermission Start")
	return Promise.delay(5, function(resolve, reject)
		print("Intermission Over")

		resolve(1, function() GoldService:Game() end)
	end):Then(Promise.delay)
end

function GoldService:Game()
	print("Game Start")
	return Promise.delay(5, function(resolve, reject)
		print("Game Over")
		resolve(1, function() GoldService:Intermission() end)
	end):Then(Promise.delay)
end

return GoldService