-- // KHỞI TẠO DỊCH VỤ
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")

-- // BIẾN
local target = nil
local flying = false
local heightOffset = 10
local distanceOffset = 0

-- // HÀM TÌM NPC GẦN NHẤT
local function getNearestTarget()
    local closest, minDist = nil, math.huge
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            local name = npc.Name:lower()
            if string.find(name, "citynpc") or string.find(name, "npcity") then
                local dist = (npc.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = npc
                end
            end
        end
    end
    return closest
end

-- // HÀM BAY LÊN ĐẦU NPC
RunService.Heartbeat:Connect(function()
    if flying and target and target:FindFirstChild("HumanoidRootPart") then
        local pos = target.HumanoidRootPart.Position + Vector3.new(0, heightOffset, distanceOffset)
        hrp.CFrame = CFrame.new(pos, target.HumanoidRootPart.Position)
    end
end)

-- // GUI MENU
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
OrionLib:MakeWindow({
    Name = "Fram Fly Head - NghiaMinh",
    SaveConfig = true,
    ConfigFolder = "framhead"
})

-- TAB 1: FRAM
local tab1 = OrionLib:MakeTab({Name = "Fram", Icon = "rbxassetid://7734053494", PremiumOnly = false})
tab1:AddToggle({
    Name = "Bật Fram",
    Default = false,
    Callback = function(v)
        flying = v
        if v then
            target = getNearestTarget()
        end
    end
})

-- TAB 2: TÙY CHỈNH THÔNG SỐ
local tab2 = OrionLib:MakeTab({Name = "Tùy chỉnh", Icon = "rbxassetid://7734068321", PremiumOnly = false})
tab2:AddTextbox({
    Name = "khoảng cách",
    Default = "10",
    TextDisappear = false,
    Callback = function(txt)
        heightOffset = tonumber(txt) or 10
    end
})
tab2:AddTextbox({
    Name = "Khoảng cách ngang",
    Default = "0",
    TextDisappear = false,
    Callback = function(txt)
        distanceOffset = tonumber(txt) or 0
    end
})