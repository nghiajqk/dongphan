-- GUI đơn giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "BossFarmGui"
gui.ResetOnSpawn = false

-- Nút bật/tắt script
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 140, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Script"
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Ô nhập bán kính
local radiusBox = Instance.new("TextBox", gui)
radiusBox.Size = UDim2.new(0, 140, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.Text = "Bán kính: 10"
radiusBox.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
radiusBox.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Ô nhập tốc độ
local speedBox = Instance.new("TextBox", gui)
speedBox.Size = UDim2.new(0, 140, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 90)
speedBox.Text = "Tốc độ: 2"
speedBox.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
speedBox.TextColor3 = Color3.fromRGB(0, 0, 0)

-- Biến điều khiển
local active = false
local radius = 10
local speed = 2
local target = nil

-- Tìm mục tiêu chứa "BOSS"
local function findBoss()
	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") then
			if string.find(string.upper(obj.Name), "BOSS") then
				return obj
			end
		end
	end
	return nil
end

-- Hành vi khi bật script
toggleBtn.MouseButton1Click:Connect(function()
	active = not active
	toggleBtn.Text = active and "Tắt Script" or "Bật Script"
	if active then
		target = findBoss()
	end
end)

-- Cập nhật bán kính
radiusBox.FocusLost:Connect(function()
	local val = tonumber(radiusBox.Text:match("%d+"))
	if val then
		radius = val
		radiusBox.Text = "Bán kính: " .. val
	end
end)

-- Cập nhật tốc độ
speedBox.FocusLost:Connect(function()
	local val = tonumber(speedBox.Text:match("%d+"))
	if val then
		speed = val
		speedBox.Text = "Tốc độ: " .. val
	end
end)

-- Vòng lặp chạy vòng tròn và auto aim
spawn(function()
	while true do
		wait(0.03)
		if active and target and target:FindFirstChild("HumanoidRootPart") then
			local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				-- Aim vào mục tiêu
				local dir = (target.HumanoidRootPart.Position - hrp.Position).Unit
				hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(dir.X, 0, dir.Z))

				-- Tính toán vị trí chạy vòng tròn
				local time = tick() * speed
				local offset = Vector3.new(math.cos(time) * radius, 0, math.sin(time) * radius)
				local newPos = target.HumanoidRootPart.Position + offset
				hrp.CFrame = CFrame.new(newPos, target.HumanoidRootPart.Position)
			end
		end
	end
end)