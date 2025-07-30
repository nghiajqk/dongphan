-- MENU GUI
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoFarmGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.35, 0) -- Lệch trái một chút
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "AUTO FARM MENU"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local toggleScript = Instance.new("TextButton", frame)
toggleScript.Size = UDim2.new(1, -20, 0, 30)
toggleScript.Position = UDim2.new(0, 10, 0, 40)
toggleScript.Text = "BẬT SCRIPT"
toggleScript.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleScript.TextColor3 = Color3.new(1,1,1)

local toggleMenu = Instance.new("TextButton", frame)
toggleMenu.Size = UDim2.new(1, -20, 0, 30)
toggleMenu.Position = UDim2.new(0, 10, 0, 80)
toggleMenu.Text = "ẨN MENU"
toggleMenu.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleMenu.TextColor3 = Color3.new(1,1,1)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Text = "Tốc độ bay:"
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 120)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(1, -20, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 140)
speedBox.Text = "3"
speedBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
speedBox.TextColor3 = Color3.new(1,1,1)

local rangeLabel = Instance.new("TextLabel", frame)
rangeLabel.Text = "Tầm đánh:"
rangeLabel.Size = UDim2.new(1, -20, 0, 20)
rangeLabel.Position = UDim2.new(0, 10, 0, 180)
rangeLabel.BackgroundTransparency = 1
rangeLabel.TextColor3 = Color3.new(1,1,1)

local rangeBox = Instance.new("TextBox", frame)
rangeBox.Size = UDim2.new(1, -20, 0, 30)
rangeBox.Position = UDim2.new(0, 10, 0, 200)
rangeBox.Text = "24"
rangeBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
rangeBox.TextColor3 = Color3.new(1,1,1)

-- LOGIC
local running = false
local RunService = game:GetService("RunService")

function getClosestTarget()
    local closest, shortest = nil, math.huge
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
            local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < shortest and v.Humanoid.Health > 0 then
                shortest = dist
                closest = v
            end
        end
    end
    return closest
end

function moveTo(pos)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:MoveTo(pos)
    end
end

function aimAt(target)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and target:FindFirstChild("HumanoidRootPart") then
        local dir = (target.HumanoidRootPart.Position - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + dir)
    end
end

function showHealth(target)
    local h = target:FindFirstChild("Humanoid")
    if h then
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "👊 Máu mục tiêu: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth);
            Color = Color3.fromRGB(255, 120, 120)
        })
    end
end

-- AUTO FARM LOOP
RunService.Heartbeat:Connect(function()
    if not running then return end

    local target = getClosestTarget()
    if target then
        local targetHRP = target:FindFirstChild("HumanoidRootPart")
        local myHRP = char:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            local dist = (targetHRP.Position - myHRP.Position).Magnitude
            local range = tonumber(rangeBox.Text) or 24
            local speed = tonumber(speedBox.Text) or 3

            if dist > range then
                moveTo(targetHRP.Position)
            else
                local angle = tick() * speed
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * range
                moveTo(targetHRP.Position + offset)

                aimAt(target)
                showHealth(target)

                local tool = char:FindFirstChildWhichIsA("Tool")
                if tool then tool:Activate() end
            end
        end
    end
end)

-- Nút bật tắt
toggleScript.MouseButton1Click:Connect(function()
    running = not running
    toggleScript.Text = running and "TẮT SCRIPT" or "BẬT SCRIPT"
end)

toggleMenu.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)