local Players = game:GetService( "Players" )

local Plr = Players.LocalPlayer

local UserId = Plr.UserId < 0 and 16015142 or Plr.UserId

local Unis, Selected, SelectedTShirt = game:GetService( "ReplicatedStorage" ):WaitForChild( "GetUni" ):InvokeServer( )

local ChangeUni = game:GetService( "ReplicatedStorage" ):WaitForChild( "ChangeUni" )

local Gui = script.Parent:WaitForChild( "Frame" )

function GetMatchingKeys( T, Str )
	
	local Tmp = { }
	
	for a, b in pairs( T ) do
		
		if a:lower( ):find( Str:lower( ) ) and a ~= Selected and a ~= SelectedTShirt then
			
			Tmp[ #Tmp + 1 ] = a
			
		end
		
	end
	
	table.sort( Tmp )
	
	if SelectedTShirt then
		
		table.insert( Tmp, 1, SelectedTShirt )
		
	end
	
	if Selected then
		
		table.insert( Tmp, 1, Selected )
		
	end
	
	return Tmp
	
end

local App = Players:GetCharacterAppearanceAsync( UserId )

function GetNormPants( )
	
	return App:FindFirstChild( "Pants" ) and App.Pants.PantsTemplate:match( "%d+" )
	
end

function GetNormShirt( )
	
	return App:FindFirstChild( "Shirt" ) and App.Shirt.ShirtTemplate:match( "%d+" )
	
end

function GetNormTShirt( )
	
	return App:FindFirstChild( "Shirt Graphic" ) and App[ "Shirt Graphic" ].Graphic:match( "%d+" )
	
end

function PopulateScroll( )
	
	local Search, Base, ScrFr = Gui:WaitForChild( "Search" ), Gui:WaitForChild( "Base" ), Gui:WaitForChild( "ScrollingFrame" )
	
	local Buttons = ScrFr:GetChildren( )
	
	for a = 1, #Buttons do
		
		if Buttons[ a ]:IsA( "TextButton" ) then
			
			Buttons[ a ]:Destroy( )
			
		end
		
	end
	
	local Keys = GetMatchingKeys( Unis, Search.Text )
	
	Keys[ #Keys + 1 ] = false
	
	Buttons = { }
	
	for a = 1, #Keys do
		
		local Uni = Unis[ Keys[ a ] ] or { }
		
		local Shirt, TShirt = Uni[ 1 ] ~= nil, Uni[ 3 ] ~= nil
		
		local New = Base:Clone( )
		
		ScrFr.CanvasSize = UDim2.new( 0, 0, 0, 5 + ( 55 * a ) )
		
		Buttons[ #Buttons + 1 ] = New
		
		New.Name = tostring( Keys[ a ] )
		
		New.LayoutOrder = a
		
		if Selected == Keys[ a ] or ( SelectedTShirt == Keys[ a ] and Keys[ a ] ) then
			
			New.BorderSizePixel = 5
			
		end
		
		if Shirt then
			
			New:WaitForChild( "ImageLabel" ).Image = "rbxassetid://" .. ( Uni[ 1 ] or Uni[ 2 ] )
			
		end
		
		if TShirt then
			
			New.BorderColor3 = Color3.fromRGB( 100, 200, 100 )
			
			New:WaitForChild( "ImageLabel" ).Image = "rbxassetid://" .. Uni[ 3 ]
			
			New.ImageLabel.ImageRectOffset = Vector2.new( 0, 0 )
			
			New.ImageLabel.ImageRectSize = Vector2.new( 0, 0 )
			
		end
		
		if not Shirt and not TShirt then
			
			New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
			
			New.ImageLabel.Image = "rbxassetid://" .. ( GetNormShirt( ) or GetNormPants( ) or GetNormTShirt( ) or "" )
			
		end
		
		New:WaitForChild( "Title" ).Text = Keys[ a ] or "None"
		
		New.Visible = true
		
		New.MouseButton1Click:Connect( function ( )
			
			if Keys[ a ] == false then
				
				if ScrFr:FindFirstChild( tostring( Selected ) ) then
					
					ScrFr:FindFirstChild( tostring( Selected ) ).BorderSizePixel = 0
					
				end
				
				if ScrFr:FindFirstChild( tostring( SelectedTShirt ) ) then
					
					ScrFr:FindFirstChild( tostring( SelectedTShirt ) ).BorderSizePixel = 0
					
				end
				
				if Selected == false and SelectedTShirt == false then
					
					Selected, SelectedTShirt = nil, nil
					
					ScrFr:FindFirstChild( "false" ).BorderSizePixel = 0
					
				else
					
					Selected, SelectedTShirt = false, false
					
					ScrFr:FindFirstChild( "false" ).BorderSizePixel = 5
					
				end
				
			else
				
				if Shirt then
					
					if ScrFr:FindFirstChild( tostring( Selected ) ) then
						
						ScrFr:FindFirstChild( tostring( Selected ) ).BorderSizePixel = 0
						
					end
					
					Selected = Selected ~= Keys[ a ] and Keys[ a ] or false
					
					if Selected == false then
						
						ScrFr:FindFirstChild( "false" ).BorderSizePixel = 5
						
					end
					
					New.BorderSizePixel = Selected == Keys[ a ] and 5
					
				end
				
				if TShirt then
					
					if ScrFr:FindFirstChild( tostring( SelectedTShirt ) ) then
						
						ScrFr:FindFirstChild( tostring( SelectedTShirt ) ).BorderSizePixel = 0
						
					end
					
					SelectedTShirt = SelectedTShirt ~= Keys[ a ] and Keys[ a ] or false
					
					if SelectedTShirt == false then
						
						ScrFr:FindFirstChild( "false" ).BorderSizePixel = 5
						
					end
					
					New.BorderSizePixel = SelectedTShirt == Keys[ a ] and 5
					
				end
				
			end
			
			local ShirtUni, TShirtUni = Unis[ Selected ] or { }, Unis[ SelectedTShirt ] or { }
			
			ChangeUni:FireServer( Selected, SelectedTShirt, { ShirtUni[ 1 ], ShirtUni[ 2 ], TShirtUni[ 3 ] } )
			
			PopulateScroll( )
			
		end )
		
	end
	
	for a = 1, #Buttons do
		
		Buttons[ a ].Parent = ScrFr
		
	end
	
	Buttons = nil
	
end

local Visible

Gui.Position = UDim2.new( 1, 0, 0.2, 0 )

Gui.Search.PlaceholderText = "Search.."

Gui.Search.Changed:Connect( function ( Prop )
	
	if Prop == "Text" then PopulateScroll( ) end
	
end )

local Populated

if Gui:FindFirstChild( "InOut" ) then
	
	Gui.InOut.Text = "<"

	Gui.InOut.MouseButton1Click:Connect( function ( )

		Visible = not Visible

		Gui.InOut.Text = Visible and ">" or "<"

		if not Populated then

			Populated = true

			PopulateScroll( )

		end

		Gui:TweenPosition( Visible and UDim2.new( 0.8, 0, 0.2, 0 ) or UDim2.new( 1, 0, 0.2, 0 ), nil, nil, .5, true )

	end )
	
else
	
	Visible = true
	
	if not Populated then
		
		Populated = true
		
		PopulateScroll( )
		
	end
	
end
