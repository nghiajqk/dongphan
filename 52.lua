local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FramMenuMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 460)
frame.Position = UDim2.new(0, 50, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Tên menu
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Menu: Nghia Minh"
title.TextColor3 = Color3.new(1, 1, 0)
title.BackgroundTransparency = 1
title.TextSize = 18

-- Máu mục tiêu
local healthLabel = Instance.new("TextLabel", gui)
healthLabel.Size = UDim2.new(0, 200, 0, 30)
healthLabel.Position = UDim2.new(1, -210, 0.05, 0)
healthLabel.BackgroundTransparency = 0.2
healthLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthLabel.TextColor3 = Color3.new(1, 0, 0)
healthLabel.TextSize = 18
healthLabel.Text = "Máu mục tiêu: Không có"

-- Helper UI tạo button + input
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

local function createInput(text, default, posY)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(0, 220, 0, 20)
	label.Position = UDim2.new(0, 10, 0, posY)
	label.Text = text .. ": " .. default
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

-- Trạng thái
local running, aiming, clicking, noclip, visible, showCharHitbox, showWeaponHitbox = false, false, false, false, true, false, false

-- Nút và input
local framBtn = createButton("Chạy Vòng", 40)
local aimBtn = createButton("Auto Aim", 80)
local clickBtn = createButton("Auto Đánh", 120)
local noclipBtn = createButton("Noclip", 160)
local toggleGUI = createButton("Ẩn/Hiện Menu", 200)
local showCharBtn = createButton("Hitbox Nhân Vật", 240)
local showWeaponBtn = createButton("Hitbox Vũ Khí", 280)
local distanceBox = createInput("Khoảng cách", 10, 320)
local speedBox = createInput("Tốc độ", 2, 370)

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

showCharBtn.MouseButton1Click:Connect(function()
	showCharHitbox = not showCharHitbox
	showCharBtn.Text = "Hitbox Nhân Vật [" .. (showCharHitbox and "ON" or "OFF") .. "]"
end)

showWeaponBtn.MouseButton1Click:Connect(function()
	showWeaponHitbox = not showWeaponHitbox
	showWeaponBtn.Text = "Hitbox Vũ Khí [" .. (showWeaponHitbox and "ON" or "OFF") .. "]"
end)

-- Tìm mục tiêu gần nhất
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

-- Hiển thị máu mục tiêu
task.spawn(function()
	while true do
		task.wait(0.2)
		local target = getNearestEnemy()
		if target and target:FindFirstChild("Humanoid") then
			healthLabel.Text = "Máu mục tiêu: " .. math.floor(target.Humanoid.Health)
		else
			healthLabel.Text = "Máu mục tiêu: Không có"
		end
	end
end)

-- Auto đánh
task.spawn(function()
	while true do
		task.wait(0.1)
		if clicking then pcall(function() mouse1click() end) end
	end
end)

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
	if noclip then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- Auto Aim
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

-- Chạy vòng quanh mục tiêu
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
				goalPos = Vector3.new(goalPos.X, hrp.Position.Y, goalPos.Z)
				local goalCF = CFrame.new(goalPos, target.HumanoidRootPart.Position)
				local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
				TweenService:Create(hrp, tweenInfo, {CFrame = goalCF}):Play()
			end
		end
	end
end)

-- Hiển thị hitbox hình khối: nhân vật và vũ khí
task.spawn(function()
	while true do
		task.wait(0.5)
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				local adorn = v:FindFirstChild("BoxAdornment")
				if adorn then adorn:Destroy() end

				if (showCharHitbox or showWeaponHitbox) then
					local isWeapon = tostring(v.Parent):lower():find("sword") or tostring(v):lower():find("weapon")
					if (showCharHitbox and not isWeapon) or (showWeaponHitbox and isWeapon) then
						local box = Instance.new("BoxHandleAdornment")
						box.Adornee = v
						box.Size = v.Size
						box.Color3 = isWeapon and Color3.new(1, 1, 0) or Color3.new(1, 0, 0)
						box.Transparency = 0.5
						box.AlwaysOnTop = true
						box.ZIndex = 5
						box.Name = "BoxAdornment"
						box.Parent = v
					end
				end
			end
		end
	end
end)