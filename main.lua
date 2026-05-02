local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ CONFIG / 設定 ]]
local LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv"
local KeyURL = "https://work.ink/2xWq/xxs-dragon-hub2026no1-key"

-- [[ 🗝️ KEY SYSTEM WINDOW ]]
local KeyWindow = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB | KEY",
    SubTitle = "Verification Required",
    TabWidth = 160,
    Size = UDim2.fromOffset(450, 320),
    Acrylic = true,
    Theme = "Dark"
})

local KeyTab = KeyWindow:AddTab({ Title = "Key", Icon = "key" })

KeyTab:AddParagraph({
    Title = "Access Key Required / キー入力",
    Content = "Get the key from the link below.\n下のボタンからキーを取得してください。"
})

KeyTab:AddButton({
    Title = "📋 Get Key Link / リンクをコピー",
    Callback = function()
        setclipboard(KeyURL)
        Fluent:Notify({ Title = "System", Content = "Copied! / コピー完了", Duration = 5 })
    end
})

local KeyInput = ""
KeyTab:AddInput("Input", {
    Title = "Enter Key",
    Placeholder = "Paste here...",
    Callback = function(Value) KeyInput = Value end
})

KeyTab:AddButton({
    Title = "🔓 Start Hub / 起動",
    Callback = function()
        if KeyInput == LatestKey then
            Fluent:Notify({ Title = "Success", Content = "Loading Main UI...", Duration = 2 })
            KeyWindow:Destroy()
            task.wait(0.5)
            StartMainHub()
        else
            Fluent:Notify({ Title = "Error", Content = "Invalid Key", Duration = 5 })
        end
    end
})

-- [[ 🐉 MAIN HUB FUNCTION ]]
function StartMainHub()
    local success, Window = pcall(function()
        return Fluent:CreateWindow({
            Title = "XXS-DRAGON-HUB v2.0",
            SubTitle = "by GOTTS",
            TabWidth = 160,
            Size = UDim2.fromOffset(580, 480),
            Acrylic = true,
            Theme = "Dark",
            MinimizeKey = Enum.KeyCode.LeftControl
        })
    end)

    if not success or not Window then return end

    local Tabs = {
        Player = Window:AddTab({ Title = "Player / プレイヤー", Icon = "user" }),
        Aura = Window:AddTab({ Title = "Aura / オーラ", Icon = "zap" }),
        Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
        Local = Window:AddTab({ Title = "Local / ローカル", Icon = "terminal" })
    }

    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local WalkSpeed, JumpPower, bS, Target = 16, 50, 5, ""

    -- [[ 👤 PLAYER ]]
    local SpdToggle = Tabs.Player:AddToggle("Spd", {Title = "Speed Up / 速度向上", Default = false })
    Tabs.Player:AddSlider("SpdSl", { Title = "Speed", Default = 16, Min = 16, Max = 150, Rounding = 1, Callback = function(v) WalkSpeed = v end })
    local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
    local NcToggle = Tabs.Player:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

    -- [[ ✨ AURA ]]
    local KAToggle = Tabs.Aura:AddToggle("KA", {Title = "Kill Aura / キルオーラ", Default = false })
    local BAToggle = Tabs.Aura:AddToggle("BA", {Title = "Bring Aura / ブリングオーラ", Default = false })

    -- [[ 😏 SUS ]]
    local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG / 腰振り", Default = false })
    local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Target / 対象選択", Values = {}, Callback = function(v) Target = v end })
    local function Upd()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
        Dropdown:SetValues(t)
    end
    Upd()
    Tabs.Sus:AddButton({ Title = "🔄 Refresh List / 更新", Callback = Upd })
    Tabs.Sus:AddSlider("bS", { Title = "Action Speed", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) bS = v end })

    -- [[ 🛠️ LOCAL ]]
    local EspToggle = Tabs.Local:AddToggle("Esp", {Title = "Player ESP / 透視", Default = false })
    local HamToggle = Tabs.Local:AddToggle("Ham", {Title = "BANNED Hammer (P Key)", Default = false })
    Tabs.Local:AddButton({
        Title = "Apply Skin / スキン適用",
        Callback = function()
            local c = lp.Character
            if not c then return end
            for _, v in pairs(c:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
            Instance.new("Shirt", c).ShirtTemplate = "rbxassetid://108102438"
            Instance.new("Pants", c).PantsTemplate = "rbxassetid://108102886"
            local m = Instance.new("SpecialMesh", c.Head); m.MeshId = "rbxassetid://135202452"
        end
    })

    -- [[ 🔄 MAIN LOOP ]]
    rs.Heartbeat:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        if SpdToggle.Value then char.Humanoid.WalkSpeed = WalkSpeed end
        if NcToggle.Value then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if FlyToggle.Value then char.HumanoidRootPart.Velocity = Vector3.new(0,5,0) + (char.Humanoid.MoveDirection * 50) end
        
        if BangToggle.Value and Target ~= "" then
            local p = game.Players:FindFirstChild(Target)
            if p and p.Character then
                char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1) * CFrame.Angles(0, math.rad(180), 0)
                char.HumanoidRootPart.CFrame *= CFrame.new(0, 0, math.sin(tick() * bS * 2) * 1.5)
            end
        end

        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < 20 and KAToggle.Value then v.Character.Humanoid:TakeDamage(1) end
                if EspToggle.Value then
                    if not v.Character:FindFirstChild("ESP") then
                        local b = Instance.new("BillboardGui", v.Character); b.Name = "ESP"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,0); l.Text = v.Name; l.Font = Enum.Font.GothamBold; l.TextSize = 14
                    end
                elseif v.Character:FindFirstChild("ESP") then v.Character.ESP:Destroy() end
            end
        end
    end)

    -- [[ 🔨 ULTIMATE HAMMER LOGIC ]]
    uis.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.P and HamToggle.Value then
            local root = lp.Character.HumanoidRootPart
            -- Sound
            local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 8; s:Play(); game.Debris:AddItem(s, 2)
            -- Shockwave (Low Lag)
            local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(2,2,2); b.CFrame = root.CFrame * CFrame.new(0,0,-5); b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
            task.spawn(function() for i=1,10 do b.Size = b.Size + Vector3.new(4,4,4); b.Transparency = i/10; task.wait() end b:Destroy() end)
            -- Target Effect
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 18 then
                        -- 赤色変化
                        for _, p in pairs(v.Character:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.new(1,0,0); p.Material = "Neon"; task.delay(1, function() pcall(function() p.Material = "Plastic" end) end) end end
                        -- BANNED!!! 文字
                        local g = Instance.new("BillboardGui", v.Character.Head); g.Size = UDim2.new(0,200,0,50); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,4,0)
                        local t = Instance.new("TextLabel", g); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "BANNED!!!"; t.TextColor3 = Color3.new(1,0,0); t.Font = "GothamBlack"; t.TextSize = 50; t.TextStrokeTransparency = 0
                        game.Debris:AddItem(g, 1.5)
                    end
                end
            end
            Fluent:Notify({ Title = "BAN", Content = "ELIMINATED!!!", Duration = 2 })
        end
    end)
    Window:SelectTab(1)
end
