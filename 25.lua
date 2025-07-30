-- Gui setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhan"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "DongPhan Menu"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 100, 0, 25)
toggleBtn.Position = UDim2.new(0, 10, 0, 180)
toggleBtn.Text = "Ẩn Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
toggleBtn.TextColor3 = Color3.new(1,1,1)

toggleBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleBtn.Text = frame.Visible and "Ẩn Menu" or "Hiện Menu"
end)

-- Các ô nhập và nút
local toggleFarm = Instance.new("TextButton", frame)
toggleFarm.Size = UDim2.new(0, 110, 0, 25)
toggleFarm.Position = UDim2.new(0, 10, 0, 30)
toggleFarm.Text = "Bật Farm"
toggleFarm.BackgroundColor3 = Color3.fromRGB(0,200,0)

local toggleSpeed = Instance.new("TextButton", frame)
toggleSpeed.Size = UDim2.new(0, 110, 0, 25)
toggleSpeed.Position = UDim2.new(0, 130, 0, 30)
toggleSpeed.Text = "Bật SpeedRun"
toggleSpeed.BackgroundColor3 = Color3.fromRGB(255,170,0)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(0, 100, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 65)
radiusBox.PlaceholderText = "Bán kính"
radiusBox.Text = "24"

local rotateSpeedBox = Instance.new("TextBox", frame)
rotateSpeedBox.Size = UDim2.new(0, 100, 0, 25)
rotateSpeedBox.Position = UDim2.new(0, 130, 0, 65)
rotateSpeedBox.PlaceholderText = "Tốc độ xoay"
rotateSpeedBox.Text = "3"

local walkSpeedBox = Instance.new("TextBox", frame)
walkSpeedBox.Size = UDim2.new(0, 100, 0, 25)
walkSpeedBox.Position = UDim2.new(0, 10, 0, 100)
walkSpeedBox.PlaceholderText = "Tốc độ chạy"
walkSpeedBox.Text = "60"

-- Biến
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local angle = 0
local farming = false
local speedOn = false

local function getTarget()
	local min = math.huge
	local found = nil
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			local dist = (lp.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
			if dist < min and v.Humanoid.Health > 0 and v ~= lp.Character then
				min = dist
				found = v
			end
		end
	end
	return found
end

-- Auto Farm logic
RunService.Heartbeat:Connect(function(dt)
	if not farming then return end
	if not lp.Character or not lp.Character:FindFirstChild("Humanoid") or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

	local hrp = lp.Character.HumanoidRootPart
	local hum = lp.Character.Humanoid
	local target = getTarget()
	if not target then return end

	-- cập nhật tốc độ chạy
	local radius = tonumber(radiusBox.Text) or 24
	local rotateSpeed = tonumber(rotateSpeedBox.Text) or 3
	local walkSpeed = tonumber(walkSpeedBox.Text) or 60

	hum.WalkSpeed = speedOn and walkSpeed or 16

	local tPos = target.HumanoidRootPart.Position
	local dist = (tPos - hrp.Position).Magnitude

	if dist > radius + 2 then
		hum:MoveTo(tPos)
	else
		angle = angle + dt * rotateSpeed
		local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
		local movePos = tPos + offset
		hum:MoveTo(movePos)

		-- Aim mặt
		local lookDir = (tPos - hrp.Position).Unit
		hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookDir.X, 0, lookDir.Z))

		-- Auto attack
		local tool = lp.Character:FindFirstChildOfClass("Tool")
		if tool then tool:Activate() end
	end
end)

-- Nút
toggleFarm.MouseButton1Click:Connect(function()
	farming = not farming
	toggleFarm.Text = farming and "Tắt Farm" or "Bật Farm"
	toggleFarm.BackgroundColor3 = farming and Color3.fromRGB(200,0,0) or Color3.fromRGB(0,200,0)
end)

toggleSpeed.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	toggleSpeed.Text = speedOn and "Tắt SpeedRun" or "Bật SpeedRun"
	toggleSpeed.BackgroundColor3 = speedOn and Color3.fromRGB(200,60,60) or Color3.fromRGB(255,170,0)
end)