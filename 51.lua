--[[
Script Auto Fram - Nghia Minh
]]--

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FramMenuMobile"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 420)
frame.Position = UDim2.new(0, 10, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, -30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Text = "Script: Nghia Minh"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

function createButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.Parent = frame
	return btn
end

function createInput(placeholder, y)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -20, 0, 30)
	box.Position = UDim2.new(0, 10, 0, y)
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.Font = Enum.Font.SourceSans
	box.TextSize = 18
	box.Parent = frame
	return box
end

local distanceBox = createInput("Khoảng cách", 40)
local speedBox = createInput("Tốc độ", 80)

local toggleBtn = createButton("Bật Fram", 120)
local running = false

toggleBtn.MouseButton1Click:Connect(function()
	running = not running
	toggleBtn.Text = running and "Tắt Fram" or "Bật Fram"
end)

local showWeaponHitbox = false
local weaponHitboxBtn = createButton("Hiển thị Hitbox Vũ Khí", 160)
weaponHitboxBtn.MouseButton1Click:Connect(function()
	showWeaponHitbox = not showWeaponHitbox
	weaponHitboxBtn.Text = "Hiển thị Hitbox Vũ Khí [" .. (showWeaponHitbox and "ON" or "OFF") .. "]"
end)

-- Hàm tìm mục tiêu gần nhất
function getNearestEnemy()
	local closest, dist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			local d = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
			if d < dist and v.Humanoid.Health > 0 then
				closest = v
				dist = d
			end
		end
	end
	return closest
end

-- Chạy vòng quanh mục tiêu
local TweenService = game:GetService("TweenService")
spawn(function()
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
				TweenService:Create(hrp, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {CFrame = goalCF}):Play()
			end
		end
	end
end)

-- Hiển thị hitbox vũ khí
spawn(function()
	while true do
		task.wait(1)
		if showWeaponHitbox then
			for _, tool in pairs(char:GetChildren()) do
				if tool:IsA("Tool") then
					for _, part in pairs(tool:GetDescendants()) do
						if part:IsA("BasePart") and not part:FindFirstChild("BoxAdornment") then
							local box = Instance.new("BoxHandleAdornment")
							box.Adornee = part
							box.Size = part.Size
							box.Color3 = Color3.fromRGB(255, 0, 0)
							box.Transparency = 0.5
							box.AlwaysOnTop = true
							box.ZIndex = 5
							box.Name = "BoxAdornment"
							box.Parent = part
						end
					end
				end
			end
		else
			for _, tool in pairs(char:GetChildren()) do
				if tool:IsA("Tool") then
					for _, part in pairs(tool:GetDescendants()) do
						if part:IsA("BasePart") then
							local adorn = part:FindFirstChild("BoxAdornment")
							if adorn then adorn:Destroy() end
						end
					end
				end
			end
		end
	end
end)