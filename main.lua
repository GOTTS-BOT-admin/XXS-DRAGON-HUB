-- ライブラリ読み込み待機とエラー防止
local Success, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end)

if not Success or not Fluent then
    warn("Fluentライブラリの読み込みに失敗しました。")
    return
end

-- [[ 🗝️ MAIN WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB v4.0",
    SubTitle = "MOBILE ULTIMATE EDITION",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- 重くなる原因をオフ
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- スマホ用フローティングボタン（これがないとスマホで閉じたら最後なので必須）
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 90, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = "GothamBold"
OpenBtn.Draggable = true
local Corner = Instance.new("UICorner", OpenBtn); Corner.CornerRadius = UDim.new(0, 10)

OpenBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- [[ 📂 TABS 作成（ここでエラーが出ないよう安全に定義） ]]
local Tabs = {
    Movement = Window:AddTab({ Title = "Movement", Icon = "run" }),
    Combat = Window:AddTab({ Title = "Combat/BAN", Icon = "sword" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
    World = Window:AddTab({ Title = "World", Icon = "globe" }),
    Extra = Window:AddTab({ Title = "Extra", Icon = "plus" })
}

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, JumpPower, Target, bS = 16, 50, "", 20

-- [[ 🏃 1. MOVEMENT ]]
Tabs.Movement:AddSlider("Spd", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 500, Rounding = 0, Callback = function(v) WalkSpeed = v end })
Tabs.Movement:AddSlider("Jmp", { Title = "JumpPower", Default = 50, Min = 50, Max = 500, Rounding = 0, Callback = function(v) JumpPower = v end })
local TpWalk = Tabs.Movement:AddToggle("TpW", {Title = "TP Walk (最速移動)", Default = false})
local FlyToggle = Tabs.Movement:AddToggle("Fly", {Title = "Fly (飛行)", Default = false})
local NcToggle = Tabs.Movement:AddToggle("Nc", {Title = "Noclip (壁抜け)", Default = false})
local InfJump = Tabs.Movement:AddToggle("InfJ", {Title = "Infinite Jump", Default = false})

-- [[ 💥 2. COMBAT / BAN ]]
local HamToggle = Tabs.Combat:AddToggle("Ham", {Title = "BAN HAMMER Mode", Default = false})
Tabs.Combat:AddButton({
    Title = "🔨 SWING HAMMER / 攻撃実行",
    Callback = function() if HamToggle.Value then HammerAttack() end end
})
local Hitbox = Tabs.Combat:AddToggle("Hb", {Title = "Big Hitbox (判定拡大)", Default = false})

-- [[ 👁️ 3. VISUAL ]]
local EspToggle = Tabs.Visual:AddToggle("Esp", {Title = "Name ESP", Default = false})
local FullBright = Tabs.Visual:AddToggle("FB", {Title = "Full Bright (夜消し)", Default = false})

-- [[ 😏 4. SUS ]]
local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG (ピストン運動)", Default = false})
local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Target Player", Values = {}, Callback = function(v) Target = v end })
Tabs.Sus:AddButton({Title = "🔄 Refresh Players", Callback = function() 
    local t={}; for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then table.insert(t,v.Name) end end; Dropdown:SetValues(t) 
end})
Tabs.Sus:AddSlider("bS", { Title = "Action Speed", Default = 20, Min = 1, Max = 100, Rounding = 0, Callback = function(v) bS = v end })
Tabs.Sus:AddButton({Title = "🧲 Bring All (全員集合)", Callback = function() 
    for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then v.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end end 
end})

-- [[ 🌍 5. WORLD ]]
Tabs.World:AddSlider("Grav", { Title = "Gravity", Default = 196, Min = 0, Max = 500, Rounding = 0, Callback = function(v) workspace.Gravity = v end })
local AntiAfk = Tabs.World:AddToggle("Afk", {Title = "Anti-AFK", Default = true})

-- [[ ➕ 6. EXTRA ]]
Tabs.Extra:AddButton({Title = "✨ Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, lp) end})
Tabs.Extra:AddButton({Title = "🛑 FPS Unlocker", Callback = function() setfpscap(999) end})

-- [[ 🔨 BAN HAMMER 演出 ]]
function HammerAttack()
    local root = lp.Character.HumanoidRootPart
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s.PlaybackSpeed = 0.35; s:Play(); game.Debris:AddItem(s, 3)
    for i=1,5 do
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(5,5,5); b.CFrame = root.CFrame; b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function() for x=1,25 do b.Size = b.Size + Vector3.new(15,15,15); b.Transparency = x/25; task.wait(0.01) end b:Destroy() end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 45 then
                local char = v.Character
                for _,p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.new(1,0,0); p.Material = "Neon"; task.delay(1.5, function() pcall(function() p.Material = "Plastic"; p.Color = Color3.new(1,1,1) end) end) end end
                local g = Instance.new("BillboardGui", char.Head); g.Size = UDim2.new(0,400,0,200); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,8,0)
                local t1 = Instance.new("TextLabel", g); t1.Size = UDim2.new(1,0,0.5,0); t1.BackgroundTransparency = 1; t1.Text = "HITHIT!!!"; t1.TextColor3 = Color3.new(1,1,1); t1.Font = "GothamBlack"; t1.TextSize = 80; t1.TextStrokeTransparency = 0
                local t2 = Instance.new("TextLabel", g); t2.Position = UDim2.new(0,0,0.5,0); t2.Size = UDim2.new(1,0,0.5,0); t2.BackgroundTransparency = 1; t2.Text = "BANNED!!!"; t2.TextColor3 = Color3.new(1,0,0); t2.Font = "GothamBlack"; t2.TextSize = 100; t2.TextStrokeTransparency = 0
                game.Debris:AddItem(g, 2)
            end
        end
    end
end

-- [[ 🔄 物理ループ ]]
rs.RenderStepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Speed / TP Walk
    if TpWalk.Value and char.Humanoid.MoveDirection.Magnitude > 0 then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (char.Humanoid.MoveDirection * (WalkSpeed / 45))
    else
        char.Humanoid.WalkSpeed = WalkSpeed
    end
    char.Humanoid.JumpPower = JumpPower

    -- Noclip
    if NcToggle.Value then
        for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end

    -- Fly
    if FlyToggle.Value then
        char.HumanoidRootPart.Velocity = (workspace.CurrentCamera.CFrame.LookVector * WalkSpeed * 1.3) + Vector3.new(0, 2, 0)
    end

    -- BANG (背後固定)
    if BangToggle.Value and Target ~= "" and game.Players:FindFirstChild(Target) then
        local targetChar = game.Players[Target].Character
        if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1 + math.sin(tick() * bS) * 1.0)
        end
    end
end)

-- 無限ジャンプ
uis.JumpRequest:Connect(function()
    if InfJump.Value then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Window:SelectTab(1)
