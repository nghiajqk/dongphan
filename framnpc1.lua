-- GUI tạo bởi ChatGPT - Đơn giản cho KRNL Mobile
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Biến điều khiển
local active = false
local autoAttack = true
local radius = 10
local speed = 2
local target = nil

-- Tìm mục tiêu gần nhất tên có chứa "NPC"
local function findTarget()
    local nearest = nil
    local shortest = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name:lower():find("npc") then
            local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < shortest then
                shortest = dist
                nearest = v
            end
        end
    end
    return nearest
end

-- Hiển thị máu mục tiêu
local function showHealth()
    if target and target:FindFirstChild("Humanoid") then
        healthLabel.Text = "Máu: " .. math.floor(target.Humanoid.Health)
    else
        healthLabel.Text = "Không có mục tiêu"
    end
end

-- Tự động di chuyển vòng tròn quanh mục tiêu
RunService.RenderStepped:Connect(function(dt)
    if active and target and target:FindFirstChild("HumanoidRootPart") then
        local time = tick()
        local angle = time * speed
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local pos = target.HumanoidRootPart.Position + Vector3.new(x, 0, z)
        hrp.CFrame = CFrame.new(pos, target.HumanoidRootPart.Position)
        
        -- Auto đánh (giả lập click)
        if autoAttack and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
            mouse1click()
        end
        
        showHealth()
    end
end)

-- Tìm mục tiêu liên tục
task.spawn(function()
    while true do
        if active then
            target = findTarget()
        end
        task.wait(1)
    end
end)

-- Giao diện menu
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "VongBossMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 10, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, 0, 0, 40)
toggleBtn.Text = "Bật/Tắt Auto"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 127)
toggleBtn.MouseButton1Click:Connect(function()
    active = not active
    toggleBtn.Text = active and "Đang chạy..." or "Bật Auto"
end)

local attackBtn = Instance.new("TextButton", frame)
attackBtn.Size = UDim2.new(1, 0, 0, 40)
attackBtn.Position = UDim2.new(0, 0, 0, 50)
attackBtn.Text = "Tự động đánh: Bật"
attackBtn.BackgroundColor3 = Color3.fromRGB(127, 127, 255)
attackBtn.MouseButton1Click:Connect(function()
    autoAttack = not autoAttack
    attackBtn.Text = "Tự động đánh: " .. (autoAttack and "Bật" or "Tắt")
end)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(1, 0, 0, 30)
radiusBox.Position = UDim2.new(0, 0, 0, 100)
radiusBox.Text = tostring(radius)
radiusBox.PlaceholderText = "Bán kính"
radiusBox.FocusLost:Connect(function()
    local num = tonumber(radiusBox.Text)
    if num then radius = num end
end)

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(1, 0, 0, 30)
speedBox.Position = UDim2.new(0, 0, 0, 140)
speedBox.Text = tostring(speed)
speedBox.PlaceholderText = "Tốc độ"
speedBox.FocusLost:Connect(function()
    local num = tonumber(speedBox.Text)
    if num then speed = num end
end)

healthLabel = Instance.new("TextLabel", frame)
healthLabel.Size = UDim2.new(1, 0, 0, 40)
healthLabel.Position = UDim2.new(0, 0, 0, 180)
healthLabel.Text = "Máu: --"
healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
healthLabel.BackgroundTransparency = 1

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(1, 0, 0, 30)
hideBtn.Position = UDim2.new(0, 0, 1, -30)
hideBtn.Text = "Ẩn Menu"
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
hideBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
end)