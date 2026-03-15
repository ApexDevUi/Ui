local UiLibrary = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local FONT = Enum.Font.FredokaOne

local function corner(obj,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(90,90,90)
    s.Thickness = 1
    s.Parent = obj
end

function UiLibrary:CreateWindow(title)

    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernUILibrary"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,320,0,220)
    main.Position = UDim2.new(0.5,-160,0.5,-110)
    main.BackgroundColor3 = Color3.fromRGB(20,20,20)
    main.Parent = gui
    corner(main,12)
    stroke(main)

    local top = Instance.new("TextLabel")
    top.Size = UDim2.new(1,0,0,32)
    top.BackgroundTransparency = 1
    top.Text = title
    top.Font = FONT
    top.TextSize = 16
    top.TextColor3 = Color3.new(1,1,1)
    top.Parent = main

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(0,90,1,-32)
    tabHolder.Position = UDim2.new(0,0,0,32)
    tabHolder.BackgroundTransparency = 1
    tabHolder.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0,4)
    tabLayout.Parent = tabHolder

    local pages = Instance.new("Frame")
    pages.Size = UDim2.new(1,-90,1,-32)
    pages.Position = UDim2.new(0,90,0,32)
    pages.BackgroundTransparency = 1
    pages.Parent = main

    local window = {}

    -- draggable
    do
        local drag
        local start
        local startPos

        top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                start = input.Position
                startPos = main.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        drag = false
                    end
                end)
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
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

    function window:CreateTab(name)

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1,-6,0,26)
        tabBtn.Position = UDim2.new(0,3,0,0)
        tabBtn.Text = name
        tabBtn.Font = FONT
        tabBtn.TextSize = 13
        tabBtn.TextColor3 = Color3.new(1,1,1)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        tabBtn.Parent = tabHolder
        corner(tabBtn,8)
        stroke(tabBtn)

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pages

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0,6)
        layout.Parent = page

        tabBtn.MouseButton1Click:Connect(function()
            for _,v in pairs(pages:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            page.Visible = true
        end)

        local tab = {}

        function tab:CreateButton(text,callback)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,-8,0,30)
            btn.Position = UDim2.new(0,4,0,0)
            btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            btn.Text = text
            btn.Font = FONT
            btn.TextSize = 13
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = page
            corner(btn,8)
            stroke(btn)

            btn.MouseButton1Click:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(55,55,55)}):Play()
                task.wait(0.12)
                TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(35,35,35)}):Play()
                callback()
            end)

        end

        function tab:CreateToggle(text,callback)

            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1,-8,0,30)
            holder.Position = UDim2.new(0,4,0,0)
            holder.BackgroundColor3 = Color3.fromRGB(35,35,35)
            holder.Parent = page
            corner(holder,8)
            stroke(holder)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1,-50,1,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = FONT
            label.TextSize = 13
            label.TextColor3 = Color3.new(1,1,1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Position = UDim2.new(0,8,0,0)
            label.Parent = holder

            local toggleBtn = Instance.new("Frame")
            toggleBtn.Size = UDim2.new(0,36,0,18)
            toggleBtn.Position = UDim2.new(1,-44,0.5,-9)
            toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            toggleBtn.Parent = holder
            corner(toggleBtn,9)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0,14,0,14)
            knob.Position = UDim2.new(0,2,0.5,-7)
            knob.BackgroundColor3 = Color3.new(1,1,1)
            knob.Parent = toggleBtn
            corner(knob,7)

            local state = false

            holder.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then

                    state = not state

                    if state then
                        TweenService:Create(toggleBtn,TweenInfo.new(0.2),{
                            BackgroundColor3 = Color3.fromRGB(0,170,127)
                        }):Play()

                        TweenService:Create(knob,TweenInfo.new(0.2),{
                            Position = UDim2.new(1,-16,0.5,-7)
                        }):Play()
                    else
                        TweenService:Create(toggleBtn,TweenInfo.new(0.2),{
                            BackgroundColor3 = Color3.fromRGB(60,60,60)
                        }):Play()

                        TweenService:Create(knob,TweenInfo.new(0.2),{
                            Position = UDim2.new(0,2,0.5,-7)
                        }):Play()
                    end

                    callback(state)
                end
            end)

        end

        return tab
    end

    return window
end

return UiLibrary
