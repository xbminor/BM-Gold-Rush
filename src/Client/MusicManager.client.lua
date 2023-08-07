local SoundService = game:GetService("SoundService")

local musicGroup = SoundService:FindFirstChild("MusicGroup")

if musicGroup then
	local track = musicGroup:FindFirstChildOfClass("Sound")
	if track and not track.Playing then
		track.Playing = true
	end
end