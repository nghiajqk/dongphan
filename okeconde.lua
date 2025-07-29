-- Tạo GUI đơn giản
local gui = Instance.new("ScreenGui")
gui.Name = "DongPhanAuto"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

-- Biến điều khiển
_G.AutoFarm = false
_G.Radius = 15
_G.Speed = 5

-- Khung menu
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- Tên menu
local title = Instance.new("TextLabel", frame)
title.Text = "dong phan | vòng boss"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Nút bật auto
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.9, 0, 0, 30)
toggle.Position = UDim2.new(0.05, 0, 0, 40)
toggle.Text = "Bật Auto Farm: TẮT"
toggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSans
toggle.TextSize = 16
toggle.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    toggle.Text = "Bật Auto Farm: " .. (_G.AutoFarm and "BẬT" or "TẮT")
end)

-- Slider bán kính
local radiusLabel = Instance.new("TextLabel", frame)
radiusLabel.Text = "Bán kính: 15"
radiusLabel.Size = UDim2.new(1, -20, 0, 25)
radiusLabel.Position = UDim2.new(0.05, 0, 0, 80)
radiusLabel.TextColor3 = Color3.new(1,1,1)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Font = Enum.Font.SourceSans
radiusLabel.TextSize = 16

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Text = tostring(_G.Radius)
radiusBox.Size = UDim2.new(0.3, 0, 0, 25)
radiusBox.Position = UDim2.new(0.65, 0, 0, 80)
radiusBox.BackgroundColor3 = Color3.fromRGB(100,100,100)
radiusBox.TextColor3 = Color3.new(1,1,1)
radiusBox.TextSize = 16
radiusBox.FocusLost:Connect(function()
    local num = tonumber(radiusBox.Text)
    if num then
        _G.Radius = num
        radiusLabel.Text = "Bán kính: " .. num
    end
end)

-- Slider tốc độ
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Text = "Tốc độ: 5"
speedLabel.Size = UDim2.new(1, -20, 0, 25)
speedLabel.Position = UDim2.new(0.05, 0, 0, 115)
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

local speedBox = Instance.new("TextBox", frame)
speedBox.Text = tostring(_G.Speed)
speedBox.Size = UDim2.new(0.3, 0, 0, 25)
speedBox.Position = UDim2.new(0.65, 0, 0, 115)
speedBox.BackgroundColor3 = Color3.fromRGB(100,100,100)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.TextSize = 16
speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then
        _G.Speed = num
        speedLabel.Text = "Tốc độ: " .. num
    end
end)

-- Nút ẩn menu
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0.9, 0, 0, 30)
close.Position = UDim2.new(0.05, 0, 0, 155)
close.Text = "Ẩn menu"
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Font = Enum.Font.SourceSansBold
close.TextSize = 16
close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Hàm tìm boss gần nhất
function GetNearestBoss()
    local nearest
    local shortest = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name:lower():find("boss") then
            local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                nearest = v
            end
        end
    end
    return nearest
end

-- Chạy auto farm
task.spawn(function()
    while true do
        if _G.AutoFarm then
            local boss = GetNearestBoss()
            if boss then
                local angle = tick() * _G.Speed
                local x = math.cos(angle) * _G.Radius
                local z = math.sin(angle) * _G.Radius
                local pos = boss.HumanoidRootPart.Position + Vector3.new(x, 0, z)
                game.Players.LocalPlayer.Character:MoveTo(pos)

                -- Auto đánh nếu có vũ khí
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end
        task.wait(0.1)
    end
end)