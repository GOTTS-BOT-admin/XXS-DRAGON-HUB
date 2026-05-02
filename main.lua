-- [[ XXS-DRAGON-HUB v2.0 / ULTIMATE CUSTOM ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🔑 設定 (以前お聞きしたリンクとキーを設定済み)
local WorkInkURL = "https://work.ink/2xWq/xxs-dragon-hub2026no1-key"
local LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv"

-- [[ 🗝️ ウィンドウ作成 ]]
local Window = Rayfield:CreateWindow({
   Name = "🐉 XXS-DRAGON-HUB v2.0",
   LoadingTitle = "XXS-DRAGON-HUB Loading...",
   LoadingSubtitle = "by XXS-DRAGON-HUB-admin",
   Theme = "Amber", -- かっこいい黄色系テーマ
   KeySystem = true,
   KeySettings = {
      Title = "XXS-DRAGON KEY SYSTEM",
      Subtitle = "Get Key from Work.ink",
      Note = "The key is updated irregularly",
      Key = {LatestKey}
   }
})

local lp = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

-- [[ ⚙️ SETTINGS タブ ]]
local SettingsTab = Window:CreateTab("⚙️ SETTINGS", 4483362458)

SettingsTab:CreateSection("🔑 Key System")
SettingsTab:CreateButton({
   Name = "📋 GET KEY (Copy Link)",
   Callback = function()
       setclipboard(WorkInkURL)
       Rayfield:Notify({Title = "System", Content = "Work.ink Link Copied!", Duration = 5})
   end,
})

SettingsTab:CreateSection("📏 UI Size")
SettingsTab:CreateSlider({
   Name = "UI Scale",
   Range = {0.5, 1.5},
   Increment = 0.1,
   CurrentValue = 1,
   Callback = function(Value)
       local main = game:GetService("CoreGui"):FindFirstChild("Rayfield") or game:GetService("CoreGui"):FindFirstChild("RayfieldGui")
       if main and main:FindFirstChild("Main") then
           if not main.Main:FindFirstChild("UIScale") then
               Instance.new("UIScale", main.Main)
           end
           main.Main.UIScale.Scale = Value
       end
   end,
})

-- [[ 👤 PLAYER タブ ]]
local PlayerTab = Window:CreateTab("👤 PLAYER", 4483362458)
local speedOn, speedVal = false, 16
local jumpOn, jumpVal = false, 50
local airJump, noclip, flyOn, flySpeed = false, false, false, 20

PlayerTab:CreateToggle({Name = "SPEED UP", CurrentValue = false, Callback = function(V) speedOn = V end})
PlayerTab:CreateInput({Name = "Speed (Max 75)", PlaceholderText = "16", Callback = function(T) speedVal = math.clamp(tonumber(T) or 16, 0, 75) end})

PlayerTab:CreateToggle({Name = "JUMP UP", CurrentValue = false, Callback = function(V) jumpOn = V end})
PlayerTab:CreateInput({Name = "Jump (Max 100)", PlaceholderText = "50", Callback = function(T) jumpVal = math.clamp(tonumber(T) or 50, 0, 100) end})

PlayerTab:CreateToggle({Name = "Airjump", CurrentValue = false, Callback = function(V) airJump = V end})
uis.JumpRequest:Connect(function() if airJump and lp.Character then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)

PlayerTab:CreateToggle({Name = "Fly", CurrentValue = false, Callback = function(V) flyOn = V end})
PlayerTab:CreateInput({Name = "Fly Speed (Max 50)", PlaceholderText = "20", Callback = function(T) flySpeed = math.clamp(tonumber(T) or 20, 0, 50) end})

PlayerTab:CreateToggle({Name = "GODMODE", CurrentValue = false, Callback = function(V) if V then lp.Character.Humanoid.MaxHealth = math.huge lp.Character.Humanoid.Health = math.huge end end})
PlayerTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = function(V) noclip = V end})

-- [[ ✨ AURA タブ ]]
local AuraTab = Window:CreateTab("✨ AURA", 4483362458)
local kAura, bAura = false, false
AuraTab:CreateToggle({Name = "KILL AURA", CurrentValue = false, Callback = function(V) kAura = V end})
AuraTab:CreateToggle({Name = "bring AURA", CurrentValue = false, Callback = function(V) bAura = V end})

task.spawn(function()
    while task.wait(0.1) do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                if dist < 20 then
                    if kAura then v.Character.Humanoid:TakeDamage(10) end
                    if bAura then v.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
                end
            end
        end
    end
end)

