-- [[ XXS-DRAGON-HUB / KEY SYSTEM & UI LOADER ]]
local RawKeyURL = "https://pastebin.com/raw/utxwjncL"
local success, LatestKey = pcall(function() return game:HttpGet(RawKeyURL):gsub("%s+", "") end)
if not success then LatestKey = "KEY-SHZ7-Ajd1-18Aw-amQv" end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🐉 XXS-DRAGON-HUB | 2026 No.1",
   LoadingTitle = "XXS-DRAGON-HUB Loading...",
   LoadingSubtitle = "by GOTTS-BOT-admin",
   KeySystem = true,
   KeySettings = {
      Title = "XXS-DRAGON KEY SYSTEM",
      Subtitle = "Get Key from Work.ink",
      Note = "The key is updated irregularly",
      FileName = "XXS_Dragon_Key",
      SaveKey = true,
      Key = {LatestKey}
   }
})

-- [[ Variables ]]
local lp = game.Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

-- [[ PLAYER Tab ]]
local PlayerTab = Window:CreateTab("👤 PLAYER", 4483362458)

PlayerTab:CreateSection("Movement")

local walkSpeedValue = 16
PlayerTab:CreateInput({
   Name = "Speed Value (Max 75)",
   PlaceholderText = "16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local val = tonumber(Text)
      if val and val <= 75 then walkSpeedValue = val end
   end,
})

PlayerTab:CreateToggle({
   Name = "SPEED UP",
   CurrentValue = false,
   Callback = function(Value)
      _G.SpeedEnabled = Value
      spawn(function()
          while _G.SpeedEnabled do
              if char:FindFirstChild("Humanoid") then hum.WalkSpeed = walkSpeedValue end
              task.wait()
          end
          hum.WalkSpeed = 16
      end)
   end,
})

local jumpPowerValue = 50
PlayerTab:CreateInput({
   Name = "Jump Value (Max 100)",
   PlaceholderText = "50",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local val = tonumber(Text)
      if val and val <= 100 then jumpPowerValue = val end
   end,
})

PlayerTab:CreateToggle({
   Name = "JUMP UP",
   CurrentValue = false,
   Callback = function(Value)
      hum.JumpPower = Value and jumpPowerValue or 50
      hum.UseJumpPower = true
   end,
})

PlayerTab:CreateToggle({
   Name = "AirJump",
   CurrentValue = false,
   Callback = function(Value)
      _G.AirJump = Value
      game:GetService("UserInputService").JumpRequest:Connect(function()
          if _G.AirJump then hum:ChangeState("Jumping") end
      end)
   end,
})

PlayerTab:CreateSection("Special States")

local flySpeed = 25
PlayerTab:CreateInput({
   Name = "Fly Speed (Max 50)",
   PlaceholderText = "25",
   Callback = function(Text)
      local val = tonumber(Text)
      if val and val <= 50 then flySpeed = val end
   end,
})

PlayerTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = function(Value)
       Rayfield:Notify({Title = "Fly", Content = "Fly mode: " .. tostring(Value), Duration = 2})
   end,
})

PlayerTab:CreateToggle({Name = "GODMODE", CurrentValue = false, Callback = function(Value) end})

PlayerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(Value)
      _G.Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
          if _G.Noclip then
              for _, v in pairs(char:GetDescendants()) do
                  if v:IsA("BasePart") then v.CanCollide = false end
              end
          end
      end)
   end,
})

-- [[ AURA Tab ]]
local AuraTab = Window:CreateTab("⚔️ AURA", 4483362458)
AuraTab:CreateToggle({Name = "KILL AURA", CurrentValue = false, Callback = function(Value) end})
AuraTab:CreateToggle({Name = "Bring AURA", CurrentValue = false, Callback = function(Value) end})

-- [[ 😏 Tab ]]
local SusTab = Window:CreateTab("😏", 4483362458)

local targetPlayer = ""
local playerNames = {}
for _, v in pairs(game.Players:GetPlayers()) do
    if v ~= lp then table.insert(playerNames, v.DisplayName .. " (@" .. v.Name .. ")") end
end

SusTab:CreateDropdown({
   Name = "Select Target",
   Options = playerNames,
   CurrentOption = "",
   Callback = function(Option) targetPlayer = Option end,
})

local susSpeed = 1
SusTab:CreateSlider({
   Name = "Action Speed",
   Range = {1, 15},
   Increment = 1,
   CurrentValue = 1,
   Callback = function(Value) susSpeed = Value end,
})

SusTab:CreateToggle({Name = "BANG", CurrentValue = false, Callback = function(Value) end})
SusTab:CreateToggle({Name = "HITHIT!!!", CurrentValue = false, Callback = function(Value) end})

-- [[ ESP Tab ]]
local ESPTab = Window:CreateTab("👁️ ESP", 4483362458)
ESPTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(Value) end})

-- [[ LOCAL Tab ]]
local LocalTab = Window:CreateTab("💻 LOCAL", 4483362458)

LocalTab:CreateToggle({
   Name = "BANNED!!!!!!! (P Key)",
   CurrentValue = false,
   Callback = function(Value)
       if Value then
           Rayfield:Notify({Title = "BAN HAMMER", Content = "Press P to use BAN HAMMER effect!", Duration = 5})
       end
   end,
})

LocalTab:CreateToggle({
   Name = "c00lkid Skin",
   CurrentValue = false,
   Callback = function(Value)
   end,
})

Rayfield:Notify({Title = "XXS-DRAGON-HUB", Content = "Enjoy Scripting!", Duration = 5})
