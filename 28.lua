local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "DongPhanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 180)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DongPhan Fram Menu"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local startBtn = Instance.new("TextButton", frame)
startBtn.Position = UDim2.new(0, 10, 0, 40)
startBtn.Size = UDim2.new(0, 100, 0, 30)
startBtn.Text = "Bật Fram"
startBtn.BackgroundColor3 = Color3.fromRGB(60, 150, 60)

local radiusBox = Instance.new("TextBox", frame)
radiusBox.Position = UDim2.new(0, 10, 0, 80)
radiusBox.Size = UDim2.new(0, 100, 0, 25)
radiusBox.Text = "24" -- tầm đánh
radiusBox.PlaceholderText = "Tầm đánh"

local speedBox = Instance.new("TextBox", frame)
speedBox.Position = UDim2.new(0, 10, 0, 115)
speedBox.Size = UDim2.new(0, 100, 0, 25)
speedBox.Text = "3" -- tốc độ xoay
speedBox.PlaceholderText = "Tốc độ xoay"

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Position = UDim2.new(0, 120, 0, 40)
hideBtn.Size = UDim2.new(0, 100, 0, 30)
hideBtn.Text = "Ẩn menu"
hideBtn.BackgroundColor3 = Color3.fromRGB(180, 60, 60)

local running = false
local angle = 0

function getNearestTarget()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
			local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
			if dist <= 100 then
				return v
			end
		end
	end
end

RunService.Heartbeat:Connect(function(dt)
	if not running then return end

	local target = getNearestTarget()
	if target and target:FindFirstChild("HumanoidRootPart") then
		local targetPos = target.HumanoidRootPart.Position
		local radius = tonumber(radiusBox.Text) or 24
		local speed = tonumber(speedBox.Text) or 3
		local dist = (hrp.Position - targetPos).Magnitude

		if dist > radius then
			hum:MoveTo(targetPos)
		else
			angle = angle + dt * speed
			local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
			local movePos = targetPos + offset
			hum:MoveTo(movePos)

			local lookDir = (targetPos - hrp.Position).Unit
			hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookDir)

			local tool = char:FindFirstChildOfClass("Tool")
			if tool then
				pcall(function() tool:Activate() end)
			end
		end
	end
end)

startBtn.MouseButton1Click:Connect(function()
	running = not running
	startBtn.Text = running and "Tắt Fram" or "Bật Fram"
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	local openBtn = Instance.new("TextButton", gui)
	openBtn.Size = UDim2.new(0, 100, 0, 30)
	openBtn.Position = UDim2.new(0, 10, 0, 10)
	openBtn.Text = "Hiện Menu"
	openBtn.Parent = gui
	openBtn.MouseButton1Click:Connect(function()
		frame.Visible = true
		openBtn:Destroy()
	end)
end)