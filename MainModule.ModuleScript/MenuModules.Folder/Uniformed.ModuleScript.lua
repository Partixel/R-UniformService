local GS = game:GetService( "GroupService" )

local Players = game:GetService( "Players" )

local Selected, Normal = { }, { }

local Loaded = { }

local DebugUserId = 16015142

local Debug = true and game.PlaceId == 1146989110

function Update( Plr, Char )
	
	if not Loaded[ Plr ] or not Char then return end
	
	if Char then
		
		local Selected = Selected[ Plr ] or { }
		
		local App = Players:GetCharacterAppearanceAsync( Plr.UserId < 0 and DebugUserId or Plr.UserId )
		
		local NormShirt, NormPants, NormTShirt = App:FindFirstChild( "Shirt" ) and App.Shirt.ShirtTemplate:match( "%d+" ), App:FindFirstChild( "Pants" ) and App.Pants.PantsTemplate:match( "%d+" ), App:FindFirstChild( "Shirt Graphic" ) and App[ "Shirt Graphic" ].Graphic:match( "%d+" )
		
		if not Char:FindFirstChild( "Shirt" ) then
			
			Instance.new( "Shirt", Char ).Name = "Shirt"
			
		end
		
		Char.Shirt.ShirtTemplate = "rbxassetid://" .. ( Selected[ 1 ] or NormShirt or "" )
		
		if not Char:FindFirstChild( "Pants" ) then
			
			Instance.new( "Pants", Char ).Name = "Pants"
			
		end
		
		Char.Pants.PantsTemplate = "rbxassetid://" .. ( Selected[ 2 ] or NormPants or "" )
		
		if not Char:FindFirstChild( "Shirt Graphic" ) then
			
			Instance.new( "ShirtGraphic", Char ).Name = "Shirt Graphic"
			
		end
		
		Char[ "Shirt Graphic" ].Graphic = "rbxassetid://" .. ( Selected[ 3 ] or NormTShirt or "" )
		
	end
	
end

Players.PlayerAdded:Connect( function ( Plr )
	
	Plr.CharacterAppearanceLoaded:Connect( function ( Char )
		
		Update( Plr, Char )
		
	end )
	
end )

for _, Plr in ipairs( Players:GetPlayers( ) ) do
	
	Plr.CharacterAppearanceLoaded:Connect( function ( Char )
		
		Update( Plr, Char )
		
	end )
	
end

function GetMax( T, Rank, TShirt )
	
	local num = -1
	
	for a, b in pairs( T ) do
		
		if a ~= "Name" and a ~= "DivisionOf" and a <= Rank and (not TShirt or b[1]) then
			
			num = math.max( num, a )
			
		end
		
	end
	
	return num
	
end

function GetGroups( UserId )
	
	local Ran, Groups
	
	while not Ran do
		
		Ran, Groups = pcall( function ( ) return GS:GetGroupsAsync( UserId ) end )
		
		if Ran then return Groups end
		
		wait( 1 )
		
	end
	
end

function GetName( ShirtName, TShirt )
	
	return ( type( ShirtName ) ~= "number" and ( ShirtName .. ( TShirt and " TShirt" or "" )  ) or ( TShirt and "TShirt" or "Uniform" ) )
	
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
			Selected[Plr] = Ids
			Update(Plr, Plr.Character)
			return {Shirt, TShirt}
		end
	end,
}

Players.PlayerRemoving:Connect( function( Plr ) Selected[ Plr ] = nil Normal[ Plr ] = nil Loaded[ Plr ] = nil end )

local Groups = require( game:GetService( "ServerStorage" ):WaitForChild( "Uniformed" ) )

