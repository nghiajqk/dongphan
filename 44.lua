-- Khởi tạo GUI
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui")
gui.Name = "FramMenuMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0, 50, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
frame.Parent = gui

-- Tạo nút
function createButton(text, posY)
local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(0, 220, 0, 30)
btn.Position = UDim2.new(0, 10, 0, posY)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Text = text .. " [OFF]"
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 16
btn.BorderSizePixel = 0
return btn
end

-- Tạo ô nhập
function createInput(text, default, posY)
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(0, 220, 0, 20)
label.Position = UDim2.new(0, 10, 0, posY)
label.Text = text .. ": " .. default
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.TextSize = 14

local box = Instance.new("TextBox")  
box.Parent = frame  
box.Size = UDim2.new(0, 220, 0, 30)  
box.Position = UDim2.new(0, 10, 0, posY + 20)  
box.Text = tostring(default)  
box.TextColor3 = Color3.new(1, 1, 1)  
box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)  
box.Font = Enum.Font.SourceSans  
box.TextSize = 16  
box.BorderSizePixel = 0  
return box, label

end

-- Trạng thái
local running, aiming, clicking, noclip, visible = false, false, false, false, true

-- Nút và input
local framBtn = createButton("Chạy Vòng", 10)
local aimBtn = createButton("Auto Aim", 50)
local clickBtn = createButton("Auto Đánh", 90)
local noclipBtn = createButton("Noclip", 130)
local toggleGUI = createButton("Ẩn/Hiện Menu", 170)
local distanceBox, distanceLabel = createInput("Khoảng cách", 10, 210)
local speedBox, speedLabel = createInput("Tốc độ", 10, 260)

-- Toggle buttons
framBtn.MouseButton1Click:Connect(function()
running = not running
framBtn.Text = "Chạy Vòng [" .. (running and "ON" or "OFF") .. "]"
end)

aimBtn.MouseButton1Click:Connect(function()
aiming = not aiming
aimBtn.Text = "Auto Aim [" .. (aiming and "ON" or "OFF") .. "]"
end)

clickBtn.MouseButton1Click:Connect(function()
clicking = not clicking
clickBtn.Text = "Auto Đánh [" .. (clicking and "ON" or "OFF") .. "]"
end)

noclipBtn.MouseButton1Click:Connect(function()
noclip = not noclip
noclipBtn.Text = "Noclip [" .. (noclip and "ON" or "OFF") .. "]"
end)

toggleGUI.MouseButton1Click:Connect(function()
visible = not visible
frame.Visible = visible
end)

-- Tìm mục tiêu gần nhất
function getNearestEnemy()
local nearest, minDist = nil, math.huge
for _, v in pairs(workspace:GetDescendants()) do
if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char and v.Humanoid.Health > 0 then
local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude
if dist < minDist then
nearest = v
minDist = dist
end
end
end
return nearest
end

-- Auto đánh
task.spawn(function()
while true do
wait(0.1)
if clicking then
pcall(function() mouse1click() end)
end
end
end)

-- Noclip
game:GetService("RunService").Stepped:Connect(function()
if noclip then
for _, v in pairs(char:GetDescendants()) do
if v:IsA("BasePart") then
v.CanCollide = false
end
end
end
end)

-- Auto Aim
task.spawn(function()
while true do
wait()
if aiming then
local target = getNearestEnemy()
if target then
local tpos = target.HumanoidRootPart.Position
hrp.CFrame = CFrame.new(hrp.Position, tpos)
end
end
end
end)

-- Auto chạy vòng mượt bằng MoveDirection
task.spawn(function()
	while true do
		wait(0.03)
		if running and char and char:FindFirstChild("Humanoid") then
			local humanoid = char:FindFirstChild("Humanoid")
			local dist = tonumber(distanceBox.Text) or 10
			local speed = tonumber(speedBox.Text) or 2
			local target = getNearestEnemy()

			if target then
				local tpos = target.HumanoidRootPart.Position
				local angle = tick() * speed
				local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * dist
				local goalPos = tpos + offset

				local direction = (goalPos - hrp.Position)
				direction = Vector3.new(direction.X, 0, direction.Z).Unit

				-- Di chuyển bằng Move
				humanoid:Move(direction, false)

				-- Cập nhật hướng nhìn nếu cần
				hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(tpos.X, hrp.Position.Y, tpos.Z))
			else
				humanoid:Move(Vector3.zero)
			end
		end
	end
end)

-- Kéo di chuyển menu
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
dragStart = input.Position
startPos = frame.Position
input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
dragging = false
end
end)
end
end)

frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
dragInput = input
end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
if input == dragInput and dragging then
local delta = input.Position - dragStart
frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
end)