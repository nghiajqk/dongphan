--// DongPhan Menu Script Gộp Hoàn Chỉnh local Players = game:GetService("Players") local RunService = game:GetService("RunService") local lp = Players.LocalPlayer local char = lp.Character or lp.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local hrp = char:WaitForChild("HumanoidRootPart")

-- UI Setup local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui")) gui.Name = "DongPhanMenu"

local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 250, 0, 180) frame.Position = UDim2.new(0, 20, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) frame.Visible = true

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 30) title.Text = "DongPhan Fram Menu" title.TextColor3 = Color3.new(1, 1, 1) title.BackgroundTransparency = 1

local toggleBtn = Instance.new("TextButton", frame) toggleBtn.Size = UDim2.new(0, 200, 0, 30) toggleBtn.Position = UDim2.new(0, 25, 0, 40) toggleBtn.Text = "Bật Fram"

local radiusBox = Instance.new("TextBox", frame) radiusBox.Size = UDim2.new(0, 100, 0, 25) radiusBox.Position = UDim2.new(0, 10, 0, 80) radiusBox.Text = "Bán kính"

local speedBox = Instance.new("TextBox", frame) speedBox.Size = UDim2.new(0, 100, 0, 25) speedBox.Position = UDim2.new(0, 130, 0, 80) speedBox.Text = "Tốc độ"

local hideBtn = Instance.new("TextButton", frame) hideBtn.Size = UDim2.new(0, 200, 0, 25) hideBtn.Position = UDim2.new(0, 25, 0, 120) hideBtn.Text = "Ẩn Menu"

-- Logic local running = false local radius = 20 local speed = 3 local angle = 0 local target = nil

local function getNearestTarget() local minDist = math.huge local found = nil for _,v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude if dist < minDist and v.Humanoid.Health > 0 then minDist = dist found = v end end end return found end

RunService.Heartbeat:Connect(function(dt) if not running then return end if not char or not hrp then return end if not target or target.Humanoid.Health <= 0 then target = getNearestTarget() if not target then return end end

local tPos = target.HumanoidRootPart.Position
local dist = (tPos - hrp.Position).Magnitude

if dist > radius + 5 then
	hum:MoveTo(tPos)
else
	angle += dt * speed
	local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
	local moveToPos = tPos + offset
	hum:MoveTo(moveToPos)

	local look = (tPos - hrp.Position).Unit
	hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(look.X, 0, look.Z))

	local tool = char:FindFirstChildOfClass("Tool")
	if tool then tool:Activate() end
end

end)

-- Button actions toggleBtn.MouseButton1Click:Connect(function() running = not running toggleBtn.Text = running and "Tắt Fram" or "Bật Fram" target = nil radius = tonumber(radiusBox.Text) or 20 speed = tonumber(speedBox.Text) or 3 end)

hideBtn.MouseButton1Click:Connect(function() frame.Visible = false wait(1) frame.Visible = true end)

