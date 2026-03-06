-- ============================================
-- FROST HUB - Compact Trade Automation
-- Blue themed with loading screen
-- ============================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Frost Colors
local C = {
    bg = Color3.fromRGB(18, 18, 22),
    bgLight = Color3.fromRGB(25, 28, 35),
    frost = Color3.fromRGB(100, 180, 255),
    frostDark = Color3.fromRGB(60, 140, 220),
    text = Color3.fromRGB(255, 255, 255),
    textDim = Color3.fromRGB(160, 180, 200),
    toggleOff = Color3.fromRGB(45, 50, 60),
    toggleOn = Color3.fromRGB(100, 180, 255)
}

-- Settings
local Settings = {
    FreezeTradeEnabled = false,
    AutoAcceptEnabled = false,
    AutoTickValuablesEnabled = false
}

-- Helper Functions
local function playSound(id, vol, pitch)
    pcall(function()
        local s = Instance.new("Sound", workspace)
        s.SoundId = id
        s.Volume = vol or 0.5
        s.PlaybackSpeed = pitch or 1
        s:Play()
        game:GetService("Debris"):AddItem(s, 2)
    end)
end

-- Create ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "FrostHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = Player.PlayerGui

-- ============================================
-- LOADING SCREEN (Compact)
-- ============================================
local loadingFrame = Instance.new("Frame", sg)
loadingFrame.Size = UDim2.new(0, 220, 0, 140)
loadingFrame.Position = UDim2.new(0.5, -110, 0.5, -70)
loadingFrame.BackgroundColor3 = C.bg
loadingFrame.BorderSizePixel = 0
loadingFrame.ZIndex = 100
Instance.new("UICorner", loadingFrame).CornerRadius = UDim.new(0, 12)

local loadStroke = Instance.new("UIStroke", loadingFrame)
loadStroke.Color = C.frost
loadStroke.Thickness = 1.5
loadStroke.Transparency = 0

-- Loading gradient animation
local loadGrad = Instance.new("UIGradient", loadStroke)
loadGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.frostDark),
    ColorSequenceKeypoint.new(0.5, C.frost),
    ColorSequenceKeypoint.new(1, C.frostDark)
})

task.spawn(function()
    while loadingFrame.Parent do
        for i = 0, 360, 3 do
            if not loadingFrame.Parent then break end
            loadGrad.Rotation = i
            task.wait(0.02)
        end
    end
end)

-- Loading icon
local loadIcon = Instance.new("TextLabel", loadingFrame)
loadIcon.Size = UDim2.new(0, 50, 0, 50)
loadIcon.Position = UDim2.new(0.5, -25, 0, 15)
loadIcon.BackgroundTransparency = 1
loadIcon.Text = "❄️"
loadIcon.TextScaled = true
loadIcon.ZIndex = 101

-- Spin animation
task.spawn(function()
    while loadIcon.Parent do
        for i = 0, 360, 4 do
            if not loadIcon.Parent then break end
            loadIcon.Rotation = i
            task.wait(0.02)
        end
    end
end)

-- Loading title
local loadTitle = Instance.new("TextLabel", loadingFrame)
loadTitle.Size = UDim2.new(1, -20, 0, 22)
loadTitle.Position = UDim2.new(0, 10, 0, 68)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "FROST HUB"
loadTitle.TextColor3 = C.text
loadTitle.Font = Enum.Font.GothamBlack
loadTitle.TextSize = 16
loadTitle.ZIndex = 101

-- Loading subtitle
local loadSub = Instance.new("TextLabel", loadingFrame)
loadSub.Size = UDim2.new(1, -20, 0, 16)
loadSub.Position = UDim2.new(0, 10, 0, 90)
loadSub.BackgroundTransparency = 1
loadSub.Text = "Trade Auto Accept"
loadSub.TextColor3 = C.textDim
loadSub.Font = Enum.Font.Gotham
loadSub.TextSize = 11
loadSub.ZIndex = 101

-- Progress bar
local progressBg = Instance.new("Frame", loadingFrame)
progressBg.Size = UDim2.new(0, 180, 0, 5)
progressBg.Position = UDim2.new(0.5, -90, 1, -15)
progressBg.BackgroundColor3 = C.toggleOff
progressBg.BorderSizePixel = 0
progressBg.ZIndex = 101
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1, 0)

