-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhanMenu"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 240, 0, 160)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Visible = true

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 25)
title.Text = "DongPhan"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0, 100, 0, 25)
toggleBtn.Position = UDim2.new(0, 10, 0, 35)
toggleBtn.Text = "Bật Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)

local radiusBox = Instance.new("TextBox", mainFrame)
radiusBox.Size = UDim2.new(0, 100, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 65)
radiusBox.PlaceholderText = "Bán kính"
radiusBox.Text = "24"

local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Position = UDim2.new(0, 120, 0, 65)
speedBox.PlaceholderText = "Tốc độ"
speedBox.Text = "3"

local hideBtn = Instance.new("TextButton", mainFrame)
hideBtn.Size = UDim2.new(0, 100, 0, 25)
hideBtn.Position = UDim2.new(0, 120, 0, 35)
hideBtn.Text = "Ẩn Menu"
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

-- Toggle Show/Hide
hideBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- Dịch vụ
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Biến
local enabled = false
local radius = 24
local speed = 3
local angle = 0
local moving = false

-- Tìm mục tiêu gần nhất
local function getNearestTarget()
	local minDist = math.huge
	local target = nil
	for _, v in pairs(workspace:GetDescendants()) do
		if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			local dist = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if dist < minDist then
				minDist = dist
				target = v
			end
		end
	end
	return target
end

-- Tự động tấn công
local function attack(target)
	local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool then tool:Activate() end
end

-- NoClip
RunService.Stepped:Connect(function()
	if enabled then
		for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)

-- Di chuyển và quay vòng tròn
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local hrp = char.HumanoidRootPart
	local humanoid = char:FindFirstChild("Humanoid")
	local target = getNearestTarget()
	if not target then return end

	local targetPos = target.HumanoidRootPart.Position
	local dist = (hrp.Position - targetPos).Magnitude

	if dist > radius + 2 then
		humanoid:MoveTo(targetPos)
	else
		angle += dt * speed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = Vector3.new(targetPos.X + offset.X, hrp.Position.Y, targetPos.Z + offset.Z)
		humanoid:MoveTo(movePos)

		-- Nhân vật xoay về mục tiêu
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
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
		radius = tonumber(radiusBox.Text) or 24
		speed = tonumber(speedBox.Text) or 3
	else
		toggleBtn.Text = "Bật Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	end
end)