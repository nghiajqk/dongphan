local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmGUI"
gui.ResetOnSpawn = false

-- Toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Fram"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Radius input
local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 80, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = "24"

-- Speed input
local speedBox = Instance.new("TextBox", gui)
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 50)
speedBox.PlaceholderText = "Tốc độ xoay"
speedBox.Text = "3"

-- Speedrun checkbox
local speedRun = false
local speedRunBtn = Instance.new("TextButton", gui)
speedRunBtn.Size = UDim2.new(0, 100, 0, 25)
speedRunBtn.Position = UDim2.new(0, 10, 0, 85)
speedRunBtn.Text = "SpeedRun: Tắt"
speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

-- Speedrun input
local speedRunBox = Instance.new("TextBox", gui)
speedRunBox.Size = UDim2.new(0, 80, 0, 25)
speedRunBox.Position = UDim2.new(0, 120, 0, 85)
speedRunBox.PlaceholderText = "Tốc độ chạy"
speedRunBox.Text = "60"

-- Trạng thái
local enabled = false
local angle = 0

-- Tìm mục tiêu gần nhất
local function getNearestTarget()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local nearest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
			if dist < minDist then
				minDist = dist
				nearest = v
			end
		end
	end
	return nearest
end

-- Gán sự kiện nút toggle
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "Tắt Fram" or "Bật Fram"
	toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)

	-- Ẩn/hiện các thành phần khi bật
	for _, v in pairs(gui:GetChildren()) do
		if v ~= toggleBtn then
			v.Visible = not enabled
		end
	end
end)

-- Nút bật/tắt speedrun
speedRunBtn.MouseButton1Click:Connect(function()
	speedRun = not speedRun
	speedRunBtn.Text = "SpeedRun: " .. (speedRun and "Bật" or "Tắt")
end)

-- Tự động fram
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")) then return end

	local humanoid = char:FindFirstChild("Humanoid")
	local hrp = char.HumanoidRootPart
	local target = getNearestTarget()
	if not target then return end

	local targetPos = target.HumanoidRootPart.Position
	local dist = (hrp.Position - targetPos).Magnitude

	-- Giá trị từ input
	local radius = tonumber(radiusBox.Text) or 24
	local speed = tonumber(speedBox.Text) or 3
	local moveSpeed = speedRun and (tonumber(speedRunBox.Text) or 60) or 16
	humanoid.WalkSpeed = moveSpeed

	if dist > radius then
		humanoid:MoveTo(targetPos)
	else
		-- Xoay vòng quanh mục tiêu
		angle = angle + dt * speed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = targetPos + offset
		humanoid:MoveTo(Vector3.new(movePos.X, hrp.Position.Y, movePos.Z))

		-- Nhìn về mục tiêu
		local direction = (targetPos - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)

		-- Auto đánh
		mouse1click()
	end
end)