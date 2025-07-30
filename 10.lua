-- GUI đơn giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SafeFramBossGui"
gui.ResetOnSpawn = false

-- Toggle menu
local open = false
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Mở Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 60)
frame.Visible = false
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Tùy chỉnh bán kính
local radSlider = Instance.new("TextBox", frame)
radSlider.Size = UDim2.new(0, 180, 0, 30)
radSlider.Position = UDim2.new(0, 10, 0, 10)
radSlider.Text = "Bán kính: 24"

-- Tùy chỉnh tốc độ
local spdSlider = Instance.new("TextBox", frame)
spdSlider.Size = UDim2.new(0, 180, 0, 30)
spdSlider.Position = UDim2.new(0, 10, 0, 50)
spdSlider.Text = "Tốc độ: 3"

-- Bật/Tắt Script
local toggleScript = Instance.new("TextButton", frame)
toggleScript.Size = UDim2.new(0, 180, 0, 40)
toggleScript.Position = UDim2.new(0, 10, 0, 90)
toggleScript.Text = "Bật Script"
toggleScript.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
toggleScript.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Hiển thị máu mục tiêu
local healthLabel = Instance.new("TextLabel", frame)
healthLabel.Size = UDim2.new(0, 180, 0, 30)
healthLabel.Position = UDim2.new(0, 10, 0, 140)
healthLabel.Text = "Máu: 0"
healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
healthLabel.BackgroundTransparency = 1

-- Toggle menu logic
toggleBtn.MouseButton1Click:Connect(function()
	open = not open
	frame.Visible = open
	toggleBtn.Text = open and "Đóng Menu" or "Mở Menu"
end)

-- Fram Boss Logic
local running = false
toggleScript.MouseButton1Click:Connect(function()
	running = not running
	toggleScript.Text = running and "Tắt Script" or "Bật Script"
end)

-- Chạy vòng tròn quanh mục tiêu gần nhất
task.spawn(function()
	while task.wait(0.1) do
		if running then
			local player = game.Players.LocalPlayer
			local char = player.Character
			if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then continue end

			-- Bán kính & tốc độ
			local radius = tonumber(radSlider.Text:match("%d+")) or 24
			local speed = tonumber(spdSlider.Text:match("%d+")) or 3

			-- Tìm mục tiêu gần nhất
			local nearest, minDist = nil, math.huge
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
					local dist = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
					if dist < minDist and dist < 100 then
						minDist = dist
						nearest = v
					end
				end
			end

			if nearest then
				-- Aim vào mục tiêu
				local lookPos = nearest.HumanoidRootPart.Position
				local charPos = char.HumanoidRootPart.Position
				char.HumanoidRootPart.CFrame = CFrame.new(charPos, lookPos)

				-- Chạy vòng tròn
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
				local moveTo = nearest.HumanoidRootPart.Position + offset
				char:MoveTo(moveTo)

				-- Hiển thị máu
				healthLabel.Text = "Máu: " .. math.floor(nearest.Humanoid.Health)

				-- Đánh tự động (nếu có công cụ hoặc kỹ năng dùng được)
				for _, tool in ipairs(player.Backpack:GetChildren()) do
					if tool:IsA("Tool") then
						tool.Parent = char
						tool:Activate()
					end
				end
			else
				healthLabel.Text = "Không tìm thấy mục tiêu"
			end
		end
	end
end)