local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ CONFIG / 設定 ]]
local LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv"
local KeyURL = "https://work.ink/2xWq/xxs-dragon-hub2026no1-key"

-- [[ 🗝️ KEY SYSTEM WINDOW / キー入力画面 ]]
local KeyWindow = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB | KEY SYSTEM",
    SubTitle = "認証が必要です / Verification Required",
    TabWidth = 160,
    Size = UDim2.fromOffset(400, 350),
    Acrylic = true,
    Theme = "Dark"
})

local KeyTab = KeyWindow:AddTab({ Title = "Verification", Icon = "key" })

KeyTab:AddParagraph({
    Title = "Access Denied / アクセス拒否",
    Content = "Please enter the key to use this script.\nスクリプトを使用するにはキーを入力してください。"
})

KeyTab:AddButton({
    Title = "📋 Get Key (Work.ink) / キーを取得",
    Callback = function()
        setclipboard(KeyURL)
        Fluent:Notify({ Title = "System", Content = "Link copied! / リンクをコピーしました", Duration = 5 })
    end
})

local KeyInput = ""
KeyTab:AddInput("Input", {
    Title = "Enter Key / キー入力",
    Placeholder = "Paste here...",
    Callback = function(Value) KeyInput = Value end
})

KeyTab:AddButton({
    Title = "🔓 Check Key / 認証",
    Callback = function()
        if KeyInput == LatestKey then
            Fluent:Notify({ Title = "Success", Content = "Welcome back! / 認証成功！", Duration = 3 })
            task.wait(1)
            KeyWindow:Destroy()
            StartMainHub()
        else
            Fluent:Notify({ Title = "Error", Content = "Invalid Key / キーが違います", Duration = 5 })
        end
    end
})

-- [[ 🐉 MAIN HUB FUNCTION / メインメニュー関数 ]]
function StartMainHub()
    local Window = Fluent:CreateWindow({
        Title = "XXS-DRAGON-HUB v2.0",
        SubTitle = "by GOTTS",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 480),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local WalkSpeed, JumpPower, bS, Target = 16, 50, 5, ""

    local Tabs = {
        Player = Window:AddTab({ Title = "Player / プレイヤー", Icon = "user" }),
        Aura = Window:AddTab({ Title = "Aura / オーラ", Icon = "zap" }),
        Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
        Local = Window:AddTab({ Title = "Local / ローカル", Icon = "terminal" })
    }

    -- [[ PLAYER TAB ]]
    local SpdToggle = Tabs.Player:AddToggle("Spd", {Title = "Speed Up / 速度向上", Default = false })
    Tabs.Player:AddSlider("SpdSl", { Title = "Speed / 速度", Default = 16, Min = 16, Max = 150, Rounding = 1, Callback = function(v) WalkSpeed = v end })
    
    local JmpToggle = Tabs.Player:AddToggle("Jmp", {Title = "Jump Up / 跳躍力向上", Default = false })
    Tabs.Player:AddSlider("JmpSl", { Title = "Jump / ジャンプ", Default = 50, Min = 50, Max = 300, Rounding = 1, Callback = function(v) JumpPower = v end })
    
    local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
    local NcToggle = Tabs.Player:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

    -- [[ AURA TAB ]]
    local KAToggle = Tabs.Aura:AddToggle("KA", {Title = "Kill Aura / キルオーラ", Default = false })
    local BAToggle = Tabs.Aura:AddToggle("BA", {Title = "Bring Aura / ブリングオーラ", Default = false })

    -- [[ 😏 SUS TAB ]]
    local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG / 腰振り", Default = false })
    local HitToggle = Tabs.Sus:AddToggle("Hit", {Title = "HITHIT!!! / 激しい動き", Default = false })
    
    local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Select Target / 対象選択", Values = {}, Callback = function(v) Target = v end })
    local function Upd()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
        Dropdown:SetValues(t)
    end
    Upd()
    Tabs.Sus:AddButton({ Title = "🔄 Refresh List / 更新", Callback = Upd })
    Tabs.Sus:AddSlider("bS", { Title = "Action Speed / 動作速度", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) bS = v end })

    -- [[ LOCAL TAB ]]
    local EspToggle = Tabs.Local:AddToggle("Esp", {Title = "Player ESP / 透視", Default = false })
    local HamToggle = Tabs.Local:AddToggle("Ham", {Title = "BANNED Hammer (P Key)", Default = false })
    
    Tabs.Local:AddButton({
        Title = "Apply c00lkid Skin / スキン適用",
        Callback = function()
            local c = lp.Character
            for _, v in pairs(c:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
            Instance.new("Shirt", c).ShirtTemplate = "rbxassetid://108102438"
            Instance.new("Pants", c).PantsTemplate = "rbxassetid://108102886"
            local m = Instance.new("SpecialMesh", c.Head); m.MeshId = "rbxassetid://135202452"
        end
    })

    -- [[ 🔄 MAIN LOOP / 実行ループ ]]
    rs.Heartbeat:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        -- Player
        if SpdToggle.Value then char.Humanoid.WalkSpeed = WalkSpeed end
        if JmpToggle.Value then char.Humanoid.JumpPower = JumpPower end
        if NcToggle.Value then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if FlyToggle.Value then char.HumanoidRootPart.Velocity = Vector3.new(0,5,0) + (char.Humanoid.MoveDirection * 50) end
        
        -- BANG
        if BangToggle.Value and Target ~= "" then
            local p = game.Players:FindFirstChild(Target)
            if p and p.Character then
                char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1) * CFrame.Angles(0, math.rad(180), 0)
                char.HumanoidRootPart.CFrame *= CFrame.new(0, 0, math.sin(tick() * bS * 2) * 1.5)
            end
        end
        
        -- HITHIT
        if HitToggle.Value then char.Humanoid.HipHeight = 0.5 + math.sin(tick() * bS * 2) * 0.5 end
        
        -- Aura & ESP
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < 20 then
                    if KAToggle.Value then v.Character.Humanoid:TakeDamage(1) end
                    if BAToggle.Value then v.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
                end
                if EspToggle.Value then
                    if not v.Character:FindFirstChild("ESP") then
                        local b = Instance.new("BillboardGui", v.Character); b.Name = "ESP"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,0); l.Text = v.Name; l.Font = Enum.Font.GothamBold; l.TextSize = 14
                    end
                elseif v.Character:FindFirstChild("ESP") then v.Character.ESP:Destroy() end
            end
        end
    end)

    -- P Key Hammer
    uis.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.P and HamToggle.Value then
            local s = Instance.new("Sound", lp.Character.HumanoidRootPart); s.SoundId = "rbxassetid://12222200"; s:Play()
            local e = Instance.new("Explosion", workspace); e.Position = lp.Character.HumanoidRootPart.Position + (lp.Character.HumanoidRootPart.CFrame.LookVector * 5); e.BlastRadius = 0
            Fluent:Notify({ Title = "BAN", Content = "BANNED!!! / 追放完了!!!", Duration = 2 })
        end
    end)
    
    Window:SelectTab(1)
end
