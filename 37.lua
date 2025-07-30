-- Khởi tạo GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FramMenuMobile"
gui.ResetOnSpawn = false

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 340)
frame.Position = UDim2.new(0, 50, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true

-- Tạo nút
function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(0, 220, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text.." [OFF]"
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 16
	btn.BorderSizePixel = 0
	return btn
end

-- Tạo ô nhập
function createInput(text, default, posY)
	local label = Instance.new("TextLabel")
	label.Parent = frame
	label.Size = UDim2.new(0, 220, 0, 20)
	label.Position = UDim2.new(0, 10, 0, posY)
	label.Text = text..": "..default
	label.TextColor3 = Color3.new(1,1,1)
	label.BackgroundTransparency = 1
	label.TextSize = 14

	local box = Instance.new("TextBox")
	box.Parent = frame
	box.Size = UDim2.new(0, 220, 0, 30)
	box.Position = UDim2.new(0, 10, 0, posY + 20)
	box.Text = tostring(default)
	box.TextColor3 = Color3.new(1,1,1)
	box.BackgroundColor3 = Color3.fromRGB(40,40,40)
	box.Font = Enum.Font.SourceSans
	box.TextSize = 16
	box.BorderSizePixel = 0
	return box, label
end

-- Trạng thái
local running = false
local aiming = false
local clicking = false
local noclip = false
local visible = true
local autoFram = false

-- Nút và nhập
local framBtn = createButton("Chạy Vòng", 10)
local aimBtn = createButton("Auto Aim", 50)
local clickBtn = createButton("Auto Đánh", 90)
local noclipBtn = createButton("Noclip", 130)
local toggleGUI = createButton("Ẩn/Hiện Menu", 170)
local autoFramBtn = createButton("Auto Fram", 210)

local distanceBox, distanceLabel = createInput("Khoảng cách", 10, 250)
local speedBox, speedLabel = createInput("Tốc độ", 10, 300)

-- Toggle nút
framBtn.MouseButton1Click:Connect(function()
	running = not running
	framBtn.Text = "Chạy Vòng ["..(running and "ON" or "OFF").."]"
end)

aimBtn.MouseButton1Click:Connect(function()
	aiming = not aiming
	aimBtn.Text = "Auto Aim ["..(aiming and "ON" or "OFF").."]"
end)

clickBtn.MouseButton1Click:Connect(function()
	clicking = not clicking
	clickBtn.Text = "Auto Đánh ["..(clicking and "ON" or "OFF").."]"
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip ["..(noclip and "ON" or "OFF").."]"
end)

toggleGUI.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)

autoFramBtn.MouseButton1Click:Connect(function()
	autoFram = not autoFram
	autoFramBtn.Text = "Auto Fram ["..(autoFram and "ON" or "OFF").."]"
end)

-- Tìm mục tiêu gần
function getNearestEnemy()
	local myChar = player.Character
	if not myChar then return nil end
	local hrp = myChar:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local nearest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= myChar and v.Humanoid.Health > 0 then
			local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
			if dist < minDist then
				nearest = v
				minDist = dist
			end
		end
	end
	return nearest
end

-- Auto Click
task.spawn(function()
	while true do wait(0.1)
		if clicking then mouse1click() end
	end
end)

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
	local char = player.Character
	if noclip and char then
		for _, v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

-- Auto Aim
task.spawn(function()
	while true do wait()
		local char = player.Character
		if aiming and not running and char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local target = getNearestEnemy()
			if target then
				local tpos = target.HumanoidRootPart.Position
				local lookVec = (tpos - hrp.Position).Unit
				hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVec.X, 0, lookVec.Z))
			end
		end
	end
end)

-- Auto Fram & Chạy vòng
task.spawn(function()
	while true do
		wait(0.1)
		local char = player.Character
		if not char then continue end

		local hrp = char:FindFirstChild("HumanoidRootPart")
		local humanoid = char:FindFirstChild("Humanoid")
		if not (hrp and humanoid) then continue end

		local target = getNearestEnemy()
		if autoFram then
			running = target ~= nil
			framBtn.Text = "Chạy Vòng ["..(running and "ON" or "OFF").."]"
		end

		if running and target and target:FindFirstChild("HumanoidRootPart") then
			local dist = tonumber(distanceBox.Text) or 10
			local speed = tonumber(speedBox.Text) or 5
			local tpos = target.HumanoidRootPart.Position
			local distanceToTarget = (hrp.Position - tpos).Magnitude

			if distanceToTarget > dist + 2 then
				-- Di chuyển lại gần
				local movePos = tpos + (hrp.Position - tpos).Unit * (-dist)
				humanoid:MoveTo(movePos)
			else
				-- Quay vòng
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
				local movePos = tpos + offset
				humanoid:MoveTo(movePos)

				-- Hướng về mục tiêu
				local lookVec = (tpos - hrp.Position).Unit
				hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookVec.X, 0, lookVec.Z))
			end
		end
	end
end)

-- Kéo GUI
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)