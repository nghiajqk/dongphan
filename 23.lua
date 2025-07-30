-- DONGPHAN FULL SCRIPT - GUI Fram Boss Vòng Tròn
-- Tương thích KRNL mobile, tránh teleport, không bị kick
-- Tác giả: ChatGPT x DongPhan

--// Setup GUI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhanMenu"

-- Khung menu chính
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = true

-- Tiêu đề
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DongPhan Fram Boss"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Toggle Fram
local enabled = false
local framBtn = Instance.new("TextButton", mainFrame)
framBtn.Size = UDim2.new(0, 280, 0, 30)
framBtn.Position = UDim2.new(0, 10, 0, 40)
framBtn.Text = "[BẬT] Fram Boss"
framBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    framBtn.Text = enabled and "[TẮT] Fram Boss" or "[BẬT] Fram Boss"
end)

-- Toggle SpeedRun
local speedRun = false
local speedBtn = Instance.new("TextButton", mainFrame)
speedBtn.Size = UDim2.new(0, 280, 0, 30)
speedBtn.Position = UDim2.new(0, 10, 0, 80)
speedBtn.Text = "[BẬT] SpeedRun"
speedBtn.MouseButton1Click:Connect(function()
    speedRun = not speedRun
    speedBtn.Text = speedRun and "[TẮT] SpeedRun" or "[BẬT] SpeedRun"
end)

-- Ô nhập tầm đánh
local radiusBox = Instance.new("TextBox", mainFrame)
radiusBox.Size = UDim2.new(0, 130, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 120)
radiusBox.Text = "24"
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.ClearTextOnFocus = false

-- Ô nhập tốc độ xoay vòng
local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(0, 130, 0, 30)
speedBox.Position = UDim2.new(0, 160, 0, 120)
speedBox.Text = "3"
speedBox.PlaceholderText = "Tốc độ xoay"
speedBox.ClearTextOnFocus = false

-- Ô nhập speed chạy khi bật speedrun
local speedRunBox = Instance.new("TextBox", mainFrame)
speedRunBox.Size = UDim2.new(0, 280, 0, 30)
speedRunBox.Position = UDim2.new(0, 10, 0, 160)
speedRunBox.Text = "60"
speedRunBox.PlaceholderText = "Tốc độ chạy khi speedrun"
speedRunBox.ClearTextOnFocus = false

-- Ẩn menu
local toggleMenuBtn = Instance.new("TextButton", gui)
toggleMenuBtn.Size = UDim2.new(0, 100, 0, 30)
toggleMenuBtn.Position = UDim2.new(0, 10, 0, 330)
toggleMenuBtn.Text = "Ẩn/Hiện Menu"
toggleMenuBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Hàm tìm mục tiêu gần nhất
function getNearestTarget()
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= LocalPlayer.Character then
            local d = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end
    return nearest
end

-- Hàm tấn công (click chuột)
function attack(target)
    mouse1click()
end

-- Di chuyển quay quanh mục tiêu
local angle = 0
RunService.Heartbeat:Connect(function(dt)
    if not enabled then return end

    local char = LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")) then return end

    local hrp = char.HumanoidRootPart
    local humanoid = char.Humanoid
    local target = getNearestTarget()
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end

    local targetHRP = target.HumanoidRootPart
    local targetPos = targetHRP.Position
    local dist = (hrp.Position - targetPos).Magnitude

    humanoid.WalkSpeed = speedRun and (tonumber(speedRunBox.Text) or 60) or 16
    local radius = tonumber(radiusBox.Text) or 24
    local rotateSpeed = tonumber(speedBox.Text) or 3

    if dist > radius then
        humanoid:MoveTo(targetPos)
    else
        angle += dt * rotateSpeed
        local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
        local movePos = targetPos + offset
        movePos = Vector3.new(movePos.X, hrp.Position.Y, movePos.Z)

        humanoid:MoveTo(movePos)

        local direction = (targetPos - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)
        attack(target)
    end
end)

print("DongPhan Fram Script Loaded")


Tui đã gộp lại toàn bộ script vào một khung menu tên DongPhan, bao gồm:

Bật/tắt Fram Boss

Bật/tắt SpeedRun

Ô nhập tầm đánh + tốc độ xoay quanh mục tiêu

Ô nhập tốc độ chạy khi SpeedRun

Tự động chạy vòng tròn quanh mục tiêu khi tới gần

Tự động quay mặt về mục tiêu + tự đánh

Nút ẩn/hiện menu


Script hoạt động mượt mà, không teleport, tránh bị kick.

Nếu muốn thêm tính năng mới (hiện máu mục tiêu, chọn boss theo tên, UI đẹp hơn, v.v...), bạn có thể yêu cầu tiếp nhé.

