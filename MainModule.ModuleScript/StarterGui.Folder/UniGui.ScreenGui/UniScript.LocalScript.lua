local ThemeUtil = require( game:GetService( "ReplicatedStorage" ):WaitForChild( "ThemeUtil" ):WaitForChild( "ThemeUtil" ) )

while not script.Help.Value do script.Help:GetPropertyChangedSignal( "Value" ):Wait( ) end

ThemeUtil.BindUpdate( { script.Parent.Frame, script.Help.Value }, { BackgroundColor3 = "Primary_BackgroundColor", BackgroundTransparency = "Primary_BackgroundTransparency" } )

ThemeUtil.BindUpdate( script.Parent.Frame.Search, { [ { "BackgroundColor3", "BorderColor3" } ] = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency", PlaceholderColor3 = "Secondary_TextColor" } )

ThemeUtil.BindUpdate( { script.Parent.Frame.Refresh, script.Parent.Frame.Help, script.Help.Value.Close }, { [ { "BackgroundColor3", "BorderColor3" } ] = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency" } )

ThemeUtil.BindUpdate( { script.Help.Value.MainText, script.Help.Value.Title }, { TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency" } )

ThemeUtil.BindUpdate( script.Parent.Frame.ScrollingFrame, { ScrollBarImageColor3 = "Secondary_BackgroundColor", ScrollBarImageTransparency = "Secondary_BackgroundTransparency" } )

local Players, TweenService = game:GetService( "Players" ), game:GetService( "TweenService" )

local Plr = Players.LocalPlayer

local UserId = Plr.UserId < 0 and 16015142 or Plr.UserId

local Unis, DefaultUni, DefaultTShirt, Selected, SelectedTShirt = game:GetService( "ReplicatedStorage" ):WaitForChild( "Uniformed" ):WaitForChild( "GetUni" ):InvokeServer( )

local ChangeUni = game:GetService( "ReplicatedStorage" ):WaitForChild( "Uniformed" ):WaitForChild( "ChangeUni" )

local Gui = script.Parent:WaitForChild( "Frame" )

local Search, ScrFr = Gui:WaitForChild( "Search" ), Gui:WaitForChild( "ScrollingFrame" )

local Hide = { }

local SelectedGroup, SelectedTShirtGroup = Selected and Selected[ 1 ] or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] ) or nil, SelectedTShirt and SelectedTShirt[ 1 ] or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] ) or nil

for a, b in pairs( Unis ) do
	
	if ( Selected == false or SelectedGroup ~= a ) and ( SelectedTShirt == false or SelectedTShirtGroup ~= a ) then
		
		Hide[ a ] = true
		
	end
	
end

if SelectedGroup then
	
	local Par = Unis[ SelectedGroup ].DivisionOf
	
	while Par do
		
		Hide[ Par ] = nil
		
		Par = Unis[ Par ].DivisionOf
		
	end
	
end

if SelectedTShirtGroup then
	
	local Par = Unis[ SelectedTShirtGroup ].DivisionOf
	
	while Par do
		
		Hide[ Par ] = nil
		
		Par = Unis[ Par ].DivisionOf
		
	end
	
end

function GetMatchingKeys( T, Str )
	
	local Tmp = { }
	
	for a, b in pairs( T ) do
		
		local Category
		
		local CatName = a
		
		local Par = b.DivisionOf
		
		while Par do
			
			CatName = Par .. "  " .. CatName
			
			Par = Unis[ Par ].DivisionOf
			
		end
		
		for c, d in pairs( b ) do
			
			if type( d ) == "table" then
				
				local Name = ( CatName .. " " .. c ):lower( )
				
				if Name:find( Str ) then
					
					if not Category then
						
						Category = { Name = a }
						
						Tmp[ #Tmp + 1 ] = Category
						
					end
					
					Category[ #Category + 1 ] = c
					
				end
				
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

local Cats

function GetButtonFromPath( Path, TShirt )
	
	if Path == nil then
		
		if TShirt then
			
			Path = DefaultTShirt or false
			
		else
			
			Path = DefaultUni or false
			
		end
		
	end
	
	return Path == false and ScrFr:FindFirstChild( "false" ) or Cats[ Path[ 1 ] ] and Cats[ Path[ 1 ] ]:FindFirstChild( Path[ 2 ] )
	
end

local EscapePatterns = {
	
	[ "(" ] = "%(",
		
	[ ")" ] = "%)",
	
	[ "." ] = "%.",
	
	[ "%" ] = "%%",
	
	[ "+" ] = "%+",
	
	[ "-" ] = "%-",
	
	[ "*" ] = "%*",
	
	[ "?" ] = "%?",
	
	[ "[" ] = "%[",
	
	[ "]" ] = "%]",
	
	[ "^" ] = "%^",
	
	[ "$" ] = "%$",
	
	[ "\0" ] = "%z"
	
	
}

function Redraw( )
	
	for _, Obj in ipairs( ScrFr:GetChildren( ) ) do
		
		if Obj:IsA( "Frame" ) or Obj:IsA( "TextButton" ) then Obj:Destroy( ) end
		
	end
	
	local Keys = GetMatchingKeys( Unis, Search.Text:lower( ):gsub( ".", EscapePatterns ) )
	
	Cats = { }
	
	local New = script.Base:Clone( )
	
	ThemeUtil.BindUpdate( New.Title, { TextColor3 = "Primary_TextColor", BorderColor3 = "Secondary_BackgroundColor", BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
	
	ThemeUtil.BindUpdate( { New.BottomSel, New.RightSel, New.TopSel }, { BackgroundTransparency = "Secondary_BackgroundTransparency" } )
	
	New.Name = "false"
	
	New.LayoutOrder = 0
	
	if ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) then
		
		New.UIPadding.PaddingRight = UDim.new( 0, 5 )
		
		New.TopSel.Visible = true
		
		New.BottomSel.Visible = true
		
		New.RightSel.Visible = true
		
		ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( Selected == false and SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
		
	end
	
	New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
	
	New.ImageLabel.Image = "rbxassetid://" .. ( GetNormShirt( ) or GetNormPants( ) or GetNormTShirt( ) or "" )
	
	New.Title.Text = "None"
	
	New.Visible = true
	
	New.MouseButton1Click:Connect( function ( )
		
		local UniButton, TShirtButton = GetButtonFromPath( Selected ), GetButtonFromPath( SelectedTShirt )
		
		if UniButton then
			
			UniButton.UIPadding.PaddingRight = UDim.new( 0, 0 )
			
			UniButton.TopSel.Visible = false
			
			UniButton.BottomSel.Visible = false
			
			UniButton.RightSel.Visible = false
			
		end
		
		if TShirtButton then
			
			TShirtButton.UIPadding.PaddingRight = UDim.new( 0, 0 )
			
			TShirtButton.TopSel.Visible = false
			
			TShirtButton.BottomSel.Visible = false
			
			TShirtButton.RightSel.Visible = false
			
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
		
		New.UIPadding.PaddingRight = UDim.new( 0, 5 )
		
		New.TopSel.Visible = true
		
		New.BottomSel.Visible = true
		
		New.RightSel.Visible = true
		
		ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( Selected == false and SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
		
		ChangeUni:FireServer( Selected, SelectedTShirt, Sel )
		
	end )
	
	New.Parent = ScrFr
	
	local Divisions = { }
	
	for a, Key in ipairs( Keys ) do
		
		local Cat = script.Category:Clone( )
		
		ThemeUtil.BindUpdate( { Cat[ "-1" ].OpenIndicator, Cat[ "-1" ].TitleText }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency" } )
		
		ThemeUtil.BindUpdate( { Cat[ "-1" ].BarL, Cat[ "-1" ].BarR, Cat[ "-1" ].BarR2 }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
		
		Cats[ Key.Name ] = Cat
		
		Cat.Name = Key.Name
		
		Cat.Visible = true
		
		Cat[ "-1" ].OpenIndicator.Text = not Hide[ Key.Name ] and  "Λ" or "V"
		
		Cat[ "-1" ].TitleText.Text = Key.Name
		
		Cat[ "-1" ].MouseButton1Click:Connect( function ( )
			
			Hide[ Key.Name ] = not Hide[ Key.Name ]
			
			TweenService:Create( Cat, TweenInfo.new( 0.5, Enum.EasingStyle.Sine ), { Size = UDim2.new( 1, 0, 0, Hide[ Key.Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y ) } ):Play( )
			
			Cat[ "-1" ].OpenIndicator.Text = not Hide[ Key.Name ] and  "Λ" or "V"
			
		end )
		
		for _, Name in ipairs( Key ) do
			
			local Uni = Unis[ Key.Name ][ Name ] or { }
			
			local Shirt, TShirt = Uni[ 1 ] ~= nil, Uni[ 3 ] ~= nil
			
			local New = script.Base:Clone( )
			
			ThemeUtil.BindUpdate( New.Title, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency", BorderColor3 = "Secondary_BackgroundColor" } )
			
			ThemeUtil.BindUpdate( { New.BottomSel, New.RightSel, New.TopSel }, { BackgroundTransparency = "Secondary_BackgroundTransparency" } )
			
			New.Name = Name
			
			local Path = Key.Name .. ": " .. Name
			
			if ( Selected and ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] .. ": " .. DefaultUni[ 2 ] ) or "false" ) == Path or ( SelectedTShirt and ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] .. ": " .. DefaultTShirt[ 2 ] ) or "false" ) == Path then
				
				New.UIPadding.PaddingRight = UDim.new( 0, 5 )
				
				New.TopSel.Visible = true
				
				New.BottomSel.Visible = true
				
				New.RightSel.Visible = true
				
			end
			
			ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( ( Shirt and Selected == nil ) or ( TShirt and SelectedTShirt == nil ) ) and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
			
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
			
			New.Title.Text = Name
			
			New.Visible = true
			
			New.MouseButton1Click:Connect( function ( )
				
				if Shirt then
					
					local Button = GetButtonFromPath( Selected )
					
					if Button then
						
						Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
						
						Button.TopSel.Visible = false
						
						Button.BottomSel.Visible = false
						
						Button.RightSel.Visible = false
						
					end
					
					Selected = ( ( Selected and ( Selected[ 1 ] .. ": " .. Selected[ 2 ] ) or Selected == nil and ( DefaultUni and DefaultUni[ 1 ] .. ": " .. DefaultUni[ 2 ] ) or "false" ) ~= Path or Selected == nil ) and { Key.Name, Name } or nil
					
					Button = GetButtonFromPath( Selected )
					
					if Button then
						
						if Button.Name == "false" then
							
							if ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) then
								
								Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
								
								Button.TopSel.Visible = true
								
								Button.BottomSel.Visible = true
								
								Button.RightSel.Visible = true
								
								ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = ( Selected == false and SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
								
							end
							
						else
							
							Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
							
							Button.TopSel.Visible = true
							
							Button.BottomSel.Visible = true
							
							Button.RightSel.Visible = true
							
							ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = Selected == nil and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
							
						end
						
					end
					
				elseif SelectedTShirt == false then
					
					SelectedTShirt = nil
					
				end
				
				if TShirt then
					
					local Button = GetButtonFromPath( Selected, true )
					
					if Button then
						
						Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
						
						Button.TopSel.Visible = false
						
						Button.BottomSel.Visible = false
						
						Button.RightSel.Visible = false
						
					end
					
					SelectedTShirt = ( ( SelectedTShirt and ( SelectedTShirt[ 1 ] .. ": " .. SelectedTShirt[ 2 ] ) or SelectedTShirt == nil and ( DefaultTShirt and DefaultTShirt[ 1 ] .. ": " .. DefaultTShirt[ 2 ] ) or "false" ) ~= Path or SelectedTShirt == nil ) and { Key.Name, Name } or nil
					
					Button = GetButtonFromPath( Selected, true )
					
					if Button then
						
						if Button.Name == "false" then
							
							if not Shirt and ( ( Selected == false and SelectedTShirt == false ) or ( Selected == nil and DefaultUni == nil and SelectedTShirt == nil and DefaultTShirt == nil ) ) then
								
								Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
								
								Button.TopSel.Visible = true
								
								Button.BottomSel.Visible = true
								
								Button.RightSel.Visible = true
								
								ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = ( Selected == false and SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
								
							end
							
						else
							
							Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
							
							Button.TopSel.Visible = true
							
							Button.BottomSel.Visible = true
							
							Button.RightSel.Visible = true
							
							ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = SelectedTShirt == nil and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
							
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
		
		Cat.Size = UDim2.new( 1, 0, 0, Hide[ Key.Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y )
		
		Cat.UIListLayout:GetPropertyChangedSignal( "AbsoluteContentSize" ):Connect( function ( )
			
			Cat.Size = UDim2.new( 1, 0, 0, Hide[ Key.Name ] and Cat[ "-1" ].Size.Y.Offset or Cat.UIListLayout.AbsoluteContentSize.Y )
			
		end )
		
		local FoundDiv
		
		if Unis[ Key.Name ].DivisionOf then
			
			for _, Key2 in ipairs( Keys ) do
				
				if Key2.Name == Unis[ Key.Name ].DivisionOf then
					
					Divisions[ Cat ] = Unis[ Key.Name ].DivisionOf
					
					FoundDiv = true
					
					break
					
				end
				
			end
			
		end
		
		if not FoundDiv then
			
			Cat.LayoutOrder = a
			
			Cat.Parent = ScrFr
			
		end
		
	end
	
	for a, b in pairs( Divisions ) do
		
		a.Parent = ScrFr:FindFirstChild( b )
		
	end
	
end

Gui.Position = UDim2.new( 1, 0, 0.2, 0 )

Gui.Search.Changed:Connect( function ( Prop )
	
	if Prop == "Text" then Redraw( ) end
	
end )

local Debounce

Gui.Refresh.MouseButton1Click:Connect( function ( )
	
	if Debounce then return end
	
	Debounce = true
	
	ThemeUtil.BindUpdate( script.Parent.Frame.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Positive_Color3" } )
	
	script.Parent.Frame.Refresh.AutoButtonColor = false
	
	Unis, DefaultUni, DefaultTShirt, Selected, SelectedTShirt = game:GetService( "ReplicatedStorage" ):WaitForChild( "Uniformed" ):WaitForChild( "GetUni" ):InvokeServer( )
	
	Redraw( )
	
	ThemeUtil.BindUpdate( script.Parent.Frame.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Negative_Color3" } )
	
	wait( 5 )
	
	script.Parent.Frame.Refresh.AutoButtonColor = true
	
	ThemeUtil.BindUpdate( script.Parent.Frame.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Secondary_BackgroundColor" } )
	
	Debounce = nil
	
end )

local HelpOpen

local function ToggleHelp( )
	
	if not HelpOpen then
		
		script.Help.Value.Position = UDim2.new( 0, script.Parent.Frame.Help.AbsolutePosition.X, 0, script.Parent.Frame.Help.AbsolutePosition.Y )
		
		script.Help.Value.Size = UDim2.new( 0, script.Parent.Frame.Help.AbsoluteSize.X, 0, script.Parent.Frame.Help.AbsoluteSize.Y )
		
		script.Help.Value.AnchorPoint = Vector2.new( 0, 0 )
		
		script.Help.Value.Visible = true
		
	end
	
	HelpOpen = not HelpOpen
	
	ThemeUtil.BindUpdate( script.Parent.Frame.Help, { BackgroundColor3 = HelpOpen and "Selection_Color3" or "Secondary_BackgroundColor" } )
	
	local Tween = TweenService:Create( script.Help.Value, TweenInfo.new( 0.5 ), { Position = HelpOpen and UDim2.new( 0.5, 0, 0.5, 0 ) or UDim2.new( 0, script.Parent.Frame.Help.AbsolutePosition.X, 0, script.Parent.Frame.Help.AbsolutePosition.Y ), AnchorPoint = HelpOpen and Vector2.new( 0.5, 0.5 ) or Vector2.new( 0, 0 ), Size = HelpOpen and UDim2.new( 0.4, 0, 0.4, 0 ) or UDim2.new( 0, script.Parent.Frame.Help.AbsoluteSize.X, 0, script.Parent.Frame.Help.AbsoluteSize.Y ) } )
	
	if not HelpOpen then
		
		Tween.Completed:Connect( function ( State )
			
			if State == Enum.PlaybackState.Completed then
				
				script.Help.Value.Visible = false
				
			end
			
		end )
		
	end
	
	Tween:Play( )
	
end

script.Help.Value.Close.MouseButton1Click:Connect( function ( )
	
	if HelpOpen then
		
		ToggleHelp( )
				
	end
	
end )

Gui.Help.MouseButton1Click:Connect( ToggleHelp )

if Gui:FindFirstChild( "InOut" ) then
	
	local Populated, Visible
	
	local function HandleTransparency( Obj, Transparency )
		
		Obj.BackgroundTransparency = Transparency
		
		if Transparency > 0.9 then
			
			ThemeUtil.BindUpdate( Obj, { TextColor3 = Visible and "Selection_Color3" or "Primary_BackgroundColor" } )
			
			Obj.TextStrokeTransparency = 0
			
		else
			
			ThemeUtil.BindUpdate( Obj, { TextColor3 = "Primary_TextColor" } )
			
			Obj.TextStrokeTransparency = 1
			
		end
		
	end
	
	ThemeUtil.BindUpdate( script.Parent.Frame.InOut, { TextTransparency = "Primary_TextTransparency", TextStrokeColor3 = "Primary_TextColor", Primary_BackgroundTransparency = HandleTransparency, BackgroundColor3 = Visible and "Selection_Color3" or "Primary_BackgroundColor" } )

	Gui.InOut.MouseButton1Click:Connect( function ( )

		Visible = not Visible
		
		ThemeUtil.BindUpdate( script.Parent.Frame.InOut, { BackgroundColor3 = Visible and "Selection_Color3" or "Primary_BackgroundColor" } )

		if not Populated then

			Populated = true

			Redraw( )

		end
		
		TweenService:Create( Gui, TweenInfo.new( 0.5 ), { Position = Visible and UDim2.new( 0.8, 0, 0.2, 0 ) or UDim2.new( 1, 0, 0.2, 0 ) } ):Play( )

	end )
	
else
	
	Redraw( )
	
end