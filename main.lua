local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ ⚙️ CONFIG ]]
local CORRECT_KEY = "KEY-SHZ7-Ajd1-18Aw-amQv"
local KEY_LINK = "Https://work.ink/2xWq/xxs-dragon-hub2026no1-key" -- 更新済み

local Window = Fluent:CreateWindow({
    Title = "XXS-DRGON-HUB_DX",
    SubTitle = "by GOTTS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local KeyTab = Window:AddTab({ Title = "key", Icon = "key" })
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local Target, WalkSpeed, JumpPower, FlySpeed = "", 16, 50, 50

-- [[ 🗝️ KEY SYSTEM (図 1000008812 再現) ]]
local KeyInput = KeyTab:AddInput("KeyIn", {Title = "key", Placeholder = "Enter Key..."})
KeyTab:AddButton({Title = "Get Key", Callback = function() setclipboard(KEY_LINK); Fluent:Notify({Title="System", Content="リンクをコピーしました"}) end})
KeyTab:AddButton({Title = "Let's go!", Callback = function()
    if KeyInput.Value == CORRECT_KEY then
        KeyTab:Destroy()
        LoadMainHub()
    else
        Fluent:Notify({Title = "Error", Content = "キーが違います", Duration = 3})
    end
end})
KeyTab:AddParagraph({Title = "", Content = "                                                                        BY GOTTS"})

-- [[ 🐉 MAIN HUB FUNCTIONS ]]
function LoadMainHub()
    local Tabs = {
        Lang = Window:AddTab({ Title = "English/Japanese", Icon = "languages" }),
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Wow = Window:AddTab({ Title = "WOW", Icon = "skull" })
    }

    -- Language (図 1000008813)
    Tabs.Lang:AddButton({Title = "English ✔️", Callback = function() end})
    Tabs.Lang:AddButton({Title = "Japanese ◯", Callback = function() end})

    -- Player (図 1000008814)
    Tabs.Player:AddSlider("Spd", {Title = "Speed", Default = 16, Min = 16, Max = 500, Callback = function(v) WalkSpeed = v end})
    Tabs.Player:AddSlider("Jmp", {Title = "JUMP", Default = 50, Min = 50, Max = 500, Callback = function(v) JumpPower = v end})
    local FlyT = Tabs.Player:AddToggle("Fly", {Title = "fly", Default = false})
    Tabs.Player:AddSlider("FlSp", {Title = "fly speed", Default = 50, Min = 1, Max = 500, Callback = function(v) FlySpeed = v end})
    local AirJ = Tabs.Player:AddToggle("AirJ", {Title = "airjump", Default = false})
    local Noc = Tabs.Player:AddToggle("Noc", {Title = "Noclip", Default = false})

    -- WOW (図 1000008815 + 腰曲げ90度パンパン)
    local Bang = Tabs.Wow:AddToggle("Bang", {Title = "BANG", Default = false})
    local Voice = Tabs.Wow:AddToggle("Voice", {Title = "AHH!!! Voice text", Default = false})
    local Dropdown = Tabs.Wow:AddDropdown("Plr", { Title = "Select Target", Values = {}, Callback = function(v) Target = v end })
    Tabs.Wow:AddButton({Title = "Refresh Players", Callback = function()
        local t = {}; for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end; Dropdown:SetValues(t)
    end})

    -- 物理ループ
    rs.RenderStepped:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        char.Humanoid.WalkSpeed = WalkSpeed
        char.Humanoid.JumpPower = JumpPower

        if Noc.Value then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if FlyT.Value then char.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed + Vector3.new(0,2,0) end

        if Bang.Value and Target ~= "" then
            local tPlr = game.Players:FindFirstChild(Target)
            if tPlr and tPlr.Character and tPlr.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = tPlr.Character.HumanoidRootPart
                local joint = tPlr.Character:FindFirstChild("LowerTorso") and tPlr.Character.LowerTorso:FindFirstChild("Root")
                -- 腰を90度曲げる
                if joint then joint.C1 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), 0, 0) end
                -- パンパン往復運動
                char.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(0, -0.5, 1.2 + math.sin(tick() * 25) * 0.8)
                
                -- AHH!!! テキスト表示
                if Voice.Value and tPlr.Character:FindFirstChild("Head") then
                    local h = tPlr.Character.Head
                    local g = h:FindFirstChild("SusG") or Instance.new("BillboardGui", h)
                    g.Name = "SusG"; g.Size = UDim2.new(0,200,0,50); g.AlwaysOnTop = true; g.ExtentsOffset = Vector3.new(0,3,0)
                    local l = g:FindFirstChild("L") or Instance.new("TextLabel", g)
                    l.Name = "L"; l.Size = UDim2.new(1,0,1,0); l.BackgroundTransparency = 1; l.Text = "Ahh.... nnn.... more! More!!"; l.TextColor3 = Color3.new(1,0,0); l.TextSize = 18
                end
            end
        end
    end)

    uis.JumpRequest:Connect(function() if AirJ.Value then lp.Character.Humanoid:ChangeState("Jumping") end end)
    Window:SelectTab(2)
end

Window:SelectTab(1)
