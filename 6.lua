--// GUI Đơn Giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FramBossMenu"
gui.ResetOnSpawn = false

local openButton = Instance.new("TextButton", gui)
openButton.Size = UDim2.new(0, 120, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.Text = "Mở Menu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Visible = false

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -20, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Bật Script"

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(1, -20, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.Text = "Tầm đánh: 24"

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 90)
speedBox.Text = "Tốc độ quay: 3"

local healthLabel = Instance.new("TextLabel", frame)
healthLabel.Size = UDim2.new(1, -20, 0, 30)
healthLabel.Position = UDim2.new(0, 10, 0, 130)
healthLabel.Text = "HP: 0"
healthLabel.TextColor3 = Color3.new(1, 0, 0)
healthLabel.BackgroundTransparency = 1

--/ Biến điều khiển
local running = false

openButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	openButton.Text = frame.Visible and "Đóng Menu" or "Mở Menu"
end)

toggleBtn.MouseButton1Click:Connect(function()
	running = not running
	toggleBtn.Text = running and "Tắt Script" or "Bật Script"
end)

--/ Hàm hỗ trợ
local function getNearestTarget(maxDistance)
	local char = game.Players.LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end

	local closest, shortestDist = nil, maxDistance
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
			local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
			if dist < shortestDist and v.Humanoid.Health > 0 then
				shortestDist = dist
				closest = v
			end
		end
	end
	return closest
end

--/ Vòng lặp chính
task.spawn(function()
	while true do task.wait()
		if running then
			local player = game.Players.LocalPlayer
			local char = player.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") then continue end

			local radius = tonumber(radiusBox.Text:match("%d+")) or 24
			local speed = tonumber(speedBox.Text:match("%d+")) or 3
			local target = getNearestTarget(radius + 20)

			if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") then
				-- Quay vòng quanh mục tiêu
				local tPos = target.HumanoidRootPart.Position
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
				local movePos = tPos + offset
				char:MoveTo(movePos)

				-- Hướng về mục tiêu
				local lookDir = (tPos - char.HumanoidRootPart.Position).Unit
				char.HumanoidRootPart.CFrame = CFrame.new(char.HumanoidRootPart.Position, char.HumanoidRootPart.Position + lookDir)

				-- Đánh mục tiêu (giả lập click)
				mouse1click()

				-- Hiển thị máu
				local hp = math.floor(target.Humanoid.Health)
				local maxHp = math.floor(target.Humanoid.MaxHealth)
				healthLabel.Text = "HP: " .. hp .. "/" .. maxHp
			else
				healthLabel.Text = "Không có mục tiêu"
			end
		end
	end
end)