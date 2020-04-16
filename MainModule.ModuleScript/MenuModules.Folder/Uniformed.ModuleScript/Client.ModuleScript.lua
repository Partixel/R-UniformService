local TweenService, ThemeUtil = game:GetService("TweenService"), require(game:GetService("ReplicatedStorage"):WaitForChild("ThemeUtil"):WaitForChild("ThemeUtil"))
local Players = game:GetService( "Players" )
local LocalPlayer = Players.LocalPlayer
local TemplateToId = require(script:WaitForChild("TemplateToId"))
local MarketplaceService = game:GetService("MarketplaceService")

local EscapePatterns = {
	["("] = "%(",
	[")"] = "%)",
	["."] = "%.",
	["%"] = "%%",
	["+"] = "%+",
	["-"] = "%-",
	["*"] = "%*",
	["?"] = "%?",
	["["] = "%[",
	["]"] = "%]",
	["^"] = "%^",
	["$"] = "%$",
	["\0"] = "%z",
}

function GetMatchingKeys( T, Str )
	local Tmp = { }
	
	for a, b in pairs( T ) do
		
		local Category
		
		local CatName = a
		
		local Par = b.DivisionOf
		
		while Par do
			
			CatName = Par .. "  " .. CatName
			
			Par = T[ Par ].DivisionOf
			
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

function GetButtonFromPath(self, Path, TShirt)
	if Path == nil then
		if TShirt then
			Path = self.DefaultTShirt or false
		else
			Path = self.DefaultUni or false
		end
	end
	
	return Path == false and self.Tab.ScrollingFrame:FindFirstChild( "false" ) or self.Tab.ScrollingFrame:FindFirstChild( Path[ 1 ], true ) and self.Tab.ScrollingFrame:FindFirstChild( Path[ 1 ], true ):FindFirstChild( Path[ 2 ] )
end

local App = Players:GetCharacterAppearanceAsync( LocalPlayer.UserId > 0 and LocalPlayer.UserId or 16015142 )
local NormIcon = "rbxassetid://" .. (App:FindFirstChild( "Pants" ) and App.Pants.PantsTemplate:match( "%d+" ) or App:FindFirstChild( "Shirt" ) and App.Shirt.ShirtTemplate:match( "%d+" ) or App:FindFirstChild( "Shirt Graphic" ) and App[ "Shirt Graphic" ].Graphic:match( "%d+" ) or "")

local function CheckOwned(ID, ID2, Button)
	if (not MarketplaceService:GetProductInfo(ID).IsForSale or MarketplaceService:PlayerOwnsAsset(LocalPlayer, ID)) and (not ID2 or not MarketplaceService:GetProductInfo(ID2).IsForSale or MarketplaceService:PlayerOwnsAsset(LocalPlayer, ID2)) then
		Button:Destroy()
	else
		Button.MouseButton1Click:Connect(function()
			local Purch
			if MarketplaceService:GetProductInfo(ID).IsForSale and not MarketplaceService:PlayerOwnsAsset(LocalPlayer, ID) then
				MarketplaceService:PromptPurchase(LocalPlayer, ID)
				while true do
					local Player, PID, Purchased = MarketplaceService.PromptPurchaseFinished:Wait()
					if Player == LocalPlayer and tostring(PID) == ID then
						if Purchased then
							Purch = Purchased
							break
						end
					end
				end
			end
			
			if Purch == false then return end
			
			if ID2 and MarketplaceService:GetProductInfo(ID2).IsForSale and not MarketplaceService:PlayerOwnsAsset(LocalPlayer, ID2) then
				MarketplaceService:PromptPurchase(LocalPlayer, ID2)
				while true do
					local Player, PID, Purchased = MarketplaceService.PromptPurchaseFinished:Wait()
					if Player == LocalPlayer and tostring(PID) == ID2 then
						Purch = Purchased
						break
					end
				end
			end
			
			if Purch then
				Button:Destroy()
			end
		end)
	end
end

