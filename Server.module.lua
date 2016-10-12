-- Server Code
-- @author Narrev

-- Services
local Players = game:GetService("Players")
local GameChat = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SoloTestMode = game:GetService("RunService"):IsStudio()

-- Nevermore
local Retrieve = require(ReplicatedStorage:WaitForChild("Nevermore"))

-- RemoteEvents
local RavenChat = Retrieve:Event("RavenChat")

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
local FilterStringAsync = not SoloTestMode and GameChat.FilterStringAsync or function(_, a) return a end

-- Event Handlers
local function Chatted(Chatter, Message, Pal, TeamColor)
	-- @param Player Chatter The player who typed the message
	-- @param string Message What the player wishes to Chat
	-- @param Player Pal Optional player that should receive the message
	-- @param TeamColor Used for TeamChat

	Message = FilterStringAsync(GameChat, Message, Chatter, Chatter)
	if Pal then -- Whisper! (goose flesh invoker)
		FireClient(RavenChat, Chatter, Pal, Message, true)
		FireClient(RavenChat, Pal, Chatter, Message, true)
	else
		FireAllClients(RavenChat, Chatter, Message, false, TeamColor)
	end
end

local function PlayerAdded(Player)
	FireAllClients(RavenChat, Player, Player.Name .. JoinOptions[random(1, NumJoinOptions)], "SYSTEM")
end

-- Connect Events
math.randomseed(tick())
RavenChat.OnServerEvent:Connect(Chatted)
Players.PlayerAdded:Connect(PlayerAdded)
