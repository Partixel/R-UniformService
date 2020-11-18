if not game:GetService("ServerStorage"):FindFirstChild("Uni") then return end
if not game:GetService("ServerStorage").Uni:FindFirstChild("Cache") then
	local C = Instance.new("ModuleScript")
	C.Name = "Cache"
	C.Parent = game:GetService("ServerStorage").Uni
	C.Source = "{}"
end
local NewCache = game:GetService("ServerStorage").Uni.Cache
local Cache = game.HttpService:JSONDecode(NewCache.Source)
local toolbar = plugin:CreateToolbar("ImageIdConverter")
local GS = game:GetService("GroupService")
local button = toolbar:CreateButton("Convert", "Press me", "")
button.ClickableWhenViewportHidden = true
local Stringify = require(2789644632)
button.Click:Connect(function()
	local s = game:GetService("ServerStorage").Uni.MainModule.Source
	local b = 0
	for a in s:gmatch("%d+") do
		repeat
			b = b + 1
			if tonumber(a) < 256 or Cache[a] == true then break end
			if Cache[a] then
				print(a, Cache[a])
				s = s:gsub("%f[%d]" .. a .. "%f[%D]", function(...) return Cache[a] end)
				break
			end
			game["Run Service"].Heartbeat:wait()
			if pcall(function() return game.GroupService:GetGroupInfoAsync(tonumber(a)) end) then
				Cache[a] = true
				break
			end
			print("Checking " .. a)
			local Ran, Ret = pcall(function()
				local items = game:GetObjects("http://www.roblox.com/asset/?id=" .. a)
				local ty = items[1]:IsA("Shirt") and "ShirtTemplate" or items[1]:IsA("Pants") and "PantsTemplate" or items[1]:IsA("ShirtGraphic") and "Graphic"
				return items[1][ty]:match("%d+")
			end)
			if Ran and Ret ~= "1" then
				print("converted", a, Ret)
				Cache[a] = Ret
				Cache[Ret] = true
				s = s:gsub("%f[%d]" .. a .. "%f[%D]", Ret)
				break
			end
			print("already converted")
			Cache[a] = true
		until true
	end
	game:GetService("ServerStorage").Uni.MainModule.Source = s
	NewCache.Source = game.HttpService:JSONEncode(Cache)
	--[[local function(Find(ID)
		for _, Value in pairs(Cache) do
			if Value == ID then return true end
		end
	end
	for ID, Value in pairs(Cache) do
		if Value == true then
			pcall(function()
				if not Find(ID) and not pcall(function(() return game.GroupService:GetGroupInfoAsync(tonumber(ID)) end) and game.MarketplaceService:GetProductInfo(ID).AssetTypeId == 1 then
					print("checking " .. ID .. " - " .. tostring(Value))
					local Found
					for a = 1, 200 do
						local Ran, Ret = pcall(function()
							local items = game:GetObjects("http://www.roblox.com/asset/?id=" .. ID + a)
							local ty = items[1]:IsA("Shirt") and "ShirtTemplate" or items[1]:IsA("Pants") and "PantsTemplate" or items[1]:IsA("ShirtGraphic") and "Graphic"
							if items[1][ty]:match("%d+") == tostring(ID) then
								return tostring(ID + a)
							end
						end)
						if Ran and Ret then
							Cache[Ret] = ID
							Found = true
							print("found " .. Ret .. " for " .. ID)
							break
						end
					end
					if not Found then
						warn("failed to find id for " .. ID)
					end
				end
			end)
		end
	end
	NewCache.Source = game.HttpService:JSONEncode(Cache)]]
	print("Done conversion")
	local TemplateToId = {}
	for Id, Template in pairs(Cache) do
		if Template ~= true then
			TemplateToId[Template] = Id
		end
	end
	game:GetService("ServerStorage").Uni.MainModule.MenuModules.Uniformed.Client.TemplateToId.Source = "return " .. Stringify(TemplateToId, nil, {Space = "", Tab = "", NewLine = "", SecondaryNewLine = "",})
	print("Done template to shirt")
end)