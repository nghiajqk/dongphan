-- GUI menu
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Visible = true

local function CreateButton(text, posY)
	local button = Instance.new("TextButton", Frame)
	button.Size = UDim2.new(1, -10, 0, 30)
	button.Position = UDim2.new(0, 5, 0, posY)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.TextColor3 = Color3.new(1,1,1)
	button.Text = text
	button.Font = Enum.Font.SourceSansBold
	button.TextSize = 18
	return button
end

local running = false
local menuVisible = true

local toggleScript = CreateButton("🌀 Bật Script", 10)
local toggleMenu = CreateButton("📴 Đóng Menu", 50)

-- Tìm NPC gần nhất
function getNearestTarget()
	local closest = nil
	local shortest = math.huge
	for _, npc in pairs(workspace:GetDescendants()) do
		if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
			local dist = (npc.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortest and dist <= 100 then
				shortest = dist
				closest = npc
			end
		end
	end
	return closest
end

-- Vòng xoay
spawn(function()
	local angle = 0
	local radius = 24
	local speed = 1 -- tốc độ quay, càng cao quay càng nhanh

	while task.wait(0.03) do
		if running then
			local player = game.Players.LocalPlayer
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local target = getNearestTarget()

			if hrp and target and target:FindFirstChild("HumanoidRootPart") then
				angle += speed * 0.03
				local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
				local targetPos = target.HumanoidRootPart.Position + offset
				hrp.CFrame = CFrame.new(targetPos, target.HumanoidRootPart.Position)

				-- Auto đánh
				mouse1click()
			end
		end
	end
end)

-- Nút bấm
toggleScript.MouseButton1Click:Connect(function()
	running = not running
	toggleScript.Text = running and "✅ Đang chạy" or "🌀 Bật Script"
end)

toggleMenu.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	Frame.Visible = menuVisible
end)