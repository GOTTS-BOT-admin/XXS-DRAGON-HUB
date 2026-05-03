local Success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not Success or not Fluent then return end

local Window = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB v4.0",
    SubTitle = "GALAXY EDITION",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- スマホ用フローティングボタン
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
OpenBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

-- タブ作成
local Tabs = {
    Movement = Window:AddTab({ Title = "Movement", Icon = "run" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
    World = Window:AddTab({ Title = "World", Icon = "globe" }),
    Extra = Window:AddTab({ Title = "Extra", Icon = "plus" })
}

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, JumpPower, Target, bS = 16, 50, "", 20

-- [[ 🏃 MOVEMENT ]]
Tabs.Movement:AddSlider("Spd", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 500, Rounding = 0, Callback = function(v) WalkSpeed = v end })
local TpWalk = Tabs.Movement:AddToggle("TpW", {Title = "TP Walk", Default = false})
local FlyToggle = Tabs.Movement:AddToggle("Fly", {Title = "Fly", Default = false})
local NcToggle = Tabs.Movement:AddToggle("Nc", {Title = "Noclip", Default = false})
local InfJump = Tabs.Movement:AddToggle("InfJ", {Title = "Infinite Jump", Default = false})

-- [[ 💥 COMBAT / BAN ]]
local HamToggle = Tabs.Combat:AddToggle("Ham", {Title = "BAN HAMMER Mode", Default = false})
Tabs.Combat:AddButton({ Title = "🔨 SWING HAMMER", Callback = function() if HamToggle.Value then HammerAttack() end end })

function HammerAttack()
    local root = lp.Character.HumanoidRootPart
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s.PlaybackSpeed = 0.35; s:Play()
    for i=1,5 do
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(5,5,5); b.CFrame = root.CFrame; b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function() for x=1,20 do b.Size = b.Size + Vector3.new(15,15,15); b.Transparency = x/20; task.wait(0.01) end b:Destroy() end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 50 then
                local g = Instance.new("BillboardGui", v.Character.Head); g.Size = UDim2.new(0,400,0,200); g.AlwaysOnTop = true
                local t1 = Instance.new("TextLabel", g); t1.Size = UDim2.new(1,0,0.5,0); t1.Text = "HITHIT!!!"; t1.TextColor3 = Color3.new(1,1,1); t1.TextSize = 80; t1.BackgroundTransparency = 1
                local t2 = Instance.new("TextLabel", g); t2.Position = UDim2.new(0,0,0.5,0); t2.Size = UDim2.new(1,0,0.5,0); t2.Text = "BANNED!!!"; t2.TextColor3 = Color3.new(1,0,0); t2.TextSize = 100; t2.BackgroundTransparency = 1
                game.Debris:AddItem(g, 2)
            end
        end
    end
end

-- [[ 😏 SUS ]]
local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG", Default = false})
local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Select Target", Values = {}, Callback = function(v) Target = v end })
Tabs.Sus:AddButton({Title = "🔄 Refresh", Callback = function() 
    local t={}; for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then table.insert(t,v.Name) end end; Dropdown:SetValues(t) 
end})

-- [[ 🔄 物理ループ（ここが重要！） ]]
rs.RenderStepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Speed / TP Walk
    if TpWalk.Value and char.Humanoid.MoveDirection.Magnitude > 0 then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (WalkSpeed / 45))
    else
        char.Humanoid.WalkSpeed = WalkSpeed
    end

    -- Noclip
    if NcToggle.Value then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Fly
    if FlyToggle.Value then
        char.HumanoidRootPart.Velocity = (workspace.CurrentCamera.CFrame.LookVector * WalkSpeed * 1.3) + Vector3.new(0, 2, 0)
    end

    -- BANG
    if BangToggle.Value and Target ~= "" and game.Players:FindFirstChild(Target) then
        local tChar = game.Players[Target].Character
        if tChar and tChar:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = tChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1 + math.sin(tick() * bS) * 1.0)
        end
    end
end)

-- 無限ジャンプ
uis.JumpRequest:Connect(function() if InfJump.Value then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

Window:SelectTab(1)
