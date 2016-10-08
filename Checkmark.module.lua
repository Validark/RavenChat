-- Check mark
local Stepped = game:GetService("RunService").RenderStepped
game.StarterGui:ClearAllChildren()
local ScreenParent = Instance.new("ScreenGui", game.StarterGui)
local Screen = Instance.new("Frame", ScreenParent)
Screen.BackgroundTransparency = 1
Screen.Position = UDim2.new(0, -20, 0, 0)
Screen.Size = UDim2.new(1, 20, 1, 0)
Screen.Rotation = 180
local FadeTime = .35


local Black = Color3.new(0, 0, 0)
local White = Color3.new(1, 1, 1)
local CheckColor = Color3.new(22 / 255, 198 / 255, 12 / 255)
local unloadedColor = Color3.new(198 / 255, 11 / 255, 11 / 255)
local ZIndex = 1
local box1, box2, box3, loadBar, loadText do
	box1 = Instance.new("Frame", Screen)
	box1.BackgroundColor3 = unloadedColor
	box1.BorderColor3 = Black
	box1.BorderSizePixel = 5
	box1.Position = UDim2.new(0.5, 50, 0.5, 0) -- UDim2.new(0.5, 0, 0.5, 0)
	box1.Size = UDim2.new(0, 50, 0, 14) -- UDim2.new(0, 0, 0, 14)
	box1.ZIndex = ZIndex + 1

	box2 = Instance.new("Frame", Screen)
		box3 = Instance.new("Frame", box2)
		box3.BackgroundColor3 = unloadedColor
		box3.BorderSizePixel = 0
		box3.Size = UDim2.new(1, 0, 1, 0)
		box3.ZIndex = ZIndex + 2
	box2.BackgroundColor3 = unloadedColor
	box2.BorderColor3 = Black
	box2.BorderSizePixel = 5
	box2.Position = UDim2.new(0.5, -2, 0.5, -38)
	box2.Rotation = 90
	box2.Size = UDim2.new(0, 14, 0, 90) -- 0
	box2.ZIndex = ZIndex

	loadBar = Instance.new("Frame", ScreenParent)
	loadBar.BackgroundColor3 = CheckColor
	loadBar.BorderSizePixel = 0
	loadBar.Position = UDim2.new(0.5, -110, 0.5, -14)
	loadBar.Size = UDim2.new(0, 40, 0, 14)
	loadBar.ZIndex = 4

	loadText = Instance.new("TextLabel", ScreenParent)
	loadText.BackgroundTransparency = 1
	loadText.Position = UDim2.new(0.5, 40, 0.5, -8) -- X.Offset = 140
	loadText.Font = "SourceSansBold"
	loadText.FontSize = "Size32"
	loadText.Text = "30%"
	loadText.TextColor3 = White
	loadText.TextStrokeColor3 = Black
	loadText.TextStrokeTransparency = 0.4
	loadText.TextXAlignment = "Left"
end
local HaltTime = 2
loadBar:TweenSize(UDim2.new(0, 140, 0, 14), "Out", "Quad", HaltTime, true)
loadText:TweenPosition(UDim2.new(0.5, 100, 0.5, -8), "Out", "Quad", HaltTime, true)

local elapsedTime, SteppedConnection = 0
SteppedConnection = Stepped:connect(function(step)
	if elapsedTime < HaltTime then
		elapsedTime = elapsedTime + step
		local r = elapsedTime / HaltTime * 2
		local ratio = r < 1 and .5 * r * r or -.5 * ((r - 1) * (r - 3) - 1)
		loadText.Text = string.sub(ratio * 100, 1, 4) .. "%"
	else
		loadText.Text = "100%"
		box1.BackgroundColor3 = CheckColor
		box3.BackgroundColor3 = CheckColor
		box2.BackgroundColor3 = CheckColor
		loadBar:Destroy()
		SteppedConnection:disconnect()
		SteppedConnection = nil
	end
end)

wait(HaltTime + .1)
do
	local elapsedTime, SteppedConnection = 0
	SteppedConnection = Stepped:connect(function(step)
		if elapsedTime < FadeTime then
			elapsedTime = elapsedTime + step
			local r = elapsedTime / FadeTime * 2
			local ratio = r < 1 and .5 * r * r or -.5 * ((r - 1) * (r - 3) - 1)
			loadText.TextTransparency = ratio
			Screen.Rotation = ratio * 45 + 180
			box2.Rotation = 90 - ratio * 90
			box2.Position = UDim2.new(0.5, ratio * 2 - 2, 0.5, ratio * 38 - 38)
			box1.Position = UDim2.new(0.5, 50 - ratio * 50, 0.5, 0)

		else
			loadText.TextTransparency = 1
			Screen.Rotation = 225
			box2.Rotation = 180
			box2.Position = UDim2.new(0.5, 0, 0.5, 0)
			box1.Position = UDim2.new(0.5, 0, 0.5, 0)
			SteppedConnection:disconnect()

			--[[local elapsedTime = 0
			local FadeTime = 1
			SteppedConnection = Stepped:connect(function(step)
				if elapsedTime < FadeTime then
					elapsedTime = elapsedTime + step
					local r = elapsedTime / FadeTime * 2
					local ratio = r < 1 and .5 * r * r or -.5 * ((r - 1) * (r - 3) - 1)
					box2.BackgroundTransparency = ratio
					box1.BackgroundTransparency = ratio
					box3.BackgroundTransparency = 1
				else
					box2:Destroy()
					box1:Destroy()
					box3:Destroy()
					SteppedConnection:disconnect()
				end
			end)]]

		end
	end)
end

--box1:TweenSizeAndPosition(UDim2.new(0, 50, 0, 14), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", .2, true)
--box2:TweenSizeAndPosition(UDim2.new(0, 14, 0, 90), UDim2.new(0.5, 0, 0.5, 0), "Out", "Quad", .1, true)
