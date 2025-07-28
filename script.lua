--// GUI tạo nút bật tắt
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Name = "FlyGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

ToggleButton.Name = "ToggleFly"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
ToggleButton.Position = UDim2.new(0.02, 0, 0.3, 0)
ToggleButton.Size = UDim2.new(0, 120, 0, 40)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "Bật Bay"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 22

--// Tính năng bay
local flying = false
local player = game.Players.LocalPlayer
local humanoid = player.Character:WaitForChild("HumanoidRootPart")

-- Hàm bắt đầu bay
local function startFlying()
    spawn(function()
        while flying do
            humanoid.Velocity = Vector3.new(0, 100, 0) -- bay tuốt lên trời
            wait(0.1)
        end
    end)
end

-- Nút bật/tắt
ToggleButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        ToggleButton.Text = "Tắt Bay"
        startFlying()
    else
        ToggleButton.Text = "Bật Bay"
        humanoid.Velocity = Vector3.new(0, -100, 0) -- rớt xuống nhanh
    end
end)