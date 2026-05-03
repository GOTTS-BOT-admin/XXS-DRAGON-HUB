local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ 🗝️ MAIN WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB v4.0",
    SubTitle = "MOBILE OPTIMIZED | 30+ FEATURES",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- PC用
})

-- [[ 📱 スマホ用フローティングボタン ]]
-- PCのキーボードがない環境でも、このボタンでメニューの開閉ができます。
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 90, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "MENU"
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = "GothamBold"
OpenBtn.Draggable = true -- 指で好きな場所に動かせます
local Corner = Instance.new("UICorner", OpenBtn); Corner.CornerRadius = Radius.new(0, 8)

OpenBtn.MouseButton1Click:Connect(function()
    Window:Minimize() -- メニューの表示/非表示を切り替え
end)

-- [[ 📂 タブ分け (30機能搭載) ]]
local Tabs = {
    Movement = Window:AddTab({ Title = "Movement", Icon = "run" }),
    Combat = Window:AddTab({ Title = "Combat/BAN", Icon = "sword" }),
    Visual = Window:AddTab({ Title = "Visual/ESP", Icon = "eye" }),
    Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
    World = Window:AddTab({ Title = "World/Server", Icon = "globe" }),
    Extra = Window:AddTab({ Title = "Extra/Misc", Icon = "plus" })
}

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, JumpPower, Target, bS = 16, 50, "", 20

-- [[ 🏃 1. MOVEMENT (スマホでも滑らかに動く) ]]
Tabs.Movement:AddSlider("Spd", { Title = "WalkSpeed (爆速)", Default = 16, Min = 16, Max = 500, Rounding = 0, Callback = function(v) WalkSpeed = v end })
Tabs.Movement:AddSlider("Jmp", { Title = "JumpPower (高跳び)", Default = 50, Min = 50, Max = 500, Rounding = 0, Callback = function(v) JumpPower = v end })
local TpWalk = Tabs.Movement:AddToggle("TpW", {Title = "TP Walk (最速テレポート移動)", Default = false})
local FlyToggle = Tabs.Movement:AddToggle("Fly", {Title = "Fly (飛行)", Default = false})
local NcToggle = Tabs.Movement:AddToggle("Nc", {Title = "Noclip (壁抜け)", Default = false})
local InfJump = Tabs.Movement:AddToggle("InfJ", {Title = "Infinite Jump (無限ジャンプ)", Default = false})
Tabs.Movement:AddButton({Title = "🚀 TP to Target (対象へ即移動)", Callback = function() if Target ~= "" then lp.Character.HumanoidRootPart.CFrame = game.Players[Target].Character.HumanoidRootPart.CFrame end end})
local NoSlow = Tabs.Movement:AddToggle("NoS", {Title = "No Slowdown (減速防止)", Default = false})
local AutoWalk = Tabs.Movement:AddToggle("AW", {Title = "Auto Walk (自動前進)", Default = false})
local Swim = Tabs.Movement:AddToggle("Swim", {Title = "Swim Air (空中水泳)", Default = false})

-- [[ 💥 2. COMBAT / BAN (えぐい演出) ]]
local HamToggle = Tabs.Combat:AddToggle("Ham", {Title = "BAN HAMMER Mode", Default = false})
-- スマホ専用BAN攻撃ボタン
Tabs.Combat:AddButton({
    Title = "🔨 SWING HAMMER / ハンマー攻撃",
    Callback = function() if HamToggle.Value then HammerAttack() end end
})
local Hitbox = Tabs.Combat:AddToggle("Hb", {Title = "Big Hitbox (当たり判定拡大)", Default = false})
local TpAura = Tabs.Combat:AddToggle("TpA", {Title = "TP Aura (自動密着攻撃)", Default = false})
Tabs.Combat:AddButton({Title = "🛡️ God Mode (無敵化試行)", Callback = function() lp.Character.Humanoid:ChangeState(11) end})

-- [[ 👁️ 3. VISUAL / ESP ]]
local EspToggle = Tabs.Visual:AddToggle("Esp", {Title = "Name ESP", Default = false})
local Tracers = Tabs.Visual:AddToggle("Tra", {Title = "Tracers (線表示)", Default = false})
local BoxEsp = Tabs.Visual:AddToggle("Box", {Title = "Box ESP", Default = false})
local FullBright = Tabs.Visual:AddToggle("FB", {Title = "Full Bright (夜消し)", Default = false})
Tabs.Visual:AddButton({Title = "🎥 Free Cam (視点自由化)", Callback = function() --[[FreeCam]] end})

