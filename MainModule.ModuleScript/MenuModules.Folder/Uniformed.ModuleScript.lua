local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local Selected, Normal = {}, {}
local Loaded = {}

local DebugUserId = 16015142
local Debug = true and game.PlaceId == 5616199692

local function Update(Plr, Char)
	if not Loaded[Plr] or not Char then
		return
	end
	
	local Selected = Selected[Plr] or {}
	if not Char:FindFirstChild("Shirt") then
		Instance.new("Shirt", Char).Name = "Shirt"
	end
	Char.Shirt.ShirtTemplate = "rbxassetid://" .. (Selected[1] or Normal[Plr][1] or "")
	
	if not Char:FindFirstChild("Pants") then
		Instance.new("Pants", Char).Name = "Pants"
	end
	Char.Pants.PantsTemplate = "rbxassetid://" .. (Selected[2] or Normal[Plr][2] or "")
	
	if not Char:FindFirstChild("Shirt Graphic") then
		Instance.new("ShirtGraphic", Char).Name = "Shirt Graphic"
	end
	Char["Shirt Graphic"].Graphic = "rbxassetid://" .. (Selected[3] or (not Selected[1] and Normal[Plr][3]) or "")
end

local function PlayerAdded(Plr)
	Plr.CharacterAppearanceLoaded:Connect(function(Char)
		Normal[Plr] = {Char:FindFirstChild("Shirt") and Char.Shirt.ShirtTemplate:match("%d+"), Char:FindFirstChild("Pants") and Char.Pants.PantsTemplate:match("%d+"), Char:FindFirstChild("Shirt Graphic") and Char["Shirt Graphic"].Graphic:match("%d+")}
		Update(Plr, Char)
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)
for _, Plr in ipairs(Players:GetPlayers()) do
	PlayerAdded(Plr)
end

Players.PlayerRemoving:Connect(function(Plr)
	Selected[Plr] = nil
	Normal[Plr] = nil
	Loaded[Plr] = nil
end)

function GetMax(T, Rank, TShirt)
	local num = -1
	for a, b in pairs(T) do
		if type(a) == "number" and a <= Rank and (not TShirt or b[1]) then
			num = math.max(num, a)
		end
	end
	
	return num
end

function GetGroups(UserId)
	local Ran, Groups
	while not Ran do
		Ran, Groups = pcall(function()
			return GroupService:GetGroupsAsync(UserId)
		end)
		if Ran then
			return Groups
		end
		
		wait(0.1)
	end
end

function GetName(ShirtName, TShirt)
	return (type(ShirtName) ~= "number" and (ShirtName .. (TShirt and " TShirt" or "")) or (TShirt and "TShirt" or "Uniform"))
end

local Menu Menu = {
	Key = "Uniformed1",
	DefaultValue = {},
	SendToClient = true,
	AllowRemoteSet = true,
	PrimaryGroupId = game.CreatorType == Enum.CreatorType.Group and game.CreatorId or nil,
	BeforeRemoteSet = function(Plr, DataStore, Remote, Shirt, TShirt, Ids)
		if Shirt == -1 then
			Remote:FireClient(Plr, Menu.BeforeSendToClient(Plr, DataStore:Get({})))
		else
			if Ids["3"] then
				Ids[3] = Ids["3"]
				Ids["3"] = nil
			end
			
			Selected[Plr] = Ids
			Update(Plr, Plr.Character)
			return {Shirt, TShirt}
		end
	end,
}

