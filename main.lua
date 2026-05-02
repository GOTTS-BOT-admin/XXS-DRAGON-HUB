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
    MinimizeKey = Enum.KeyCode.LeftControl -- PC用
})

-- [[ 📱 スマホ用復帰ボタン（エラー回避用） ]]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "DragonHubOpen"
OpenBtn.Size = UDim2.new(0, 80, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "OPEN HUB"
OpenBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Visible = true -- 常に表示
OpenBtn.Draggable = true -- 邪魔なら動かせるように設定
OpenBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- [[ 🗝️ タブの作成（順序固定でエラー防止） ]]
local KeyTab = Window:AddTab({ Title = "Key / 認証", Icon = "key" })
local PlayerTab = Window:AddTab({ Title = "Player", Icon = "user" })
local AuraTab = Window:AddTab({ Title = "Aura", Icon = "zap" })
local SusTab = Window:AddTab({ Title = "😏 SUS", Icon = "skull" })
local LocalTab = Window:AddTab({ Title = "Local", Icon = "terminal" })

-- [[ 🗝️ KEY SYSTEM 処理（タブ削除をせず機能制限で対応） ]]
KeyTab:AddParagraph({
    Title = "Verification / 認証",
    Content = "キーを入力して Unlock を押してください。\n認証されるまで他の機能は使えません。"
})

local KeyBox = KeyTab:AddInput("Input", {
    Title = "Enter Key",
    Default = "",
    Placeholder = "Paste here...",
    Callback = function(v) end
})

local IsUnlocked = false -- 認証フラグ

KeyTab:AddButton({
    Title = "🔓 Unlock / 起動",
    Callback = function()
        local input = string.gsub(KeyBox.Value, "^%s*(.-)%s*$", "%1")
        if input == LatestKey then
            IsUnlocked = true
            Fluent:Notify({ Title = "Success", Content = "Verified! 機能が解放されました。", Duration = 3 })
            Window:SelectTab(2) -- Playerタブへ自動移動
        else
            Fluent:Notify({ Title = "Error", Content = "Key is Incorrect.", Duration = 5 })
        end
    end
})

-- [[ 🐉 MAIN FEATURES（認証チェック付き） ]]
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, bS, Target = 16, 8, ""

-- プレイヤー
PlayerTab:AddSlider("SpdSl", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 150, Rounding = 1, Callback = function(v) WalkSpeed = v end })
local TpToggle = PlayerTab:AddToggle("Tp", {Title = "Third Person / 三人称", Default = false })
local FlyToggle = PlayerTab:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
local NcToggle = PlayerTab:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

-- オーラ
local KAToggle = AuraTab:AddToggle("KA", {Title = "Kill Aura", Default = false })
local BAToggle = AuraTab:AddToggle("BA", {Title = "Bring Aura", Default = false })

-- SUS
local BangToggle = SusTab:AddToggle("Bang", {Title = "BANG / 背後追従", Default = false })
local Dropdown = SusTab:AddDropdown("Plr", { Title = "Target / 対象", Values = {}, Callback = function(v) Target = v end })
local function Upd()
    local t = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
    Dropdown:SetValues(t)
end
Upd()
SusTab:AddButton({ Title = "🔄 Refresh List", Callback = Upd })
SusTab:AddSlider("bS", { Title = "Speed", Default = 8, Min = 1, Max = 20, Rounding = 1, Callback = function(v) bS = v end })

-- BAN実行関数
function ExecuteBanHammer()
    if not IsUnlocked then return end
    local root = lp.Character.HumanoidRootPart
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s:Play(); game.Debris:AddItem(s, 2)
    local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(2,2,2); b.CFrame = root.CFrame * CFrame.new(0,0,-5); b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
    task.spawn(function() for i=1,10 do b.Size = b.Size + Vector3.new(6,6,6); b.Transparency = i/10; task.wait() end b:Destroy() end)
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 20 then
                for _, p in pairs(v.Character:GetChildren()) do if p:IsA("BasePart") then p.Color = Color3.new(1,0,0); p.Material = "Neon"; task.delay(1, function() pcall(function() p.Color = Color3.new(1,1,1) p.Material = "Plastic" end) end) end end
                local g = Instance.new("BillboardGui", v.Character.Head); g.Size = UDim2.new(0,250,0,70); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,4,0)
                local t = Instance.new("TextLabel", g); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "BANNED!!!"; t.TextColor3 = Color3.new(1,0,0); t.Font = "GothamBlack"; t.TextSize = 60; t.TextStrokeTransparency = 0
                game.Debris:AddItem(g, 1.5)
            end
        end
    end
end

-- ローカル
LocalTab:AddToggle("Esp", {Title = "Player ESP", Default = false, Callback = function(v) EspEnabled = v end})
LocalTab:AddButton({ Title = "💥 EXECUTE BAN / BAN実行", Callback = function() ExecuteBanHammer() end })

-- [[ 🔄 MAIN LOOP ]]
rs.Heartbeat:Connect(function()
    if not IsUnlocked then return end -- 認証前は何もさせない
    
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    char.Humanoid.WalkSpeed = WalkSpeed
    lp.CameraMinZoomDistance = TpToggle.Value and 5 or 0.5
    lp.CameraMaxZoomDistance = TpToggle.Value and 100 or 12.5

    if NcToggle.Value then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if FlyToggle.Value then char.HumanoidRootPart.Velocity = Vector3.new(0,5,0) + (char.Humanoid.MoveDirection * 50) end
    
    if BangToggle.Value and Target ~= "" then
        local p = game.Players:FindFirstChild(Target)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2) * CFrame.new(0, 0, math.sin(tick() * bS * 2) * 0.8)
        end
    end
end)

uis.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then ExecuteBanHammer() end
end)

Window:SelectTab(1)
