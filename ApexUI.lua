-- Load ApexUI
local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ApexDevUi/Ui/refs/heads/main/ApexUI.lua"))()

-- Create main window
local Window = ApexUI:CreateWindow("Cartoon UI Example")

-- Create a tab
local MainTab = Window:CreateTab("Main")

-- Create a ScrollingFrame inside the tab
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -10)
scrollFrame.Position = UDim2.new(0, 10, 0, 5)
scrollFrame.BackgroundColor3 = Color3.fromRGB(245, 240, 230) -- soft white/brown
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = MainTab.Container -- assuming ApexUI tab exposes Container

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- Update CanvasSize
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

-- Helper function to create modern buttons
local function CreateButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,32)
    btn.BackgroundColor3 = Color3.fromRGB(230,210,190)
    btn.Text = text
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(90,60,40)
    btn.Parent = scrollFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,12)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(150,120,100)
    s.Thickness = 2
    s.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Helper function to create modern toggles
local function CreateToggle(text, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1,0,0,32)
    holder.BackgroundColor3 = Color3.fromRGB(230,210,190)
    holder.Parent = scrollFrame

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,12)
    c.Parent = holder

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(150,120,100)
    s.Thickness = 2
    s.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(90,60,40)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0,10,0,0)
    label.Parent = holder

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0,30,0,16)
    toggleBtn.Position = UDim2.new(1,-36,0.5,-8)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200,160,120)
    toggleBtn.Parent = holder
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(0,1,0,1)
    knob.BackgroundColor3 = Color3.fromRGB(245,240,230)
    knob.Parent = toggleBtn

    local k = Instance.new("UICorner")
    k.CornerRadius = UDim.new(0,7)
    k.Parent = knob
    local t = Instance.new("UICorner")
    t.CornerRadius = UDim.new(0,8)
    t.Parent = toggleBtn

    local state = default
    local function update()
        if state then
            toggleBtn.BackgroundColor3 = Color3.fromRGB(120,200,140)
            knob.Position = UDim2.new(1,-15,0,1)
        else
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200,160,120)
            knob.Position = UDim2.new(0,1,0,1)
        end
    end
    update()

    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            update()
            callback(state)
        end
    end)
end

-- Example buttons and toggles
CreateButton("Click Me", function()
    print("Button clicked!")
end)

CreateButton("Print Hello", function()
    print("Hello World!")
end)

CreateToggle("Enable Feature", false, function(state)
    print("Toggle:", state)
end)

CreateToggle("God Mode", true, function(state)
    print("God Mode:", state)
end)
