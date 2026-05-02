local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

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

-- スマホ用復帰ボタン（ドラッグ可能）
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 90, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "OPEN HUB"
OpenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() Window:Minimize() end)

-- [[ 📂 TABS ]]
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
    Local = Window:AddTab({ Title = "Local", Icon = "terminal" })
}

local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, bS, Target = 16, 8, ""
local FlyVelocity = Vector3.new(0,0,0)

-- [[ 👤 PLAYER TAB ]]
-- スライダーをタップ対応に（Rounding設定で感度調整）
Tabs.Player:AddSlider("SpdSl", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 250, Rounding = 0, Callback = function(v) WalkSpeed = v end })
local TpToggle = Tabs.Player:AddToggle("Tp", {Title = "Third Person / 三人称", Default = false })
local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
local NcToggle = Tabs.Player:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

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
Tabs.Sus:AddSlider("bS", { Title = "Action Speed", Default = 8, Min = 1, Max = 30, Rounding = 0, Callback = function(v) bS = v end })

-- [[ 🛠️ LOCAL & BAN HAMMER ]]
local EspToggle = Tabs.Local:AddToggle("Esp", {Title = "Player ESP", Default = false })
local HammerToggle = Tabs.Local:AddToggle("Ham", {Title = "BAN HAMMER Mode", Default = false })

-- スマホ用BAN攻撃ボタン（HammerModeがONの時だけ機能）
local BanBtn = Tabs.Local:AddButton({
    Title = "🔨 SWING HAMMER / ハンマーを振る",
    Callback = function() 
        if HammerToggle.Value then HammerAttack() end
    end
})

-- [[ 🔨 BAN HAMMER LOGIC ]]
function HammerAttack()
    local root = lp.Character.HumanoidRootPart
    -- 音：えぐい音量
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s.PlaybackSpeed = 0.5; s:Play(); game.Debris:AddItem(s, 3)
    
    -- 衝撃波：ばちくそえぐい演出
    for i = 1, 3 do
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(2,2,2); b.CFrame = root.CFrame; b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function()
            for x = 1, 15 do
                b.Size = b.Size + Vector3.new(8,8,8)
                b.Transparency = x/15
                task.wait(0.02)
            end
            b:Destroy()
        end)
    end

    -- ヒット判定
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 25 then
                -- 真っ赤＋ネオン
                for _, p in pairs(v.Character:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.Color = Color3.new(1,0,0); p.Material = "Neon"
                        task.delay(1.5, function() pcall(function() p.Material = "Plastic"; p.Color = Color3.new(1,1,1) end) end)
                    end
                end
                -- 頭上にBANNED!!!（赤文字太字）
                local g = Instance.new("BillboardGui", v.Character.Head); g.Size = UDim2.new(0,300,0,100); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,5,0)
                local t = Instance.new("TextLabel", g); t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1; t.Text = "BANNED!!!"; t.TextColor3 = Color3.new(1,0,0); t.Font = "GothamBlack"; t.TextSize = 80; t.TextStrokeTransparency = 0; t.TextStrokeColor3 = Color3.new(0,0,0)
                game.Debris:AddItem(g, 2)
            end
        end
    end
end

-- [[ 🔄 MAIN LOOP (Noclip / Fly / Bang / Speed) ]]
rs.Stepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Speed
    char.Humanoid.WalkSpeed = WalkSpeed

    -- Noclip (Steppedで回さないと動作しない)
    if NcToggle.Value then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Fly (Velocityを直接制御)
    if FlyToggle.Value then
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        char.HumanoidRootPart.Velocity = move * WalkSpeed + Vector3.new(0,2,0)
        char.HumanoidRootPart.Anchored = false
    end

    -- BANG (背後固定)
    if BangToggle.Value and Target ~= "" then
        local p = game.Players:FindFirstChild(Target)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local offset = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
            char.HumanoidRootPart.CFrame = offset * CFrame.new(0, 0, math.sin(tick() * bS * 2) * 1.2)
        end
    end
    
    -- 三人称化
    lp.CameraMinZoomDistance = TpToggle.Value and 5 or 0.5
    lp.CameraMaxZoomDistance = TpToggle.Value and 200 or 12.5
end)

-- PキーでもBAN発動
uis.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P and HammerToggle.Value then HammerAttack() end
end)

Window:SelectTab(1)
