local require = require(script.Parent.loader).load(script)

local Maid = require("Maid")


local GoldService = {}
GoldService.ServiceName = "GoldService"

function GoldService:Init(serviceBag)
	assert(not self._serviceBag, GoldService.ServiceName .. " is already initialized...")
	self._serviceBag = assert(serviceBag, "No ServiceBag found...")
	self._maid = Maid.new()
end


function GoldService:Start()
	print("started")
end

function GoldService:Destroy()
	self._maid:DoCleaning()
end

return GoldService