return {
	RequiresRemote = true,
	SetupGui = function(self)
		ThemeUtil.BindUpdate(self.Gui, {BackgroundColor3 = "Primary_BackgroundColor", BackgroundTransparency = "Primary_BackgroundTransparency"})
		
		self.Remote.OnClientEvent:Connect(function(Unis, DefaultUni, DefaultTShirt, Selected, SelectedTShirt)
			self.Tabs[1].Debounce = true
			self.Tabs[1].Unis, self.Tabs[1].DefaultUni, self.Tabs[1].DefaultTShirt, self.Tabs[1].Selected, self.Tabs[1].SelectedTShirt = Unis, DefaultUni, DefaultTShirt, Selected, SelectedTShirt
			self.Tabs[1]:Invalidate()
			
			wait( 5 )
			
			self.Tabs[1].Tab.Refresh.AutoButtonColor = true
			ThemeUtil.BindUpdate( self.Tabs[1].Tab.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Secondary_BackgroundColor" } )
			self.Tabs[1].Debounce = nil
		end)
	end,
	Tabs = {
		{
			Tab = script:WaitForChild("Gui"):WaitForChild("MainTab"),
			Button = script.Gui:WaitForChild("HelpTab"):WaitForChild("Close"),
			Show = {},
			SetupTab = function(self)
				ThemeUtil.BindUpdate(self.Tab.ScrollingFrame, {ScrollBarImageColor3 = "Secondary_BackgroundColor", ScrollBarImageTransparency = "Secondary_BackgroundTransparency"})
				ThemeUtil.BindUpdate({self.Tab.Search, self.Tab.Refresh, self.Tab.Help}, {BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency"})
				ThemeUtil.BindUpdate(self.Tab.Search, {PlaceholderColor3 = "Secondary_TextColor"})
				
				self.SelectedGroup, self.SelectedTShirtGroup = self.Selected and self.Selected[ 1 ] or self.Selected == nil and ( self.DefaultUni and self.DefaultUni[ 1 ] ) or nil, self.SelectedTShirt and self.SelectedTShirt[ 1 ] or self.SelectedTShirt == nil and ( self.DefaultTShirt and self.DefaultTShirt[ 1 ] ) or nil
				
				if self.SelectedGroup then
					local Par = self.Unis[ self.SelectedGroup ].DivisionOf
					
					while Par do
						self.Show[ Par ] = true
						Par = self.Unis[ Par ].DivisionOf
					end
				end
				
				if self.SelectedTShirtGroup then
					local Par = self.Unis[ self.SelectedTShirtGroup ].DivisionOf
					
					while Par do
						self.Show[ Par ] = true
						Par = self.Unis[ Par ].DivisionOf
					end
				end
				
				self.Tab.Refresh.MouseButton1Click:Connect( function ( )
					if self.Debounce then return end
					self.Debounce = true
					
					ThemeUtil.BindUpdate( self.Tab.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Positive_Color3" } )
					self.Tab.Refresh.AutoButtonColor = false
					
					self.Options.Remote:FireServer(-1)
				end )
				
				self.Tab.ScrollingFrame.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					self.Tab.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, self.Tab.ScrollingFrame.UIListLayout.AbsoluteContentSize.Y)
				end)
				
				self.Tab.Search:GetPropertyChangedSignal("Text"):Connect(function()
					self:Invalidate()
				end)
				
				ThemeUtil.BindUpdate( { self.Tab.ScrollingFrame.NotLoaded[ "-1" ].TitleText }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency" } )
				
				ThemeUtil.BindUpdate( { self.Tab.ScrollingFrame.NotLoaded[ "-1" ].BarL, self.Tab.ScrollingFrame.NotLoaded[ "-1" ].BarR }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
			end,
			Redraw = function(self)
				if self.Unis then
					if self.Debounce then
						self.Tab.Refresh.AutoButtonColor = false
						ThemeUtil.BindUpdate( self.Tab.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Negative_Color3" } )
					else
						self.Tab.Refresh.AutoButtonColor = true
						ThemeUtil.BindUpdate( self.Tab.Refresh, { [ { "BackgroundColor3", "BorderColor3" } ] = "Secondary_BackgroundColor" } )
					end
					
					for _, Obj in ipairs( self.Tab.ScrollingFrame:GetChildren( ) ) do
						if Obj:IsA( "Frame" ) or Obj:IsA( "TextButton" ) then Obj:Destroy( ) end
					end
					
					local Keys = GetMatchingKeys( self.Unis, self.Tab.Search.Text:lower( ):gsub( ".", EscapePatterns ) )
					
					local New = script.Base:Clone( )
					
					ThemeUtil.BindUpdate( New.Title, { TextColor3 = "Primary_TextColor", BorderColor3 = "Secondary_BackgroundColor", BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
					
					ThemeUtil.BindUpdate( { New.BottomSel, New.RightSel, New.TopSel }, { BackgroundTransparency = "Secondary_BackgroundTransparency" } )
					
					New.Name = "false"
					
					New.LayoutOrder = 0
					
					if ( self.Selected == false and self.SelectedTShirt == false ) or ( self.Selected == nil and self.DefaultUni == nil and self.SelectedTShirt == nil and self.DefaultTShirt == nil ) then
						
						New.UIPadding.PaddingRight = UDim.new( 0, 5 )
						
						New.TopSel.Visible = true
						
						New.BottomSel.Visible = true
						
						New.RightSel.Visible = true
						
						ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( self.Selected == false and self.SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
						
					end
					
					New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
					
					New.ImageLabel.Image = NormIcon
					
					New.Title.Text = "None"
					
					New.BuyButton:Destroy()
					
					New.Visible = true
					
					New.MouseButton1Click:Connect( function ( )
						
						local UniButton, TShirtButton = GetButtonFromPath( self, self.Selected ), GetButtonFromPath( self, self.SelectedTShirt )
						
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
						
						if self.Selected == false and self.SelectedTShirt == false then
							
							self.Selected = nil
							
							self.SelectedTShirt = nil
							
							if self.DefaultUni then
								
								Sel[ 1 ] = self.Unis[ self.DefaultUni[ 1 ] ][ self.DefaultUni[ 2 ] ][ 1 ]
								
								Sel[ 2 ] = self.Unis[ self.DefaultUni[ 1 ] ][ self.DefaultUni[ 2 ] ][ 2 ]
								
							end
							
							if self.DefaultTShirt then
								
								Sel[ 3 ] = self.Unis[ self.DefaultTShirt[ 1 ] ][ self.DefaultTShirt[ 2 ] ][ 3 ]
								
							end
							
						else
							
							self.Selected = false
							
							self.SelectedTShirt = false
							
						end
						
						New.UIPadding.PaddingRight = UDim.new( 0, 5 )
						
						New.TopSel.Visible = true
						
						New.BottomSel.Visible = true
						
						New.RightSel.Visible = true
						
						ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( self.Selected == false and self.SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
						
						self.Options.Remote:FireServer( self.Selected, self.SelectedTShirt, Sel )
						
					end )
					
					New.Parent = self.Tab.ScrollingFrame
					
					local Divisions = { }
					
					for a, Key in ipairs( Keys ) do
						
						local Cat = script.Category:Clone( )
						
						ThemeUtil.BindUpdate( { Cat[ "-1" ].OpenIndicator, Cat[ "-1" ].TitleText }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency" } )
						
						ThemeUtil.BindUpdate( { Cat[ "-1" ].BarL, Cat[ "-1" ].BarR, Cat[ "-1" ].BarR2 }, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
						
						Cat.Name = Key.Name
						
						Cat.Visible = true
						
						Cat[ "-1" ].OpenIndicator.Text = self.Show[ Key.Name ] and  "Λ" or "V"
						
						Cat[ "-1" ].TitleText.Text = Key.Name
						
						local Drawn
						local function Draw()
							Drawn = true
							
							for _, Name in ipairs( Key ) do
								
								local Uni = self.Unis[ Key.Name ][ Name ] or { }
								
								local Shirt, TShirt = Uni[ 1 ] ~= nil, Uni[ 3 ] ~= nil
								
								local New = script.Base:Clone( )
								
								ThemeUtil.BindUpdate( New.Title, { BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency", BorderColor3 = "Secondary_BackgroundColor" } )
								
								ThemeUtil.BindUpdate( { New.BottomSel, New.RightSel, New.TopSel }, { BackgroundTransparency = "Secondary_BackgroundTransparency" } )
								
								New.Name = Name
								
								local Path = Key.Name .. ": " .. Name
								
								if ( self.Selected and ( self.Selected[ 1 ] .. ": " .. self.Selected[ 2 ] ) or self.Selected == nil and ( self.DefaultUni and self.DefaultUni[ 1 ] .. ": " .. self.DefaultUni[ 2 ] ) or "false" ) == Path or ( self.SelectedTShirt and ( self.SelectedTShirt[ 1 ] .. ": " .. self.SelectedTShirt[ 2 ] ) or self.SelectedTShirt == nil and ( self.DefaultTShirt and self.DefaultTShirt[ 1 ] .. ": " .. self.DefaultTShirt[ 2 ] ) or "false" ) == Path then
									
									New.UIPadding.PaddingRight = UDim.new( 0, 5 )
									
									New.TopSel.Visible = true
									
									New.BottomSel.Visible = true
									
									New.RightSel.Visible = true
									
								end
								
								ThemeUtil.BindUpdate( { New.TopSel, New.BottomSel, New.RightSel }, { BackgroundColor3 = ( ( Shirt and self.Selected == nil ) or ( TShirt and self.SelectedTShirt == nil ) ) and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
								
								if Shirt then
									
									New:WaitForChild( "ImageLabel" ).Image = "rbxassetid://" .. ( Uni[ 1 ] or Uni[ 2 ] )
									
									coroutine.wrap(CheckOwned)(TemplateToId[tostring(Uni[1])], TemplateToId[tostring(Uni[2])], New.BuyButton)
								end
								
								if TShirt then
									
									New.BorderColor3 = Color3.fromRGB( 100, 200, 100 )
									
									New:WaitForChild( "ImageLabel" ).Image = "rbxassetid://" .. Uni[ 3 ]
									
									New.ImageLabel.ImageRectOffset = Vector2.new( 0, 0 )
									
									New.ImageLabel.ImageRectSize = Vector2.new( 0, 0 )
									
									coroutine.wrap(CheckOwned)(TemplateToId[tostring(Uni[3])], nil, New.BuyButton)
								end
								
								New.ImageLabel.BackgroundColor3 = App[ "Body Colors" ].TorsoColor3
								
								New.Title.Text = Name
								
								New.Visible = true
								
								New.MouseButton1Click:Connect( function ( )
									
									if Shirt then
										
										local Button = GetButtonFromPath( self, self.Selected )
										
										if Button then
											
											Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
											
											Button.TopSel.Visible = false
											
											Button.BottomSel.Visible = false
											
											Button.RightSel.Visible = false
											
										end
										
										self.Selected = ( ( self.Selected and ( self.Selected[ 1 ] .. ": " .. self.Selected[ 2 ] ) or self.Selected == nil and ( self.DefaultUni and self.DefaultUni[ 1 ] .. ": " .. self.DefaultUni[ 2 ] ) or "false" ) ~= Path or self.Selected == nil ) and { Key.Name, Name } or nil
										
										Button = GetButtonFromPath( self, self.Selected )
										
										if Button then
											
											if Button.Name == "false" then
												
												if ( self.Selected == false and self.SelectedTShirt == false ) or ( self.Selected == nil and self.DefaultUni == nil and self.SelectedTShirt == nil and self.DefaultTShirt == nil ) then
													
													Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
													
													Button.TopSel.Visible = true
													
													Button.BottomSel.Visible = true
													
													Button.RightSel.Visible = true
													
													ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = ( self.Selected == false and self.SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
													
												end
												
											else
												
												Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
												
												Button.TopSel.Visible = true
												
												Button.BottomSel.Visible = true
												
												Button.RightSel.Visible = true
												
												ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = self.Selected == nil and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
												
											end
											
										end
										
									elseif self.SelectedTShirt == false then
										
										self.SelectedTShirt = nil
										
									end
									
									if TShirt then
										
										local Button = GetButtonFromPath( self, self.Selected, true )
										
										if Button then
											
											Button.UIPadding.PaddingRight = UDim.new( 0, 0 )
											
											Button.TopSel.Visible = false
											
											Button.BottomSel.Visible = false
											
											Button.RightSel.Visible = false
											
										end
										
										self.SelectedTShirt = ( ( self.SelectedTShirt and ( self.SelectedTShirt[ 1 ] .. ": " .. self.SelectedTShirt[ 2 ] ) or self.SelectedTShirt == nil and ( self.DefaultTShirt and self.DefaultTShirt[ 1 ] .. ": " .. self.DefaultTShirt[ 2 ] ) or "false" ) ~= Path or self.SelectedTShirt == nil ) and { Key.Name, Name } or nil
										
										Button = GetButtonFromPath( self, self.Selected, true )
										
										if Button then
											
											if Button.Name == "false" then
												
												if not Shirt and ( ( self.Selected == false and self.SelectedTShirt == false ) or ( self.Selected == nil and self.DefaultUni == nil and self.SelectedTShirt == nil and self.DefaultTShirt == nil ) ) then
													
													Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
													
													Button.TopSel.Visible = true
													
													Button.BottomSel.Visible = true
													
													Button.RightSel.Visible = true
													
													ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = ( self.Selected == false and self.SelectedTShirt == false ) and "Selection_Color3" or "Positive_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
													
												end
												
											else
												
												Button.UIPadding.PaddingRight = UDim.new( 0, 5 )
												
												Button.TopSel.Visible = true
												
												Button.BottomSel.Visible = true
												
												Button.RightSel.Visible = true
												
												ThemeUtil.BindUpdate( { Button.TopSel, Button.BottomSel, Button.RightSel }, { BackgroundColor3 = self.SelectedTShirt == nil and "Positive_Color3" or "Selection_Color3", BackgroundTransparency = "Secondary_BackgroundTransparency" } )
												
											end
											
										end
										
									elseif self.SelectedTShirt == false then
										
										self.SelectedTShirt = nil
										
									end
									
									local Sel = { }
									
									if self.Selected then
										
										Sel[ 1 ] = self.Unis[ self.Selected[ 1 ] ][ self.Selected[ 2 ] ][ 1 ]
										
										Sel[ 2 ] = self.Unis[ self.Selected[ 1 ] ][ self.Selected[ 2 ] ][ 2 ]
										
									elseif self.DefaultUni then
										
										self.Show[ self.DefaultUni[ 1 ] ] = true
										
										Sel[ 1 ] = self.Unis[ self.DefaultUni[ 1 ] ][ self.DefaultUni[ 2 ] ][ 1 ]
										
										Sel[ 2 ] = self.Unis[ self.DefaultUni[ 1 ] ][ self.DefaultUni[ 2 ] ][ 2 ]
										
									end
									
									if self.SelectedTShirt then
										
										Sel[ 3 ] = self.Unis[ self.SelectedTShirt[ 1 ] ][ self.SelectedTShirt[ 2 ] ][ 3 ]
										
									elseif self.DefaultTShirt then
										
										self.Show[ self.DefaultTShirt[ 1 ] ] = true
										
										Sel[ 3 ] = self.Unis[ self.DefaultTShirt[ 1 ] ][ self.DefaultTShirt[ 2 ] ][ 3 ]
										
									end
									
									self.Options.Remote:FireServer( self.Selected, self.SelectedTShirt, Sel )
									
								end )
								
								New.Parent = Cat
								
							end
						
							Cat.UIListLayout:GetPropertyChangedSignal( "AbsoluteContentSize" ):Connect( function ( )
								
								Cat.Size = UDim2.new( 1, 0, 0, self.Show[ Key.Name ] and Cat.UIListLayout.AbsoluteContentSize.Y or Cat[ "-1" ].Size.Y.Offset )
								
							end )
						end
						
						Cat[ "-1" ].MouseButton1Click:Connect( function ( )
							if not Drawn then
								Draw()
								
								wait()
							end
							
							self.Show[ Key.Name ] = not self.Show[ Key.Name ]
							
							TweenService:Create( Cat, TweenInfo.new( 0.5, Enum.EasingStyle.Sine ), { Size = UDim2.new( 1, 0, 0, self.Show[ Key.Name ] and Cat.UIListLayout.AbsoluteContentSize.Y or Cat[ "-1" ].Size.Y.Offset ) } ):Play( )
							
							Cat[ "-1" ].OpenIndicator.Text = self.Show[ Key.Name ] and "Λ" or "V"
							
						end )
						
						if self.Show[Key.Name] then
							Draw()
						end
						
						Cat.Size = UDim2.new( 1, 0, 0, self.Show[ Key.Name ] and Cat.UIListLayout.AbsoluteContentSize.Y or Cat[ "-1" ].Size.Y.Offset )
						
						local FoundDiv
						
						if self.Unis[ Key.Name ].DivisionOf then
							
							for _, Key2 in ipairs( Keys ) do
								
								if Key2.Name == self.Unis[ Key.Name ].DivisionOf then
									
									Divisions[ Cat ] = self.Unis[ Key.Name ].DivisionOf
									
									FoundDiv = true
									
									break
									
								end
								
							end
							
						end
						
						if not FoundDiv then
							
							Cat.LayoutOrder = a
							
							Cat.Parent = self.Tab.ScrollingFrame
							
						end
						
					end
					
					for a, b in pairs( Divisions ) do
						
						a.Parent = self.Tab.ScrollingFrame:FindFirstChild( b )
						
					end
				end
			end
		},
		{
			Tab = script.Gui.HelpTab,
			Button = script.Gui.MainTab:WaitForChild("Help"),
			SetupTab = function(self)
				ThemeUtil.BindUpdate(self.Tab.Filler, {BackgroundColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency"})
				ThemeUtil.BindUpdate({ self.Tab.ScrollingFrame.MainText, self.Tab.Title, self.Tab.Close }, {BackgroundColor3 = "Secondary_BackgroundColor", BorderColor3 = "Secondary_BackgroundColor", BackgroundTransparency = "Secondary_BackgroundTransparency", TextColor3 = "Primary_TextColor", TextTransparency = "Primary_TextTransparency"})
				ThemeUtil.BindUpdate(self.Tab.ScrollingFrame, {ScrollBarImageColor3 = "Secondary_BackgroundColor", ScrollBarImageTransparency = "Secondary_BackgroundTransparency"})
			end,
		},
	},
}