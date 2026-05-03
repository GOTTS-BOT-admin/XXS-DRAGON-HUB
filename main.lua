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
OpenBtn.Size = UDim2.new(0, 90, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.Text = "OPEN HUB"
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- [[ 👤 PLAYER TAB ]]
Tabs.Player:AddSlider("SpdSl", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 300, Rounding = 0, Callback = function(v) WalkSpeed = v end })
local TpToggle = Tabs.Player:AddToggle("Tp", {Title = "Third Person / 三人称解放", Default = false })
local FlyToggle = Tabs.Player:AddToggle("Fly", {Title = "Fly / 飛行", Default = false })
local NcToggle = Tabs.Player:AddToggle("Nc", {Title = "Noclip / 壁抜け", Default = false })

-- [[ 😏 SUS TAB ]]
local BangToggle = Tabs.Sus:AddToggle("Bang", {Title = "BANG / 背後密着", Default = false })
local Dropdown = Tabs.Sus:AddDropdown("Plr", { Title = "Select Target", Values = {}, Callback = function(v) Target = v end })
local function Upd()
    local t = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
    Dropdown:SetValues(t)
end
Upd()
Tabs.Sus:AddButton({ Title = "🔄 Refresh Players", Callback = Upd })
Tabs.Sus:AddSlider("bS", { Title = "Action Speed", Default = 10, Min = 1, Max = 40, Rounding = 0, Callback = function(v) bS = v end })

-- [[ 🛠️ LOCAL & BAN HAMMER ]]
local EspToggle = Tabs.Local:AddToggle("Esp", {Title = "Player ESP", Default = false })
local HammerToggle = Tabs.Local:AddToggle("Ham", {Title = "BAN HAMMER Mode", Default = false })

-- スマホ用BANボタン
Tabs.Local:AddButton({
    Title = "💥 SWING HAMMER / ハンマーを振る",
    Callback = function() if HammerToggle.Value then HammerAttack() end end
})

-- [[ 🔨 BAN HAMMER 究極演出 ]]
function HammerAttack()
    local root = lp.Character.HumanoidRootPart
    -- 音：破壊音
    local s = Instance.new("Sound", root); s.SoundId = "rbxassetid://12222200"; s.Volume = 10; s.PlaybackSpeed = 0.4; s:Play(); game.Debris:AddItem(s, 3)
    
    -- 衝撃波：広がる赤いリング
    for i = 1, 3 do
        local b = Instance.new("Part", workspace); b.Shape = "Ball"; b.Size = Vector3.new(3,3,3); b.CFrame = root.CFrame; b.Anchored = true; b.CanCollide = false; b.Color = Color3.new(1,0,0); b.Material = "Neon"
        task.spawn(function()
            for x = 1, 20 do
                b.Size = b.Size + Vector3.new(10,10,10)
                b.Transparency = x/20
                task.wait(0.01)
            end
            b:Destroy()
        end)
    end

    -- ヒット判定と演出
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if (root.Position - v.Character.HumanoidRootPart.Position).Magnitude < 30 then
                -- HIT演出
                local char = v.Character
                for _, p in pairs(char:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.Color = Color3.new(1,0,0); p.Material = "Neon"
                        task.delay(1.5, function() pcall(function() p.Material = "Plastic"; p.Color = Color3.new(1,1,1) end) end)
                    end
                end
                
                -- HITHIT!!! & BANNED!!! 表示
                local g = Instance.new("BillboardGui", char.Head); g.Size = UDim2.new(0,350,0,150); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,6,0)
                local t1 = Instance.new("TextLabel", g); t1.Size = UDim2.new(1,0,0.5,0); t1.BackgroundTransparency = 1; t1.Text = "HITHIT!!!"; t1.TextColor3 = Color3.new(1,1,1); t1.Font = "GothamBlack"; t1.TextSize = 70; t1.TextStrokeTransparency = 0
                local t2 = Instance.new("TextLabel", g); t2.Position = UDim2.new(0,0,0.5,0); t2.Size = UDim2.new(1,0,0.5,0); t2.BackgroundTransparency = 1; t2.Text = "BANNED!!!"; t2.TextColor3 = Color3.new(1,0,0); t2.Font = "GothamBlack"; t2.TextSize = 90; t2.TextStrokeTransparency = 0
                game.Debris:AddItem(g, 2)
            end
        end
    end
end

-- [[ 🔄 MAIN LOOP ]]
rs.RenderStepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- Speed
    char.Humanoid.WalkSpeed = WalkSpeed

    -- 三人称 (一人称固定を解除)
    if TpToggle.Value then
        lp.CameraMinZoomDistance = 10
        lp.CameraMaxZoomDistance = 200
    else
        lp.CameraMinZoomDistance = 0.5
    end

    -- Noclip (RenderSteppedで全パーツの衝突判定をOFFにする)
    if NcToggle.Value then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- Fly (ふわふわさせず、WalkSpeedに依存した移動)
    if FlyToggle.Value then
        char.Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        local cam = workspace.CurrentCamera.CFrame
        local move = Vector3.new(0,0,0)
        if uis:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if uis:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if uis:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        char.HumanoidRootPart.Velocity = (move * WalkSpeed * 1.5) + Vector3.new(0, 1.5, 0)
    end

    -- BANG (修正：相手の向きに合わせて真後ろに固定)
    if BangToggle.Value and Target ~= "" then
        local p = game.Players:FindFirstChild(Target)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- 相手のCFrameを基準にして、Z軸方向に1.2スタッド後ろ、Sin波でピストン運動
            local pRoot = p.Character.HumanoidRootPart
            local moveZ = 1.1 + math.sin(tick() * bS) * 0.9
            char.HumanoidRootPart.CFrame = pRoot.CFrame * CFrame.new(0, 0, moveZ)
        end
    end
end)

-- Pキー
uis.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P and HammerToggle.Value then HammerAttack() end
end)

Window:SelectTab(1)
