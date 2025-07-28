local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
local ToggleButton = Instance.new("TextButton", Frame)

-- GUI Properties
ScreenGui.Name = "FlyGui"
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

ToggleButton.Size = UDim2.new(1, 0, 0.5, 0)
ToggleButton.Position = UDim2.new(0, 0, 0, 25)
ToggleButton.Text = "Bật Bay"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50,150,250)
ToggleButton.TextColor3 = Color3.new(1,1,1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

-- Bay lên trời
local flying = false
local UIS = game:GetService("UserInputService")

local function flyUp()
    local hrp = character:WaitForChild("HumanoidRootPart")
    while flying and character and hrp do
        hrp.Velocity = Vector3.new(0, 150, 0)  -- bay tuốt lên
        wait(0.1)
    end
end

-- Toggle logic
ToggleButton.MouseButton1Click:Connect(function()
    flying = not flying
    ToggleButton.Text = flying and "Tắt Bay" or "Bật Bay"
    if flying then
        flyUp()
    end
end)