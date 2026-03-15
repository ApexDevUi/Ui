local UiLibrary = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Soft rounded helper
local function corner(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(180,150,120)
    s.Thickness = 2
    s.Parent = obj
end

local function tween(obj,props,time)
    TweenService:Create(obj,TweenInfo.new(time),props):Play()
end

function UiLibrary:CreateWindow(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernCartoonUI"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,380,0,240)
    main.Position = UDim2.new(0.5,-190,0.5,-120)
    main.BackgroundColor3 = Color3.fromRGB(220,200,180)
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

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,1,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextColor3 = Color3.fromRGB(90,60,40)
    titleLabel.TextSize = 18
    titleLabel.Parent = top

    -- Tab container
    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(0,90,1,-36)
    tabHolder.Position = UDim2.new(0,0,0,36)
    tabHolder.BackgroundTransparency = 1
    tabHolder.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0,6)
    tabLayout.Parent = tabHolder

    -- Pages container
    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1,-90,1,-36)
    pages.Position = UDim2.new(0,90,0,36)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    -- Draggable
    do
        local dragging
        local start
        local startPos
        top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                start = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - start
                main.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
    end

    local window = {}

    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,-6,0,30)
        tabBtn.BackgroundColor3 = Color3.fromRGB(230,210,190)
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

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,8)
        layout.Parent = page

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            page.Visible = true
        end)

        local tab = {}

        -- Button
        function tab:CreateButton(opts)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-12,0,28)
            btn.BackgroundColor3 = Color3.fromRGB(230,210,190)
            btn.Text = opts.Name or "Button"
            btn.Font = Enum.Font.FredokaOne
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(120,80,50)
            btn.Parent = page
            corner(btn,12)
            stroke(btn)

            btn.MouseEnter:Connect(function()
                tween(btn,{BackgroundColor3=Color3.fromRGB(245,220,180)},0.2)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn,{BackgroundColor3=Color3.fromRGB(230,210,190)},0.2)
            end)

            btn.MouseButton1Click:Connect(function()
                if opts.Callback then opts.Callback() end
            end)
        end

        -- Toggle
        function tab:CreateToggle(opts)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-12,0,28)
            holder.BackgroundColor3 = Color3.fromRGB(230,210,190)
            holder.Parent = page
            corner(holder,12)
            stroke(holder)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = opts.Name or "Toggle"
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

            local state = opts.Default or false
            local function update()
                if state then
                    tween(toggleBtn,{BackgroundColor3=Color3.fromRGB(120,200,140)},0.2)
                    tween(knob,{Position=UDim2.new(1,-13,0,1)},0.2)
                else
                    tween(toggleBtn,{BackgroundColor3=Color3.fromRGB(200,160,120)},0.2)
                    tween(knob,{Position=UDim2.new(0,1,0,1)},0.2)
                end
            end
            update()

            holder.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 then
                    state = not state
                    update()
                    if opts.Callback then opts.Callback(state) end
                end
            end)
        end

        return tab
    end

    return window
end

return UiLibrary
