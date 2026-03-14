local ApexUI = {}

function ApexUI:CreateWindow(title)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ApexUI"
    ScreenGui.Parent = game.CoreGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0,520,0,360)
    Main.Position = UDim2.new(0.5,-260,0.5,-180)
    Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Main.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,40)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.new(1,1,1)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Main

    -- TAB BAR

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1,0,0,35)
    TabBar.Position = UDim2.new(0,0,0,40)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0,6)
    TabLayout.Parent = TabBar

    -- CONTENT AREA

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1,0,1,-75)
    Pages.Position = UDim2.new(0,0,0,75)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Main

    local Window = {}

    function Window:CreateTab(name)

        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0,110,1,0)
        TabButton.Text = name
        TabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
        TabButton.TextColor3 = Color3.new(1,1,1)
        TabButton.Font = Enum.Font.Gotham
        TabButton.TextSize = 16
        TabButton.Parent = TabBar

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.Parent = TabButton

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

        function Tab:CreateButton(text,callback)

            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1,-10,0,35)
            Button.Text = text
            Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Button.TextColor3 = Color3.new(1,1,1)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 16
            Button.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                callback()
            end)

        end

        -- TOGGLE

        function Tab:CreateToggle(text,callback)

            local State = false

            local Toggle = Instance.new("TextButton")
            Toggle.Size = UDim2.new(1,-10,0,35)
            Toggle.Text = text.." : OFF"
            Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)
            Toggle.TextColor3 = Color3.new(1,1,1)
            Toggle.Font = Enum.Font.Gotham
            Toggle.TextSize = 16
            Toggle.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.Parent = Toggle

            Toggle.MouseButton1Click:Connect(function()

                State = not State

                if State then
                    Toggle.Text = text.." : ON"
                else
                    Toggle.Text = text.." : OFF"
                end

                callback(State)

            end)

        end

        return Tab

    end

    -- DRAGGING

    local dragging
    local dragInput
    local dragStart
    local startPos

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

    game:GetService("UserInputService").InputChanged:Connect(function(input)

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
