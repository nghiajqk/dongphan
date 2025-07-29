-- Menu UI
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "dong phan hub | vòng boss", HidePremium = false, SaveConfig = true, ConfigFolder = "dongphan"})

-- Biến điều khiển
local autoCircle = false
local autoAttack = false
local radius = 10
local speed = 1
local reduceGraphics = false

-- Tìm mục tiêu gần nhất
function getNearestEnemy()
    local nearest, dist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
            local mag = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                nearest = v
                dist = mag
            end
        end
    end
    return nearest
end

-- Di chuyển xoay vòng
task.spawn(function()
    while task.wait() do
        if autoCircle then
            local char = game.Players.LocalPlayer.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local target = getNearestEnemy()
            if root and target then
                local tpos = target.HumanoidRootPart.Position
                local angle = tick() * speed
                local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * radius
                root.CFrame = CFrame.new(tpos + offset, tpos)
            end
        end
    end
end)

-- Tự động đánh
task.spawn(function()
    while task.wait(0.3) do
        if autoAttack then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    end
end)

-- Giảm đồ họa
function setLowGraphics()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game:GetService("Lighting").FogEnd = 100
    game:GetService("Lighting").Brightness = 1
    game:GetService("Lighting").GlobalShadows = false
end

-- Tab chính
local MainTab = Window:MakeTab({Name = "Chạy vòng boss", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MainTab:AddToggle({
    Name = "Tự xoay vòng quanh boss",
    Default = false,
    Callback = function(v) autoCircle = v end
})
MainTab:AddToggle({
    Name = "Tự động đánh",
    Default = false,
    Callback = function(v) autoAttack = v end
})
MainTab:AddSlider({
    Name = "Bán kính vòng (m)",
    Min = 5,
    Max = 30,
    Default = 10,
    Increment = 1,
    Callback = function(v) radius = v end
})
MainTab:AddSlider({
    Name = "Tốc độ xoay",
    Min = 0.5,
    Max = 5,
    Default = 1,
    Increment = 0.1,
    Callback = function(v) speed = v end
})
MainTab:AddButton({
    Name = "Giảm đồ họa 70%",
    Callback = function()
        reduceGraphics = true
        setLowGraphics()
    end
})

-- Tab khác
Window:MakeTab({Name = "Menu", Icon = "rbxassetid://4483345998", PremiumOnly = false}):AddButton({
    Name = "Đóng menu",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Gọi menu
OrionLib:Init()