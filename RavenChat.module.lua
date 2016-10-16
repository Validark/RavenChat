
-- RavenChat User Interface
-- @author Narrev
-- Designed to work even if ClearGuiOnRespawn is Enabled

-- Config (Client)
local AnimationTime = .25
local AnimationEase = "Quart"
local BarSize = UDim2.new(1, 0, 0, 30)
local BarPosition = UDim2.new(0, 16, 1, -30)
local ClosedTextBarPos = UDim2.new(0, 0, 1, 0)
local Font = Enum.Font.ArialBold
local FontSize = 16
local TextBoxOffset = 16
local TextColor3 = Color3.new(1, 1, 1)
local TextStrokeColor3 = Color3.new(0, 0, 0)
local TextStrokeTransparency = .7

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Nevermore
local Nevermore = require(ReplicatedStorage:WaitForChild("Nevermore"))
local DestroyFirstChild = Nevermore:GetModule("DestroyFirstChild")

-- RemoteEvents
local RavenChat = Nevermore:GetEvent("RavenChat")

-- Chat Obect
local Chat = {}
local isServer = RunService:IsServer()
local isClient = RunService:IsClient()

if isServer then
	-- Services
	local GameChat = game:GetService("Chat")

	-- Module Data
	local JoinOptions = {
		" joined";
		" entered";
		" has arrived";
		" showed up!";
		" has entered the building!";
		" in the house!";
		" is here :D";
	}

	-- Optimizations
	local NumJoinOptions = #JoinOptions
	local random = math.random
	local FireClient = RavenChat.FireClient
	local FireAllClients = RavenChat.FireAllClients
	local FilterStringAsync = not isClient and GameChat.FilterStringAsync or function(_, a) return a end

	-- Event Handlers
	local function Chatted(Chatter, Message, PalName, TeamColor)
		-- @param Player Chatter The player who typed the message
		-- @param string Message What the player wishes to Chat
		-- @param string PalName Optional PlayerName that should receive the message
		-- @param TeamColor Used for TeamChat

		Message = FilterStringAsync(GameChat, Message, Chatter, Chatter)
		local ChatterName = Chatter.Name
		if PalName then -- Whisper! (goose flesh invoker)
			local Pal = Players[PalName]
			FireClient(RavenChat, Chatter, PalName, Message, true)

			if PalName ~= ChatterName then
				FireClient(RavenChat, Pal, ChatterName, Message, true)
			end
		else
			FireAllClients(RavenChat, ChatterName, Message, false, TeamColor)
		end
	end

	local function PlayerAdded(Player)
		FireAllClients(RavenChat, Player, "[SYSTEM]", Player.Name .. JoinOptions[random(1, NumJoinOptions)])
	end

	-- Connect Events
	math.randomseed(tick())
	RavenChat.OnServerEvent:Connect(Chatted)
	Players.PlayerAdded:Connect(PlayerAdded)
	--[[local a = -1
	spawn(function()
		while wait(.5) do
			a = a + 1
			FireAllClients(RavenChat, "Narrev", "UR DUM".. a)
			if a > 1000 then
				break
			end
		end
	end)--]]
end

