-- Made by @ChatGPT VN | Bản Bay & AutoAttack + GUI Toggle

-- Library UI
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/Zj8s8t1L"))() 
local Window = Library:CreateWindow("Việt Nam Combat Menu")
local MainTab = Window:CreateTab("Chính")
local SettingsTab = Window:CreateTab("Cài Đặt")

-- Biến Toggle
local flyEnabled = false
local attackEnabled = false

-- Bay quanh mục tiêu
function flyAroundTarget(target)
    spawn(function()
        while flyEnabled and target and target.Parent do
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos = target.Position + Vector3.new(math.sin(tick()) * 10, 5, math.cos(tick()) * 10)
                char:MoveTo(pos)
                wait(0.1)
            end
        end
    end)
end

-- Tìm mục tiêu gần nhất
function getClosestTarget()
    local player = game.Players.LocalPlayer
    local char = player.Character
    local closest, distance = nil, math.huge

    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v ~= char then
            local dist = (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
            if dist < distance then
                distance = dist
                closest = v.HumanoidRootPart
            end
        end
    end

    return closest
end

-- Tự động đánh
function autoAttack()
    spawn(function()
        while attackEnabled do
            local target = getClosestTarget()
            if target then
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(target)
            end
            wait(0.3)
        end
    end)
end

-- Menu Toggle
MainTab:CreateToggle("🛫 Bật chế độ Bay quanh địch", function(state)
    flyEnabled = state
    if state then
        local target = getClosestTarget()
        if target then
            flyAroundTarget(target)
        end
    end
end)

MainTab:CreateToggle("⚔️ Auto Attack mục tiêu", function(state)
    attackEnabled = state
    if state then
        autoAttack()
    end
end)

SettingsTab:CreateButton("❌ Tắt GUI", function()
    Library:Destroy()
end)