--// UI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SimpleMenu"
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function createBtn(txt, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = txt
	return btn
end

local toggle = false
local radius = 10
local speed = 3
local target = nil
local running = false

-- UI Buttons
local toggleScriptBtn = createBtn("🟢 Bật Script", 10)
local setTargetBtn = createBtn("🎯 Tìm NPC", 50)
local radiusBtn = createBtn("📏 Bán kính: 10", 90)
local speedBtn = createBtn("⚡ Tốc độ: 3", 130)
local healthLabel = createBtn("❤️ Máu: 0", 170)
healthLabel.AutoButtonColor = false
local closeMenuBtn = createBtn("❌ Đóng Menu", 210)

--// Functions
function findNearestNPC()
	local char = game.Players.LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local nearest, minDist = nil, math.huge
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
			if string.find(v.Name, "NPC") or string.find(v.Name, "npc") then
				local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
				if dist < minDist then
					minDist = dist
					nearest = v
				end
			end
		end
	end
	return nearest
end

--// Auto Attack and Circle
spawn(function()
	while wait() do
		if toggle and target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") then
			local char = game.Players.LocalPlayer.Character
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				-- Vòng tròn quanh mục tiêu
				local tPos = target.HumanoidRootPart.Position
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle)*radius, 0, math.sin(angle)*radius)
				hrp.CFrame = CFrame.new(tPos + offset, tPos)

				-- Tự động đánh (nếu có tool hoặc animation thì chỉnh thêm)
				if char:FindFirstChildOfClass("Tool") then
					char:FindFirstChildOfClass("Tool"):Activate()
				end

				-- Cập nhật máu
				local hp = math.floor(target.Humanoid.Health)
				healthLabel.Text = "❤️ Máu: " .. hp
			end
		end
	end
end)

--// Button logic
toggleScriptBtn.MouseButton1Click:Connect(function()
	toggle = not toggle
	toggleScriptBtn.Text = toggle and "🔴 Tắt Script" or "🟢 Bật Script"
end)

setTargetBtn.MouseButton1Click:Connect(function()
	target = findNearestNPC()
	if target then
		setTargetBtn.Text = "🎯 Đã chọn: " .. target.Name
	else
		setTargetBtn.Text = "❌ Không tìm thấy NPC"
	end
end)

radiusBtn.MouseButton1Click:Connect(function()
	radius = radius + 2
	if radius > 20 then radius = 6 end
	radiusBtn.Text = "📏 Bán kính: " .. radius
end)

speedBtn.MouseButton1Click:Connect(function()
	speed = speed + 1
	if speed > 8 then speed = 2 end
	speedBtn.Text = "⚡ Tốc độ: " .. speed
end)

closeMenuBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)