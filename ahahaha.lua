-- GUI Đơn Giản
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SpinMenu"
gui.ResetOnSpawn = false

-- Nút mở menu
local toggleMenuBtn = Instance.new("TextButton", gui)
toggleMenuBtn.Size = UDim2.new(0, 100, 0, 30)
toggleMenuBtn.Position = UDim2.new(0, 10, 0, 10)
toggleMenuBtn.Text = "Mở Menu"
toggleMenuBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
toggleMenuBtn.TextColor3 = Color3.new(1, 1, 1)

-- Khung menu
local menuFrame = Instance.new("Frame", gui)
menuFrame.Size = UDim2.new(0, 200, 0, 180)
menuFrame.Position = UDim2.new(0, 10, 0, 50)
menuFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuFrame.Visible = false

-- Nút bật/tắt script
local toggleScriptBtn = Instance.new("TextButton", menuFrame)
toggleScriptBtn.Size = UDim2.new(0, 180, 0, 30)
toggleScriptBtn.Position = UDim2.new(0, 10, 0, 10)
toggleScriptBtn.Text = "Bật Script"
toggleScriptBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
toggleScriptBtn.TextColor3 = Color3.new(1, 1, 1)

-- Bán kính đánh
local radiusBox = Instance.new("TextBox", menuFrame)
radiusBox.Size = UDim2.new(0, 180, 0, 30)
radiusBox.Position = UDim2.new(0, 10, 0, 50)
radiusBox.PlaceholderText = "Bán kính vòng tròn (mặc định: 10)"
radiusBox.Text = ""

-- Tốc độ xoay
local speedBox = Instance.new("TextBox", menuFrame)
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 90)
speedBox.PlaceholderText = "Tốc độ chạy vòng (mặc định: 2)"
speedBox.Text = ""

-- Nút đóng menu
local closeMenuBtn = Instance.new("TextButton", menuFrame)
closeMenuBtn.Size = UDim2.new(0, 180, 0, 30)
closeMenuBtn.Position = UDim2.new(0, 10, 0, 130)
closeMenuBtn.Text = "Đóng Menu"
closeMenuBtn.BackgroundColor3 = Color3.new(0.3, 0.1, 0.1)
closeMenuBtn.TextColor3 = Color3.new(1, 1, 1)

-- Toggle menu
toggleMenuBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible
end)

closeMenuBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = false
end)

-- Script logic
local running = false

toggleScriptBtn.MouseButton1Click:Connect(function()
	running = not running
	toggleScriptBtn.Text = running and "Tắt Script" or "Bật Script"

	if running then
		spawn(function()
			local Players = game:GetService("Players")
			local RunService = game:GetService("RunService")
			local LocalPlayer = Players.LocalPlayer
			local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
			local HRP = Character:WaitForChild("HumanoidRootPart")

			while running and task.wait() do
				-- Tìm mục tiêu chứa tên "CityNPC"
				local target = nil
				local minDist = math.huge
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and string.find(v.Name, "CityNPC") then
						local dist = (v.HumanoidRootPart.Position - HRP.Position).Magnitude
						if dist < minDist then
							minDist = dist
							target = v
						end
					end
				end

				if target then
					-- Tham số bán kính và tốc độ
					local radius = tonumber(radiusBox.Text) or 10
					local speed = tonumber(speedBox.Text) or 2
					local angle = 0

					while running and target and target:FindFirstChild("HumanoidRootPart") do
						task.wait()
						local targetPos = target.HumanoidRootPart.Position
						angle += speed * 0.05
						local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
						local destination = targetPos + offset

						-- Di chuyển nhân vật đến điểm (không teleport)
						local direction = (destination - HRP.Position).Unit
						HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + direction) -- Hướng nhìn
						Character:MoveTo(destination)

						-- Quay như chong chóng
						HRP.CFrame = HRP.CFrame * CFrame.Angles(0, math.rad(20), 0)
					end
				end
			end
		end)
	end
end)