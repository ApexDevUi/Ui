-- SERVICES
local UIS = game:GetService("UserInputService")

-------------------------------------------------
-- SHOW / HIDE UI
-------------------------------------------------

local UIVisible = true

Toggle_Button4463.MouseButton1Click:Connect(function()
	UIVisible = not UIVisible
	Frame1007.Visible = UIVisible
	
	if UIVisible then
		Toggle_Button4463.Text = "Hide UI"
	else
		Toggle_Button4463.Text = "Show UI"
	end
end)

-------------------------------------------------
-- CLOSE BUTTON
-------------------------------------------------

Delete7251.MouseButton1Click:Connect(function()
	Apex_Ui:Destroy()
end)

-------------------------------------------------
-- FIX TEXT LABEL COLORS
-------------------------------------------------

local CorrectColor = Color3.fromRGB(255,191,127)

TextLabel1376.TextColor3 = CorrectColor
TextLabel5268.TextColor3 = CorrectColor
Slider_Label9831.TextColor3 = CorrectColor

-------------------------------------------------
-- BUTTON EVENT
-------------------------------------------------

TextButton4177.MouseButton1Click:Connect(function()
	print("ApexUI Button Clicked")
end)

-------------------------------------------------
-- TEXTBOX EVENT
-------------------------------------------------

TextBox7930.FocusLost:Connect(function()
	print("Textbox value:", TextBox7930.Text)
end)

-------------------------------------------------
-- TOGGLE SYSTEM
-------------------------------------------------

local ToggleState = false

TextButton8560.MouseButton1Click:Connect(function()
	ToggleState = not ToggleState
	
	if ToggleState then
		TextButton8560.BackgroundColor3 = Color3.fromRGB(0,255,0)
		print("Toggle Enabled")
	else
		TextButton8560.BackgroundColor3 = Color3.fromRGB(255,191,127)
		print("Toggle Disabled")
	end
end)

-------------------------------------------------
-- SLIDER SYSTEM
-------------------------------------------------

local dragging = false
local sliderMin = 0
local sliderMax = 100

Circle_Slider8977.MouseButton1Down:Connect(function()
	dragging = true
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging then
		
		local mouse = UIS:GetMouseLocation().X
		local start = Frame8653.AbsolutePosition.X
		local size = Frame8653.AbsoluteSize.X
		
		local pos = math.clamp(mouse - start,0,size)
		
		Circle_Slider8977.Position = UDim2.new(0,pos,-0.5,0)
		
		local value = math.floor((pos/size)*(sliderMax-sliderMin)+sliderMin)
		
		print("Slider value:",value)
		
	end
end)

-------------------------------------------------
-- DRAGGABLE UI
-------------------------------------------------

local draggingUI = false
local dragInput
local startPos
local startFrame

Frame1007.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingUI = true
		startPos = input.Position
		startFrame = Frame1007.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				draggingUI = false
			end
		end)
	end
end)

Frame1007.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and draggingUI then
		
		local delta = input.Position - startPos
		
		Frame1007.Position = UDim2.new(
			startFrame.X.Scale,
			startFrame.X.Offset + delta.X,
			startFrame.Y.Scale,
			startFrame.Y.Offset + delta.Y
		)
		
	end
end)
