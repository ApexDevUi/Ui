local ApexUI = {}

function ApexUI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ApexUI"
    ScreenGui.Parent = game.CoreGui

    -- MAIN WINDOW
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0,300,0,250) -- smaller
    Main.Position = UDim2.new(0.5,-150,0.5,-125)
    Main.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0,6)
    UICorner.Parent = Main

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,30)
    Title.Position = UDim2.new(0,0,0,0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main

    -- LEFT TAB BAR
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(0,80,1,-30)
    TabBar.Position = UDim2.new(0,0,0,30)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Vertical
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0,6)
    TabLayout.Parent = TabBar

    -- CONTENT AREA
    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1,-80,1,-30)
    Pages.Position = UDim2.new(0,80,0,30)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    local Window = {}

    function Window:CreateTab(name)
        -- TAB BUTTON
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1,0,0,30)
        TabButton.Text = name
        TabButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
        TabButton.TextColor3 = Color3.new(1,1,1)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 14
        TabButton.Parent = TabBar

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0,4)
        Corner.Parent = TabButton

        -- TAB PAGE
        local Page = Instance.new("Frame")
        Page.Size = UDim2.new(1,0,1,0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = Pages

        local Layout = Instance.new("UIListLayout")
        Layout.Padding = UDim.new(0,6)
        Layout.Parent = Page

        local Tab = {}

        TabButton.MouseButton1Click:Connect(function()
            for _,v in pairs(Pages:GetChildren()) do
                if v:IsA("Frame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        -- BUTTON
        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1,-10,0,25)
            Button.Text = text
            Button.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 14
            Button.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,4)
            Corner.Parent = Button

            Button.MouseButton1Click:Connect(callback)
        end

        -- TOGGLE
        function Tab:CreateToggle(text, callback)
            local State = false
            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1,-10,0,25)
            Toggle.Text = text.." : OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 14
            Toggle.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,4)
            Corner.Parent = Toggle

            Toggle.MouseButton1Click:Connect(function()
                State = not State
                Toggle.Text = text.." : "..(State and "ON" or "OFF")
                callback(State)
            end)
        end

        -- SLIDER
        function Tab:CreateSlider(text, min, max, callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1,-10,0,25)
            Frame.BackgroundColor3 = Color3.fromRGB(60,60,60)
            Frame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0,4)
            Corner.Parent = Frame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5,0,1,0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.new(1,1,1)
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.Parent = Frame

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(0.4,0,0.3,0)
            SliderBar.Position = UDim2.new(0.55,0,0.35,0)
            SliderBar.BackgroundColor3 = Color3.fromRGB(120,120,120)
            SliderBar.Parent = Frame

            local UIS = game:GetService("UserInputService")
            local dragging = false

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - Frame.AbsolutePosition.X)/Frame.AbsoluteSize.X,0,1)
                    SliderBar.Size = UDim2.new(rel,0,0.3,0)
                    local value = min + (max-min)*rel
                    callback(value)
                end
            end)
        end

        return Tab
    end

    -- DRAGGING
    local dragging = false
    local dragInput, dragStart, startPos
    local UIS = game:GetService("UserInputService")

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    return Window
end

return ApexUI
