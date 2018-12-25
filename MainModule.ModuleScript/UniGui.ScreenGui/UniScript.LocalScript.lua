local ThemeUtil = require( game:GetService( "ReplicatedStorage" ):WaitForChild( "ThemeUtil" ) )

ThemeUtil.BindUpdate( script.Parent.Frame, "BackgroundColor3", "Background" )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, { "BackgroundColor3", "BorderColor3" }, { "SecondaryBackground", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "TextColor3", { "TextColor", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "PlaceholderColor3", { "SecondaryTextColor", "InvertedTextColor" } )

ThemeUtil.BindUpdate( script.Parent.Frame.ScrollingFrame, "ScrollBarImageColor3", "SecondaryBackground" )

local Players = game:GetService( "Players" )

local Plr = Players.LocalPlayer

local UserId = Plr.UserId < 0 and 16015142 or Plr.UserId

local Unis, DefaultUni, DefaultTShirt, Selected, SelectedTShirt = game:GetService( "ReplicatedStorage" ):WaitForChild( "GetUni" ):InvokeServer( )

local ChangeUni = game:GetService( "ReplicatedStorage" ):WaitForChild( "ChangeUni" )

local Gui = script.Parent:WaitForChild( "Frame" )

local Search, Base, ScrFr = Gui:WaitForChild( "Search" ), Gui:WaitForChild( "Base" ), Gui:WaitForChild( "ScrollingFrame" )

local Hide = { }

local SelectedGroup, SelectedTShirtGroup = Selected and Selected[ 1 ] or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] ) or nil, SelectedTShirt and SelectedTShirt[ 1 ] or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] ) or nil


for a, b in pairs( Unis ) do
	
	if ( Selected == false or SelectedGroup ~= a ) and ( SelectedTShirt == false or SelectedTShirtGroup ~= a ) then
		
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
	
	local SelectedName, SelectedTShirtName = Selected and ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] .. ": " .. DefaultUni[ 2 ] ) or "false", SelectedTShirt and ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] .. ": " .. DefaultTShirt[ 2 ] ) or "false"
	
	local Keys = GetMatchingKeys( Unis, Search.Text:lower( ) )
	
	local New = Base:Clone( )
	
	ThemeUtil.BindUpdate( New, "BackgroundColor3", { "SelectionColor", "InvertedBackground" } )
	
	ThemeUtil.BindUpdate( New.Title, "TextColor3", { "TextColor", "InvertedBackground" } )
	
	ThemeUtil.BindUpdate( { New.Title, New.Bkg }, "BackgroundColor3", "SecondaryBackground" )
	
	ThemeUtil.BindUpdate( New.Title, "BorderColor3", "SecondaryBackground" )
	
	New.Name = "false"
	
	New.LayoutOrder = 1
	
	if Selected == false and SelectedTShirt == false then
		
		New.BackgroundTransparency = 0
		
		New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingRight = UDim.new( 0, 5 )
		
	end
	
	New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
	
	New.ImageLabel.Image = "rbxassetid://" .. ( GetNormShirt( ) or GetNormPants( ) or GetNormTShirt( ) or "" )
	
	New:WaitForChild( "Title" ).Text = "None"
	
	New.Visible = true
	
	New.MouseButton1Click:Connect( function ( )
		
		if ScrFr:FindFirstChild( SelectedName ) then
			
			ScrFr:FindFirstChild( SelectedName ).BackgroundTransparency = 1
			
		end
		
		if ScrFr:FindFirstChild( SelectedTShirtName ) then
			
			ScrFr:FindFirstChild( SelectedTShirtName ).BackgroundTransparency = 1
			
		end
		
		local Sel = { }
		
		if Selected == false and SelectedTShirt == false then
			
			Selected = nil
			
			SelectedTShirt = nil
			
			if DefaultUni then
				
				Sel[ 1 ] = Unis[ DefaultUni[ 1 ] ][ DefaultUni[ 2 ] ][ 1 ]
				
				Sel[ 2 ] = Unis[ DefaultUni[ 1 ] ][ DefaultUni[ 2 ] ][ 2 ]
				
			end
			
			if DefaultTShirt then
				
				Sel[ 3 ] = Unis[ DefaultTShirt[ 1 ] ][ DefaultTShirt[ 2 ] ][ 3 ]
				
			end
			
		else
			
			Selected = false
			
			SelectedTShirt = false
			
		end
		
		ChangeUni:FireServer( Selected, SelectedTShirt, Sel )
		
		PopulateScroll( )
		
	end )
	
	New.Parent = ScrFr
	
	local Cur = 1
	
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
				
				ThemeUtil.BindUpdate( New.Title, "TextColor3", { "TextColor", "InvertedBackground" } )
				
				ThemeUtil.BindUpdate( { New.Title, New.Bkg }, "BackgroundColor3", "SecondaryBackground" )
				
				ThemeUtil.BindUpdate( New.Title, "BorderColor3", "SecondaryBackground" )
				
				New.Name = Keys[ a ].Name .. ": " .. Keys[ a ][ b ]
				
				New.LayoutOrder = Cur
				
				if SelectedName == New.Name or SelectedTShirtName == New.Name then
					
					New.BackgroundTransparency = 0
					
					New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
					
					New.UIPadding.PaddingRight = UDim.new( 0, 5 )
					
				end
				
				if ( Shirt and Selected == nil ) or ( TShirt and SelectedTShirt == nil ) then
					
					ThemeUtil.BindUpdate( New, "BackgroundColor3", { "PositiveColor", "InvertedBackground" } )
					
				else
					
					ThemeUtil.BindUpdate( New, "BackgroundColor3", { "SelectionColor", "InvertedBackground" } )
					
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
						
						Selected = ( SelectedName ~= New.Name or Selected == nil ) and { Keys[ a ].Name, Keys[ a ][ b ] } or nil
						
					elseif SelectedTShirt == false then
						
						SelectedTShirt = nil
						
					end
					
					if TShirt then
						
						SelectedTShirt = ( SelectedTShirtName ~= New.Name or SelectedTShirt == nil ) and { Keys[ a ].Name, Keys[ a ][ b ] } or nil
						
					elseif SelectedTShirt == false then
						
						SelectedTShirt = nil
						
					end
					
					local Sel = { }
					
					if Selected then
						
						Sel[ 1 ] = Unis[ Selected[ 1 ] ][ Selected[ 2 ] ][ 1 ]
						
						Sel[ 2 ] = Unis[ Selected[ 1 ] ][ Selected[ 2 ] ][ 2 ]
						
					elseif DefaultUni then
						
						Hide[ DefaultUni[ 1 ] ] = nil
						
						Sel[ 1 ] = Unis[ DefaultUni[ 1 ] ][ DefaultUni[ 2 ] ][ 1 ]
						
						Sel[ 2 ] = Unis[ DefaultUni[ 1 ] ][ DefaultUni[ 2 ] ][ 2 ]
						
					end
					
					if SelectedTShirt then
						
						Sel[ 3 ] = Unis[ SelectedTShirt[ 1 ] ][ SelectedTShirt[ 2 ] ][ 3 ]
						
					elseif DefaultTShirt then
						
						Hide[ DefaultTShirt[ 1 ] ] = nil
						
						Sel[ 3 ] = Unis[ DefaultTShirt[ 1 ] ][ DefaultTShirt[ 2 ] ][ 3 ]
						
					end
					
					ChangeUni:FireServer( Selected, SelectedTShirt, Sel )
					
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
