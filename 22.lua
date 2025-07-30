local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmGUI"
gui.ResetOnSpawn = false

-- Toggle Fram
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Fram"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

-- Radius (Tầm đánh)
local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 80, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = "24"

-- Speed xoay quanh mục tiêu
local rotateSpeedBox = Instance.new("TextBox", gui)
rotateSpeedBox.Size = UDim2.new(0, 80, 0, 25)
rotateSpeedBox.Position = UDim2.new(0, 100, 0, 50)
rotateSpeedBox.PlaceholderText = "Tốc xoay"
rotateSpeedBox.Text = "3"

-- SpeedRun Toggle
local speedRunBtn = Instance.new("TextButton", gui)
speedRunBtn.Size = UDim2.new(0, 100, 0, 25)
speedRunBtn.Position = UDim2.new(0, 10, 0, 85)
speedRunBtn.Text = "SpeedRun: Tắt"
speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

-- Speed chạy thường
local speedRunBox = Instance.new("TextBox", gui)
speedRunBox.Size = UDim2.new(0, 80, 0, 25)
speedRunBox.Position = UDim2.new(0, 120, 0, 85)
speedRunBox.PlaceholderText = "Tốc chạy"
speedRunBox.Text = "60"

-- Trạng thái script
local enabled = false
local speedRun = false
local angle = 0

-- Hàm tìm mục tiêu gần nhất
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

-- Bật/Tắt Fram
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "Tắt Fram" or "Bật Fram"
	toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)

	for _, v in pairs(gui:GetChildren()) do
		if v ~= toggleBtn then
			v.Visible = not enabled -- ẩn menu khi fram
		end
	end
end)

-- Bật/Tắt SpeedRun
speedRunBtn.MouseButton1Click:Connect(function()
	speedRun = not speedRun
	speedRunBtn.Text = "SpeedRun: " .. (speedRun and "Bật" or "Tắt")
end)

-- Logic Fram
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then return end

	local humanoid = char.Humanoid
	local hrp = char.HumanoidRootPart
	local target = getNearestTarget()
	if not target then return end

	local targetHRP = target:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

	local radius = tonumber(radiusBox.Text) or 24
	local rotateSpeed = tonumber(rotateSpeedBox.Text) or 3
	local moveSpeed = speedRun and (tonumber(speedRunBox.Text) or 60) or 16
	humanoid.WalkSpeed = moveSpeed

	local dist = (hrp.Position - targetHRP.Position).Magnitude

	if dist > radius + 1 then
		-- Chạy tới mục tiêu nếu còn xa
		humanoid:MoveTo(targetHRP.Position)
	else
		-- Di chuyển vòng tròn quanh mục tiêu
		angle = angle + dt * rotateSpeed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = targetHRP.Position + offset
		humanoid:MoveTo(Vector3.new(movePos.X, hrp.Position.Y, movePos.Z))

		-- Xoay mặt về mục tiêu
		local direction = (targetHRP.Position - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + direction)

		-- Tự đánh
		mouse1click()
	end
end)