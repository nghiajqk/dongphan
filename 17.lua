-- GUI local gui = Instance.new("ScreenGui", game.CoreGui) local toggleBtn = Instance.new("TextButton", gui) toggleBtn.Size = UDim2.new(0, 120, 0, 30) toggleBtn.Position = UDim2.new(0, 10, 0, 10) toggleBtn.Text = "[Bật] Fram Boss" toggleBtn.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2) toggleBtn.TextColor3 = Color3.new(1, 1, 1)

local radiusBox = Instance.new("TextBox", gui) radiusBox.Size = UDim2.new(0, 120, 0, 30) radiusBox.Position = UDim2.new(0, 10, 0, 50) radiusBox.PlaceholderText = "Bán kính (vd: 15)"

local speedBox = Instance.new("TextBox", gui) speedBox.Size = UDim2.new(0, 120, 0, 30) speedBox.Position = UDim2.new(0, 10, 0, 90) speedBox.PlaceholderText = "Tốc độ chạy (vd: 20)"

-- Biến chính local run = false local Players = game:GetService("Players") local player = Players.LocalPlayer local char = player.Character or player.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local root = char:WaitForChild("HumanoidRootPart")

-- Tìm mục tiêu gần nhất function getNearestTarget() local nearest, dist = nil, math.huge for _, v in pairs(workspace:GetDescendants()) do if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= player.Name then local d = (v.HumanoidRootPart.Position - root.Position).Magnitude if d < dist then dist = d nearest = v end end end return nearest end

-- Di chuyển tự nhiên quanh mục tiêu function moveAround(target, radius, speed) local angle = 0 while run and target and target:FindFirstChild("HumanoidRootPart") do local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius local movePos = target.HumanoidRootPart.Position + offset hum:MoveTo(movePos)

-- Xoay mặt về mục tiêu
    root.CFrame = CFrame.new(root.Position, target.HumanoidRootPart.Position)

    angle = angle + math.rad(speed)
    if angle > math.pi * 2 then angle = 0 end

    wait(0.2)
end

end

-- Xử lý khi bấm nút local currentThread = nil toggleBtn.MouseButton1Click:Connect(function() run = not run toggleBtn.Text = run and "[Tắt] Fram Boss" or "[Bật] Fram Boss" toggleBtn.BackgroundColor3 = run and Color3.new(1, 0.4, 0.4) or Color3.new(0.2, 0.8, 0.2)

if run then
    local radius = tonumber(radiusBox.Text) or 15
    local speed = tonumber(speedBox.Text) or 20
    local target = getNearestTarget()
    if target then
        currentThread = coroutine.create(function()
            moveAround(target, radius, speed)
        end)
        coroutine.resume(currentThread)
    end
else
    if currentThread then
        coroutine.close(currentThread)
    end
end

end)