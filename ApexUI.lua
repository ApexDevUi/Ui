-- ApexUI.lua
-- Fully manual, publishable UI module
-- Windows, tabs, buttons, toggles, sliders, draggable, fade in/out

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local ApexUI = {}
ApexUI.__index = ApexUI

-- Colors
local MAIN_COLOR = Color3.fromRGB(255,191,127)
local FRAME_BG = Color3.fromRGB(30,30,30)
local FADE_TIME = 0.3

-- Tween helper
local function fade(obj, props, time)
	local tween = TweenService:Create(obj, TweenInfo.new(time), props)
	tween:Play()
	return tween
end

-- Draggable helper (full frame)
local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

-- Create a window
function ApexUI:CreateWindow(title)
	local player = Players.LocalPlayer
	local gui = Instance.new("ScreenGui")
	gui.Name = "ApexUI"
	gui.Parent = player:WaitForChild("PlayerGui")

	local window = {}
	window.Tabs = {}

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,400,0,300)
	frame.Position = UDim2.new(0.5,-200,0.5,-150)
	frame.BackgroundColor3 = FRAME_BG
	frame.Visible = true
	frame.Parent = gui

	makeDraggable(frame)

	-- Fade in
	frame.BackgroundTransparency = 1
	fade(frame, {BackgroundTransparency = 0}, FADE_TIME)

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1,0,0,30)
	titleLabel.Position = UDim2.new(0,0,0,0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = MAIN_COLOR
	titleLabel.Font = Enum.Font.FredokaOne
	titleLabel.TextScaled = true
	titleLabel.Parent = frame

	-- Tabs container (left)
	local tabsFrame = Instance.new("Frame")
	tabsFrame.Size = UDim2.new(0,120,1,-30)
	tabsFrame.Position = UDim2.new(0,0,0,30)
	tabsFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
	tabsFrame.Parent = frame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = tabsFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0,5)

	-- Pages container
	local pagesFrame = Instance.new("Frame")
	pagesFrame.Size = UDim2.new(1,-120,1,-30)
	pagesFrame.Position = UDim2.new(0,120,0,30)
	pagesFrame.BackgroundTransparency = 1
	pagesFrame.Parent = frame

	-- Create tab
	function window:CreateTab(name)
		local tab = {}
		tab.Button = Instance.new("TextButton")
		tab.Button.Size = UDim2.new(1,0,0,30)
		tab.Button.BackgroundColor3 = FRAME_BG
		tab.Button.TextColor3 = MAIN_COLOR
		tab.Button.Text = name
		tab.Button.Font = Enum.Font.FredokaOne
		tab.Button.Parent = tabsFrame

		local page = Instance.new("Frame")
		page.Size = UDim2.new(1,0,1,0)
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = pagesFrame

		-- Show page on tab click
		tab.Button.MouseButton1Click:Connect(function()
			for _, p in pairs(pagesFrame:GetChildren()) do
				if p:IsA("Frame") then p.Visible = false end
			end
			page.Visible = true
		end)

		tab.Elements = {}

		-- Button
		function tab:CreateButton(text, callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,30)
			btn.Position = UDim2.new(0,5,#tab.Elements*35,0)
			btn.BackgroundColor3 = MAIN_COLOR
			btn.TextColor3 = Color3.new(0,0,0)
			btn.Text = text
			btn.Font = Enum.Font.FredokaOne
			btn.Parent = page
			btn.MouseButton1Click:Connect(callback)
			table.insert(tab.Elements, btn)
			return btn
		end

		-- Toggle
		function tab:CreateToggle(text, callback)
			local frameToggle = Instance.new("Frame")
			frameToggle.Size = UDim2.new(1,-10,0,30)
			frameToggle.Position = UDim2.new(0,5,#tab.Elements*35,0)
			frameToggle.BackgroundColor3 = MAIN_COLOR
			frameToggle.Parent = page

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.7,0,1,0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.new(0,0,0)
			label.Font = Enum.Font.FredokaOne
			label.Parent = frameToggle

			local button = Instance.new("TextButton")
			button.Size = UDim2.new(0.3,-5,1,0)
			button.Position = UDim2.new(0.7,5,0,0)
			button.Text = "Off"
			button.TextColor3 = Color3.new(0,0,0)
			button.BackgroundColor3 = Color3.fromRGB(50,50,50)
			button.Font = Enum.Font.FredokaOne
			button.Parent = frameToggle

			local state = false
			button.MouseButton1Click:Connect(function()
				state = not state
				button.Text = state and "On" or "Off"
				callback(state)
			end)

			table.insert(tab.Elements, frameToggle)
			return frameToggle
		end

		-- Slider
		function tab:CreateSlider(text,min,max,callback)
			local frameSlider = Instance.new("Frame")
			frameSlider.Size = UDim2.new(1,-10,0,30)
			frameSlider.Position = UDim2.new(0,5,#tab.Elements*35,0)
			frameSlider.BackgroundColor3 = MAIN_COLOR
			frameSlider.Parent = page

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.7,0,1,0)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.new(0,0,0)
			label.Font = Enum.Font.FredokaOne
			label.Parent = frameSlider

			local slider = Instance.new("TextButton")
			slider.Size = UDim2.new(0.3,-5,1,0)
			slider.Position = UDim2.new(0.7,5,0,0)
			slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
			slider.Text = "0"
			slider.Font = Enum.Font.FredokaOne
			slider.TextColor3 = Color3.new(0,0,0)
			slider.Parent = frameSlider

			local dragging = false
			slider.MouseButton1Down:Connect(function()
				dragging = true
			end)
			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)
			UserInputService.InputChanged:Connect(function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local relative = math.clamp((input.Position.X - slider.AbsolutePosition.X)/slider.AbsoluteSize.X,0,1)
					local value = math.floor(min + (max-min)*relative)
					slider.Text = tostring(value)
					callback(value)
				end
			end)

			table.insert(tab.Elements, frameSlider)
			return frameSlider
		end

		self.Tabs[name] = tab
		return tab
	end

	-- Function to close window with fade
	function window:Close()
		fade(frame, {BackgroundTransparency=1}, FADE_TIME):Play()
		delay(FADE_TIME, function()
			gui:Destroy()
		end)
	end

	return window
end

return ApexUI
