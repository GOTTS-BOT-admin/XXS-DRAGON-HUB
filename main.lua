local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "XXS-DRAGON-HUB v2.0",
    SubTitle = "by admin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- [[ 変数設定 ]]
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local WalkSpeed, JumpPower = 16, 50
local Target = ""
local bS = 5

-- [[ タブ作成 ]]
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Aura = Window:AddTab({ Title = "Aura", Icon = "zap" }),
    Sus = Window:AddTab({ Title = "😏 SUS", Icon = "skull" }),
    Local = Window:AddTab({ Title = "Local", Icon = "terminal" })
}

-- [[ 1. Main タブ ]]
Tabs.Main:AddButton({
    Title = "📋 Copy Key Link",
    Callback = function()
        setclipboard("https://work.ink/2xWq/xxs-dragon-hub2026no1-key")
        Fluent:Notify({ Title = "System", Content = "Link Copied!", Duration = 5 })
    end
})

-- [[ 2. Player タブ ]]
local SpdToggle = Tabs.Player:AddToggle("SpdToggle", {Title = "Speed Up", Default = false })
Tabs.Player:AddSlider("SpdSlider", { Title = "Speed", Default = 16, Min = 16, Max = 100, Rounding = 1, Callback = function(v) WalkSpeed = v end })

local JmpToggle = Tabs.Player:AddToggle("JmpToggle", {Title = "Jump Up", Default = false })
Tabs.Player:AddSlider("JmpSlider", { Title = "Jump", Default = 50, Min = 50, Max = 200, Rounding = 1, Callback = function(v) JumpPower = v end })

local FlyToggle = Tabs.Player:AddToggle("FlyToggle", {Title = "Fly", Default = false })
local NcToggle = Tabs.Player:AddToggle("NcToggle", {Title = "Noclip", Default = false })

-- [[ 3. Aura タブ ]]
local KAToggle = Tabs.Aura:AddToggle("KAToggle", {Title = "Kill Aura", Default = false })
local BAToggle = Tabs.Aura:AddToggle("BAToggle", {Title = "Bring Aura", Default = false })

-- [[ 4. 😏 SUS タブ ]]
local BangToggle = Tabs.Sus:AddToggle("BangToggle", {Title = "BANG", Default = false })
local HitToggle = Tabs.Sus:AddToggle("HitToggle", {Title = "HITHIT!!!", Default = false })

local Dropdown = Tabs.Sus:AddDropdown("PlrDrop", { Title = "Select Target", Values = {}, Callback = function(v) Target = v end })
local function Upd()
    local t = {}
    for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end
    Dropdown:SetValues(t)
end
Upd()
Tabs.Sus:AddButton({ Title = "🔄 Refresh List", Callback = Upd })
Tabs.Sus:AddSlider("SusSpeed", { Title = "Action Speed", Default = 5, Min = 1, Max = 20, Rounding = 1, Callback = function(v) bS = v end })

-- [[ 5. Local タブ ]]
local EspToggle = Tabs.Local:AddToggle("EspToggle", {Title = "Player ESP", Default = false })
local HamToggle = Tabs.Local:AddToggle("HamToggle", {Title = "BANNED Hammer (P Key)", Default = false })

Tabs.Local:AddButton({
    Title = "Apply c00lkid Skin",
    Callback = function()
        local c = lp.Character
        for _, v in pairs(c:GetChildren()) do if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end end
        Instance.new("Shirt", c).ShirtTemplate = "rbxassetid://108102438"
        Instance.new("Pants", c).PantsTemplate = "rbxassetid://108102886"
        local m = Instance.new("SpecialMesh", c.Head); m.MeshId = "rbxassetid://135202452"
    end
})

-- [[ 🔄 統合ループ ]]
rs.Heartbeat:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    if SpdToggle.Value then char.Humanoid.WalkSpeed = WalkSpeed end
    if JmpToggle.Value then char.Humanoid.JumpPower = JumpPower end
    if NcToggle.Value then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if FlyToggle.Value then char.HumanoidRootPart.Velocity = Vector3.new(0,5,0) + (char.Humanoid.MoveDirection * 40) end

    -- BANG
    if BangToggle.Value and Target ~= "" then
        local p = game.Players:FindFirstChild(Target)
        if p and p.Character then
            char.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1) * CFrame.Angles(0, math.rad(180), 0)
            char.HumanoidRootPart.CFrame *= CFrame.new(0, 0, math.sin(tick() * bS * 2) * 1.5)
        end
    end

    -- HITHIT
    if HitToggle.Value then
        char.Humanoid.HipHeight = 0.5 + math.sin(tick() * bS * 2) * 0.5
    end

    -- Aura & ESP
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < 20 then
                if KAToggle.Value then v.Character.Humanoid:TakeDamage(1) end
                if BAToggle.Value then v.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
            end
            if EspToggle.Value then
                if not v.Character:FindFirstChild("ESP") then
                    local b = Instance.new("BillboardGui", v.Character); b.Name = "ESP"; b.Size = UDim2.new(0,100,0,50); b.AlwaysOnTop = true; b.ExtentsOffset = Vector3.new(0,3,0)
                    local l = Instance.new("TextLabel", b); l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.TextColor3 = Color3.new(1,1,0); l.Text = v.Name
                end
            elseif v.Character:FindFirstChild("ESP") then v.Character.ESP:Destroy() end
        end
    end
end)

-- P Key for Hammer
uis.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P and HamToggle.Value then
        local s = Instance.new("Sound", lp.Character.HumanoidRootPart); s.SoundId = "rbxassetid://12222200"; s:Play()
        local e = Instance.new("Explosion", workspace); e.Position = lp.Character.HumanoidRootPart.Position + (lp.Character.HumanoidRootPart.CFrame.LookVector * 5); e.BlastRadius = 0
        Fluent:Notify({ Title = "BAN", Content = "BANNED!!!", Duration = 2 })
    end
end)

Window:SelectTab(1)
