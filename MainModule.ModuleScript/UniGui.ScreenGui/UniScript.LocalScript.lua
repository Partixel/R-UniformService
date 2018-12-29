local ThemeUtil = require( game:GetService( "ReplicatedStorage" ):WaitForChild( "ThemeUtil" ) )

ThemeUtil.BindUpdate( script.Parent.Frame, "BackgroundColor3", "Background" )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, { "BackgroundColor3", "BorderColor3" }, { "SecondaryBackground", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "TextColor3", { "TextColor", "InvertedBackground" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, "PlaceholderColor3", { "SecondaryTextColor", "InvertedTextColor" } )

ThemeUtil.BindUpdate( script.Parent.Frame.ScrollingFrame, "ScrollBarImageColor3", "SecondaryBackground" )

local Players, TweenService = game:GetService( "Players" ), game:GetService( "TweenService" )

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

ScrFr.UIListLayout:GetPropertyChangedSignal( "AbsoluteContentSize" ):Connect( function ( )
	
	ScrFr.CanvasSize = UDim2.new( 0, 0, 0, ScrFr.UIListLayout.AbsoluteContentSize.Y )
	
end )

function GetButtonFromPath( Path, TShirt )
	
	if Path == nil then
		
		if TShirt then
			
			Path = DefaultTShirt or false
			
		else
			
			Path = DefaultUni or false
			
		end
		
	end
	
	return Path == false and ScrFr:FindFirstChild( "false" ) or ScrFr:FindFirstChild( Path[ 1 ] ) and ScrFr:FindFirstChild( Path[ 1 ] ):FindFirstChild( Path[ 2 ] )
	
end

function Redraw( )
	
	local Old = ScrFr:GetChildren( )
	
	for a = 1, #Old do
		
		if Old[ a ]:IsA( "Frame" ) or Old[ a ]:IsA( "TextButton" ) then Old[ a ]:Destroy( ) end
		
	end
	
	local Keys = GetMatchingKeys( Unis, Search.Text:lower( ) )
	
	local New = Base:Clone( )
	
	ThemeUtil.BindUpdate( New.Title, "TextColor3", { "TextColor", "InvertedBackground" } )
	
	ThemeUtil.BindUpdate( { New.Title, New.Bkg }, "BackgroundColor3", "SecondaryBackground" )
	
	ThemeUtil.BindUpdate( New.Title, "BorderColor3", "SecondaryBackground" )
	
	New.Name = "false"
	
	New.LayoutOrder = 0
	
	if ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) then
		
		New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingRight = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingTop = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingBottom = UDim.new( 0, 5 )
		
		New.Size = UDim2.new( 1, 0, 0, 50 )
		
		ThemeUtil.BindUpdate( New, "BackgroundColor3", { ( Selected == false and SelectedTShirt == false ) and "SelectionColor" or "PositiveColor", "InvertedBackground" } )
		
	end
	
	New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
	
	New.ImageLabel.Image = "rbxassetid://" .. ( GetNormShirt( ) or GetNormPants( ) or GetNormTShirt( ) or "" )
	
	New.Title.Text = "None"
	
	New.Visible = true
	
	New.MouseButton1Click:Connect( function ( )
		
		local UniButton, TShirtButton = GetButtonFromPath( Selected ), GetButtonFromPath( SelectedTShirt )
		
		if UniButton then
			
			UniButton.UIPadding.PaddingLeft = UDim.new( 0, 0 )
			
			UniButton.UIPadding.PaddingRight = UDim.new( 0, 0 )
			
			UniButton.UIPadding.PaddingTop = UDim.new( 0, 0 )
			
			UniButton.UIPadding.PaddingBottom = UDim.new( 0, 0 )
			
			UniButton.Size = UDim2.new( 1, 0, 0, 40 )
			
		end
		
		if TShirtButton then
			
			TShirtButton.UIPadding.PaddingLeft = UDim.new( 0, 0 )
			
			TShirtButton.UIPadding.PaddingRight = UDim.new( 0, 0 )
			
			TShirtButton.UIPadding.PaddingTop = UDim.new( 0, 0 )
			
			TShirtButton.UIPadding.PaddingBottom = UDim.new( 0, 0 )
			
			TShirtButton.Size = UDim2.new( 1, 0, 0, 40 )
			
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
		
		New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingRight = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingTop = UDim.new( 0, 5 )
		
		New.UIPadding.PaddingBottom = UDim.new( 0, 5 )
		
		New.Size = UDim2.new( 1, 0, 0, 50 )
		
		ThemeUtil.BindUpdate( New, "BackgroundColor3", { ( Selected == false and SelectedTShirt == false ) and "SelectionColor" or "PositiveColor", "InvertedBackground" } )
		
		ChangeUni:FireServer( Selected, SelectedTShirt, Sel )
		
	end )
	
	New.Parent = ScrFr
	
	for a = 1, #Keys do
		
		local Cat = Gui.Category:Clone( )
		
		ThemeUtil.BindUpdate( { Cat[ "-1" ].Bar, Cat[ "-1" ].OpenIndicator, Cat[ "-1" ].TitleText }, "BackgroundColor3", "SecondaryBackground" )
		
		ThemeUtil.BindUpdate( { Cat[ "-1" ].OpenIndicator, Cat[ "-1" ].TitleText }, "TextColor3", "TextColor" )
		
		Cat.Name = Keys[ a ].Name
		
		Cat.Visible = true
		
		Cat.LayoutOrder = a
		
		Cat[ "-1" ].OpenIndicator.Text = not Hide[ Keys[ a ].Name ] and  "Λ" or "V"
		
		Cat[ "-1" ].TitleText.Text = Keys[ a ].Name
		
		Cat[ "-1" ].MouseButton1Click:Connect( function ( )
			
			Hide[ Keys[ a ].Name ] = not Hide[ Keys[ a ].Name ]
			
			TweenService:Create( Cat, TweenInfo.new( 0.5, Enum.EasingStyle.Sine ), { Size = UDim2.new( 1, 0, 0, Hide[ Keys[ a ].Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y ) } ):Play( )
			
			Cat[ "-1" ].OpenIndicator.Text = not Hide[ Keys[ a ].Name ] and  "Λ" or "V"
			
		end )
		
		for b = 1, #Keys[ a ] do
			
			local Uni = Unis[ Keys[ a ].Name ][ Keys[ a ][ b ] ] or { }
			
			local Shirt, TShirt = Uni[ 1 ] ~= nil, Uni[ 3 ] ~= nil
			
			local New = Base:Clone( )
			
			ThemeUtil.BindUpdate( New.Title, "TextColor3", { "TextColor", "InvertedBackground" } )
			
			ThemeUtil.BindUpdate( { New.Title, New.Bkg }, "BackgroundColor3", "SecondaryBackground" )
			
			ThemeUtil.BindUpdate( New.Title, "BorderColor3", "SecondaryBackground" )
			
			New.Name = Keys[ a ][ b ]
			
			local Path = Keys[ a ].Name .. ": " .. Keys[ a ][ b ]
			
			if ( Selected and ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] .. ": " .. DefaultUni[ 2 ] ) or "false" ) == Path or ( SelectedTShirt and ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] .. ": " .. DefaultTShirt[ 2 ] ) or "false" ) == Path then
				
				New.UIPadding.PaddingLeft = UDim.new( 0, 5 )
				
				New.UIPadding.PaddingRight = UDim.new( 0, 5 )
				
				New.UIPadding.PaddingTop = UDim.new( 0, 5 )
				
				New.UIPadding.PaddingBottom = UDim.new( 0, 5 )
				
				New.Size = UDim2.new( 1, 0, 0, 50 )
				
			end
			
			ThemeUtil.BindUpdate( New, "BackgroundColor3", { ( ( Shirt and Selected == nil ) or ( TShirt and SelectedTShirt == nil ) ) and "PositiveColor" or "SelectionColor", "InvertedBackground" } )
			
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
			
			New.Title.Text = Keys[ a ][ b ]
			
			New.Visible = true
			
			New.MouseButton1Click:Connect( function ( )
				
				if Shirt then
					
					local Button = GetButtonFromPath( Selected )
					
					if Button then
						
						Button.UIPadding.PaddingLeft = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingTop = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingBottom = UDim.new( 0, 0 )
						
						Button.Size = UDim2.new( 1, 0, 0, 40 )
						
					end
					
					Selected = ( ( Selected and ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] .. ": " .. DefaultUni[ 2 ] ) or "false" ) ~= Path or Selected == nil ) and { Keys[ a ].Name, Keys[ a ][ b ] } or nil
					
					Button = GetButtonFromPath( Selected )
					
					if Button then
						
						if Button.Name == "false" then
							
							if ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) then
								
								Button.UIPadding.PaddingLeft = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingTop = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingBottom = UDim.new( 0, 5 )
								
								Button.Size = UDim2.new( 1, 0, 0, 50 )
								
								ThemeUtil.BindUpdate( Button, "BackgroundColor3", { ( Selected == false and SelectedTShirt == false ) and "SelectionColor" or "PositiveColor", "InvertedBackground" } )
								
							end
							
						else
							
							Button.UIPadding.PaddingLeft = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingTop = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingBottom = UDim.new( 0, 5 )
							
							Button.Size = UDim2.new( 1, 0, 0, 50 )
							
							ThemeUtil.BindUpdate( Button, "BackgroundColor3", { Selected == nil and "PositiveColor" or "SelectionColor", "InvertedBackground" } )
							
						end
						
					end
					
				elseif SelectedTShirt == false then
					
					SelectedTShirt = nil
					
				end
				
				if TShirt then
					
					local Button = GetButtonFromPath( Selected, true )
					
					if Button then
						
						Button.UIPadding.PaddingLeft = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingTop = UDim.new( 0, 0 )
						
						Button.UIPadding.PaddingBottom = UDim.new( 0, 0 )
						
						Button.Size = UDim2.new( 1, 0, 0, 40 )
						
					end
					
					SelectedTShirt = ( ( SelectedTShirt and ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] .. ": " .. DefaultTShirt[ 2 ] ) or "false" ) ~= Path or SelectedTShirt == nil ) and { Keys[ a ].Name, Keys[ a ][ b ] } or nil
					
					Button = GetButtonFromPath( Selected, true )
					
					if Button then
						
						if Button.Name == "false" then
							
							if not Shirt and ( ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) ) then
								
								Button.UIPadding.PaddingLeft = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingTop = UDim.new( 0, 5 )
								
								Button.UIPadding.PaddingBottom = UDim.new( 0, 5 )
								
								Button.Size = UDim2.new( 1, 0, 0, 50 )
								
								ThemeUtil.BindUpdate( Button, "BackgroundColor3", { ( Selected == false and SelectedTShirt == false ) and "SelectionColor" or "PositiveColor", "InvertedBackground" } )
								
							end
							
						else
							
							Button.UIPadding.PaddingLeft = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingTop = UDim.new( 0, 5 )
							
							Button.UIPadding.PaddingBottom = UDim.new( 0, 5 )
							
							Button.Size = UDim2.new( 1, 0, 0, 50 )
							
							ThemeUtil.BindUpdate( Button, "BackgroundColor3", { SelectedTShirt == nil and "PositiveColor" or "SelectionColor", "InvertedBackground" } )
							
						end
						
					end
					
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
				
			end )
			
			New.Parent = Cat
			
		end
		
		Cat.Size = UDim2.new( 1, 0, 0, Hide[ Keys[ a ].Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y )
		
		Cat.UIListLayout:GetPropertyChangedSignal( "AbsoluteContentSize" ):Connect( function ( )
			
			Cat.Size = UDim2.new( 1, 0, 0, Hide[ Keys[ a ].Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y )
			
		end )
		
		Cat.Parent = ScrFr
		
	end
	
end

Gui.Position = UDim2.new( 1, 0, 0.2, 0 )

Gui.Search.Changed:Connect( function ( Prop )
	
	if Prop == "Text" then Redraw( ) end
	
end )

if Gui:FindFirstChild( "InOut" ) then
	
	local Populated, Visible
	
	ThemeUtil.BindUpdate( script.Parent.Frame.InOut, "BackgroundColor3", "Background" )
	
	ThemeUtil.BindUpdate( script.Parent.Frame.InOut, "TextColor3", { "TextColor", "InvertedBackground" } )
	
	Gui.InOut.Text = "<"

	Gui.InOut.MouseButton1Click:Connect( function ( )

		Visible = not Visible

		Gui.InOut.Text = Visible and ">" or "<"

		if not Populated then

			Populated = true

			Redraw( )

		end
		
		TweenService:Create( Gui, TweenInfo.new( 0.5 ), { Position = Visible and UDim2.new( 0.8, 0, 0.2, 0 ) or UDim2.new( 1, 0, 0.2, 0 ) } ):Play( )

	end )
	
else
	
	Redraw( )
	
end