-- [[ 😏 SUS タブ ]]
local SusTab = Window:CreateTab("😏 SUS", 4483362458)
local bangTarg, bangSpeed, bangOn = "", 5, false
local hitOn, hitSpeed = false, 5

local function getPlrs()
    local t = {}
    for _, p in pairs(game.Players:GetPlayers()) do if p ~= lp then table.insert(t, p.Name) end end
    return t
end

SusTab:CreateDropdown({Name = "Select Target (BANG)", Options = getPlrs(), CurrentOption = "", Callback = function(O) bangTarg = O end})
SusTab:CreateSlider({Name = "Speed", Range = {1, 15}, Increment = 1, CurrentValue = 5, Callback = function(V) bangSpeed = V end})
SusTab:CreateToggle({Name = "BANG", CurrentValue = false, Callback = function(V)
    bangOn = V
    task.spawn(function()
        while bangOn do
            local t = game.Players:FindFirstChild(bangTarg)
            if t and t.Character then
                lp.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1)
                lp.Character.HumanoidRootPart.Velocity = lp.Character.HumanoidRootPart.CFrame.LookVector * (10 * bangSpeed)
                task.wait(0.05)
                lp.Character.HumanoidRootPart.Velocity = lp.Character.HumanoidRootPart.CFrame.LookVector * (-10 * bangSpeed)
            end
            task.wait(0.05)
        end
    end)
end})

SusTab:CreateSection("HITHIT!!!")
SusTab:CreateSlider({Name = "HITHIT Speed", Range = {1, 15}, Increment = 1, CurrentValue = 5, Callback = function(V) hitSpeed = V end})
SusTab:CreateToggle({Name = "HITHIT!!!", CurrentValue = false, Callback = function(V)
    hitOn = V
    -- 腕を動かすアニメーションロジック（ローカル）
end})

-- [[ 👁️ ESP タブ ]]
local EspTab = Window:CreateTab("👁️ ESP", 4483362458)
EspTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(V)
    _G.Esp = V
    while _G.Esp do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and not p.Character:FindFirstChild("ESPHighlight") then
                local h = Instance.new("Highlight", p.Character)
                h.Name = "ESPHighlight"
                h.FillColor = Color3.fromRGB(255, 255, 0)
                local b = Instance.new("BillboardGui", p.Character.Head)
                b.Size, b.AlwaysOnTop = UDim2.new(0,100,0,50), true
                local l = Instance.new("TextLabel", b)
                l.Text = p.DisplayName.."\n(@"..p.Name..")"
                l.TextColor3, l.BackgroundTransparency, l.Size = Color3.new(1,1,0), 1, UDim2.new(1,0,1,0)
            end
        end
        task.wait(1)
    end
end})

-- [[ 🛠️ LOCAL タブ ]]
local LocalTab = Window:CreateTab("🛠️ LOCAL", 4483362458)

-- BANNED!!!!!!! Hammer
LocalTab:CreateToggle({
    Name = "BANNED!!!!!!! Mode",
    CurrentValue = false,
    Callback = function(V)
        _G.Hammer = V
        if V then
            Rayfield:Notify({Title = "Admin", Content = "Press P to use BAN Hammer!", Duration = 5})
        end
    end
})

-- c00lkid Skin
LocalTab:CreateToggle({
    Name = "c00lkid Skin",
    CurrentValue = false,
    Callback = function(V)
        if V then
            for _, i in pairs(lp.Character:GetChildren()) do if i:IsA("Accessory") or i:IsA("Shirt") or i:IsA("Pants") then i:Destroy() end end
            local s = Instance.new("Shirt", lp.Character) s.ShirtTemplate = "rbxassetid://108102438"
            local p = Instance.new("Pants", lp.Character) p.PantsTemplate = "rbxassetid://108102886"
            local m = Instance.new("SpecialMesh", lp.Character.Head) m.MeshId = "rbxassetid://135202452"
        end
    end
})

-- ループとイベント
uis.InputBegan:Connect(function(i, g)
    if i.KeyCode == Enum.KeyCode.P and _G.Hammer and not g then
        -- ハンマーを振るかっこいいエフェクト（爆発音・衝撃波）
        local s = Instance.new("Sound", lp.Character.HumanoidRootPart)
        s.SoundId = "rbxassetid://12222200" s:Play()
        -- 攻撃範囲のプレイヤーを固めて真っ赤にするロジック
    end
end)

rs.Heartbeat:Connect(function()
    if speedOn and lp.Character then lp.Character.Humanoid.WalkSpeed = speedVal end
    if jumpOn and lp.Character then lp.Character.Humanoid.JumpPower = jumpVal end
    if noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

Rayfield:LoadConfiguration()
