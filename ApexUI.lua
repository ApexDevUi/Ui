-- Load ApexUI library
local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ApexDevUi/Ui/refs/heads/main/ApexUI.lua"))()

-- Create main window
local Window = ApexUI:CreateWindow({
    Name = "Modern Cartoon UI"
})

-- Create Main tab
local MainTab = Window:CreateTab("Main")

-- Create a ScrollingFrame inside the tab for content
local pageFrame = MainTab.Page
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(245, 235, 220) -- soft white/brown
scroll.Parent = pageFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

local function updateCanvas()
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- Helper to create buttons inside scrolling frame
local function CreateButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(220, 200, 180)
    btn.Text = name
    btn.Font = Enum.Font.FredokaOne
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(90, 60, 40)
    btn.Parent = scroll
    btn.AutoButtonColor = true

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(150, 120, 100)
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Helper to create toggles inside scrolling frame
local function CreateToggle(name, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -12, 0, 28)
    holder.BackgroundColor3 = Color3.fromRGB(220, 200, 180)
    holder.Parent = scroll

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(150, 120, 100)
    stroke.Parent = holder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.FredokaOne
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(90, 60, 40)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Size = UDim2.new(0, 24, 0, 14)
    toggleBtn.Position = UDim2.new(1, -32, 0.5, -7)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(120, 200, 140) or Color3.fromRGB(200, 160, 120)
    toggleBtn.Parent = holder
    toggleBtn.AnchorPoint = Vector2.new(0, 0)
    toggleBtn.Name = "ToggleFrame"

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -13, 0, 1) or UDim2.new(0, 1, 0, 1)
    knob.BackgroundColor3 = Color3.fromRGB(240, 220, 180)
    knob.Parent = toggleBtn
    knob.Name = "Knob"

    local uicorner1 = Instance.new("UICorner")
    uicorner1.CornerRadius = UDim.new(0, 7)
    uicorner1.Parent = toggleBtn

    local uicorner2 = Instance.new("UICorner")
    uicorner2.CornerRadius = UDim.new(0, 6)
    uicorner2.Parent = knob

    local state = default
    local TweenService = game:GetService("TweenService")

    local function updateToggle()
        local targetPos = state and UDim2.new(1, -13, 0, 1) or UDim2.new(0, 1, 0, 1)
        local targetColor = state and Color3.fromRGB(120, 200, 140) or Color3.fromRGB(200, 160, 120)
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end

    holder.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
            callback(state)
        end
    end)
end
