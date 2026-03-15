-- ApexUI.lua | Modernized with ScrollingFrame & strokes
local ApexUI = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local function corner(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

local function stroke(obj,color)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(160,120,90)
    s.Thickness = 2
    s.Parent = obj
end

local function tween(obj,props,time)
    TweenService:Create(obj,TweenInfo.new(time or 0.2),props):Play()
end

function ApexUI:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ApexUI"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,380,0,240)
    main.Position = UDim2.new(0.5,-190,0.5,-120)
    main.BackgroundColor3 = Color3.fromRGB(230,210,190)
    main.Parent = gui
    corner(main,16)
    stroke(main)

    -- Top bar
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1,0,0,36)
    top.BackgroundColor3 = Color3.fromRGB(200,170,140)
    top.Parent = main
    corner(top,16)
    stroke(top)
    top.Active = true
    top.Selectable = true

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,1,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextColor3 = Color3.fromRGB(90,60,40)
    titleLabel.TextSize = 18
    titleLabel.Parent = top

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(0,90,1,-36)
    tabHolder.Position = UDim2.new(0,0,0,36)
    tabHolder.BackgroundTransparency = 1
    tabHolder.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0,6)
    tabLayout.Parent = tabHolder

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1,-90,1,-36)
    pages.Position = UDim2.new(0,90,0,36)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    -- Dragging code
    do
        local dragging, dragInput, mousePos, framePos
        local function update(input)
            local delta = input.Position - mousePos
            main.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end

        top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                mousePos = input.Position
                framePos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        top.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                dragInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    local window = {}

    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,-6,0,30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(245,225,200)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.FredokaOne
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(120,80,50)
        tabBtn.Parent = tabHolder
        corner(tabBtn,12)
        stroke(tabBtn)

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pages

        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(1,0,1,0)
        scroll.BackgroundTransparency = 1
        scroll.ScrollBarImageTransparency = 1 -- transparent scrollbar
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.Parent = page

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        local function updateCanvas()
            scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            page.Visible = true
        end)

        local tab = {}

        function tab:CreateButton(name,callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-12,0,28)
            btn.BackgroundColor3 = Color3.fromRGB(245,225,200)
            btn.Text = name
            btn.Font = Enum.Font.FredokaOne
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(120,80,50)
            btn.Parent = scroll
            corner(btn,12)
            stroke(btn)
            btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(255,235,210)},0.2) end)
            btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(245,225,200)},0.2) end)
            btn.MouseButton1Click:Connect(callback)
        end

        function tab:CreateToggle(name,default,callback)
            local state = default or false
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-12,0,28)
            holder.BackgroundColor3 = Color3.fromRGB(245,225,200)
            holder.Parent = scroll
            corner(holder,12)
            stroke(holder)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.Font = Enum.Font.FredokaOne
            label.TextSize = 14
            label.TextColor3 = Color3.fromRGB(120,80,50)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Position = UDim2.new(0,8,0,0)
            label.Parent = holder

            local toggleBtn = Instance.new("Frame")
            toggleBtn.Size = UDim2.new(0,24,0,14)
            toggleBtn.Position = UDim2.new(1,-32,0.5,-7)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(200,160,120)
            toggleBtn.Parent = holder
            corner(toggleBtn,7)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0,12,0,12)
            knob.Position = UDim2.new(0,1,0,1)
            knob.BackgroundColor3 = Color3.fromRGB(240,220,180)
            knob.Parent = toggleBtn
            corner(knob,6)

            local function updateToggle()
                if state then
                    tween(toggleBtn,{BackgroundColor3=Color3.fromRGB(120,200,140)},0.2)
                    tween(knob,{Position=UDim2.new(1,-13,0,1)},0.2)
                else
                    tween(toggleBtn,{BackgroundColor3=Color3.fromRGB(200,160,120)},0.2)
                    tween(knob,{Position=UDim2.new(0,1,0,1)},0.2)
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

        return tab
    end

    return window
end

return ApexUI
