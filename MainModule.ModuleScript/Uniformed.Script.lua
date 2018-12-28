local GS = game:GetService( "GroupService" )

local Groups = require( game:GetService( "ServerStorage" ):WaitForChild( "UniDatabase" ) )

local Ran, DataStore = pcall( game:GetService( "DataStoreService" ).GetDataStore, game:GetService( "DataStoreService" ), "Uniformed" )

if not Ran or type( DataStore ) ~= "userdata" or not pcall( function ( ) DataStore:GetAsync( "Test" ) end ) then
	
	DataStore = { GetAsync = function ( ) end, SetAsync = function ( ) end, UpdateAsync = function ( ) end, OnUpdate = function ( ) end }
	
end

local Players = game:GetService( "Players" )

local Selected, Normal = { }, { }

function GetNormPants( UserId )
	
	local App = Players:GetCharacterAppearanceAsync( UserId )
	
	return App:FindFirstChild( "Pants" ) and App.Pants.PantsTemplate:match( "%d+" )
	
end

function GetNormShirt( UserId )
	
	local App = Players:GetCharacterAppearanceAsync( UserId )
	
	return App:FindFirstChild( "Shirt" ) and App.Shirt.ShirtTemplate:match( "%d+" )
	
end

function GetNormTShirt( UserId )
	
	local App = Players:GetCharacterAppearanceAsync( UserId )
	
	return App:FindFirstChild( "Shirt Graphic" ) and App[ "Shirt Graphic" ].Graphic:match( "%d+" )
	
end

local Loaded = { }

function Update( Plr, Char )
	
	if not Loaded[ Plr ] or not Char then return end
	
	if Char then
		
		local Selected = Selected[ Plr ] or { }
		
		if not Char:FindFirstChild( "Shirt" ) then
			
			Instance.new( "Shirt", Char ).Name = "Shirt"
			
		end
		
		Char.Shirt.ShirtTemplate = "rbxassetid://" .. ( Selected[ 1 ] or GetNormShirt( Plr.UserId < 0 and 16015142 or Plr.UserId ) or "" )
		
		if not Char:FindFirstChild( "Pants" ) then
			
			Instance.new( "Pants", Char ).Name = "Pants"
			
		end
		
		Char.Pants.PantsTemplate = "rbxassetid://" .. ( Selected[ 2 ] or GetNormPants( Plr.UserId < 0 and 16015142 or Plr.UserId ) or "" )
		
		if not Char:FindFirstChild( "Shirt Graphic" ) then
			
			Instance.new( "ShirtGraphic", Char ).Name = "Shirt Graphic"
			
		end
		
		Char[ "Shirt Graphic" ].Graphic = "rbxassetid://" .. ( Selected[ 3 ] or GetNormTShirt( Plr.UserId < 0 and 16015142 or Plr.UserId ) or "" )
		
	end
	
end

Players.PlayerAdded:Connect( function ( Plr )
	
	Plr.CharacterAppearanceLoaded:Connect( function ( Char )
		
		Update( Plr, Char )
		
	end )
	
end )

local Plrs = Players:GetPlayers( )

for a = 1, #Plrs do
	
	Plrs[ a ].CharacterAppearanceLoaded:Connect( function ( Char )
		
		Update( Plrs[ a ], Char )
		
	end )
	
end

function GetMax( T, Rank )
	
	local num = -1
	
	for a, b in pairs( T ) do
		
		if a ~= "Name" and a <= Rank then
			
			num = math.max( num, a )
			
		end
		
	end
	
	return num
	
end

function First( T )
	
	for a, b in pairs( T ) do
		
		return a
		
	end
	
end

local GetUni = Instance.new( "RemoteFunction", game:GetService( "ReplicatedStorage" ) )

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

Players.PlayerRemoving:Connect( function( Plr ) Selected[ Plr ] = nil Normal[ Plr ] = nil Loaded[ Plr ] = nil end )

local Debug = false

function GetUni.OnServerInvoke( Plr )
	
	local UGroups = GetGroups( Plr.UserId < 0 and 16015142 or Plr.UserId )
	
	local Unis, DefaultUni, DefaultTShirt = { }
	
	if not Debug then
		
		for a, b in pairs( UGroups ) do
			
			if Groups[ b.Id ] then
				
				if b.IsPrimary then
					
					local Highest = GetMax( Groups[ b.Id ], b.Rank )
					
					local R = Groups[ b.Id ][ Highest ]
					
					local F = First( R )
					
					if R[ F ][ 1 ] == nil then
						
						DefaultTShirt = { b.Name, GetName( F, true ) }
						
						repeat
							
							Highest = GetMax( Groups[ b.Id ], Highest - 1 )
							
							R = Groups[ b.Id ][ Highest ]
							
							if not R then break end
							
							F = First( R )
							
						until R[ F ][ 1 ] or Highest <= 1
						
					end
					
					DefaultUni = { b.Name, GetName( F ) }
					
				end
				
				Unis[ b.Name ] = Unis[ b.Name ] or { }
				
				for c, d in pairs( Groups[ b.Id ] ) do
					
					if c ~= "Name" then
						
						if c <= b.Rank then
							
							for e, f in pairs( d ) do
								
								Unis[ b.Name ][ GetName( e, not f[ 1 ] ) ] = f
								
							end
							
						end
						
					end
					
				end
				
			end
			
		end
		
	end
	
	if Debug then
		
		Unis = { }
		
		local t = ""
		
		for a, b in pairs( Groups ) do
			
			local Name = b.Name or game:GetService( "GroupService" ):GetGroupInfoAsync( a ).Name
			t = t .. Name .. ", "
			
			if b.Name ~= Name then warn( a .. " -" .. Name .. "- is not optimised!" ) end
			
			Unis[ b.Name ] = Unis[ b.Name ] or { }
			
			for c, d in pairs( b ) do
				
				if c ~= "Name" then
					
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
	
	local Data = DataStore:GetAsync( Plr.UserId ) or { }
	
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

GetUni.Name = "GetUni"

local ChangeUni = Instance.new( "RemoteEvent", game:GetService( "ReplicatedStorage" ) )

ChangeUni.OnServerEvent:Connect( function ( Plr, Shirt, TShirt, Ids )
	
	Selected[ Plr ] = Ids
	
	Update( Plr, Plr.Character )
	
	pcall( function ( ) DataStore:SetAsync( Plr.UserId, { Shirt, TShirt } ) end )
	
end )

ChangeUni.Name = "ChangeUni"