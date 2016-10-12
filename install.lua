local HttpService = game.HttpService
local Nevermore = "https://raw.githubusercontent.com/Narrev/NevermoreEngine/c6b971b4c925a251ae1ab4118992bc7c09f11cdc/App/NevermoreEngine.lua"
local Modules = {
	Emoji = "https://github.com/Narrev/RavenChat/blob/master/Emoji.module.lua"
}

for i, v in pairs(URLs) do
	local loaded = HttpService:GetAsync(v)
	local identifier = string.sub(loaded, 0, 9)
	local c = Instance.new("Script", game.ServerScriptService)
	c.Source = HttpService:GetAsync(v)
end
