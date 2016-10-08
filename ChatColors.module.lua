-- ChatColor with picker
-- @author Narrev
-- @author noliCAIKS

local ChatColors = {
	Color3.fromRGB(255, 119, 119); Color3.fromRGB(167, 214, 255);
	Color3.fromRGB(96,  255, 162); Color3.fromRGB(233, 153, 255);
	Color3.fromRGB(255, 201, 156); Color3.fromRGB(255, 240, 160);
	Color3.fromRGB(255, 189, 230); Color3.fromRGB(227, 216, 197);

	System = Color3.fromRGB(0, 215, 136);
}

local ModeratorColor = Color3.fromRGB(255, 223, 94)

local Moderators = {
	142762267
}

local CustomColors = {
	[16826035] = Color3.fromRGB(255, 180, 252)
}

local byte = string.byte
function ChatColors:__index(Player)
	--- Gets a chat color and indexes it if one doesn't exist
	if Player:IsA("Player") then
		local userId, Name = Player.userId, Player.Name

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
			local ReverseIndex
			if length % 2 == 1 then
				ReverseIndex = length - letter
			else
				ReverseIndex = length - letter + 1
			end
			if ReverseIndex % 4 >= 2 then
				CharacterValue = -CharacterValue
			end
			userId = userId + CharacterValue
		end

		local Color = self[userId % #ChatColors + 1]
		self[Player] = Color
		return Color
	end
end

local Players = game:GetService("Players")
Players.PlayerRemoving:connect(function(Player)
	wait(10) -- Just chill to make sure that any of their messages have finished sending
	ChatColors[Player] = nil
end)

return setmetatable(ChatColors, ChatColors)
