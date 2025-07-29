-- 📜 Menu "đông phan" chạy vòng boss (có auto đánh + nút tắt)

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DongPhanGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "đông phan"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local runButton = Instance.new("TextButton", frame)
runButton.Size = UDim2.new(1, 0, 0, 40)
runButton.Position = UDim2.new(0, 0, 0, 45)
runButton.Text = "chạy vòng boss"
runButton.Font = Enum.Font.SourceSansBold
runButton.TextSize = 22
runButton.TextColor3 = Color3.new(1, 1, 1)
runButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Position = UDim2.new(0, 0, 0, 95)
speedLabel.Size = UDim2.new(0, 80, 0, 25)
speedLabel.Text = "Tốc độ:"
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

local speedBox = Instance.new("TextBox", frame)
speedBox.Position = UDim2.new(0, 85, 0, 95)
speedBox.Size = UDim2.new(0, 50, 0, 25)
speedBox.Text = "2"
speedBox.TextColor3 = Color3.new(0, 0, 0)
speedBox.BackgroundColor3 = Color3.new(1, 1, 1)
speedBox.ClearTextOnFocus = false

local radiusLabel = Instance.new("TextLabel", frame)
radiusLabel.Position = UDim2.new(0, 150, 0, 95)
radiusLabel.Size = UDim2.new(0, 80, 0, 25)
radiusLabel.Text = "Bán kính:"
radiusLabel.TextSize = 18
radiusLabel.TextColor3 = Color3.new(1, 1, 1)
radiusLabel.BackgroundTransparency = 1

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Position = UDim2.new(0, 235, 0, 95)
radiusBox.Size = UDim2.new(0, 50, 0, 25)
radiusBox.Text = "15"
radiusBox.TextColor3 = Color3.new(0, 0, 0)
radiusBox.BackgroundColor3 = Color3.new(1, 1, 1)
radiusBox.ClearTextOnFocus = false

local tt = Instance.new("TextLabel", frame)
tt.Position = UDim2.new(0, 0, 0, 130)
tt.Size = UDim2.new(1, 0, 0, 30)
tt.Text = "tt:dongphandzs1"
tt.Font = Enum.Font.SourceSans
tt.TextSize = 20
tt.TextColor3 = Color3.new(1, 1, 1)
tt.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Position = UDim2.new(0, 0, 0, 165)
closeBtn.Size = UDim2.new(1, 0, 0, 35)
closeBtn.Text = "Đóng menu"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 20
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Tìm mục tiêu gần nhất
function getNearestEnemy()
	local closest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v ~= char then
			local root = v:FindFirstChild("HumanoidRootPart")
			if root then
				local dist = (root.Position - hrp.Position).Magnitude
				if dist < minDist then
					minDist = dist
					closest = root
				end
			end
		end
	end
	return closest
end

-- Auto chạy vòng & đánh
local angle = 0
local running = false

runButton.MouseButton1Click:Connect(function()
	running = not running
	runButton.Text = running and "Đang chạy vòng" or "chạy vòng boss"
end)

game:GetService("RunService").RenderStepped:Connect(function(dt)
	if running then
		local target = getNearestEnemy()
		if target then
			local speed = tonumber(speedBox.Text) or 2
			local radius = tonumber(radiusBox.Text) or 15
			angle = angle + dt * speed
			local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
			local newPos = target.Position + offset
			hrp.CFrame = CFrame.new(newPos, target.Position)

			-- Tự động đánh (click chuột)
			mouse1click()
		end
	end
end)