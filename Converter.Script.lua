if not game:GetService( "ServerStorage" ):FindFirstChild( "Uniformed" ) then return end

if not game:GetService( "ServerStorage" ).Uniformed:FindFirstChild( "Cache" ) then
	
	local C = Instance.new( "ModuleScript" )
	
	C.Name = "Cache"
	
	C.Parent = game:GetService( "ServerStorage" ).Uniformed
	
	C.Source = "{}"
	
end

local NewCache = game:GetService( "ServerStorage" ).Uniformed.Cache

local Cache = game.HttpService:JSONDecode( NewCache.Source )

local toolbar = plugin:CreateToolbar( "ImageIdConverter" )

local GS = game:GetService( "GroupService" )

local button = toolbar:CreateButton( "Convert", "Press me", "" )

button.ClickableWhenViewportHidden = true

button.Click:Connect(function()
	
	local s = game:GetService( "ServerStorage" ).Uniformed.MainModule.Source
	
	local b = 0
	
	for a in s:gmatch( "%d+" ) do
		
		repeat
			
			b = b + 1
			
			if tonumber( a ) < 256 or Cache[ a ] == true then do break end end
			
			if Cache[ a ] then
				
				print( a, Cache[ a ] )
				
				s = s:gsub( "%f[%d]" .. a .. "%f[%D]", function ( ... ) return Cache[ a ] end )
				
				do break end
				
			end
			
			game["Run Service"].Heartbeat:wait( )
			
			if pcall( function ( ) return game.GroupService:GetGroupInfoAsync( tonumber( a ) ) end ) then
				
				Cache[ a ] = true
				
				do break end
				
			end
			
			print( "Checking " .. a )
			
			local Ran, Ret = pcall( function ( )
				
				local items = game:GetObjects( "http://www.roblox.com/asset/?id=" .. a )
				
				local ty = items[ 1 ]:IsA( "Shirt" ) and "ShirtTemplate" or items[ 1 ]:IsA( "Pants" ) and "PantsTemplate" or items[ 1 ]:IsA( "ShirtGraphic" ) and "Graphic"
				
				return items[ 1 ][ ty ]:match( "%d+" )
				
			end )
			
			if Ran and Ret ~= "1" then
				
				print( a, Ret )
				
				Cache[ a ] = Ret
				
				Cache[ Ret ] = true
				
				NewCache.Source = game.HttpService:JSONEncode( Cache )
				
				s = s:gsub( "%f[%d]" .. a .. "%f[%D]", Ret )
				
				do break end
				
			end
			
			Cache[ a ] = true
			
			NewCache.Source = game.HttpService:JSONEncode( Cache )
			
		until true
		
	end
	
	NewCache.Source = game.HttpService:JSONEncode( Cache )
	
	game:GetService( "ServerStorage" ).Uniformed.MainModule.Source = s
	
	print( "Done" )
	
end)