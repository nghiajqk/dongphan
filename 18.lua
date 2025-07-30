-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmBossMenu"
gui.ResetOnSpawn = false

-- Nút bật/tắt farm
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

-- Tầm đánh
local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 80, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = "24"

-- Tốc độ xoay
local speedBox = Instance.new("TextBox", gui)
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 50)
speedBox.PlaceholderText = "Tốc độ xoay"
speedBox.Text = "3"

-- Nút bật/tắt SpeedRun
local speedRunBtn = Instance.new("TextButton", gui)
speedRunBtn.Size = UDim2.new(0, 120, 0, 25)
speedRunBtn.Position = UDim2.new(0, 10, 0, 80)
speedRunBtn.Text = "Bật SpeedRun"
speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

-- Nhập tốc độ chạy khi bật SpeedRun
local speedRunBox = Instance.new("TextBox", gui)
speedRunBox.Size = UDim2.new(0, 80, 0, 25)
speedRunBox.Position = UDim2.new(0, 140, 0, 80)
speedRunBox.PlaceholderText = "Tốc độ chạy"
speedRunBox.Text = "60"

-- Hiển thị máu
local hpText = Instance.new("TextLabel", gui)
hpText.Size = UDim2.new(0, 200, 0, 25)
hpText.Position = UDim2.new(0, 10, 0, 110)
hpText.BackgroundTransparency = 1
hpText.TextColor3 = Color3.fromRGB(255, 0, 0)
hpText.TextScaled = true
hpText.Text = "HP: N/A"

-- Service
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Biến
local enabled = false
local radius = 24
local speed = 3
local angle = 0
local speedRun = false
local movingToTarget = false
local speedRunSpeed = 60

-- Tìm mục tiêu gần nhất
local function getNearestTarget()
	local minDist = math.huge
	local nearest = nil
	for _, v in pairs(workspace:GetDescendants()) do
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			if v ~= LocalPlayer.Character then
				local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

-- Tự đánh
local function attack(target)
	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool then
		tool:Activate()
	end
end

-- Noclip (đi xuyên vật thể)
RunService.Stepped:Connect(function()
	if enabled and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Hiển thị máu
RunService.RenderStepped:Connect(function()
	if not enabled then 
		hpText.Text = "HP: N/A"
		return 
	end
	local target = getNearestTarget()
	if target and target:FindFirstChild("Humanoid") then
		hpText.Text = "HP: " .. math.floor(target.Humanoid.Health) .. " / " .. math.floor(target.Humanoid.MaxHealth)
	else
		hpText.Text = "HP: N/A"
	end
end)

-- Di chuyển vòng quanh mục tiêu
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")) then return end

	local humanoid = char.Humanoid
	local target = getNearestTarget()
	if not target then return end

	local hrp = char.HumanoidRootPart
	local targetPos = target.HumanoidRootPart.Position
	local dist = (hrp.Position - targetPos).Magnitude

	-- Tốc độ chạy
	humanoid.WalkSpeed = speedRun and speedRunSpeed or 16

	if dist > radius + 2 then
		humanoid:MoveTo(targetPos)
	else
		angle = angle + dt * speed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = Vector3.new(targetPos.X + offset.X, hrp.Position.Y, targetPos.Z + offset.Z)
		humanoid:MoveTo(movePos)

		local lookAt = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookAt)

		attack(target)
	end
end)

-- Nút bật/tắt Farm
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleBtn.Text = "Tắt Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		radius = tonumber(radiusBox.Text) or 24
		speed = tonumber(speedBox.Text) or 3
		speedRunSpeed = tonumber(speedRunBox.Text) or 60
	else
		toggleBtn.Text = "Bật Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
	end
end)

-- Nút bật/tắt SpeedRun
speedRunBtn.MouseButton1Click:Connect(function()
	speedRun = not speedRun
	if speedRun then
		speedRunBtn.Text = "Tắt SpeedRun"
		speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		speedRunSpeed = tonumber(speedRunBox.Text) or 60
	else
		speedRunBtn.Text = "Bật SpeedRun"
		speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	end
end)