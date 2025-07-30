--// GUI SETUP
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "DongPhanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DongPhan"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Text = "Bật Fram"
toggleBtn.Size = UDim2.new(0, 100, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 40)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Text = "24"
radiusBox.Size = UDim2.new(0, 100, 0, 25)
radiusBox.Position = UDim2.new(0, 10, 0, 80)
radiusBox.PlaceholderText = "Bán kính"

local speedBox = Instance.new("TextBox", frame)
speedBox.Text = "3"
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Position = UDim2.new(0, 10, 0, 115)
speedBox.PlaceholderText = "Tốc độ xoay"

local hideBtn = Instance.new("TextButton", gui)
hideBtn.Text = "Ẩn/Hiện Menu"
hideBtn.Size = UDim2.new(0, 120, 0, 30)
hideBtn.Position = UDim2.new(0, 10, 0, 10)

--// LOGIC
local RunService = game:GetService("RunService")
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local running = false
local angle = 0

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

toggleBtn.MouseButton1Click:Connect(function()
	running = not running
	toggleBtn.Text = running and "Tắt Fram" or "Bật Fram"
end)

RunService.Heartbeat:Connect(function(dt)
	if not running then return end

	local radius = tonumber(radiusBox.Text) or 24
	local speed = tonumber(speedBox.Text) or 3

	-- Tìm mục tiêu gần nhất
	local target = nil
	local minDist = math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
			local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
			if dist < minDist then
				min