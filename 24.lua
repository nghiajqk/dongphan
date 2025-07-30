-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhan"
gui.ResetOnSpawn = false

-- Khung chính
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 250, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0

-- Ẩn/hiện menu
local toggleMenu = Instance.new("TextButton", gui)
toggleMenu.Size = UDim2.new(0, 100, 0, 25)
toggleMenu.Position = UDim2.new(0, 10, 0, 200)
toggleMenu.Text = "Ẩn Menu"
toggleMenu.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleMenu.TextColor3 = Color3.new(1,1,1)

toggleMenu.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
	toggleMenu.Text = mainFrame.Visible and "Ẩn Menu" or "Hiện Menu"
end)

-- Các nút và ô nhập
local function createLabel(text, posY)
	local label = Instance.new("TextLabel", mainFrame)
	label.Size = UDim2.new(0, 240, 0, 20)
	label.Position = UDim2.new(0, 5, 0, posY)
	label.Text = text
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	return label
end

createLabel("Farm Boss - DongPhan", 5)

local toggleFarm = Instance.new("TextButton", mainFrame)
toggleFarm.Size = UDim2.new(0, 110, 0, 25)
toggleFarm.Position = UDim2.new(0, 5, 0, 30)
toggleFarm.Text = "Bật Farm"
toggleFarm.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

local toggleSpeedRun = Instance.new("TextButton", mainFrame)
toggleSpeedRun.Size = UDim2.new(0, 110, 0, 25)
toggleSpeedRun.Position = UDim2.new(0, 130, 0, 30)
toggleSpeedRun.Text = "Bật SpeedRun"
toggleSpeedRun.BackgroundColor3 = Color3.fromRGB(255, 170, 0)

local radiusBox = Instance.new("TextBox", mainFrame)
radiusBox.Size = UDim2.new(0, 100, 0, 25)
radiusBox.Position = UDim2.new(0, 5, 0, 65)
radiusBox.PlaceholderText = "Tầm đánh"
radiusBox.Text = "24"

local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Position = UDim2.new(0, 130, 0, 65)
speedBox.PlaceholderText = "Tốc độ xoay"
speedBox.Text = "3"

local walkSpeedBox = Instance.new("TextBox", mainFrame)
walkSpeedBox.Size = UDim2.new(0, 100, 0, 25)
walkSpeedBox.Position = UDim2.new(0, 5, 0, 100)
walkSpeedBox.PlaceholderText = "Tốc độ chạy"
walkSpeedBox.Text = "60"

-- Service
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Biến
local enabled = false
local speedRun = false
local angle = 0
local radius = 24
local circleSpeed = 3
local walkSpeed = 60

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
	if tool then tool:Activate() end
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

-- Di chuyển vòng tròn quanh mục tiêu
RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end

	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid")) then return end
	local humanoid = char:FindFirstChild("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")

	local target = getNearestTarget()
	if not target then return end

	local targetPos = target.HumanoidRootPart.Position
	local dist = (targetPos - hrp.Position).Magnitude

	-- Cập nhật tốc độ
	humanoid.WalkSpeed = speedRun and walkSpeed or 16

	if dist > radius + 3 then
		humanoid:MoveTo(targetPos)
	else
		angle = angle + dt * circleSpeed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = targetPos + offset
		humanoid:MoveTo(movePos)

		-- Quay mặt về mục tiêu
		local lookDir = (Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z) - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)

		-- Tự động đánh
		attack(target)
	end
end)

-- Nút Bật/Tắt Farm
toggleFarm.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleFarm.Text = "Tắt Farm"
		toggleFarm.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
		radius = tonumber(radiusBox.Text) or 24
		circleSpeed = tonumber(speedBox.Text) or 3
		walkSpeed = tonumber(walkSpeedBox.Text) or 60
	else
		toggleFarm.Text = "Bật Farm"
		toggleFarm.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end
end)

-- Nút Bật/Tắt SpeedRun
toggleSpeedRun.MouseButton1Click:Connect(function()
	speedRun = not speedRun
	if speedRun then
		toggleSpeedRun.Text = "Tắt SpeedRun"
		toggleSpeedRun.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
	else
		toggleSpeedRun.Text = "Bật SpeedRun"
		toggleSpeedRun.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
	end
end)