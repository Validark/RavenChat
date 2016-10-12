return function(WasHttpEnabled)
	local HttpService = game:GetService("HttpService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local ServerScriptService = game:GetService("ServerScriptService")

	local Modules = {
		Nevermore = "https://raw.githubusercontent.com/Narrev/NevermoreEngine/c6b971b4c925a251ae1ab4118992bc7c09f11cdc/App/NevermoreEngine.lua";
		Emoji = "https://github.com/Narrev/RavenChat/blob/master/Emoji.module.lua";
		List = "https://github.com/Narrev/RavenChat/blob/master/List.module.lua";
		RavenChat = "https://github.com/Narrev/RavenChat/blob/master/RavenChat.module.lua";
	}

	local function GetFolder(Name, Parent)
		local Folder = Parent:FindFirstChild(Name)
		if not Folder then
			Folder = Instance.new("Folder", Parent)
		end
		return Folder
	end

	local ModuleScript = {
		function new(Name, Parent)
			local script = Instance.new("ModuleScript", Parent)
			script.Name = Name
			script.Source = HttpService:GetAsync(Modules[Name])
			return script
		end
	}

	local ModuleFolder = GetFolder("Modules", ServerScriptService)

	ModuleScript.new("Nevermore", ReplicatedStorage)
	ModuleScript.new("Emoji", ModuleFolder)
	ModuleScript.new("List", ModuleFolder)
	ModuleScript.new("RavenChat", ModuleFolder)
	print("Successfully installed RavenChat")
	HttpService.HttpEnabled = WasHttpEnabled
end
