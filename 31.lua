local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DongPhanMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DongPhan"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local farmBtn = Instance.new("TextButton", frame)
farmBtn.Size = UDim2.new(0, 100, 0, 30)
farmBtn.Position = UDim2.new(0, 10, 0, 40)
farmBtn.Text = "Bật Farm"
farmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
farmBtn.TextColor3 = Color3.new(1, 1, 1)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0, 100, 0, 30)
hideBtn.Position = UDim2.new(0, 130, 0, 40)
hideBtn.Text = "Ẩn Menu"
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
hideBtn.TextColor3 = Color3.new(0, 0, 0)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Size = UDim2.new(0, 100, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 80)
radiusBox.Text = "10" -- Bán kính
radiusBox.PlaceholderText = "Bán kính"

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0, 100, 0, 30)
speedBox.Position = UDim2.new(0, 130, 0, 80)
speedBox.Text = "2" -- Tốc độ
speedBox.PlaceholderText = "Tốc độ"

-- Logic
local run = false
farmBtn.MouseButton1Click:Connect(function()
	run = not run
	if run then
		farmBtn.Text = "Đang Farm"
		farmBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	else
		farmBtn.Text = "Bật Farm"
		farmBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	end
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Vòng farm
task.spawn(function()
	while true do
		task.wait(0.1)
		if run then
			local radius = tonumber(radiusBox.Text) or 10
			local speed = tonumber(speedBox.Text) or 2

			-- Tìm mục tiêu gần nhất
			local closest = nil
			local shortest = math.huge
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
					local root = v:FindFirstChild("HumanoidRootPart")
					if root then
						local dist = (hrp.Position - root.Position).Magnitude
						if dist < shortest and dist < 100 then
							shortest = dist
							closest = v
						end
					end
				end
			end

			-- Di chuyển đến mục tiêu
			if closest and closest:FindFirstChild("HumanoidRootPart") then
				local targetRoot = closest.HumanoidRootPart
				local dist = (hrp.Position - targetRoot.Position).Magnitude

				-- Nếu chưa tới gần thì MoveTo
				if dist > radius + 2 then
					humanoid:MoveTo(targetRoot.Position)
				else
					-- Chạy vòng tròn quanh mục tiêu
					local t = tick()
					local x = math.cos(t * speed) * radius
					local z = math.sin(t * speed) * radius
					local movePos = targetRoot.Position + Vector3.new(x, 0, z)
					humanoid:MoveTo(movePos)

					-- Auto hướng mặt về mục tiêu
					local dir = (targetRoot.Position - hrp.Position).Unit
					hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(dir.X, 0, dir.Z))
				end
			end
		end
	end
end)