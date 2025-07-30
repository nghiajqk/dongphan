-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmBossMenu"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 80, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = "24"

local speedBox = Instance.new("TextBox", gui)
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 50)
speedBox.PlaceholderText = "Tốc độ"
speedBox.Text = "3"

local speedRunBtn = Instance.new("TextButton", gui)
speedRunBtn.Size = UDim2.new(0, 120, 0, 25)
speedRunBtn.Position = UDim2.new(0, 10, 0, 80)
speedRunBtn.Text = "Bật SpeedRun"
speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

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

-- Auto Attack
local function attack(target)
	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool then
		tool:Activate()
	end
end

-- Noclip
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

-- Di chuyển vòng quanh
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")) then return end

	local humanoid = char:FindFirstChild("Humanoid")
	local target = getNearestTarget()
	if not target then return end

	local hrp = char.HumanoidRootPart
	local targetPos = target.HumanoidRootPart.Position
	local dist = (hrp.Position - targetPos).Magnitude

	-- SpeedRun tăng tốc
	humanoid.WalkSpeed = speedRun and 60 or 16

	if dist > radius + 2 then
		-- Chạy bộ tới mục tiêu
		movingToTarget = true
		humanoid:MoveTo(targetPos)
	else
		-- Đã tới gần → chạy vòng tròn
		movingToTarget = false
		angle = angle + dt * speed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = Vector3.new(targetPos.X + offset.X, hrp.Position.Y, targetPos.Z + offset.Z)

		humanoid:MoveTo(movePos)

		-- Hướng về mục tiêu
		local lookAt = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookAt)

		-- Đánh
		attack(target)
	end
end)

-- Bật / Tắt Farm
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleBtn.Text = "Tắt Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		radius = tonumber(radiusBox.Text) or 24
		speed = tonumber(speedBox.Text) or 3
	else
		toggleBtn.Text = "Bật Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 16
	end
end)

-- Bật / Tắt SpeedRun
speedRunBtn.MouseButton1Click:Connect(function()
	speedRun = not speedRun
	if speedRun then
		speedRunBtn.Text = "Tắt SpeedRun"
		speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	else
		speedRunBtn.Text = "Bật SpeedRun"
		speedRunBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	end
end)