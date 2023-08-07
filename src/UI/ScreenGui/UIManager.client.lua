local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local uiEvent = ReplicatedStorage:WaitForChild("UIEvent")

local screenGUI = script.Parent
local goldFrame = screenGUI.ScoreBarFrame
local warningFrame = screenGUI.WarningFrame
local amountLabel = goldFrame.GoldAmount
local goldIcon = goldFrame.GoldIcon

-- Set up tween for gold icon
local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tween = TweenService:Create(goldIcon, tweenInfo, {Rotation = 360})
tween.Completed:Connect(function()
	goldIcon.Tweening.Value = false
	goldIcon.Rotation = 0
end)

local function processClientEvent(params)
	if params.showAlert then
		-- Show warning frame
		warningFrame.Visible = true
		goldFrame.Visible = true
	else
		-- Update text label
		amountLabel.Text = params.gold

		-- Tween icon
		if params.doTween and goldIcon.Tweening.Value == false then
			goldIcon.Tweening.Value = true
			tween:Play()
		end
	end
end

uiEvent.OnClientEvent:Connect(processClientEvent)