local Groups = require(game:GetService("ServerStorage"):WaitForChild("Uniformed"))
function Menu.BeforeSendToClient(Plr, Data, PrimaryGroupId, UniformName)
	local UGroups = GetGroups(Plr.UserId < 0 and DebugUserId or Plr.UserId)
	local Unis, DefaultUni, DefaultTShirt = {}, nil, nil
	if not Debug then
		local FoundPlacePrimary
		for _, GroupData in pairs(UGroups) do
			if Groups[GroupData.Name] then
				local Primary
				if GroupData.IsPrimary and Groups[GroupData.Name].DivisionOf and Groups[Groups[GroupData.Name].DivisionOf].Id == Menu.PrimaryGroupId then
					Primary = true
					FoundPlacePrimary = true
				elseif not FoundPlacePrimary then
					if GroupData.IsPrimary or GroupData.Id == Menu.PrimaryGroupId then
						Primary = true
						FoundPlacePrimary = GroupData.Id == Menu.PrimaryGroupId
					end
				end
				
				if Primary then
					local Highest = GetMax(Groups[GroupData.Name], GroupData.Rank)
					
					local R = Groups[GroupData.Name][Highest]
					
					local F = Menu.DefaultUni and Menu.DefaultUni[GroupData.Name] and Menu.DefaultUni[GroupData.Name][Highest]
					local ShirtF = next(R)
					if not F then
						F = ShirtF
					elseif type(F) ~= "string" then
						F = F[2]
					end
					
					if R[ShirtF][1] == nil then
						DefaultTShirt = {GroupData.Name, GetName(ShirtF, true)}
						Highest = GetMax(Groups[GroupData.Name], GroupData.Rank, true)
						
						R = Groups[GroupData.Name][Highest]
						if ShirtF == F then
							F = next(R)
						end
					end
					
					DefaultUni = {GroupData.Name, GetName(F)}
				end
				
				Unis[GroupData.Name] = Unis[GroupData.Name] or {}
				if Groups[GroupData.Name].DivisionOf and Groups[Groups[GroupData.Name].DivisionOf] then
					Unis[GroupData.Name].DivisionOf = Groups[GroupData.Name].DivisionOf
				end
				
				for c, d in pairs(Groups[GroupData.Name]) do
					if type(c) == "number" then
						if c <= GroupData.Rank then
							for e, f in pairs(d) do
								Unis[GroupData.Name][GetName(e, not f[1])] = f
							end
						end
					end
				end
			end
		end
	else
		local GroupNames = {}
		for Name, GroupInfo in pairs(Groups) do
			GroupNames[#GroupNames + 1] = Name
			
			Unis[Name] = Unis[Name] or {}
			if GroupInfo.DivisionOf then
				if Groups[GroupInfo.DivisionOf] then
					Unis[Name].DivisionOf = GroupInfo.DivisionOf
				else
					warn(Name .. " - could not find the group this division is part of - " .. GroupInfo.DivisionOf)
				end
			end
			
			for c, d in pairs(GroupInfo) do
				if type(c) == "number" then
					for c, d in pairs(d) do
						Unis[Name][GetName(c, not d[1])] = d
					end
				end
			end
		end
		
		table.sort(GroupNames)
		print(table.concat(GroupNames, ", "))
	end
	
	local Shirt, TShirt, Sel, TSel = DefaultUni and Unis[DefaultUni[1]][DefaultUni[2]] or {}, DefaultTShirt and Unis[DefaultTShirt[1]][DefaultTShirt[2]] or {}, nil, nil
	if Data[1] == false or (Data[1] and Unis[Data[1][1]] and Unis[Data[1][1]][Data[1][2]]) then
		Sel = Data[1]
		Shirt = Data[1] and Unis[Data[1][1]][Data[1][2]] or {}
	end
	
	if Data[2] == false or (Data[2] and Unis[Data[2][1]] and Unis[Data[2][1]][Data[2][2]]) then
		TSel = Data[2]
		Shirt = Data[2] and Unis[Data[2][1]][Data[2][2]] or {}
	end
	
	Selected[Plr] = {Shirt[1], Shirt[2], TShirt[3] or Shirt[3]}
	Loaded[Plr] = true
	
	if Normal[Plr] then
		Update(Plr, Plr.Character)
	end
	
	return Unis, DefaultUni, DefaultTShirt, Sel, TSel
end

local VH_Func = function(Main)
	Main.Commands["SetUniform"] = {
		Alias = {"setuniform", "uniform", "uni"},
		Description = "Sets the player(s) uniform to the specified uniform",
		CanRun = "$moderator, $debugger",
		Category = "character",
		ArgTypes = {},
		Callback = function(self, Plr, Cmd, Args, NextCmds, Silent)
			return true
		end
	}
end

if _G.VH_AddExternalCmds then
	_G.VH_AddExternalCmds(VH_Func)
else
	_G.VH_AddExternalCmdsQueue = _G.VH_AddExternalCmdsQueue or {}
	_G.VH_AddExternalCmdsQueue[script] = VH_Func
end

return Menu