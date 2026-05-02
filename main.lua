-- [[ XXS-DRAGON-HUB v2.0 / MULTILINGUAL & TP UPDATE ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 🔑 ユーザー設定 (ここを自分のリンクに変える)
local WorkInkURL = "https://work.ink/xxxxxx/xxxxxx"
local LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv"

-- [[ 🌐 言語データ定義 ]]
local lang = {
    curr = "en", -- 起動時のデフォルト (jp に変えると最初から日本語)
    data = {
        en = {
            m_title = "🐉 XXS-DRAGON-HUB v2.0",
            m_sub = "by XXS-DRAGON-HUB-admin",
            t_player = "👤 PLAYER",
            t_sus = "😏 (Sus)",
            t_set = "⚙️ SETTINGS",
            f_tp_toggle = "TP Command (C Key / Button)",
            f_ui_trans = "UI Transparency",
            f_lang_sel = "Select Language",
            n_changed = "Language Changed!"
        },
        jp = {
            m_title = "🐉 XXS-DRAGON-HUB v2.0 (admin製)",
            m_sub = "XXS-DRAGON-HUB-adminが開発",
            t_player = "👤 プレイヤー",
            t_sus = "😏 (ネタ機能)",
            t_set = "⚙️ 設定",
            f_tp_toggle = "TPコマンド (Cキー / ボタン)",
            f_ui_trans = "メニューの透明度",
            f_lang_sel = "言語を選択してください",
            n_changed = "言語を切り替えました！"
        }
    }
}

-- 現在の言語データをセット
local d = lang.data[lang.curr]

-- [[ 🗝️ ウィンドウ作成 ]]
local Window = Rayfield:CreateWindow({
   Name = d.m_title,
   LoadingTitle = "XXS-DRAGON-HUB Loading...",
   LoadingSubtitle = d.m_sub,
   KeySystem = true,
   KeySettings = {
      Title = "XXS-DRAGON KEY SYSTEM",
      Subtitle = "Get Key from Work.ink",
      Note = "The key is updated irregularly",
      Key = {LatestKey}
   }
})

-- [[ ⚙️ SETTINGS タブ ]]
local SettingsTab = Window:CreateTab(d.t_set, 4483362458)
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local uis = game:GetService("UserInputService")

-- 言語切り替えボタン
SettingsTab:CreateSection(d.f_lang_sel)
SettingsTab:CreateButton({
   Name = "English / 日本語 (Toggle)",
   Callback = function()
       if lang.curr == "en" then lang.curr = "jp" else lang.curr = "en" end
       Rayfield:Notify({Title = "System", Content = lang.data[lang.curr].n_changed, Duration = 3})
       -- 注意: Rayfieldの仕様上、タブ名の即時書き換えは再ロードが必要です
   end,
})

-- TP機能のロジック
SettingsTab:CreateSection("Teleport Module")
_G.TPEnabled = false
local function doTeleport()
    if _G.TPEnabled then
        local char = lp.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end

SettingsTab:CreateToggle({
   Name = d.f_tp_toggle,
   CurrentValue = false,
   Callback = function(Value)
      _G.TPEnabled = Value
      if uis.TouchEnabled then -- スマホ判定
          if Value then
              if not _G.TPButton then
                  _G.TPButton = Instance.new("ScreenGui", game.CoreGui)
                  local btn = Instance.new("TextButton", _G.TPButton)
                  btn.Size = UDim2.new(0, 65, 0, 65)
                  btn.Position = UDim2.new(1, -80, 1, -80)
                  btn.Text = "TP"
                  btn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
                  local corner = Instance.new("UICorner", btn)
                  corner.CornerRadius = UDim.new(0, 10)
                  btn.MouseButton1Click:Connect(doTeleport)
              end
              _G.TPButton.Enabled = true
          else
              if _G.TPButton then _G.TPButton.Enabled = false end
          end
      end
   end,
})

-- PC用 Cキー
uis.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.C then doTeleport() end
end)

-- [[ 👤 PLAYER タブ ]]
local PlayerTab = Window:CreateTab(d.t_player, 4483362458)
PlayerTab:CreateInput({
   Name = "Speed Value",
   PlaceholderText = "16",
   Callback = function(Text)
      local val = tonumber(Text)
      if val then lp.Character.Humanoid.WalkSpeed = val end
   end,
})

-- [[ 😏 SUS タブ ]]
local SusTab = Window:CreateTab(d.t_sus, 4483362458)
local susSpeed = 1
SusTab:CreateSlider({Name = "HITHIT Speed", Range = {1, 20}, Increment = 1, CurrentValue = 1, Callback = function(v) susSpeed = v end})

SusTab:CreateToggle({
   Name = "HITHIT!!! (Server Sided)",
   CurrentValue = false,
   Callback = function(Value)
      _G.HitHitEnabled = Value
      task.spawn(function()
          while _G.HitHitEnabled do
              local char = lp.Character
              if char and char:FindFirstChild("HumanoidRootPart") then
                  char.HumanoidRootPart.Velocity = char.HumanoidRootPart.CFrame.LookVector * (15 * susSpeed)
                  task.wait(0.05)
                  char.HumanoidRootPart.Velocity = -char.HumanoidRootPart.CFrame.LookVector * (15 * susSpeed)
                  task.wait(0.05)
              else break end
          end
      end)
   end,
})

Rayfield:LoadConfiguration()
