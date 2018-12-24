local ThemeUtil = require( game:GetService( "ReplicatedStorage" ):WaitForChild( "ThemeUtil" ) )

ThemeUtil.BindUpdate( script.Parent.Frame, "BackgroundColor3", "Background" )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, { "BackgroundColor3", "BorderColor3" }, { "SecondaryBackground", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "TextColor3", { "TextColor", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "PlaceholderColor3", { "SecondaryTextColor", "InvertedTextColor" } )

ThemeUtil.BindUpdate( script.Parent.Frame.ScrollingFrame, "ScrollBarImageColor3", "SecondaryBackground" )

local Players = game:GetService( "Players" )

local Plr = Players.LocalPlayer

local UserId = Plr.UserId < 0 and 16015142 or Plr.UserId

local Unis, Selected, SelectedTShirt = game:GetService( "ReplicatedStorage" ):WaitForChild( "GetUni" ):InvokeServer( )

local ChangeUni = game:GetService( "ReplicatedStorage" ):WaitForChild( "ChangeUni" )

local Gui = script.Parent:WaitForChild( "Frame" )

local Search, Base, ScrFr = Gui:WaitForChild( "Search" ), Gui:WaitForChild( "Base" ), Gui:WaitForChild( "ScrollingFrame" )

local Hide = { }

for a, b in pairs( Unis ) do
	
	if ( not Selected or Selected[ 1 ] ~= a ) and ( not SelectedTShirt or SelectedTShirt[ 1 ] ~= a ) then
		
		Hide[ a ] = true
		
	end
	
end

function GetMatchingKeys( T, Str )
	
	local Tmp = { }
	
	for a, b in pairs( T ) do
		
		local Category
		
		for c, d in pairs( b ) do
			
			local Name = ( a .. " " .. c ):lower( )
			
			if Name:find( Str ) then
				
				if not Category then
					
					Category = { Name = a }
					
					Tmp[ #Tmp + 1 ] = Category
					
				end
				
				Category[ #Category + 1 ] = c
				
			end
			
		end
		
	end
	
	table.sort( Tmp, function( a, b )
		
		return a.Name < b.Name
		
	end )
	
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
	
	local Buttons = ScrFr:GetChildren( )
	
	for a = 1, #Buttons do
		
		if Buttons[ a ]:IsA( "TextButton" ) then
			
			Buttons[ a ]:Destroy( )
			
		end
		
	end
	
	local Keys = GetMatchingKeys( Unis, Search.Text:lower( ) )
	
	local Cur = 2
	
	for a = 1, #Keys do
		
		Cur = Cur + 1
		
		local Cat = Gui.Category:Clone( )
		
		ThemeUtil.BindUpdate( { Cat, Cat.Bar, Cat.OpenIndicator, Cat.TitleText }, "BackgroundColor3", "SecondaryBackground" )
		
		ThemeUtil.BindUpdate( { Cat, Cat.OpenIndicator, Cat.TitleText }, "TextColor3", "TextColor" )
		
		Cat.Visible = true
		
		Cat.LayoutOrder = Cur
		
		Cat.OpenIndicator.Text = not Hide[ Keys[ a ].Name ] and  "Λ" or "V"
		
		Cat.TitleText.Text = Keys[ a ].Name
		
		Cat.MouseButton1Click:Connect( function ( )
			
			Hide[ Keys[ a ].Name ] = not Hide[ Keys[ a ].Name ]
			
			PopulateScroll( )
			
		end )
		
		Cat.Parent = ScrFr
		
		if not Hide[ Keys[ a ].Name ] then
			
			for b = 1, #Keys[ a ] do
				
				Cur = Cur + 1
				
				local Uni = Unis[ Keys[ a ].Name ][ Keys[ a ][ b ] ] or { }
				
				local Shirt, TShirt = Uni[ 1 ] ~= nil, Uni[ 3 ] ~= nil
				
				local New = Base:Clone( )
				
				ThemeUtil.BindUpdate( New, "BackgroundColor3", { "SelectionColor", "InvertedBackground" } )
				
				ThemeUtil.BindUpdate( New.Title, "TextColor3", { "TextColor", "InvertedBackground" } )
				
				ThemeUtil.BindUpdate( { New.Title, New.Bkg }, "BackgroundColor3", "SecondaryBackground" )
				
				ThemeUtil.BindUpdate( New.Title, "BorderColor3", "SecondaryBackground" )
				
				New.Name = Keys[ a ].Name .. ": " .. Keys[ a ][ b ]
				
				New.LayoutOrder = Cur
				
				if ( Selected and Selected[ 1 ] == Keys[ a ].Name and Selected[ 2 ] == Keys[ a ][ b ] ) or ( SelectedTShirt and SelectedTShirt and SelectedTShirt[ 1 ] == Keys[ a ].Name and SelectedTShirt[ 2 ] == Keys[ a ][ b ] ) then
					
					New.BackgroundTransparency = 0
					
					New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
					
					New.UIPadding.PaddingRight = UDim.new( 0, 5 )
					
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
				
				New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
				
				New:WaitForChild( "Title" ).Text = Keys[ a ][ b ]
				
				New.Visible = true
				
				New.MouseButton1Click:Connect( function ( )
					
					if Shirt then
						
						if Selected and ScrFr:FindFirstChild( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) then
							
							ScrFr:FindFirstChild( Selected[ 1 ] .. ": " .. Selected[ 2 ] ).BackgroundTransparency = 1
							
						end
						
						Selected = ( not Selected or ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) ~= New.Name ) and { Keys[ a ].Name, Keys[ a ][ b ] } or false
						
						New.BackgroundTransparency = Selected == Keys[ a ] and 0 or 1
						
					end
					
					if TShirt then
						
						if SelectedTShirt and ScrFr:FindFirstChild( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) then
							
							ScrFr:FindFirstChild( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ).BackgroundTransparency = 1
							
						end
						
						SelectedTShirt = ( not SelectedTShirt or ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) ~= New.Name ) and { Keys[ a ].Name, Keys[ a ][ b ] } or false
						
						New.BackgroundTransparency = SelectedTShirt == Keys[ a ] and 0 or 1
						
					end
					
					local ShirtUni, TShirtUni = Selected and Unis[ Selected[ 1 ] ][ Selected[ 2 ] ] or { }, SelectedTShirt and Unis[ SelectedTShirt[ 1 ] ][ SelectedTShirt[ 2 ] ] or { }
					
					ChangeUni:FireServer( Selected, SelectedTShirt, { ShirtUni[ 1 ], ShirtUni[ 2 ], TShirtUni[ 3 ] } )
					
					PopulateScroll( )
					
				end )
				
				New.Parent = ScrFr
				
			end
			
		end
		
	end
	
	ScrFr.CanvasSize = UDim2.new( 0, 0, 0, ScrFr.UIListLayout.AbsoluteContentSize.Y )
	
end

local Visible

Gui.Position = UDim2.new( 1, 0, 0.2, 0 )

Gui.Search.Changed:Connect( function ( Prop )
	
	if Prop == "Text" then PopulateScroll( ) end
	
end )

local Populated

if Gui:FindFirstChild( "InOut" ) then
	
	ThemeUtil.BindUpdate( script.Parent.Frame.InOut, "BackgroundColor3", "Background" )
	
	ThemeUtil.BindUpdate( script.Parent.Frame.InOut, "TextColor3", { "TextColor", "InvertedBackground" } )
	
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