-- [[ 😏 4. SUS (正常動作版) ]]
local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG (背後固定ピストン)", Default = false})
local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Target Player", Values = {}, Callback = function(v) Target = v end })
Tabs.Sus:AddButton({Title = "🔄 Refresh Players", Callback = function() local t={}; for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then table.insert(t,v.Name) end end; Dropdown:SetValues(t) end})
Tabs.Sus:AddSlider("bS", { Title = "Action Speed", Default = 20, Min = 1, Max = 100, Rounding = 0, Callback = function(v) bS = v end })
Tabs.Sus:AddButton({Title = "🧲 Bring All (全員自分に集める)", Callback = function() for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then v.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end end end})

-- [[ 🌍 5. WORLD / SERVER ]]
Tabs.World:AddSlider("Grav", { Title = "Gravity (重力操作)", Default = 196, Min = 0, Max = 500, Rounding = 0, Callback = function(v) workspace.Gravity = v end })
Tabs.World:AddButton({Title = "❄️ Freeze All (全員フリーズ)", Callback = function() for _,v in pairs(game.Players:GetPlayers()) do if v~=lp then v.Character.HumanoidRootPart.Anchored = true end end end})
Tabs.World:AddButton({Title = "🔥 Unfreeze All (フリーズ解除)", Callback = function() for _,v in pairs(game.Players:GetPlayers()) do v.Character.HumanoidRootPart.Anchored = false end end})
Tabs.World:AddButton({Title = "💣 Destroy Map (マップ削除)", Callback = function() for _,v in pairs(workspace:GetChildren()) do if v:IsA("Part") then v:Destroy() end end end})
local AntiAfk = Tabs.World:AddToggle("Afk", {Title = "Anti-AFK (放置落ち防止)", Default = true})

-- [[ ➕ 6. EXTRA / MISC ]]
Tabs.Extra:AddButton({Title = "✨ Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, lp) end})
Tabs.Extra:AddButton({Title = "🛑 FPS Unlocker", Callback = function() setfpscap(999) end})
Tabs.Extra:AddButton({Title = "🎭 Invisible (透明化試行)", Callback = function() lp.Character.LowerTorso:Destroy() end})
Tabs.Extra:AddButton({Title = "📱 Low Graphic Mode", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = "Plastic"; v.Reflectance = 0 end end end})
Tabs.Extra:AddButton({Title = "🗑️ Remove UI", Callback = function() ScreenGui:Destroy(); Window:Destroy() end})

-- [[ 🔨 BAN HAMMER 究極演出関数 ]]
function HammerAttack()
    local root = lp.Character.HumanoidRootPart
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s.PlaybackSpeed = 0.3; s:Play(); game.Debris:AddItem(s, 3)
    for i=1,5 do
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(5,5,5); b.CFrame = root.CFrame; b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function() for x=1,25 do b.Size = b.Size + Vector3.new(15,15,15); b.Transparency = x/25; task.wait(0.01) end b:Destroy() end)
    end
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 50 then
                local char = v.Character
                for _,p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.new(1,0,0); p.Material = "Neon"; task.delay(2, function() pcall(function() p.Material = "Plastic"; p.Color = Color3.new(1,1,1) end) end) end end
                local g = Instance.new("BillboardGui", char.Head); g.Size = UDim2.new(0,500,0,250); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,8,0)
                local t1 = Instance.new("TextLabel", g); t1.Size = UDim2.new(1,0,0.5,0); t1.BackgroundTransparency = 1; t1.Text = "HITHIT!!!"; t1.TextColor3 = Color3.new(1,1,1); t1.Font = "GothamBlack"; t1.TextSize = 100; t1.TextStrokeTransparency = 0
                local t2 = Instance.new("TextLabel", g); t2.Position = UDim2.new(0,0,0.5,0); t2.Size = UDim2.new(1,0,0.5,0); t2.BackgroundTransparency = 1; t2.Text = "BANNED!!!"; t2.TextColor3 = Color3.new(1,0,0); t2.Font = "GothamBlack"; t2.TextSize = 120; t2.TextStrokeTransparency = 0
                game.Debris:AddItem(g, 2)
            end
        end
    end
end

-- [[ 🔄 物理・描画ループ ]]
rs.RenderStepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- 移動速度設定
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
        local pRoot = game.Players[Target].Character.HumanoidRootPart
        char.HumanoidRootPart.CFrame = pRoot.CFrame * CFrame.new(0, 0, 1.1 + math.sin(tick() * bS) * 1.0)
    end

    -- Full Bright
    if FullBright.Value then
        game.Lighting.Brightness = 2; game.Lighting.ClockTime = 14; game.Lighting.GlobalShadows = false
    end
end)

Window:SelectTab(1)
