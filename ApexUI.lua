-- Load ApexUI
local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ApexDevUi/Ui/refs/heads/main/ApexUI.lua"))()

-- Create Window
local Window = ApexUI:CreateWindow("Cartoon UI Example")

-- Customize window appearance
Window.Frame.BackgroundColor3 = Color3.fromRGB(245, 235, 220) -- soft white-brown
Window.Frame.BackgroundTransparency = 0.3

-- Add ScrollingFrame for content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -40)
content.Position = UDim2.new(0, 10, 0, 36)
content.BackgroundColor3 = Color3.fromRGB(245, 240, 230)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.ScrollBarThickness = 8
content.Parent = Window.Frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = content

-- Helper function for cartoon buttons
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(210, 180, 140)
    btn.Text = text
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(80, 50, 30)
    btn.Parent = content
    btn.AutoButtonColor = false

    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    -- Frame stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(160, 130, 100)
    stroke.Thickness = 2
    stroke.Parent = btn

    -- Text stroke (outline)
    local textStroke = Instance.new("UIStroke")
    textStroke.ApplyStrokeToText = true
    textStroke.Thickness = 2
    textStroke.Color = Color3.fromRGB(160, 130, 100)
    textStroke.Parent = btn

    -- Button hover animation
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(230, 200, 160)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(210, 180, 140)
    end)

    btn.MouseButton1Click:Connect(callback)
end

-- Helper function for cartoon toggles
local function CreateToggle(text, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 30)
    holder.BackgroundColor3 = Color3.fromRGB(210, 180, 140)
    holder.Parent = content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = holder

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(160, 130, 100)
    stroke.Thickness = 2
    stroke.Parent = holder

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(80, 50, 30)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = holder

    -- Text stroke
    local labelStroke = Instance.new("UIStroke")
    labelStroke.ApplyStrokeToText = true
    labelStroke.Thickness = 2
    labelStroke.Color = Color3.fromRGB(160, 130, 100)
    labelStroke.Parent = label

    -- Toggle button
    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 28, 0, 16)
    toggle.Position = UDim2.new(1, -38, 0.5, -8)
    toggle.BackgroundColor3 = Color3.fromRGB(180, 140, 100)
    toggle.Parent = holder

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggle

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 1, 0, 1)
    knob.BackgroundColor3 = Color3.fromRGB(245, 235, 220)
    knob.Parent = toggle

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 7)
    knobCorner.Parent = knob

    local state = default or false
    local function updateToggle()
        if state then
            toggle.BackgroundColor3 = Color3.fromRGB(120, 200, 140)
            knob:TweenPosition(UDim2.new(1, -15, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            toggle.BackgroundColor3 = Color3.fromRGB(180, 140, 100)
            knob:TweenPosition(UDim2.new(0, 1, 0, 1), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
    end
    updateToggle()

    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
            if callback then callback(state) end
        end
    end)
end

-- Example usage
CreateButton("Click Me", function() print("Button clicked!") end)
CreateButton("Print Hello", function() print("Hello World") end)
CreateToggle("Enable Feature", false, function(state) print("Toggle:", state) end)
CreateToggle("God Mode", true, function(state) print("God Mode:", state) end)
