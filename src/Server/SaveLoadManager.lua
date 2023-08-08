local srp_SaveLoadManager = {}

local svc_DataStoreService = game:GetService("DataStoreService")
local svc_Players = game:GetService("Players")

local str_JobId = game.JobId
local data_goldStore = nil

if str_JobId ~= "" then
	data_goldStore = svc_DataStoreService:GetDataStore("Gold")
end

local dict_PlayerGold = {}


function srp_SaveLoadManager:fn_AddGold(int_userId, any_value)
	dict_PlayerGold[int_userId] += any_value
	return dict_PlayerGold[int_userId]
end

function srp_SaveLoadManager:fn_GetGold(int_userId)
	return dict_PlayerGold[int_userId]
end



local function fn_CreatePacket(int_userId, bool_pcallStatus, any_value)
	local dict_packet = {
		userId = int_userId,
		status = bool_pcallStatus,
		value = any_value
	}
	return dict_packet
end


local function fn_SaveData(int_userId, any_value)
	local bool_pcallStatus = pcall(function()
		data_goldStore:SetAsync(int_userId, any_value)
	end)

	if not bool_pcallStatus then
		warn("Failed to save...")
	end

	return fn_CreatePacket(int_userId, bool_pcallStatus, any_value)
end



local function fn_LoadData(int_userId)
	local bool_pcallStatus, any_value = pcall(function()
		return data_goldStore:GetAsync(int_userId)
	end)

	if not bool_pcallStatus then
		local plr_player = svc_Players:GetPlayerByUserId(int_userId)
		warn(plr_player.Name, " has no data...")
	end

	return fn_CreatePacket(int_userId, bool_pcallStatus, any_value)
end



local function fn_OnPlayerRemoving(plr_player)
	local int_userId = plr_player.UserId
	fn_SaveData(int_userId, dict_PlayerGold[int_userId])
end



local function fn_OnPlayerAdded(plr_player)
	local int_userId = plr_player.UserId

	local dict_packet = fn_LoadData(int_userId)

	-- load failed or player has no data, set value to 0
	if not dict_packet.status then
		dict_packet.value = 0
	end

	dict_PlayerGold[int_userId] = dict_packet.value
end


svc_Players.PlayerAdded:Connect(fn_OnPlayerAdded)
svc_Players.PlayerRemoving:Connect(fn_OnPlayerRemoving)


return srp_SaveLoadManager

--TODO
--Add autosave support
--Add signal based saving