-- Gui chính
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhanMenu"
gui.ResetOnSpawn = false

-- Khung menu
local mainFrame = Instance.new("Frame", gui)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Size = UDim2.new(0, 200, 0, 200)
mainFrame.Position = UDim2.new(0, 20, 0, 200)
mainFrame.Visible = true

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Text = "DongPhan"
title.Size = UDim2.new(1, 0, 0, 30)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Nút Farm
local toggleFarm = Instance.new("TextButton", mainFrame)
toggleFarm.Text = "Bắt Đầu Farm"
toggleFarm.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleFarm.Position = UDim2.new(0, 10, 0, 40)
toggleFarm.Size = UDim2.new(0, 180, 0, 30)

-- Nút ẩn menu
local toggleMenu = Instance.new("TextButton", mainFrame)
toggleMenu.Text = "Ẩn Menu"
toggleMenu.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
toggleMenu.Position = UDim2.new(0, 10, 0, 80)
toggleMenu.Size = UDim2.new(0, 180, 0, 30)

-- Ô nhập bán kính
local radiusBox = Instance.new("TextBox", mainFrame)
radiusBox.Text = "24"
radiusBox.Position = UDim2.new(0, 10, 0, 120)
radiusBox.Size = UDim2.new(0, 85, 0, 30)
radiusBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Ô nhập tốc độ
local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Text = "10"
speedBox.Position = UDim2.new(0, 105, 0, 120)
speedBox.Size = UDim2.new(0, 85, 0, 30)
speedBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

-- Biến trạng thái
local farming = false

-- Tìm mục tiêu gần nhất có chứa "BOSS"
function findNearestBoss()
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and string.find(v.Name, "BOSS") then
            local d = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

-- Hàm chạy vòng tròn quanh mục tiêu
function circleAroundTarget(target, radius, speed)
    local player = game.Players.LocalPlayer
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local angle = 0

    while farming and target and target:FindFirstChild("HumanoidRootPart") do
        angle = angle + speed * 0.03
        local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        local moveTo = target.HumanoidRootPart.Position + offset
        humanoid:MoveTo(moveTo)

        -- Auto aim
        hrp.CFrame = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)

        task.wait(0.03)
    end
end

-- Khi bấm nút Farm
toggleFarm.MouseButton1Click:Connect(function()
    farming = not farming
    toggleFarm.Text = farming and "Ngừng Farm" or "Bắt Đầu Farm"
    toggleFarm.BackgroundColor3 = farming and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 200, 0)

    if farming then
        local target = findNearestBoss()
        if target then
            local radius = tonumber(radiusBox.Text) or 24
            local speed = tonumber(speedBox.Text) or 10
            circleAroundTarget(target, radius, speed)
        end
    end
end)

-- Khi bấm ẩn menu
toggleMenu.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)