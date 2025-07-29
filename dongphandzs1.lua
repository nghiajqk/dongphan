-- Menu GUI đơn giản
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 160)
Frame.Position = UDim2.new(0, 50, 0, 100)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Visible = true

-- Toggle buttons
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

-- Toggle trạng thái
local running = false
local menuVisible = true

local toggleScript = CreateButton("🌀 Bật Script", 10)
local toggleMenu = CreateButton("📴 Đóng Menu", 50)

-- Tìm mục tiêu gần nhất
function getNearestTarget()
	local closest = nil
	local shortest = math.huge
	for _, npc in pairs(workspace:GetDescendants()) do
		if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
			local dist = (npc.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if dist < shortest and dist <= 50 then -- chỉ lấy mục tiêu dưới 50m
				shortest = dist
				closest = npc
			end
		end
	end
	return closest
end

-- Auto vòng quanh boss + đánh
spawn(function()
	while task.wait(0.1) do
		if running then
			local char = game.Players.LocalPlayer.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local target = getNearestTarget()
			if hrp and target and target:FindFirstChild("HumanoidRootPart") then
				local angle = tick() % 6.28 -- quay theo thời gian
				local radius = 10
				local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
				local pos = target.HumanoidRootPart.Position + offset
				hrp.CFrame = CFrame.new(pos, target.HumanoidRootPart.Position)

				-- Tự đánh (giả lập click)
				mouse1click()
			end
		end
	end
end)

-- Button sự kiện
toggleScript.MouseButton1Click:Connect(function()
	running = not running
	toggleScript.Text = running and "✅ Đang chạy" or "🌀 Bật Script"
end)

toggleMenu.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	Frame.Visible = menuVisible
end)