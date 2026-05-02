local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ CONFIG / 設定 ]]
local LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv"
local KeyURL = "https://work.ink/2xWq/xxs-dragon-hub2026no1-key"

-- [[ 🗝️ MAIN WINDOW ]]
local Window = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB v2.0",
    SubTitle = "by GOTTS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- スマホ用 OPEN ボタン (右上の「ー」で閉じた時用)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "DragonHubOpen"
OpenBtn.Size = UDim2.new(0, 100, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.5, 0)
OpenBtn.Text = "OPEN HUB"
OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = false -- 認証前は隠す
OpenBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- 初期状態のKeyタブ
local KeyTab = Window:AddTab({ Title = "Key / 認証", Icon = "key" })

KeyTab:AddParagraph({
    Title = "Verification / 認証",
    Content = "Get the key from the link.\n認証に成功すると、このタブは消去されます。"
})

KeyTab:AddButton({
    Title = "📋 Get Key Link / リンクコピー",
    Callback = function()
        setclipboard(KeyURL)
        Fluent:Notify({ Title = "System", Content = "Copied!", Duration = 5 })
    end
})

local KeyInput = ""
KeyTab:AddInput("Input", {
    Title = "Enter Key",
    Callback = function(v) KeyInput = v end
})

local Loaded = false
KeyTab:AddButton({
    Title = "🔓 Unlock / 起動",
    Callback = function()
        if KeyInput == LatestKey and not Loaded then
            Loaded = true
            Fluent:Notify({ Title = "Success", Content = "Unlocking Features...", Duration = 3 })
            KeyTab:Destroy() -- Keyタブを消去
            OpenBtn.Visible = true -- スマホボタン表示
            StartMainFeatures()
        else
            Fluent:Notify({ Title = "Error", Content = "Invalid Key", Duration = 5 })
        end
    end
})

-- [[ 🐉 MAIN FEATURES ]]
function StartMainFeatures()
    local Tabs = {
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Aura = Window:AddTab({ Title = "Aura", Icon = "zap" }),
        Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
        Local = Window:AddTab({ Title = "Local", Icon = "terminal" })
    }

    local lp = game.Players.LocalPlayer
    local rs = game:GetService("RunService")
    local uis = game:GetService("UserInputService")
    local WalkSpeed, bS, Target = 16, 8, ""

    -- [[ PLAYER TAB ]]
    Tabs.Player:AddSlider("SpdSl", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 150, Rounding = 1, Callback = function(v) WalkSpeed = v end })
    local TpToggle = Tabs.Player:AddToggle("Tp", {Title = "Third Person / 三人称化", Default = false }) -- 追加機能
    local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
    local NcToggle = Tabs.Player:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

    -- [[ AURA TAB ]]
    local KAToggle = Tabs.Aura:AddToggle("KA", {Title = "Kill Aura", Default = false })
    local BAToggle = Tabs.Aura:AddToggle("BA", {Title = "Bring Aura", Default = false })

    -- [[ 😏 SUS TAB ]]
    local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG / 背後追尾", Default = false })
    local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Target / 対象", Values = {}, Callback = function(v) Target = v end })
    local function Upd()
        local t = {}
        for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
        Dropdown:SetValues(t)
    end
    Upd()
    Tabs.Sus:AddButton({ Title = "🔄 Refresh List", Callback = Upd })
    Tabs.Sus:AddSlider("bS", { Title = "Speed", Default = 8, Min = 1, Max = 20, Rounding = 1, Callback = function(v) bS = v end })

    -- [[ LOCAL TAB ]]
    local EspToggle = Tabs.Local:AddToggle("Esp", {Title = "Player ESP", Default = false })
    Tabs.Local:AddParagraph({Title = "BAN Hammer", Content = "P-Key or Button below / Pキーまたはボタン"})
    Tabs.Local:AddButton({
        Title = "💥 EXECUTE BAN / BAN実行",
        Callback = function() ExecuteBanHammer() end
    })

    -- [[ 🔨 BAN実行関数 ]]
    function ExecuteBanHammer()
        local root = lp.Character.HumanoidRootPart
        local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s:Play(); game.Debris:AddItem(s, 2)
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(2,2,2); b.CFrame = root.CFrame * CFrame.new(0,0,-5); b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function() for i=1,10 do b.Size = b.Size + Vector3.new(6,6,6); b.Transparency = i/10; task.wait() end b:Destroy() end)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 20 then
                    for _, p in pairs(v.Character:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.new(1,0,0); p.Material = "Neon"; task.delay(1, function() pcall(function() p.Material = "Plastic" end) end) end end
                    local g = Instance.new("BillboardGui", v.Character.Head); g.Size = UDim2.new(0,250,0,70); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,4,0)
                    local t = Instance.new("TextLabel", g); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "BANNED!!!"; t.TextColor3 = Color3.new(1,0,0); t.Font = "GothamBlack"; t.TextSize = 60; t.TextStrokeTransparency = 0
                    game.Debris:AddItem(g, 1.5)
                end
            end
        end
        Fluent:Notify({ Title = "BAN", Content = "ADMIN EXECUTED!!!", Duration = 2 })
    end

    -- [[ 🔄 MAIN LOOP ]]
    rs.Heartbeat:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        char.Humanoid.WalkSpeed = WalkSpeed
        
        -- 三人称化機能のロジック
        if TpToggle.Value then
            lp.CameraMinZoomDistance = 5
            lp.CameraMaxZoomDistance = 100
        else
            -- オフの時はゲームデフォルトに任せる（通常は0.5）
            lp.CameraMinZoomDistance = 0.5
        end

        if NcToggle.Value then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if FlyToggle.Value then char.HumanoidRootPart.Velocity = Vector3.new(0,5,0) + (char.Humanoid.MoveDirection * 50) end
        
        -- BANG 修正版 (相手と同じ向きで背後に張り付く)
        if BangToggle.Value and Target ~= "" then
            local p = game.Players:FindFirstChild(Target)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                -- 相手の背後1.2スタッド、高さは同じ
                local backPos = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                char.HumanoidRootPart.CFrame = backPos
                -- 腰振りアニメーション
                char.HumanoidRootPart.CFrame *= CFrame.new(0, 0, math.sin(tick() * bS * 2) * 0.8)
            end
        end

        if EspToggle.Value then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    if not v.Character:FindFirstChild("ESP") then
                        local b = Instance.new("BillboardGui", v.Character); b.Name = "ESP"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                        local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,0); l.Text = v.Name; l.Font = "GothamBold"; l.TextSize = 14
                    end
                end
            end
        end
    end)

    uis.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.P then ExecuteBanHammer() end
    end)

    Window:SelectTab(2)
end

Window:SelectTab(1)
