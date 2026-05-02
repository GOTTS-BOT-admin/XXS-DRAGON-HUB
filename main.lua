local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDZHUB/RedzLibV5/main/Source.lua"))()

-- [[ 🗝️ ウィンドウ作成 ]]
local Window = RedzLib:MakeWindow({
  Title = "XXS-DRAGON-HUB v2.0",
  SubTitle = "by XXS-DRAGON-HUB-admin",
  SaveFolder = "XXS_Dragon_Config"
})

-- 共通変数
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

-- [[ 🔑 KEY SYSTEM ]]
local KeyTab = Window:AddTab({ Name = "KEY SYSTEM", Icon = "rbxassetid://6031104609" })
KeyTab:AddButton({
  Name = "📋 GET KEY (Work.ink)",
  Callback = function()
    setclipboard("https://work.ink/2xWq/xxs-dragon-hub2026no1-key")
    RedzLib:SetNotification("System", "Link Copied!", 5)
  end
})

-- [[ 👤 PLAYER タブ ]]
local PlayerTab = Window:AddTab({ Name = "PLAYER", Icon = "rbxassetid://6031104612" })
local sOn, sV, jOn, jV, aJ, flyOn, flyV, nC = false, 16, false, 50, false, false, 20, false

PlayerTab:AddToggle({ Name = "SPEED UP", Callback = function(V) sOn = V end })
PlayerTab:AddTextBox({ Name = "Max 75", Default = "16", Callback = function(T) sV = math.clamp(tonumber(T) or 16, 0, 75) end })
PlayerTab:AddToggle({ Name = "JUMP UP", Callback = function(V) jOn = V end })
PlayerTab:AddTextBox({ Name = "Max 100", Default = "50", Callback = function(T) jV = math.clamp(tonumber(T) or 50, 0, 100) end })
PlayerTab:AddToggle({ Name = "Airjump", Callback = function(V) aJ = V end })
PlayerTab:AddToggle({ Name = "Fly", Callback = function(V) flyOn = V end })
PlayerTab:AddToggle({ Name = "GODMODE", Callback = function(V) if V then lp.Character.Humanoid.MaxHealth = math.huge lp.Character.Humanoid.Health = math.huge end end })
PlayerTab:AddToggle({ Name = "Noclip", Callback = function(V) nC = V end })

-- [[ ✨ AURA タブ ]]
local AuraTab = Window:AddTab({ Name = "AURA", Icon = "rbxassetid://6031104611" })
local kA, bA = false, false
AuraTab:AddToggle({ Name = "KILL AURA", Callback = function(V) kA = V end })
AuraTab:AddToggle({ Name = "bring AURA", Callback = function(V) bA = V end })

-- [[ 😏 SUS タブ ]]
local SusTab = Window:AddTab({ Name = "SUS", Icon = "rbxassetid://6031104610" })
local bT, bS, bActive, hActive, hS = "", 5, false, false, 5

local function getPlrs()
    local t = {}
    for _, p in pairs(game.Players:GetPlayers()) do if p ~= lp then table.insert(t, p.DisplayName.." (@"..p.Name..")") end end
    return t
end

local Dropdown = SusTab:AddDropdown({ Name = "Select Target", Options = getPlrs(), Callback = function(O) bT = string.match(O, "@(%w+)") or "" end })
SusTab:AddButton({ Name = "🔄 Refresh List", Callback = function() Dropdown:SetOptions(getPlrs()) end })
SusTab:AddSlider({ Name = "Action Speed", Min = 1, Max = 15, Default = 5, Callback = function(V) bS = V hS = V end })

SusTab:AddToggle({ Name = "BANG", Callback = function(V) bActive = V end })
SusTab:AddToggle({ Name = "HITHIT!!!", Callback = function(V) hActive = V end })

-- [[ 👁️ ESP タブ ]]
local EspTab = Window:AddTab({ Name = "ESP", Icon = "rbxassetid://6034502934" })
EspTab:AddToggle({ Name = "Player ESP", Callback = function(V) _G.EspActive = V end })

-- [[ 🛠️ LOCAL タブ ]]
local LocalTab = Window:AddTab({ Name = "LOCAL", Icon = "rbxassetid://6031104613" })
LocalTab:AddToggle({ Name = "BANNED Mode (P Key)", Callback = function(V) _G.Hammer = V end })
LocalTab:AddButton({
    Name = "Apply c00lkid Skin",
    Callback = function()
        for _, i in pairs(lp.Character:GetChildren()) do if i:IsA("Accessory") or i:IsA("Shirt") or i:IsA("Pants") then i:Destroy() end end
        local s = Instance.new("Shirt", lp.Character); s.ShirtTemplate = "rbxassetid://108102438"
        local p = Instance.new("Pants", lp.Character); p.PantsTemplate = "rbxassetid://108102886"
        local m = Instance.new("SpecialMesh", lp.Character.Head); m.MeshId = "rbxassetid://135202452"
    end
})

-- [[ 核心ロジック ]]

-- ESP & Hammer P Key
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P and _G.Hammer then
        -- ローカル爆発演出
        local sound = Instance.new("Sound", lp.Character.HumanoidRootPart)
        sound.SoundId = "rbxassetid://12222200"; sound:Play()
        local exp = Instance.new("Explosion", workspace)
        exp.Position = lp.Character.HumanoidRootPart.Position + (lp.Character.HumanoidRootPart.CFrame.LookVector * 4)
        exp.BlastRadius = 0 -- ローカルのみ
        RedzLib:SetNotification("BAN", "BANNED!!!!!!!", 2)
    end
end)

rs.Heartbeat:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    -- PLAYER
    if sOn then char.Humanoid.WalkSpeed = sV end
    if jOn then char.Humanoid.JumpPower = jV end
    if nC then for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
    if flyOn then char.HumanoidRootPart.Velocity = Vector3.new(0,2,0) + (char.Humanoid.MoveDirection * flyV * 2.5) end

    -- BANG (😏)
    if bActive and bT ~= "" then
        local target = game.Players:FindFirstChild(bT)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.1) * CFrame.Angles(0, math.rad(180), 0)
            local backForth = math.sin(tick() * (bS * 2.5)) * 1.2
            char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, backForth)
        end
    end

    -- HITHIT!!! (😏)
    if hActive then
        local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
        if rArm then
            char.Humanoid.HipHeight = 0.5 + math.sin(tick() * hS) * 0.2 -- 体も上下させる
        end
    end

    -- AURA
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < 20 then
                if kA then v.Character.Humanoid:TakeDamage(1) end
                if bA then v.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,-3) end
            end
            -- ESP (タグ生成)
            if _G.EspActive then
                if not v.Character:FindFirstChild("XXS_ESP") then
                    local bg = Instance.new("BillboardGui", v.Character); bg.Name = "XXS_ESP"; bg.Size = UDim2.new(0,100,0,50); bg.AlwaysOnTop = true; bg.ExtentsOffset = Vector3.new(0,3,0)
                    local tl = Instance.new("TextLabel", bg); tl.Size = UDim2.new(1,0,1,0); tl.BackgroundTransparency = 1; tl.TextColor3 = Color3.new(1,0,0); tl.TextStrokeTransparency = 0; tl.Text = v.DisplayName
                end
            else
                if v.Character:FindFirstChild("XXS_ESP") then v.Character.XXS_ESP:Destroy() end
            end
        end
    end
end)

uis.JumpRequest:Connect(function() if aJ then lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end end)
