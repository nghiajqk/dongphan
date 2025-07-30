-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmMenu"
gui.ResetOnSpawn = false

-- Toggle Button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

-- Tốc độ & bán kính
local radius = 24
local speed = 3
local enabled = false
local angleVal = 0

-- Nhập tầm đánh
local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 80, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = tostring(radius)

-- Nhập tốc độ
local speedBox = Instance.new("TextBox", gui)
speedBox.Size = UDim2.new(0, 80, 0, 25)
speedBox.Position = UDim2.new(0, 100, 0, 50)
speedBox.PlaceholderText = "Tốc độ"
speedBox.Text = tostring(speed)

-- HP Hiển thị
local hpText = Instance.new("TextLabel", gui)
hpText.Size = UDim2.new(0, 200, 0, 30)
hpText.Position = UDim2.new(0, 10, 0, 85)
hpText.BackgroundTransparency = 1
hpText.TextColor3 = Color3.fromRGB(255, 0, 0)
hpText.TextScaled = true
hpText.Text = "HP: N/A"

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Tìm mục tiêu gần nhất
local function getNearestTarget()
	local nearest, minDist = nil, math.huge
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			if v ~= LocalPlayer.Character then
				local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if dist < minDist and dist <= 50 then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

-- Auto đánh
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
			if part:IsA("BasePart") and part.CanCollide == true then
				part.CanCollide = false
			end
		end
	end
end)

-- Di chuyển vòng quanh
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart")) then return end

	local target = getNearestTarget()
	if target then
		angleVal = angleVal + dt * speed
		local charPos = char.HumanoidRootPart.Position
		local offset = Vector3.new(math.cos(angleVal), 0, math.sin(angleVal)) * radius

		local moveTo = Vector3.new(
			target.HumanoidRootPart.Position.X + offset.X,
			charPos.Y,
			target.HumanoidRootPart.Position.Z + offset.Z
		)

		char:MoveTo(moveTo)

		-- Quay mặt về mục tiêu
		local direction = (Vector3.new(target.HumanoidRootPart.Position.X, charPos.Y, target.HumanoidRootPart.Position.Z) - charPos).Unit
		char.HumanoidRootPart.CFrame = CFrame.new(charPos, charPos + direction)

		-- Auto đánh
		attack(target)
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

-- Chống lỗi tele cao
RunService.Stepped:Connect(function()
	if enabled then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and root.Position.Y > 250 then
			root.Velocity = Vector3.new(0, -100, 0)
		end
	end
end)

-- Toggle bật/tắt farm
toggleBtn.MouseButton1Click:Connect(function()
	if radiusBox.Text ~= "" then
		radius = tonumber(radiusBox.Text) or 24
	end
	if speedBox.Text ~= "" then
		speed = tonumber(speedBox.Text) or 3
	end

	enabled = not enabled
	toggleBtn.Text = enabled and "Tắt Farm" or "Bật Farm"
	toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(50, 200, 50)
end)