function Menu.BeforeSendToClient(Plr, Data, PrimaryGroupId, UniformName)
	
	local UGroups = GetGroups( Plr.UserId < 0 and DebugUserId or Plr.UserId )

	local Unis, DefaultUni, DefaultTShirt = { }, nil, nil
	
	if not Debug then
		
		local FoundPlacePrimary
		for a, b in pairs( UGroups ) do
			if Groups[ b.Id ] then
				local Primary
				if b.IsPrimary and Groups[b.Id].DivisionOf and Groups[b.Id].DivisionOf == Menu.PrimaryGroupId then
					Primary = true
					FoundPlacePrimary = true
				elseif not FoundPlacePrimary then
					if b.IsPrimary or b.Id == Menu.PrimaryGroupId then
						Primary = true
						FoundPlacePrimary = b.Id == Menu.PrimaryGroupId
					end
				end
				
				if Primary then
					
					local Highest = GetMax( Groups[ b.Id ], b.Rank )
					
					local R = Groups[ b.Id ][ Highest ]
					
					local F = Menu.DefaultUni and Menu.DefaultUni[b.Id] and Menu.DefaultUni[b.Id][Highest]
					local ShirtF = next(R)
					if not F then
						F = ShirtF
					elseif type(F) ~= "string" then
						F = F[2]
					end
					
					if R[ ShirtF ][ 1 ] == nil then
						
						DefaultTShirt = { b.Name, GetName( ShirtF, true ) }
						
						Highest = GetMax( Groups[ b.Id ], b.Rank, true )
						
						R = Groups[ b.Id ][ Highest ]
						
						if ShirtF == F then
							F = next( R )
						end
					end
					
					DefaultUni = { b.Name, GetName( F ) }
					
				end
				
				Unis[ b.Name ] = Unis[ b.Name ] or { }
				
				if Groups[ b.Id ].DivisionOf and Groups[ Groups[ b.Id ].DivisionOf ] then
					
					Unis[ b.Name ].DivisionOf = Groups[ Groups[ b.Id ].DivisionOf ].Name
					
				end
				
				for c, d in pairs( Groups[ b.Id ] ) do
					
					if type( c ) == "number" then
						
						if c <= b.Rank then
							
							for e, f in pairs( d ) do
								
								Unis[ b.Name ][ GetName( e, not f[ 1 ] ) ] = f
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	else
		
		Unis = { }
		
		local t = ""
		
		for a, b in pairs( Groups ) do
			
			local Name = b.Name or game:GetService( "GroupService" ):GetGroupInfoAsync( a ).Name
			t = t .. Name .. ", "
			
			if b.Name ~= Name then warn( a .. " - " .. Name .. " - is not optimised!" ) end
			
			Unis[ b.Name ] = Unis[ b.Name ] or { }
			
			if b.DivisionOf then
				
				if Groups[ b.DivisionOf ] then
					
					Unis[ b.Name ].DivisionOf = Groups[ b.DivisionOf ].Name
					
				else
					
					warn( a .. " - " .. b.Name .. " - could not find the division this group is part of - " .. b.DivisionOf )
					
				end
				
			end
			
			for c, d in pairs( b ) do
				
				if type( c ) == "number" then
					
					for c, d in pairs( d ) do
						
						Unis[ b.Name ][ GetName( c, not d[ 1 ] ) ] = d
						
					end
					
				end
				
			end
			
		end
		
		t = t:sub( 1, -3 )
		
		print( t )
		
	end
	
	local Shirt, TShirt = DefaultUni and Unis[ DefaultUni[ 1 ] ][ DefaultUni[ 2 ] ] or { }, DefaultTShirt and Unis[ DefaultTShirt[ 1 ] ][ DefaultTShirt[ 2 ] ] or { }
	
	Normal[ Plr ] = { Shirt[ 1 ], Shirt[ 2 ], TShirt[ 3 ] }
	
	local Sel, TSel
	
	if Data[ 1 ] == false or ( Data[ 1 ] and Unis[ Data[ 1 ][ 1 ] ] and Unis[ Data[ 1 ][ 1 ] ][ Data[ 1 ][ 2 ] ] ) then
		
		Sel = Data[ 1 ]
		
		Shirt = Data[ 1 ] and Unis[ Data[ 1 ][ 1 ] ][ Data[ 1 ][ 2 ] ] or { }
		
	end
	
	if Data[ 2 ] == false or ( Data[ 2 ] and Unis[ Data[ 2 ][ 1 ] ] and Unis[ Data[ 2 ][ 1 ] ][ Data[ 2 ][ 2 ] ] ) then
		
		TSel = Data[ 2 ]
		
		Shirt = Data[ 2 ] and Unis[ Data[ 2 ][ 1 ] ][ Data[ 2 ][ 2 ] ] or { }
		
	end
	
	Selected[ Plr ] = { Shirt[ 1 ], Shirt[ 2 ], TShirt[ 3 ] }
	
	Loaded[ Plr ] = true
	
	Update( Plr, Plr.Character )
	
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