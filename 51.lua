-- Roblox GUI Menu AutoFarm - by Nghia Minh

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FramMenuMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- MAIN MENU FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 440)
frame.Position = UDim2.new(0, 50, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 127)
title.Text = "Script: Nghia Minh"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- HEALTH DISPLAY
local healthLabel = Instance.new("TextLabel", gui)
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(1, -210, 0.05, 0)
healthLabel.BackgroundTransparency = 0.2
healthLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthLabel.TextColor3 = Color3.new(1, 0, 0)
healthLabel.TextSize = 18
healthLabel.Text = "Máu mục tiêu: Không có"

-- BUTTON CREATION
local function createButton(text, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 220, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text .. " [OFF]"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.BorderSizePixel = 0
	return btn
end

-- INPUT CREATION
local function createInput(labelText, default, posY)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0, 220, 0, 20)
	label.Position = UDim2.new(0, 10, 0, posY)
	label.Text = labelText .. ": " .. default
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.TextSize = 14

	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0, 220, 0, 30)
	box.Position = UDim2.new(0, 10, 0, posY + 20)
	box.Text = tostring(default)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 16
	box.BorderSizePixel = 0
	return box
end

-- STATES
local running, aiming, clicking, noclip, visible, showHitbox = false, false, false, false, true, false

-- BUTTONS & INPUTS
local framBtn = createButton("Chạy Vòng", 30)
local aimBtn = createButton("Auto Aim", 70)
local clickBtn = createButton("Auto Đánh", 110)
local noclipBtn = createButton("Noclip", 150)
local toggleGUI = createButton("Ẩn/Hiện Menu", 190)
local hitboxBtn = createButton("Hiển thị Vùng Gây Sát Thương", 230)

local distanceBox = createInput("Khoảng cách", 10, 270)
local speedBox = createInput("Tốc độ", 2, 320)

-- BUTTON TOGGLES
framBtn.MouseButton1Click:Connect(function()
	running = not running
	framBtn.Text = "Chạy Vòng [" .. (running and "ON" or "OFF") .. "]"
end)
aimBtn.MouseButton1Click:Connect(function()
	aiming = not aiming
	aimBtn.Text = "Auto Aim [" .. (aiming and "ON" or "OFF") .. "]"
end)
clickBtn.MouseButton1Click:Connect(function()
	clicking = not clicking
	clickBtn.Text = "Auto Đánh [" .. (clicking and "ON" or "OFF") .. "]"
end)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip [" .. (noclip and "ON" or "OFF") .. "]"
end)
toggleGUI.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)
hitboxBtn.MouseButton1Click:Connect(function()
	showHitbox = not showHitbox
	hitboxBtn.Text = "Hiển thị Vùng Gây Sát Thương [" .. (showHitbox and "ON" or "OFF") .. "]"
end)

-- FIND NEAREST ENEMY
local function getNearestEnemy()
	local nearest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char and v.Humanoid.Health > 0 then
			local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
			if dist < minDist then
				nearest = v
				minDist = dist
			end
		end
	end
	return nearest
end

-- DISPLAY TARGET HEALTH
task.spawn(function()
	while true do
		task.wait(0.2)
		local target = getNearestEnemy()
		healthLabel.Text = target and target:FindFirstChild("Humanoid") and ("Máu mục tiêu: " .. math.floor(target.Humanoid.Health)) or "Máu mục tiêu: Không có"
	end
end)

-- AUTO CLICK
task.spawn(function()
	while true do
		task.wait(0.1)
		if clicking then pcall(function() mouse1click() end) end
	end
end)

-- NOCLIP
game:GetService("RunService").Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- AUTO AIM
task.spawn(function()
	while true do
		task.wait()
		if aiming then
			local target = getNearestEnemy()
			if target and target:FindFirstChild("HumanoidRootPart") then
				hrp.CFrame = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)
			end
		end
	end
end)

-- RUN AROUND ENEMY
local TweenService = game:GetService("TweenService")
task.spawn(function()
	while true do
		task.wait(0.03)
		if running then
			local dist = tonumber(distanceBox.Text) or 10
			local speed = tonumber(speedBox.Text) or 2
			local target = getNearestEnemy()
			if target and target:FindFirstChild("HumanoidRootPart") then
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
				local goalPos = target.HumanoidRootPart.Position + offset
				local goalCF = CFrame.new(Vector3.new(goalPos.X, hrp.Position.Y, goalPos.Z), target.HumanoidRootPart.Position)
				local tween = TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = goalCF})
				tween:Play()
			end
		end
	end
end)

-- SHOW HITBOX OF WEAPON
task.spawn(function()
	while true do
		task.wait(1)
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				local adorn = v:FindFirstChild("WeaponBox")
				if showHitbox then
					if not adorn then
						local box = Instance.new("BoxHandleAdornment")
						box.Name = "WeaponBox"
						box.Adornee = v
						box.Size = v.Size + Vector3.new(0.5, 0.5, 0.5)
						box.Color3 = Color3.fromRGB(255, 0, 0)
						box.Transparency = 0.6
						box.ZIndex = 10
						box.AlwaysOnTop = true
						box.Parent = v
					end
				elseif adorn then
					adorn:Destroy()
				end
			end
		end
	end
end)