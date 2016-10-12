local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Modules = {
	Nevermore = "https://raw.githubusercontent.com/Narrev/NevermoreEngine/c6b971b4c925a251ae1ab4118992bc7c09f11cdc/App/NevermoreEngine.lua";
	Emoji = "https://raw.githubusercontent.com/Narrev/RavenChat/master/Emoji.module.lua";
	List = "https://raw.githubusercontent.com/Narrev/RavenChat/master/List.module.lua";
	RavenChat = "https://raw.githubusercontent.com/Narrev/RavenChat/master/RavenChat.module.lua";
}

local function GetFolder(Name, Parent)
	local Folder = Parent:FindFirstChild(Name)
	if not Folder then
		Folder = Instance.new("Folder", Parent)
	end
	return Folder
end

local ModuleScript = {
	new = function(Name, Parent)
		local newScript = Instance.new("ModuleScript", Parent)
		newScript.Name = Name
		newScript.Source = HttpService:GetAsync(Modules[Name])
		return newScript
	end;
}

local ModuleFolder = GetFolder("Modules", ServerScriptService)

return function(WasHttpEnabled)
	ModuleScript.new("Nevermore", ReplicatedStorage)
	ModuleScript.new("Emoji", ModuleFolder)
	ModuleScript.new("List", ModuleFolder)
	ModuleScript.new("RavenChat", ModuleFolder)
	print("Successfully installed RavenChat")
	HttpService.HttpEnabled = WasHttpEnabled
end
