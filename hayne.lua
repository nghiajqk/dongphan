-- GUI cơ bản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 310)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Text = "dong phan | vòng boss"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Biến
local running = false
local attacking = false
local radius = 10
local speed = 1
local autoFarm = false

-- Nút Auto Farm Boss
local autoFarmBtn = Instance.new("TextButton", frame)
autoFarmBtn.Size = UDim2.new(1, -20, 0, 30)
autoFarmBtn.Position = UDim2.new(0, 10, 0, 40)
autoFarmBtn.Text = "⚔️ Bật Auto Farm Boss"
autoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
autoFarmBtn.TextColor3 = Color3.new(0,0,0)
autoFarmBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    running = autoFarm
    attacking = autoFarm
    autoFarmBtn.Text = autoFarm and "✅ Auto Farm Đang chạy" or "⚔️ Bật Auto Farm Boss"
end)

-- Bật chạy vòng (có thể bật riêng)
local toggleRun = Instance.new("TextButton", frame)
toggleRun.Size = UDim2.new(1, -20, 0, 30)
toggleRun.Position = UDim2.new(0, 10, 0, 80)
toggleRun.Text = "🔄 Bật chạy vòng"
toggleRun.BackgroundColor3 = Color3.fromRGB(50, 150, 250)
toggleRun.TextColor3 = Color3.new(1,1,1)
toggleRun.MouseButton1Click:Connect(function()
    running = not running
    toggleRun.Text = running and "✅ Đang chạy vòng" or "🔄 Bật chạy vòng"
end)

-- Bật tự đánh
local toggleAtk = Instance.new("TextButton", frame)
toggleAtk.Size = UDim2.new(1, -20, 0, 30)
toggleAtk.Position = UDim2.new(0, 10, 0, 120)
toggleAtk.Text = "🗡️ Bật tự đánh"
toggleAtk.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
toggleAtk.TextColor3 = Color3.new(1,1,1)
toggleAtk.MouseButton1Click:Connect(function()
    attacking = not attacking
    toggleAtk.Text = attacking and "✅ Đang đánh" or "🗡️ Bật tự đánh"
end)

-- Nhập bán kính
local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(1, -20, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 160)
radiusBox.PlaceholderText = "Bán kính (VD: 10)"
radiusBox.Text = ""
radiusBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
radiusBox.TextColor3 = Color3.new(1,1,1)
radiusBox.FocusLost:Connect(function()
    local n = tonumber(radiusBox.Text)
    if n then radius = n end
end)

-- Nhập tốc độ
local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 200)
speedBox.PlaceholderText = "Tốc độ xoay (VD: 1)"
speedBox.Text = ""
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if n then speed = n end
end)

-- Giảm đồ họa
local graphicBtn = Instance.new("TextButton", frame)
graphicBtn.Size = UDim2.new(1, -20, 0, 30)
graphicBtn.Position = UDim2.new(0, 10, 0, 240)
graphicBtn.Text = "🧹 Giảm đồ họa"
graphicBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
graphicBtn.TextColor3 = Color3.new(0,0,0)
graphicBtn.MouseButton1Click:Connect(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game:GetService("Lighting").FogEnd = 100
    game:GetService("Lighting").Brightness = 1
    game:GetService("Lighting").GlobalShadows = false
end)

-- Đóng menu
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -20, 0, 30)
closeBtn.Position = UDim2.new(0, 10, 0, 280)
closeBtn.Text = "❌ Đóng menu"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Tìm boss gần nhất
function getNearestEnemy()
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
            local mag = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                nearest = v
                dist = mag
            end
        end
    end
    return nearest
end

-- Vòng xoay boss
spawn(function()
    while true do task.wait()
        if running then
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local target = getNearestEnemy()
            if root and target then
                local pos = target.HumanoidRootPart.Position
                local angle = tick() * speed
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
                root.CFrame = CFrame.new(pos + offset, pos)
            end
        e