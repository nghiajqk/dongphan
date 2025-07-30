-- Tạo GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "AutoFarmGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0, 20, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Visible = true

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "AUTO FARM MENU"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

-- Nút bật/tắt script
local toggleScript = Instance.new("TextButton", frame)
toggleScript.Size = UDim2.new(1, -20, 0, 30)
toggleScript.Position = UDim2.new(0, 10, 0, 40)
toggleScript.Text = "BẬT SCRIPT"
toggleScript.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleScript.TextColor3 = Color3.new(1,1,1)

-- Nút đóng/mở menu
local toggleMenu = Instance.new("TextButton", frame)
toggleMenu.Size = UDim2.new(1, -20, 0, 30)
toggleMenu.Position = UDim2.new(0, 10, 0, 80)
toggleMenu.Text = "ẨN MENU"
toggleMenu.BackgroundColor3 = Color3.fromRGB(50,50,50)
toggleMenu.TextColor3 = Color3.new(1,1,1)

-- Thanh nhập tốc độ
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

-- Thanh nhập tầm đánh
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

-- Logic Auto Farm
local running = false
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

function getClosestTarget()
    local closest = nil
    local shortest = math.huge
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v ~= player.Character then
            local mag = (v.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if mag < shortest then
                shortest = mag
                closest = v
            end
        end
    end
    return closest
end

function aimAt(target)
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if hrp and target and target:FindFirstChild("HumanoidRootPart") then
        local dir = (target.HumanoidRootPart.Position - hrp.Position).Unit
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + dir)
    end
end

function showHealth(target)
    local h = target:FindFirstChild("Humanoid")
    if h then
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "Máu mục tiêu: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth);
            Color = Color3.fromRGB(255, 100, 100)
        })
    end
end

-- Di chuyển nhân vật
function moveTo(pos)
    local human = player.Character:FindFirstChildOfClass("Humanoid")
    if human then
        human:MoveTo(pos)
    end
end

-- Vòng lặp fram
RunService.RenderStepped:Connect(function()
    if running then
        local target = getClosestTarget()
        if target and target:FindFirstChild("HumanoidRootPart") then
            local myPos = player.Character.HumanoidRootPart.Position
            local targetPos = target.HumanoidRootPart.Position
            local dist = (myPos - targetPos).Magnitude

            local range = tonumber(rangeBox.Text) or 24
            local speed = tonumber(speedBox.Text) or 3

            if dist > range then
                moveTo(targetPos)
            else
                -- Bay vòng quanh
                local t = tick()
                local angle = t * speed
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * range
                local movePos = targetPos + offset
                moveTo(movePos)

                -- Aim & đánh
                aimAt(target)
                showHealth(target)
                local tool = player.Character:FindFirstChildWhichIsA("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end
    end
end)

-- Sự kiện nút
toggleScript.MouseButton1Click:Connect(function()
    running = not running
    toggleScript.Text = running and "TẮT SCRIPT" or "BẬT SCRIPT"
end)

toggleMenu.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)