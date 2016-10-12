-- RavenChat User Interface
-- @author Narrev
-- Designed to work even if ClearGuiOnRespawn is Enabled

-- Config
local AnimationTime = .25
local AnimationEase = "Quart"
local BarSize = UDim2.new(1, 0, 0, 30)
local BarPosition = UDim2.new(0, 16, 1, -30)
local ClosedTextBarPos = UDim2.new(0, 0, 1, 0)
local Font = Enum.Font.SourceSansBold
local FontSize = Enum.FontSize.Size18
local TextBoxOffset = 16
local TextColor3 = Color3.new(1, 1, 1)
local TextStrokeColor3 = Color3.new(0, 0, 0)
local TextStrokeTransparency = .7

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Nevermore
local Retrieve = require(ReplicatedStorage:WaitForChild("Nevermore"))

-- Modules
local Emoji = Retrieve:Module("Emoji")

-- RemoteEvents
local RavenChat = Retrieve:Event("RavenChat")

-- Wait for PlayerGui to load
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Generate User Interface
local Screen = Instance.new("ScreenGui")
local ButtonClipper = Instance.new("Frame", Screen)
local Button = Instance.new("TextButton", ButtonClipper)
local TextBar = Instance.new("Frame", Screen)
local TextBox = Instance.new("TextBox", TextBar)

ButtonClipper.BackgroundTransparency = 1
ButtonClipper.ClipsDescendants = true
ButtonClipper.Name = "ButtonClipper"
ButtonClipper.Position = BarPosition
ButtonClipper.Size = BarSize
ButtonClipper.ZIndex = 9

Button.BackgroundTransparency = 1
Button.Font = Font
Button.FontSize = FontSize
Button.Name = "Button"
Button.Size = BarSize
Button.Text = "Press '/' or click here to chat."
Button.TextColor3 = TextColor3
Button.TextStrokeColor3 = TextStrokeColor3
Button.TextStrokeTransparency = TextStrokeTransparency
Button.TextXAlignment = Enum.TextXAlignment.Left
Button.TextYAlignment = Enum.TextYAlignment.Center
Button.ZIndex = 10

TextBar.BackgroundColor3 = Color3.new(0, 0, 0)
TextBar.BackgroundTransparency = .5
TextBar.BorderSizePixel = 0
TextBar.Name = "TextBar"
TextBar.Position = ClosedTextBarPos
TextBar.Size = BarSize
TextBar.ZIndex = 9

TextBox.BackgroundTransparency = 1
TextBox.Font = Font
TextBox.FontSize = FontSize
TextBox.Name = "TextBox"
TextBox.Position = UDim2.new(0, TextBoxOffset, 0, 0)
TextBox.Size = BarSize
TextBox.Text = ""
TextBox.TextColor3 = TextColor3
TextBox.TextStrokeColor3 = TextStrokeColor3
TextBox.TextStrokeTransparency = TextStrokeTransparency
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.TextYAlignment = Enum.TextYAlignment.Center
TextBox.ZIndex = 10

-- Optimizations
local OpenTextBarPos = UDim2.new(0, 0, 1, -30)
local ClosedBarSize = UDim2.new(BarSize.X.Scale, BarSize.X.Offset, 0, 0)

local find = string.find
local gsub = string.gsub
local upper = string.upper

local CaptureFocus = TextBox.CaptureFocus
local FireServer = RavenChat.FireServer
local TweenPosition = TextBar.TweenPosition
local TweenSize = ButtonClipper.TweenSize

-- Module Data
local Text = ""
local Heartbeat = RunService.Heartbeat
local yield = Heartbeat.wait
local SwitchTexts = {
	["/sc"] = "ROOT";
	[" "] = true;
	[""] = true;
}
local ChatKeys = {
	Slash = true;
	Return = true;
}

-- Event Functions
local Focused, TextBoxRemoving, SlashTouched

local function TextChanged(Property)
	TextBoxRemoving = TextBoxRemoving or TextBox.TextBounds == Vector2.new(0, 0) and TextBox.Text ~= "" -- TextBounds gets set before Text when Destroy()ing
	if Property == "Text" and not TextBoxRemoving and not SlashTouched then
		Text = TextBox.Text
		print((gsub(Text, " ", "_")))
	end
	SlashTouched = false
end

local function Regen(Screen, Parent)
	if Parent == PlayerGui then return end
	yield(Heartbeat) -- Something unexpectedly tried to set the parent of RavenChat to PlayerGui while trying to set the parent of RavenChat to NULL :/
	ButtonClipper.Parent = Screen
	Button.Parent = ButtonClipper
	TextBox.Text = Text
	TextBar.Parent = Screen
	TextBox.Parent = TextBar
	Screen.Parent = PlayerGui

	if Focused then
		TextBox.ClearTextOnFocus = false
		TextBoxRemoving = false
		CaptureFocus(TextBox)
	end
end

local function Focus()
	Focused = true
	TweenPosition(TextBar, OpenTextBarPos, "Out", AnimationEase, AnimationTime, true)
	TweenSize(ButtonClipper, ClosedBarSize, "Out", AnimationEase, AnimationTime, true)
	TextBoxRemoving = false
	CaptureFocus(TextBox)
end

local function Unfocus(EnterPressed)
	Focused = false
	if EnterPressed or Text == "" or TextBox.Text == "" then
		TweenPosition(TextBar, ClosedTextBarPos, "Out", AnimationEase, AnimationTime, true)
		TweenSize(ButtonClipper, BarSize, "Out", AnimationEase, AnimationTime, true)
	end
end

local function FocusLost(EnterPressed, Key)
	--- Releases Textbox
	TextBox.ClearTextOnFocus = true -- Correct behavior

	if not EnterPressed then -- This would be the perfect scenario for a "but" keyword xD
		if Key and Key.KeyCode.Name == "Escape" then
			Unfocus()
		end
		return
	end

	Unfocus(true) -- Tween Elements

	local PlayerName, TeamColor

	local function GetName(Name)
		PlayerName = Name
		return ""
	end

	local Text, UseTeamColor = gsub(gsub(gsub(gsub(gsub(Text, "%s+", " "), "^/w (%w+)", GetName), "^@(%w+)", GetName), "^%%? ?%l", upper), "^%%", "")
	Text = SwitchTexts[Text] or Text

	if UseTeamColor > 0 then
		TeamColor = LocalPlayer.TeamColor
	end

	if type(Text) == "string" then -- Send Text to Server
		FireServer(RavenChat, Text, PlayerName, TeamColor)
	end
end

local function InputBegan(InputObject, Processed)
	if not Processed then
		local KeyName = InputObject.KeyCode.Name
		if ChatKeys[KeyName] then
			Focus()
			if KeyName == "Slash" then
				SlashTouched = true
			end
		elseif Focused then
			Unfocus() -- This ensures that clicking off of the gui registers as unfocusing but getting removed doesn't
		end
	end
end

Screen.Name = "RavenChat"
Screen.Parent = PlayerGui
print("Loaded RavenChat by Narrev")

-- Connect Everything!
TextBox.Changed:Connect(TextChanged)
TextBox.FocusLost:Connect(FocusLost)
Screen.AncestryChanged:Connect(Regen)
Button.MouseButton1Down:Connect(Focus)
UserInputService.InputBegan:Connect(InputBegan)

return nil
