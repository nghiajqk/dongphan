--===[ GUI KHỞI TẠO ]===-- local player = game.Players.LocalPlayer local char = player.Character or player.CharacterAdded:Wait() local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui) gui.Name = "FramMenuMobile" gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 240, 0, 500) frame.Position = UDim2.new(0, 20, 0.3, 0) frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) frame.BackgroundTransparency = 0.2 frame.BorderSizePixel = 0

local uilist = Instance.new("UIListLayout", frame) uilist.Padding = UDim.new(0, 6) uilist.SortOrder = Enum.SortOrder.LayoutOrder

local function createButton(text) local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(1, 0, 0, 32) btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) btn.TextColor3 = Color3.new(1, 1, 1) btn.Font = Enum.Font.SourceSansBold btn.TextSize = 18 btn.Text = text return btn end

local function createInput(placeholder) local box = Instance.new("TextBox", frame) box.Size = UDim2.new(1, 0, 0, 32) box.BackgroundColor3 = Color3.fromRGB(70, 70, 70) box.TextColor3 = Color3.new(1, 1, 1) box.Font = Enum.Font.SourceSans box.TextSize = 16 box.PlaceholderText = placeholder return box end

--===[ INPUTS + NÚT ]===-- local distanceBox = createInput("Khoảng cách (vd: 10)") local speedBox = createInput("Tốc độ chạy (vd: 3)")

local running = false local showHitbox = false

local runBtn = createButton("Chạy vòng quanh mục tiêu") runBtn.MouseButton1Click:Connect(function() running = not running runBtn.Text = running and "Đang chạy quanh mục tiêu" or "Chạy vòng quanh mục tiêu" end)

local hitboxBtn = createButton("Hiển thị vùng đánh [OFF]") hitboxBtn.MouseButton1Click:Connect(function() showHitbox = not showHitbox hitboxBtn.Text = "Hiển thị vùng đánh [" .. (showHitbox and "ON" or "OFF") .. "]" end)

--===[ HÀM TÌM MỤC TIÊU GẦN NHẤT ]===-- local function getNearestEnemy() local minDist = math.huge local nearest = nil for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and v ~= char and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then local dist = (v.HumanoidRootPart.Position - hrp.Position).Magnitude if dist < minDist then minDist = dist nearest = v end end end return nearest end

--===[ VÒNG LẶP DI

