-- Tải thư viện OrionLib cho menu
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Tạo cửa sổ menu
local Window = OrionLib:MakeWindow({
    Name = "đông phan | vòng boss",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "dongphan"
})

-- Biến điều khiển
_G.AutoFarm = false
_G.Radius = 15
_G.Speed = 5
_G.MenuVisible = true

-- Hàm tìm boss gần nhất
function GetNearestBoss()
    local nearest
    local shortest = math.huge
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Name:lower():find("boss") then
            local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                nearest = v
            end
        end
    end
    return nearest
end

-- Hàm chạy vòng quanh boss và đánh
task.spawn(function()
    while true do
        if _G.AutoFarm then
            local boss = GetNearestBoss()
            if boss then
                local angle = tick() * _G.Speed
                local x = math.cos(angle) * _G.Radius
                local z = math.sin(angle) * _G.Radius
                local targetPos = boss.HumanoidRootPart.Position + Vector3.new(x, 0, z)
                game.Players.LocalPlayer.Character.Humanoid:MoveTo(targetPos)

                -- Tự đánh nếu có vũ khí
                local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end
        task.wait(0.1)
    end
end)

-- Tab chính
local MainTab = Window:MakeTab({Name = "Auto Fram Boss", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
    Name = "Bật vòng boss + đánh",
    Default = false,
    Callback = function(v)
        _G.AutoFarm = v
    end
})

MainTab:AddSlider({
    Name = "Bán kính vòng (m)",
    Min = 5,
    Max = 50,
    Default = 15,
    Increment = 1,
    ValueName = "m",
    Callback = function(v)
        _G.Radius = v
    end
})

MainTab:AddSlider({
    Name = "Tốc độ vòng",
    Min = 1,
    Max = 20,
    Default = 5,
    Increment = 1,
    ValueName = "",
    Callback = function(v)
        _G.Speed = v
    end
})

MainTab:AddButton({
    Name = "Ẩn menu",
    Callback = function()
        OrionLib:Destroy()
        _G.MenuVisible = false
        print("Menu đã ẩn.")
    end
})

-- Nếu bạn muốn hiển thị lại menu sau khi ẩn (mobile), có thể dùng phím tắt hoặc delay
task.spawn(function()
    while true do
        if not _G.MenuVisible then
            wait(10)
            loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
            print("Menu hiện lại.")
            break
        end
        wait(1)
    end
end)

-- Thông báo
OrionLib:MakeNotification({
    Name = "dong phan",
    Content = "Chạy vòng boss + đánh đã sẵn sàng",
    Time = 5
})