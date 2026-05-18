local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- [[ ⚙️ CONFIG ]]
local CORRECT_KEY = "KEY-SHZ7-Ajd1-18Aw-amQv"
local KEY_LINK = "Https://work.ink/2xWq/xxs-dragon-hub2026no1-key"

-- [[ 📱 モバイル用トップバー（トグルボタン） ]]
local CoreGui = game:GetService("CoreGui")
local ToggleScreen = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ToggleScreen.Name = "XXS_Toggle_Screen"
ToggleScreen.Parent = CoreGui
ToggleScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleScreen
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.5, -100, 0, 5)
ToggleButton.Size = UDim2.new(0, 200, 0, 30)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "XXS-DRAGON-HUB"
ToggleButton.TextColor3 = Color3.fromRGB(255, 50, 50)
ToggleButton.TextSize = 14

local UICorner = Instance.new("UICorner")
local UIBorder = Instance.new("UIStroke")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton
UIBorder.Color = Color3.fromRGB(150, 0, 0)
UIBorder.Thickness = 1
UIBorder.Parent = ToggleButton

-- [[ 🗝️ メインウィンドウ作成 ]]
local Window = Fluent:CreateWindow({
    Title = "XXS-DRGON-HUB_DX",
    SubTitle = "by GOTTS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

ToggleButton.MouseButton1Click:Connect(function()
    Window:Toggle()
end)

local KeyTab = Window:AddTab({ Title = "key", Icon = "key" })
local lp = game.Players.LocalPlayer
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local Target, WalkSpeed, JumpPower, FlySpeed = "", 16, 50, 50
local Tabs = {}
local AlreadyLoaded = false

-- アニメーション用変数
local AnimSpeed = 1.0 -- 初期値 100%
local ShakeActive = false

-- [[ 🗝️ KEY SYSTEM ]]
local KeyInput = KeyTab:AddInput("KeyIn", {Title = "key", Placeholder = "Enter Key..."})
KeyTab:AddButton({Title = "Get Key", Callback = function() setclipboard(KEY_LINK) end})
KeyTab:AddButton({Title = "Let's go!", Callback = function()
    if KeyInput.Value == CORRECT_KEY then
        if AlreadyLoaded then return end
        AlreadyLoaded = true
        LoadMainHub()
    else
        Fluent:Notify({Title = "Error", Content = "キーが違います", Duration = 3})
    end
end})

-- [[ 🐉 MAIN HUB FUNCTIONS ]]
function LoadMainHub()
    Tabs.Lang = Window:AddTab({ Title = "English/Japanese", Icon = "languages" })
    Tabs.Player = Window:AddTab({ Title = "Player", Icon = "user" })
    Tabs.Anim = Window:AddTab({ Title = "Animation (R6)", Icon = "clapperboard" }) -- 【新設】
    Tabs.Wow = Window:AddTab({ Title = "WOW", Icon = "skull" })
    Tabs.OP = Window:AddTab({ Title = "⚙️ OP Gimmick", Icon = "zap" })

    -- --- 1. Language ---
    Tabs.Lang:AddButton({Title = "English ✔️", Callback = function() end})
    Tabs.Lang:AddButton({Title = "Japanese ◯", Callback = function() end})

    -- --- 2. Player ---
    Tabs.Player:AddSlider("Spd", {Title = "Speed", Default = 16, Min = 16, Max = 500, Callback = function(v) WalkSpeed = v end})
    Tabs.Player:AddSlider("Jmp", {Title = "JUMP", Default = 50, Min = 50, Max = 500, Callback = function(v) JumpPower = v end})
    local FlyT = Tabs.Player:AddToggle("Fly", {Title = "fly", Default = false})
    Tabs.Player:AddSlider("FlSp", {Title = "fly speed", Default = 50, Min = 1, Max = 500, Callback = function(v) FlySpeed = v end})
    local AirJ = Tabs.Player:AddToggle("AirJ", {Title = "airjump", Default = false})
    local Noc = Tabs.Player:AddToggle("Noc", {Title = "Noclip", Default = false})

    -- --- 3. Animation タブ (R6専用・非ローカル) ---
    -- ① アニメーションの速さ (200%から0%まで10%ごと)
    Tabs.Anim:AddSlider("AnimSpd", {
        Title = "アニメーションの速さ (%)",
        Default = 100,
        Min = 0,
        Max = 200,
        Rounding = 10, -- 10%刻みに設定
        Callback = function(v)
            AnimSpeed = v / 100 -- スクリプト計算用に倍率に変換 (例: 150% -> 1.5)
        end
    })

    -- ② 右手を自分の股に置いて上下に振るやつ (トグル形式)
    local HandShakeT = Tabs.Anim:AddToggle("HandShake", {Title = "右手を股において上下に振る", Default = false})
    HandShakeT:OnChanged(function()
        ShakeActive = HandShakeT.Value
        if not ShakeActive then
            -- オフにしたら右手のジョイント位置を元に戻す
            pcall(function()
                local shoulder = lp.Character.Torso["Right Shoulder"]
                shoulder.C1 = CFrame.new(-0.5, 0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
            end)
        end
    end)

    -- ③ 75個のアニメーション選択スロット (Dropdownでスマートに選択)
    local AnimList = {}
    table.insert(AnimList, "選択なし")
    for i = 1, 75 do
        table.insert(AnimList, "アニメーション " .. i)
    end
    
    Tabs.Anim:AddDropdown("Anim75", {
        Title = "アニメーション リスト (全75個スロット)",
        Values = AnimList,
        Default = "選択なし",
        Callback = function(v)
            if v ~= "選択なし" then
                Fluent:Notify({Title = "Animation", Content = v .. " が選択されました（ID未セット）", Duration = 2})
                -- ここに将来使いたいアニメーションIDの再生ロジックを入れられます
            end
        end
    })

    -- --- 4. WOW ---
    local Bang = Tabs.Wow:AddToggle("Bang", {Title = "BANG", Default = false})
    local Voice = Tabs.Wow:AddToggle("Voice", {Title = "AHH!!! Voice text", Default = false})
    local SpinBot = Tabs.Wow:AddToggle("Spin", {Title = "💥 Spin Bot (超高速スピン)", Default = false})
    local Dropdown = Tabs.Wow:AddDropdown("Plr", { Title = "Select Target", Values = {}, Callback = function(v) Target = v end })
    Tabs.Wow:AddButton({Title = "Refresh Players", Callback = function()
        local t = {}; for _, v in pairs(game.Players:GetPlayers()) do if v ~= lp then table.insert(t, v.Name) end end; Dropdown:SetValues(t)
    end})

    -- --- 5. ⚙️ OP Gimmick ---
    local GodMode = Tabs.OP:AddToggle("God", {Title = "🛡️ Semi-God Mode (簡易無敵)", Default = false})
    local FullBright = Tabs.OP:AddToggle("FB", {Title = "👁️ Full Bright (明暗ハック)", Default = false})

    GodMode:OnChanged(function()
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, not GodMode.Value)
        end
    end)
    FullBright:OnChanged(function()
        game:GetService("Lighting").Ambient = FullBright.Value and Color3.fromRGB(255,255,255) or Color3.fromRGB(128,128,128)
        game:GetService("Lighting").Brightness = FullBright.Value and 2 or 1
    end)

    -- --- 🔄 物理演算ループ（RenderStepped） ---
    rs.RenderStepped:Connect(function()
        local char = lp.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        -- R6リグかどうかの安全チェック
        local isR6 = char:FindFirstChild("Torso") and not char:FindFirstChild("UpperTorso")

        char.Humanoid.WalkSpeed = WalkSpeed
        char.Humanoid.JumpPower = JumpPower

        if Noc.Value then for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end
        if FlyT.Value then char.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * FlySpeed + Vector3.new(0,2,0) end
        if SpinBot.Value then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0) end

        -- 【R6専用：右手を股に置いて振る物理アニメーションロジック】
        if ShakeActive and isR6 then
            pcall(function()
                local shoulder = char.Torso:FindFirstChild("Right Shoulder")
                if shoulder then
                    -- 速度スライダー（AnimSpeed）を時間計算に掛け合わせる（0%なら完全に止まる）
                    local wave = math.sin(tick() * 30 * AnimSpeed) * 0.4
                    -- 右手の位置を股（フロント側中央）に固定し、上下に高速シェイク
                    shoulder.C1 = CFrame.new(-0.2, 0.7 + wave, 0.6) * CFrame.Angles(math.rad(-45), math.rad(110), 0)
                end
            end)
        end

        -- BANG & 90度腰曲げパンパン
        if Bang.Value and Target ~= "" then
            local tPlr = game.Players:FindFirstChild(Target)
            if tPlr and tPlr.Character and tPlr.Character:FindFirstChild("HumanoidRootPart") then
                local tRoot = tPlr.Character.HumanoidRootPart
                local joint = tPlr.Character:FindFirstChild("LowerTorso") and tPlr.Character.LowerTorso:FindFirstChild("Root")
                if joint then joint.C1 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), 0, 0) end
                
                char.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(0, -0.5, 1.2 + math.sin(tick() * 25) * 0.8)
                if SpinBot.Value then char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0) end
                
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
    Window:SelectTab(3) -- 起動時に新設したAnimationタブを自動で開く
end

Window:SelectTab(1)