local progressFill = Instance.new("Frame", progressBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.frost
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 102
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

-- Animate progress
task.spawn(function()
    for i = 1, 100 do
        TweenService:Create(progressFill, TweenInfo.new(0.02), {Size = UDim2.new(i / 100, 0, 1, 0)}):Play()
        if i % 25 == 0 then
            playSound("rbxassetid://6895079813", 0.15, 0.8 + (i / 100))
        end
        task.wait(0.02)
    end
    
    task.wait(0.3)
    
    -- Fade out loading screen
    TweenService:Create(loadingFrame, TweenInfo.new(0.4), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, -110, 0.5, -100)
    }):Play()
    TweenService:Create(loadStroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    TweenService:Create(loadIcon, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(loadTitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(loadSub, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(progressBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(progressFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.4)
    loadingFrame:Destroy()
    
    -- Show main GUI
    playSound("rbxassetid://6026984887", 0.4, 1.2)
end)

-- ============================================
-- MAIN GUI
-- ============================================
local main = Instance.new("Frame", sg)
main.Name = "Main"
main.Size = UDim2.new(0, 220, 0, 180)
main.Position = UDim2.new(0, 20, 0.5, -90)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.BackgroundTransparency = 1
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- Wait for loading to finish
task.delay(2.5, function()
    main.BackgroundTransparency = 0
    main.Visible = true
    TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Position = UDim2.new(0, 20, 0.5, -90)
    }):Play()
end)

-- Border
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = C.frost
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

-- Frost particles
for i = 1, 20 do
    local particle = Instance.new("Frame", main)
    particle.Size = UDim2.new(0, 3, 0, 3)
    particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
    particle.BackgroundColor3 = C.frost
    particle.BackgroundTransparency = 0.6
    particle.BorderSizePixel = 0
    particle.ZIndex = 1
    Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        while particle.Parent do
            local newPos = UDim2.new(
                math.random(0, 100) / 100, 0,
                math.random(0, 100) / 100, 0
            )
            TweenService:Create(particle, TweenInfo.new(3), {Position = newPos}):Play()
            task.wait(3)
        end
    end)
end

-- Header
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = C.bgLight
header.BorderSizePixel = 0
header.ZIndex = 2
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -15, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Frost Hub"
title.TextColor3 = C.text
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

-- Close button (small X)
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -32, 0.5, -12.5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = C.textDim
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.ZIndex = 3

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.3)
    sg:Destroy()
end)

closeBtn.MouseEnter:Connect(function()
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

closeBtn.MouseLeave:Connect(function()
    closeBtn.TextColor3 = C.textDim
end)

-- Toggle buttons container
local buttonsContainer = Instance.new("Frame", main)
buttonsContainer.Size = UDim2.new(1, -12, 1, -51)
buttonsContainer.Position = UDim2.new(0, 6, 0, 48)
buttonsContainer.BackgroundTransparency = 1
buttonsContainer.ZIndex = 2

local buttonsLayout = Instance.new("UIListLayout", buttonsContainer)
buttonsLayout.Padding = UDim.new(0, 3)
buttonsLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Create toggle button function
local function createToggle(order, labelText, settingKey)
    local btn = Instance.new("Frame", buttonsContainer)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = C.bgLight
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = C.frost
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.9
    
    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = C.text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 3
    
    -- Toggle circle
    local toggleBg = Instance.new("Frame", btn)
    toggleBg.Size = UDim2.new(0, 36, 0, 20)
    toggleBg.Position = UDim2.new(1, -44, 0.5, -10)
    toggleBg.BackgroundColor3 = C.toggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 3
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
    
    local toggleCircle = Instance.new("Frame", toggleBg)
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.ZIndex = 4
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)
    
    -- Click handler
    local clickBtn = Instance.new("TextButton", btn)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 5
    
    clickBtn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        local isOn = Settings[settingKey]
        
        -- Animate toggle
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {
            BackgroundColor3 = isOn and C.toggleOn or C.toggleOff
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
            Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
            BackgroundColor3 = isOn and Color3.new(1, 1, 1) or Color3.fromRGB(60, 60, 70)
        }):Play()
        
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Transparency = isOn and 0.3 or 0.9
        }):Play()
        
        playSound("rbxassetid://6895079813", 0.3, isOn and 1.3 or 0.9)
        
        -- Feature-specific actions
        if settingKey == "FreezeTradeEnabled" then
            if isOn then
                print("Trade Freeze: ON")
            else
                print("Trade Freeze: OFF")
            end
        elseif settingKey == "AutoAcceptEnabled" then
            if isOn then
                print("Auto Accept: ON")
            else
                print("Auto Accept: OFF")
            end
        elseif settingKey == "AutoTickValuablesEnabled" then
            if isOn then
                print("Auto Tick Valuables: ON")
            else
                print("Auto Tick Valuables: OFF")
            end
        end
    end)
    
    clickBtn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 35, 42)}):Play()
    end)
    
    clickBtn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = C.bgLight}):Play()
    end)
end

-- Create toggles
createToggle(1, "Freeze Trade", "FreezeTradeEnabled")
createToggle(2, "Auto Accept", "AutoAcceptEnabled")
createToggle(3, "Auto Tick Valuables", "AutoTickValuablesEnabled")

print("Frost Hub Loaded!")