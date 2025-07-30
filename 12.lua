-- // GUI Đơn Giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FarmMenu"
gui.ResetOnSpawn = false

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Farm"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

local enabled = false

-- // Tuỳ chỉnh
local radius = 24
local speed = 3

-- // Chạy farm
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

local function attack(target)
	local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool then
		tool:Activate()
	end
end

-- // Đi xuyên vật thể
local function noclip()
	RunService.Stepped:Connect(function()
		if enabled and LocalPlayer.Character then
			for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide == true then
					part.CanCollide = false
				end
			end
		end
	end)
end

-- // Farm vòng tròn
noclip()

RunService.Heartbeat:Connect(function(dt)
	if not enabled then return end
	local char = LocalPlayer.Character
	if not (char and char:FindFirstChild("HumanoidRootPart")) then return end

	local target = getNearestTarget()
	if target then
		local charPos = char.HumanoidRootPart.Position
		local angle = tick() * speed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius

		local moveTo = Vector3.new(
			target.HumanoidRootPart.Position.X + offset.X,
			charPos.Y, -- Giữ nguyên độ cao của nhân vật
			target.HumanoidRootPart.Position.Z + offset.Z
		)

		local dist = (charPos - moveTo).Magnitude
		if dist > 2 and dist < 50 then
			char:MoveTo(moveTo)
		end

		-- Hướng về mục tiêu
		local direction = (Vector3.new(target.HumanoidRootPart.Position.X, charPos.Y, target.HumanoidRootPart.Position.Z) - charPos).Unit
		char.HumanoidRootPart.CFrame = CFrame.new(charPos, charPos + direction)

		-- Đánh
		attack(target)
	end
end)

-- // Hiển thị máu mục tiêu
local hpText = Instance.new("TextLabel", gui)
hpText.Size = UDim2.new(0, 200, 0, 30)
hpText.Position = UDim2.new(0, 10, 0, 50)
hpText.BackgroundTransparency = 1
hpText.TextColor3 = Color3.fromRGB(255, 0, 0)
hpText.TextScaled = true
hpText.Text = "HP: N/A"

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

-- // Nút bật tắt
toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	if enabled then
		toggleBtn.Text = "Tắt Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
	else
		toggleBtn.Text = "Bật Farm"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
	end
end)

-- // Chống teleport lỗi (rớt từ trên cao)
RunService.Stepped:Connect(function()
	if enabled then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and root.Position.Y > 250 then
			root.Velocity = Vector3.new(0, -100, 0)
		end
	end
end)