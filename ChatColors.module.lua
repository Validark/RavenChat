-- ChatColor with picker
-- @author Narrev
-- @author noliCAIKS

local ChatColors = {
	"Bright red";
	"Bright blue";
	"Earth green";
	"Bright violet";
	"Bright orange";
	"Bright yellow";
	"Light reddish violet";
	"Brick yellow";
}

local byte = string.byte

function ChatColors:__index(Player)
	--- Gets a chat color and indexes it if one doesn't exist
	if Player:IsA("Player") then
		local userId, Name = Player.userId, Player.Name
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

game:GetService("Players").PlayerRemoving:connect(function(Player)
	wait(10) -- Just chill to make sure that any of their messages have finished sending
	ChatColors[Player] = nil
end)

return setmetatable(ChatColors, ChatColors)
