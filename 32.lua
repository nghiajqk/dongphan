-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhan"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 150)
frame.Position = UDim2.new(0, 20, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DongPhan"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Toggle Farm
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 100, 0, 30)
toggle.Position = UDim2.new(0, 10, 0, 40)
toggle.Text = "Đang Farm"
toggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)

-- Hide Menu
local hide = Instance.new("TextButton", frame)
hide.Size = UDim2.new(0, 100, 0, 30)
hide.Position = UDim2.new(0, 110, 0, 40)
hide.Text = "Ẩn Menu"
hide.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
hide.TextColor3 = Color3.new(1, 1, 1)

-- Radius Input
local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(0, 100, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 80)
radiusBox.Text = "24"
radiusBox.PlaceholderText = "Bán kính"
radiusBox.TextScaled = true

-- Speed Input
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 110, 0, 80)
speedBox.Text = "13"
speedBox.PlaceholderText = "Tốc độ"
speedBox.TextScaled = true

-- Variables
local running = false
local players = game:GetService("Players")
local lp = players.LocalPlayer
local hrp = lp.Character:WaitForChild("HumanoidRootPart")
local hum = lp.Character:WaitForChild("Humanoid")

-- Find Nearest Target
local function getNearestTarget()
    local nearest = nil
    local shortest = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
            if v.Name:lower():find("boss") and v:FindFirstChild("Humanoid").Health > 0 then
                local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = v
                end
            end
        end
    end
    return nearest
end

-- Loop
task.spawn(function()
    while true do
        task.wait()
        if running then
            local radius = tonumber(radiusBox.Text) or 24
            local speed = tonumber(speedBox.Text) or 13
            local target = getNearestTarget()
            if target and target:FindFirstChild("HumanoidRootPart") then
                local time = tick()
                local angle = math.rad((tick() * speed * 50) % 360)
                local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
                local moveToPos = target.HumanoidRootPart.Position + offset
                hum:MoveTo(moveToPos)
                -- Auto aim vào mục tiêu
                hrp.CFrame = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)
            end
        end
    end
end)

-- Toggle script
toggle.MouseButton1Click:Connect(function()
    running = not running
    toggle.Text = running and "Đang Farm" or "Ngừng Farm"
    toggle.BackgroundColor3 = running and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
end)

-- Hide menu
hide.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)