if isClient then
	-- Services
	local StarterGui = game:GetService("StarterGui")
	local UserInputService = game:GetService("UserInputService")
	local Render = RunService.Heartbeat
	local Yield = Render.Wait or wait

	-- Modules
	local Easing = Nevermore:GetModule("Easing")

	-- Wait for PlayerGui to load
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local Tween = {IsRunning = false}
	Tween.__index = Tween

	function Tween:Stop()
		if self.IsRunning then
			self.Connection:Disconnect()
			self.IsRunning = nil
			setmetatable(self, nil)
		end
	end

	function Tween.new(Duration, Function, Callback)
		local EasingFunction = Easing[Function]
		local ElapsedTime = 0

		local self = setmetatable({
			StartTime = ElapsedTime;
			IsRunning = true;
		}, Tween)

		self.Connection = Render:Connect(function(step)
			if Duration > ElapsedTime then
				ElapsedTime = ElapsedTime + step
				Callback(EasingFunction(ElapsedTime, 0, 1, Duration))
			else
				Callback(1)
				self:Stop()
			end
		end)

		return self
	end

	-- Generate User Interface
	local Screen = Instance.new("ScreenGui")

	-- ChatBar
	local ButtonClipper = Instance.new("Frame", Screen)
	local Button = Instance.new("TextButton", ButtonClipper)
	local TextBar = Instance.new("Frame", Screen)
	local TextBox = Instance.new("TextBox", TextBar)

	-- Chat Display
	local Scroller = Instance.new("ScrollingFrame", Screen)

	ButtonClipper.BackgroundTransparency = 1
	ButtonClipper.ClipsDescendants = true
	ButtonClipper.Name = "ButtonClipper"
	ButtonClipper.Position = BarPosition
	ButtonClipper.Size = BarSize
	ButtonClipper.ZIndex = 9

	Button.BackgroundTransparency = 1
	Button.Font = Font
	Button.Name = "Button"
	Button.Size = BarSize
	Button.Text = "Press '/' or click here to chat."
	Button.TextColor3 = TextColor3
	Button.TextSize = FontSize
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
	TextBox.Name = "TextBox"
	TextBox.Position = UDim2.new(0, TextBoxOffset, 0, 0)
	TextBox.Size = BarSize
	TextBox.Text = ""
	TextBox.TextColor3 = TextColor3
	TextBox.TextSize = FontSize
	TextBox.TextStrokeColor3 = TextStrokeColor3
	TextBox.TextStrokeTransparency = TextStrokeTransparency
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.TextYAlignment = Enum.TextYAlignment.Center
	TextBox.ZIndex = 10

	Scroller.BackgroundTransparency = 1
	Scroller.Position = UDim2.new(0, 8, 0, 8)
	Scroller.ScrollBarThickness = 0
	Scroller.ScrollingEnabled = false
	Scroller.Size = UDim2.new(0, 400, 0, 140)
	Scroller.ZIndex = 10

	-- Optimizations
	local OpenTextBarPos = UDim2.new(0, 0, 1, -30)
	local ClosedBarSize = UDim2.new(BarSize.X.Scale, BarSize.X.Offset, 0, 0)

	local byte = string.byte
	local find = string.find
	local gsub = string.gsub
	local upper = string.upper

	local CaptureFocus = TextBox.CaptureFocus
	local FireServer = RavenChat.FireServer
	local TweenPosition = TextBar.TweenPosition
	local TweenSize = ButtonClipper.TweenSize

	-- Module Data
	local Text = ""
	local SwitchTexts = {
		["/sc"] = "ROOT";
		[" "] = true;
		[""] = true;
	}
	local ChatKeys = {
		Slash = true;
		Return = true;
	}

	local ChatColors = {
		Color3.fromRGB(255, 119, 119); Color3.fromRGB(131, 255, 251);
		Color3.fromRGB(96,  255, 162); Color3.fromRGB(255, 138, 255);
		Color3.fromRGB(255, 175, 151); Color3.fromRGB(255, 255, 150);
		Color3.fromRGB(255, 218, 255); Color3.fromRGB(227, 216, 197);
		Color3.fromRGB(0, 215, 136);

		System = Color3.fromRGB(234, 223, 204);
	}

	local ModeratorColor = Color3.fromRGB(255, 223, 94)

	local Moderators = {
		142762267
	}

	local CustomColors = {
		[16826035] = Color3.fromRGB(255, 180, 252)
	}

	function ChatColors:__index(PlayerString)
		--- Gets a chat color and indexes it if one doesn't exist
		local Player = Players:FindFirstChild(PlayerString)
		if Player then
			local userId, Name = Player.UserId, Player.Name

			for id, Color in next, CustomColors do
				if id == userId then
					self[Player] = Color
					return Color
				end
			end

			for a = 1, #Moderators do
				if Moderators[a] == userId then
					self[Player] = ModeratorColor
					return ModeratorColor
				end
			end

			local length = #Name
			for letter = 1, length do
				local CharacterValue = byte(Name, letter)
				local ReverseIndex = length - letter + (length % 2 == 1 and 1 or 0)

				if ReverseIndex % 4 >= 2 then
					CharacterValue = -CharacterValue
				end
				userId = userId + CharacterValue
			end

			local Color = self[userId % #ChatColors + 1]
			self[PlayerString] = Color
			return Color
		else
			return self[math.random(1, #ChatColors)]
		end
	end

	setmetatable(ChatColors, ChatColors)

	-- Event Functions
	local Focused, TextBoxRemoving, KeyInput, ClearDisabled

	local function TextChanged(Property)
		TextBoxRemoving = TextBoxRemoving or TextBox.TextBounds == Vector2.new(0, 0) and TextBox.Text ~= "" -- TextBounds gets set before Text when Destroy()ing
		if Property == "Text" and not TextBoxRemoving and not KeyInput then
			Text = TextBox.Text
			print(Text)
		elseif KeyInput then
			TextBox.Text = "/"
		end
		KeyInput = false
	end

	local function Regen(Screen, Parent)
		if Parent == PlayerGui then return end
		Yield(Render) -- Something unexpectedly tried to set the parent of RavenChat to PlayerGui while trying to set the parent of RavenChat to NULL :/
		ButtonClipper.Parent = Screen
		Button.Parent = ButtonClipper
		TextBox.Text = Text
		TextBar.Parent = Screen
		TextBox.Parent = TextBar
		Scroller.Parent = Screen
		Screen.Parent = PlayerGui

		if Focused then
			ClearDisabled, TextBox.ClearTextOnFocus, TextBoxRemoving = true
			CaptureFocus(TextBox)
		end
	end

	local function Focus()
		Focused = true
		if not ClearDisabled then
			Text = ""
		end
		TweenPosition(TextBar, OpenTextBarPos, "Out", AnimationEase, AnimationTime, true)
		TweenSize(ButtonClipper, ClosedBarSize, "Out", AnimationEase, AnimationTime, true)
		TextBoxRemoving = false
	end

	local function Unfocus(EnterPressed)
		Focused = false
		if EnterPressed or TextBox.Text == "" then
			TweenPosition(TextBar, ClosedTextBarPos, "Out", AnimationEase, AnimationTime, true)
			TweenSize(ButtonClipper, BarSize, "Out", AnimationEase, AnimationTime, true)
		end
	end

	local function FocusLost(EnterPressed, Key)
		--- Releases Textbox
		TextBox.ClearTextOnFocus, ClearDisabled = true -- Correct behavior

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

		local Text, UseTeamColor = gsub(gsub(gsub(Text, "%s+", " "), "^/w (%w+)", GetName), "^%%", "")
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
				KeyInput = true
				CaptureFocus(TextBox)
			elseif Focused then
				Unfocus() -- This ensures that clicking off of the gui registers as unfocusing but getting removed doesn't
			end
		end
	end

	local MessageYOffset = 140
	local Tweenable = true
	local FadeTime = .25
	local MessageNumber = 0
	local function MessageDisplay(Chatter, Message, Private, TeamColor)
		-- @param string Chatter Name of Player who is chatting
		-- @param string Message The text the Player is chatting
		-- @param bool Private Whether the message is top secret
		-- @param bool TeamColor Whether the message is for just one TeamColor

		MessageNumber = MessageNumber + 1
		Scroller.CanvasSize = UDim2.new(0, 0, 0, MessageYOffset + 20)

		local NameText = Instance.new("TextLabel", Scroller)
		NameText.BackgroundTransparency = 1
		NameText.Font = Font
		NameText.Name = MessageNumber
		NameText.Position = UDim2.new(0, 0, 0, MessageYOffset)
		NameText.Size = UDim2.new(1, 0, 0, 20)
		NameText.Text = Chatter
		NameText.TextColor3 = ChatColors[Chatter] --Color3.new(0, 1, 213/255)
		NameText.TextSize = FontSize
		NameText.TextStrokeTransparency = 0.5
		NameText.TextXAlignment = Enum.TextXAlignment.Left

		local MessageText = Instance.new("TextLabel", NameText)
		MessageText.BackgroundTransparency = 1
		MessageText.Font = Font
		MessageText.Position = UDim2.new(0, NameText.TextBounds.X, 0, 0)
		MessageText.Size = UDim2.new(0, 0, 0, 20)
		MessageText.Text = Message
		MessageText.TextColor3 = Color3.new(1, 1, 1)
		MessageText.TextSize = FontSize
		MessageText.TextStrokeTransparency = 0.7
		MessageText.TextXAlignment = Enum.TextXAlignment.Left


		if Tweenable then
			local StartPosition = Scroller.CanvasPosition
			local CanvasPositionY = StartPosition.Y
			local Accumulated = Vector2.new(0, 0)

			Tween.new(FadeTime, "OutQuad", function(ratio)
				local Change = Vector2.new(0, CanvasPositionY + ratio*20) - StartPosition
				Scroller.CanvasPosition = Scroller.CanvasPosition + Change - Accumulated
				Accumulated = Change
			end)
		end

		MessageYOffset = MessageYOffset + 20

		if MessageNumber > 100 then
			local RemoveThis = Scroller:FindFirstChild(MessageNumber - 100)
			if RemoveThis then
				RemoveThis:Destroy()
			end
		end
	end

	Screen.Name = "RavenChat"
	Screen.Parent = PlayerGui

	RavenChat.OnClientEvent:Connect(MessageDisplay)
	Players.PlayerRemoving:Connect(function(Player)
		wait(10) -- Just chill to make sure that any of their messages have finished sending
		ChatColors[Player.Name] = nil
	end)
	-- Connect Everything!
	TextBox.Changed:Connect(TextChanged)
	TextBox.Focused:Connect(Focus)
	TextBox.FocusLost:Connect(FocusLost)
	Screen.AncestryChanged:Connect(Regen)
	Button.MouseButton1Down:Connect(function()
		CaptureFocus(TextBox)
	end)
	UserInputService.InputBegan:Connect(InputBegan)
	print("Loaded RavenChat by Narrev")
end

return Chat
