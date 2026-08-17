--[[
    SCRIPT: ANIMAL HOSPITAL HACK - ULTIMATE SHOP EDITION
    Tác giả: mi va linh cu to
    Phiên bản: 5.0.0
    Mô tả: Hack đa chức năng cho Animal Hospital (Roblox)
    Menu phong cách Redz Hub
    Đầy đủ: ESP, Auto Collect, Anti Ban, Shop ESP, Auto Buy, Fly, Speed, v.v.
--]]

-- Dịch vụ cần thiết
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Biến cấu hình
local Settings = {
    MenuVisible = true,
    KeyToggleMenu = Enum.KeyCode.RightShift,
    AutoCollectEnabled = false,
    InfiniteJumpEnabled = false,
    SuperSpeedEnabled = false,
    SpeedMultiplier = 2,
    NoClipEnabled = false,
    ESPPlayersEnabled = false,
    ESPEntitiesEnabled = false,
    ESPWalkerEnabled = false,
    ESPMimicEnabled = false,
    JumpscareWarningEnabled = true,
    AntiBanEnabled = false,
    ShopESPEnabled = false,
    AutoBuyEnabled = false,
    TeleportToPlayer = nil,
    FlyEnabled = false,
    FlySpeed = 50,
    ESPColor = Color3.fromRGB(255, 0, 0),
    WalkerESPColor = Color3.fromRGB(255, 165, 0),
    MimicESPColor = Color3.fromRGB(255, 0, 255),
    ShopESPColor = Color3.fromRGB(0, 255, 0),
    WarningDistance = 25,
    AutoBuyCooldown = 1,
    LastBuyTime = 0
}

-- Biến trạng thái
local currentCharacter = nil
local currentHumanoid = nil
local autoCollectConnection = nil
local infiniteJumpConnection = nil
local noclipConnection = nil
local espPlayersConnection = nil
local espEntitiesConnection = nil
local flyConnection = nil
local speedConnection = nil
local jumpscareWarningConnection = nil
local antiBanConnection = nil
local shopESPConnection = nil
local autoBuyConnection = nil
local espObjects = {}
local entityESPObjects = {}
local shopESPObjects = {}
local warningGUI = nil
local speedValueLabel = nil
local shopItemsList = {}
local shopGUI = nil
local allConnections = {}

-- Hàm quản lý kết nối
local function addConnection(conn)
    table.insert(allConnections, conn)
end

local function cleanupConnections()
    for _, conn in ipairs(allConnections) do
        if conn and conn.Connected then
            conn:Disconnect()
        end
    end
    allConnections = {}
end

-- Tạo GUI phong cách Redz Hub
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimalHospitalHack"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Màu chủ đạo
local AccentColor = Color3.fromRGB(255, 50, 50)
local BackgroundColor = Color3.fromRGB(20, 20, 20)
local SecondaryColor = Color3.fromRGB(35, 35, 35)
local ShopColor = Color3.fromRGB(0, 200, 0)

-- Khung chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 800)
MainFrame.Position = UDim2.new(0, 50, 0, 30)
MainFrame.BackgroundColor3 = BackgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Thanh tiêu đề
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = SecondaryColor
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "ANIMAL HOSPITAL HACK"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Nút đóng
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = AccentColor
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    Settings.MenuVisible = false
    MainFrame.Visible = false
end)

-- Hàm tạo nút toggle
local function CreateToggle(name, positionY, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 30)
    button.Position = UDim2.new(0, 15, 0, positionY)
    button.BackgroundColor3 = SecondaryColor
    button.BorderSizePixel = 0
    button.Text = name .. ": OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local enabled = false
    
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            button.BackgroundColor3 = AccentColor
            button.Text = name .. ": ON"
        else
            button.BackgroundColor3 = SecondaryColor
            button.Text = name .. ": OFF"
        end
        callback(enabled)
    end)
    
    return {
        Button = button,
        SetState = function(state)
            enabled = state
            if enabled then
                button.BackgroundColor3 = AccentColor
                button.Text = name .. ": ON"
            else
                button.BackgroundColor3 = SecondaryColor
                button.Text = name .. ": OFF"
            end
        end
    }
end

-- Hàm tạo nút hành động
local function CreateActionButton(name, positionY, callback, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 30)
    button.Position = UDim2.new(0, 15, 0, positionY)
    button.BackgroundColor3 = color or Color3.fromRGB(50, 100, 255)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Tạo scroll frame cho menu
local MenuScroll = Instance.new("ScrollingFrame")
MenuScroll.Size = UDim2.new(1, 0, 1, -40)
MenuScroll.Position = UDim2.new(0, 0, 0, 40)
MenuScroll.BackgroundTransparency = 1
MenuScroll.BorderSizePixel = 0
MenuScroll.ScrollBarThickness = 3
MenuScroll.CanvasSize = UDim2.new(0, 0, 0, 800)
MenuScroll.Parent = MainFrame

-- Di chuyển tất cả nút vào scroll frame
local function reparentToScroll(guiObject)
    guiObject.Parent = MenuScroll
end

-- Tạo các nút chức năng
local AutoCollectToggle = CreateToggle("AUTO COLLECT", 10, function(enabled)
    Settings.AutoCollectEnabled = enabled
    if enabled then StartAutoCollect() else StopAutoCollect() end
end)
reparentToScroll(AutoCollectToggle.Button)

local InfiniteJumpToggle = CreateToggle("INFINITE JUMP", 50, function(enabled)
    Settings.InfiniteJumpEnabled = enabled
    if enabled then EnableInfiniteJump() else DisableInfiniteJump() end
end)
reparentToScroll(InfiniteJumpToggle.Button)

local SuperSpeedToggle = CreateToggle("SUPER SPEED", 90, function(enabled)
    Settings.SuperSpeedEnabled = enabled
    if enabled then EnableSuperSpeed() else DisableSuperSpeed() end
end)
reparentToScroll(SuperSpeedToggle.Button)

-- Tùy chỉnh tốc độ
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -30, 0, 20)
SpeedLabel.Position = UDim2.new(0, 15, 0, 130)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "TỐC ĐỘ: " .. Settings.SpeedMultiplier .. "x"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 12
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MenuScroll

speedValueLabel = SpeedLabel

-- Nút giảm tốc độ
local DecreaseSpeedButton = Instance.new("TextButton")
DecreaseSpeedButton.Size = UDim2.new(0, 40, 0, 30)
DecreaseSpeedButton.Position = UDim2.new(0, 15, 0, 150)
DecreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
DecreaseSpeedButton.BorderSizePixel = 0
DecreaseSpeedButton.Text = "-"
DecreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseSpeedButton.Font = Enum.Font.GothamBold
DecreaseSpeedButton.TextSize = 20
DecreaseSpeedButton.Parent = MenuScroll

local DecreaseCorner = Instance.new("UICorner")
DecreaseCorner.CornerRadius = UDim.new(0, 6)
DecreaseCorner.Parent = DecreaseSpeedButton

-- Nút tăng tốc độ
local IncreaseSpeedButton = Instance.new("TextButton")
IncreaseSpeedButton.Size = UDim2.new(0, 40, 0, 30)
IncreaseSpeedButton.Position = UDim2.new(1, -55, 0, 150)
IncreaseSpeedButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
IncreaseSpeedButton.BorderSizePixel = 0
IncreaseSpeedButton.Text = "+"
IncreaseSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IncreaseSpeedButton.Font = Enum.Font.GothamBold
IncreaseSpeedButton.TextSize = 20
IncreaseSpeedButton.Parent = MenuScroll

local IncreaseCorner = Instance.new("UICorner")
IncreaseCorner.CornerRadius = UDim.new(0, 6)
IncreaseCorner.Parent = IncreaseSpeedButton

-- Thanh hiển thị tốc độ
local SpeedBar = Instance.new("Frame")
SpeedBar.Size = UDim2.new(1, -110, 0, 10)
SpeedBar.Position = UDim2.new(0, 65, 0, 160)
SpeedBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedBar.BorderSizePixel = 0
SpeedBar.Parent = MenuScroll

local SpeedBarCorner = Instance.new("UICorner")
SpeedBarCorner.CornerRadius = UDim.new(0, 5)
SpeedBarCorner.Parent = SpeedBar

local SpeedBarFill = Instance.new("Frame")
SpeedBarFill.Size = UDim2.new(Settings.SpeedMultiplier / 10, 0, 1, 0)
SpeedBarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
SpeedBarFill.BorderSizePixel = 0
SpeedBarFill.Parent = SpeedBar

local SpeedBarFillCorner = Instance.new("UICorner")
SpeedBarFillCorner.CornerRadius = UDim.new(0, 5)
SpeedBarFillCorner.Parent = SpeedBarFill

-- Hàm cập nhật tốc độ
local function UpdateSpeedDisplay()
    SpeedLabel.Text = "TỐC ĐỘ: " .. Settings.SpeedMultiplier .. "x"
    SpeedBarFill.Size = UDim2.new(Settings.SpeedMultiplier / 10, 0, 1, 0)
    
    if currentHumanoid then
        currentHumanoid.WalkSpeed = 16 * Settings.SpeedMultiplier
    end
end

DecreaseSpeedButton.MouseButton1Click:Connect(function()
    Settings.SpeedMultiplier = math.max(0.5, Settings.SpeedMultiplier - 0.5)
    UpdateSpeedDisplay()
end)

IncreaseSpeedButton.MouseButton1Click:Connect(function()
    Settings.SpeedMultiplier = math.min(10, Settings.SpeedMultiplier + 0.5)
    UpdateSpeedDisplay()
end)

local NoClipToggle = CreateToggle("NO CLIP", 190, function(enabled)
    Settings.NoClipEnabled = enabled
    if enabled then EnableNoClip() else DisableNoClip() end
end)
reparentToScroll(NoClipToggle.Button)

local AntiBanToggle = CreateToggle("ANTI BAN", 230, function(enabled)
    Settings.AntiBanEnabled = enabled
    if enabled then StartAntiBan() else StopAntiBan() end
end)
reparentToScroll(AntiBanToggle.Button)

local ESPPlayersToggle = CreateToggle("ESP PLAYERS", 270, function(enabled)
    Settings.ESPPlayersEnabled = enabled
    if enabled then StartESPPlayers() else StopESPPlayers() end
end)
reparentToScroll(ESPPlayersToggle.Button)

local ESPEntitiesToggle = CreateToggle("ESP PATIENTS (CHÁY)", 310, function(enabled)
    Settings.ESPEntitiesEnabled = enabled
    if enabled then StartESPEntities() else StopESPEntities() end
end)
reparentToScroll(ESPEntitiesToggle.Button)

local ESPWalkerToggle = CreateToggle("ESP WALKER", 350, function(enabled)
    Settings.ESPWalkerEnabled = enabled
    if enabled then StartESPWalker() else StopESPWalker() end
end)
reparentToScroll(ESPWalkerToggle.Button)

local ESPMimicToggle = CreateToggle("ESP MIMIC", 390, function(enabled)
    Settings.ESPMimicEnabled = enabled
    if enabled then StartESPMimic() else StopESPMimic() end
end)
reparentToScroll(ESPMimicToggle.Button)

local JumpscareWarningToggle = CreateToggle("CẢNH BÁO JUMPSCARE", 430, function(enabled)
    Settings.JumpscareWarningEnabled = enabled
    if enabled then StartJumpscareWarning() else StopJumpscareWarning() end
end)
reparentToScroll(JumpscareWarningToggle.Button)

local FlyToggle = CreateToggle("FLY", 470, function(enabled)
    Settings.FlyEnabled = enabled
    if enabled then EnableFly() else DisableFly() end
end)
reparentToScroll(FlyToggle.Button)

-- Nút lấy kìm chích điện
local TaserButton = CreateActionButton("LẤY KÌM CHÍCH ĐIỆN", 510, function()
    GiveTaser()
end)
reparentToScroll(TaserButton)

-- Nút lấy cà phê
local CoffeeButton = CreateActionButton("LẤY CÀ PHÊ", 550, function()
    GiveCoffee()
end)
reparentToScroll(CoffeeButton)

-- Shop ESP Toggle
local ShopESPToggle = CreateToggle("HIỆN VẬT PHẨM SHOP", 590, function(enabled)
    Settings.ShopESPEnabled = enabled
    if enabled then StartShopESP() else StopShopESP() end
end)
reparentToScroll(ShopESPToggle.Button)

-- Auto Buy Toggle
local AutoBuyToggle = CreateToggle("TỰ ĐỘNG MUA ĐỒ", 630, function(enabled)
    Settings.AutoBuyEnabled = enabled
    if enabled then StartAutoBuy() else StopAutoBuy() end
end)
reparentToScroll(AutoBuyToggle.Button)

-- Nút mở shop GUI
local ShopButton = CreateActionButton("MỞ SHOP VẬT PHẨM", 670, function()
    ShowShopGUI()
end, ShopColor)
reparentToScroll(ShopButton)

-- Nút teleport đến player
local TeleportLabel = Instance.new("TextLabel")
TeleportLabel.Size = UDim2.new(1, -30, 0, 20)
TeleportLabel.Position = UDim2.new(0, 15, 0, 710)
TeleportLabel.BackgroundTransparency = 1
TeleportLabel.Text = "TELEPORT TO PLAYER:"
TeleportLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
TeleportLabel.Font = Enum.Font.Gotham
TeleportLabel.TextSize = 11
TeleportLabel.TextXAlignment = Enum.TextXAlignment.Left
TeleportLabel.Parent = MenuScroll

local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Size = UDim2.new(1, -30, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 15, 0, 730)
PlayerDropdown.BackgroundColor3 = SecondaryColor
PlayerDropdown.BorderSizePixel = 0
PlayerDropdown.Text = "Chọn Player..."
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.Font = Enum.Font.Gotham
PlayerDropdown.TextSize = 12
PlayerDropdown.Parent = MenuScroll

local DropdownCorner = Instance.new("UICorner")
DropdownCorner.CornerRadius = UDim.new(0, 6)
DropdownCorner.Parent = PlayerDropdown

-- Danh sách player dropdown
local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Size = UDim2.new(1, -30, 0, 60)
DropdownList.Position = UDim2.new(0, 15, 0, 760)
DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownList.BorderSizePixel = 0
DropdownList.Visible = false
DropdownList.ScrollBarThickness = 5
DropdownList.Parent = MenuScroll

local DropdownCorner2 = Instance.new("UICorner")
DropdownCorner2.CornerRadius = UDim.new(0, 6)
DropdownCorner2.Parent = DropdownList

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
DropdownLayout.Padding = UDim.new(0, 5)
DropdownLayout.Parent = DropdownList

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        for _, child in ipairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local playerButton = Instance.new("TextButton")
                playerButton.Size = UDim2.new(1, -10, 0, 25)
                playerButton.Position = UDim2.new(0, 5, 0, 0)
                playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                playerButton.BorderSizePixel = 0
                playerButton.Text = player.Name
                playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerButton.Font = Enum.Font.Gotham
                playerButton.TextSize = 11
                playerButton.Parent = DropdownList
                
                playerButton.MouseButton1Click:Connect(function()
                    Settings.TeleportToPlayer = player
                    PlayerDropdown.Text = player.Name
                    DropdownList.Visible = false
                    
                    if LocalPlayer.Character and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = 
                            player.Character:FindFirstChild("HumanoidRootPart").CFrame + Vector3.new(0, 3, 0)
                    end
                end)
            end
        end
    end
end)

-- CHỨC NĂNG: SHOP ESP
function FindShopItems()
    local items = {}
    local seenNames = {}
    
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") or object:IsA("BasePart") or object:IsA("Tool") then
            local name = object.Name:lower()
            local parentName = object.Parent and object.Parent.Name:lower() or ""
            
            if name:find("shop") or name:find("store") or name:find("buy") or name:find("purchase") or
               parentName:find("shop") or parentName:find("store") or parentName:find("buy") then
                
                if not seenNames[name] then
                    seenNames[name] = true
                    table.insert(items, {
                        Object = object,
                        Name = object.Name,
                        Type = "SHOP",
                        Color = Settings.ShopESPColor
                    })
                end
            end
            
            if name:find("price") or name:find("cost") or name:find("money") or name:find("cash") or
               parentName:find("price") or parentName:find("cost") then
                
                if not seenNames[name] then
                    seenNames[name] = true
                    table.insert(items, {
                        Object = object,
                        Name = object.Name,
                        Type = "ITEM",
                        Color = Color3.fromRGB(255, 255, 0)
                    })
                end
            end
            
            if name:find("purchase") or name:find("buybutton") or name:find("buy_button") or
               name:find("confirm") or parentName:find("purchase") then
                
                if not seenNames[name] then
                    seenNames[name] = true
                    table.insert(items, {
                        Object = object,
                        Name = object.Name,
                        Type = "BUY_BUTTON",
                        Color = Color3.fromRGB(0, 100, 255)
                    })
                end
            end
        end
    end
    
    return items
end

function StartShopESP()
    StopShopESP()
    
    shopESPConnection = RunService.RenderStepped:Connect(function()
        for _, esp in ipairs(shopESPObjects) do
            if esp and esp.Parent then esp:Destroy() end
        end
        shopESPObjects = {}
        
        shopItemsList = FindShopItems()
        
        for _, item in ipairs(shopItemsList) do
            local object = item.Object
            if object and object.Parent then
                local highlight = Instance.new("Highlight")
                highlight.Parent = object
                highlight.Adornee = object
                highlight.FillColor = item.Color
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                table.insert(shopESPObjects, highlight)
                
                if object:IsA("BasePart") or object:IsA("Model") then
                    local position = object.Position or (object:IsA("Model") and object:GetPivot().Position)
                    if position then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Parent = object
                        billboard.Adornee = object:IsA("BasePart") and object or object:FindFirstChildOfClass("BasePart")
                        billboard.Size = UDim2.new(0, 150, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = item.Name .. " [" .. item.Type .. "]"
                        label.TextColor3 = item.Color
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 12
                        label.TextScaled = true
                        label.Parent = billboard
                        
                        table.insert(shopESPObjects, billboard)
                    end
                end
            end
        end
    end)
    addConnection(shopESPConnection)
end

function StopShopESP()
    if shopESPConnection then
        shopESPConnection:Disconnect()
        shopESPConnection = nil
    end
    for _, esp in ipairs(shopESPObjects) do
        if esp and esp.Parent then esp:Destroy() end
    end
    shopESPObjects = {}
end

-- CHỨC NĂNG: AUTO BUY
function TryBuyItem(item)
    local object = item.Object
    if not object or not object.Parent then return false end
    
    if object:IsA("ClickDetector") then
        fireclickdetector(object)
        return true
    end
    
    if object:IsA("Model") then
        for _, child in ipairs(object:GetDescendants()) do
            if child:IsA("ClickDetector") then
                fireclickdetector(child)
                return true
            end
            if child:IsA("ProximityPrompt") then
                fireproximityprompt(child)
                return true
            end
        end
    end
    
    if object:IsA("ProximityPrompt") then
        fireproximityprompt(object)
        return true
    end
    
    if object:IsA("BasePart") then
        local parent = object.Parent
        if parent then
            for _, child in ipairs(parent:GetDescendants()) do
                if child:IsA("ClickDetector") then
                    fireclickdetector(child)
                    return true
                end
                if child:IsA("ProximityPrompt") then
                    fireproximityprompt(child)
                    return true
                end
            end
        end
    end
    
    return false
end

function StartAutoBuy()
    StopAutoBuy()
    
    autoBuyConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AutoBuyEnabled then return end
        
        local currentTime = tick()
        if currentTime - Settings.LastBuyTime < Settings.AutoBuyCooldown then
            return
        end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        if #shopItemsList == 0 then
            shopItemsList = FindShopItems()
        end
        
        for _, item in ipairs(shopItemsList) do
            if item.Type == "BUY_BUTTON" or item.Type == "ITEM" then
                local object = item.Object
                if object and object.Parent then
                    local position = object.Position or (object:IsA("Model") and object:GetPivot().Position)
                    if position then
                        local distance = (position - rootPart.Position).Magnitude
                        if distance < 30 then
                            if TryBuyItem(item) then
                                Settings.LastBuyTime = currentTime
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
    addConnection(autoBuyConnection)
end

function StopAutoBuy()
    if autoBuyConnection then
        autoBuyConnection:Disconnect()
        autoBuyConnection = nil
    end
end

-- CHỨC NĂNG: HIỂN THỊ SHOP GUI
function ShowShopGUI()
    if shopGUI then
        shopGUI.Enabled = not shopGUI.Enabled
        return
    end
    
    shopGUI = Instance.new("ScreenGui")
    shopGUI.Name = "ShopItemsGUI"
    shopGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    shopGUI.ResetOnSpawn = false
    shopGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local shopFrame = Instance.new("Frame")
    shopFrame.Name = "ShopFrame"
    shopFrame.Size = UDim2.new(0, 300, 0, 400)
    shopFrame.Position = UDim2.new(0.7, 0, 0.2, 0)
    shopFrame.BackgroundColor3 = BackgroundColor
    shopFrame.BorderSizePixel = 0
    shopFrame.Active = true
    shopFrame.Draggable = true
    shopFrame.Parent = shopGUI
    
    local shopCorner = Instance.new("UICorner")
    shopCorner.CornerRadius = UDim.new(0, 8)
    shopCorner.Parent = shopFrame
    
    local shopTitleBar = Instance.new("Frame")
    shopTitleBar.Size = UDim2.new(1, 0, 0, 40)
    shopTitleBar.BackgroundColor3 = ShopColor
    shopTitleBar.BorderSizePixel = 0
    shopTitleBar.Parent = shopFrame
    
    local shopTitleCorner = Instance.new("UICorner")
    shopTitleCorner.CornerRadius = UDim.new(0, 8)
    shopTitleCorner.Parent = shopTitleBar
    
    local shopTitle = Instance.new("TextLabel")
    shopTitle.Size = UDim2.new(1, -50, 1, 0)
    shopTitle.Position = UDim2.new(0, 15, 0, 0)
    shopTitle.BackgroundTransparency = 1
    shopTitle.Text = "SHOP VẬT PHẨM"
    shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    shopTitle.Font = Enum.Font.GothamBold
    shopTitle.TextSize = 16
    shopTitle.TextXAlignment = Enum.TextXAlignment.Left
    shopTitle.Parent = shopTitleBar
    
    local shopCloseButton = Instance.new("TextButton")
    shopCloseButton.Size = UDim2.new(0, 30, 0, 30)
    shopCloseButton.Position = UDim2.new(1, -35, 0, 5)
    shopCloseButton.BackgroundColor3 = AccentColor
    shopCloseButton.BorderSizePixel = 0
    shopCloseButton.Text = "×"
    shopCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shopCloseButton.Font = Enum.Font.GothamBold
    shopCloseButton.TextSize = 20
    shopCloseButton.Parent = shopTitleBar
    
    local shopCloseCorner = Instance.new("UICorner")
    shopCloseCorner.CornerRadius = UDim.new(0, 6)
    shopCloseCorner.Parent = shopCloseButton
    
    shopCloseButton.MouseButton1Click:Connect(function()
        shopGUI.Enabled = false
    end)
    
    local shopScroll = Instance.new("ScrollingFrame")
    shopScroll.Size = UDim2.new(1, -20, 1, -60)
    shopScroll.Position = UDim2.new(0, 10, 0, 50)
    shopScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    shopScroll.BorderSizePixel = 0
    shopScroll.ScrollBarThickness = 5
    shopScroll.Parent = shopFrame
    
    local shopScrollCorner = Instance.new("UICorner")
    shopScrollCorner.CornerRadius = UDim.new(0, 6)
    shopScrollCorner.Parent = shopScroll
    
    local shopLayout = Instance.new("UIListLayout")
    shopLayout.SortOrder = Enum.SortOrder.LayoutOrder
    shopLayout.Padding = UDim.new(0, 5)
    shopLayout.Parent = shopScroll
    
    local function UpdateShopList()
        for _, child in ipairs(shopScroll:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        local items = FindShopItems()
        
        if #items == 0 then
            local noItemsLabel = Instance.new("TextLabel")
            noItemsLabel.Size = UDim2.new(1, -10, 0, 50)
            noItemsLabel.Position = UDim2.new(0, 5, 0, 0)
            noItemsLabel.BackgroundTransparency = 1
            noItemsLabel.Text = "Không tìm thấy vật phẩm trong shop"
            noItemsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
            noItemsLabel.Font = Enum.Font.Gotham
            noItemsLabel.TextSize = 12
            noItemsLabel.Parent = shopScroll
            return
        end
        
        for i, item in ipairs(items) do
            local itemFrame = Instance.new("Frame")
            itemFrame.Size = UDim2.new(1, -10, 0, 60)
            itemFrame.Position = UDim2.new(0, 5, 0, 0)
            itemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemFrame.BorderSizePixel = 0
            itemFrame.Parent = shopScroll
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 6)
            itemCorner.Parent = itemFrame
            
            local itemName = Instance.new("TextLabel")
            itemName.Size = UDim2.new(1, -10, 0, 25)
            itemName.Position = UDim2.new(0, 5, 0, 5)
            itemName.BackgroundTransparency = 1
            itemName.Text = item.Name .. " [" .. item.Type .. "]"
            itemName.TextColor3 = item.Color
            itemName.Font = Enum.Font.GothamBold
            itemName.TextSize = 11
            itemName.TextXAlignment = Enum.TextXAlignment.Left
            itemName.Parent = itemFrame
            
            local buyButton = Instance.new("TextButton")
            buyButton.Size = UDim2.new(1, -10, 0, 25)
            buyButton.Position = UDim2.new(0, 5, 0, 32)
            buyButton.BackgroundColor3 = ShopColor
            buyButton.BorderSizePixel = 0
            buyButton.Text = "MUA"
            buyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            buyButton.Font = Enum.Font.GothamBold
            buyButton.TextSize = 11
            buyButton.Parent = itemFrame
            
            local buyCorner = Instance.new("UICorner")
            buyCorner.CornerRadius = UDim.new(0, 4)
            buyCorner.Parent = buyButton
            
            buyButton.MouseButton1Click:Connect(function()
                TryBuyItem(item)
                buyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                wait(0.3)
                buyButton.BackgroundColor3 = ShopColor
            end)
        end
    end
    
    local refreshButton = Instance.new("TextButton")
    refreshButton.Size = UDim2.new(0, 80, 0, 30)
    refreshButton.Position = UDim2.new(1, -90, 0, 5)
    refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "LÀM MỚI"
    refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.TextSize = 10
    refreshButton.Parent = shopTitleBar
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 4)
    refreshCorner.Parent = refreshButton
    
    refreshButton.MouseButton1Click:Connect(function()
        UpdateShopList()
    end)
    
    UpdateShopList()
end

-- CHỨC NĂNG: ANTI BAN
function StartAntiBan()
    StopAntiBan()
    
    antiBanConnection = RunService.Heartbeat:Connect(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            
            if method == "Kick" then
                return nil
            end
            
            if method == "Ban" then
                return nil
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
    addConnection(antiBanConnection)
end

function StopAntiBan()
    if antiBanConnection then
        antiBanConnection:Disconnect()
        antiBanConnection = nil
    end
end

-- CHỨC NĂNG: LẤY KÌM CHÍCH ĐIỆN
function GiveTaser()
    local character = LocalPlayer.Character
    if not character then return end
    
    local taserFound = false
    
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Tool") and (object.Name:lower():find("taser") or 
                                   object.Name:lower():find("kim") or 
                                   object.Name:lower():find("dien") or
                                   object.Name:lower():find("stun") or
                                   object.Name:lower():find("shock")) then
            
            local clonedTaser = object:Clone()
            clonedTaser.Parent = LocalPlayer.Backpack
            taserFound = true
            break
        end
    end
    
    if not taserFound then
        local taser = Instance.new("Tool")
        taser.Name = "Taser"
        taser.RequiresHandle = true
        taser.CanBeDropped = true
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.5, 2, 0.5)
        handle.BrickColor = BrickColor.new("Black")
        handle.Material = Enum.Material.Metal
        handle.Parent = taser
        
        taser.Parent = LocalPlayer.Backpack
    end
end

-- CHỨC NĂNG: LẤY CÀ PHÊ
function GiveCoffee()
    local character = LocalPlayer.Character
    if not character then return end
    
    local coffeeFound = false
    
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Tool") and (object.Name:lower():find("coffee") or 
                                   object.Name:lower():find("cafe") or 
                                   object.Name:lower():find("ca phe") or
                                   object.Name:lower():find("drink")) then
            
            local clonedCoffee = object:Clone()
            clonedCoffee.Parent = LocalPlayer.Backpack
            coffeeFound = true
            break
        end
    end
    
    if not coffeeFound then
        local coffee = Instance.new("Tool")
        coffee.Name = "Coffee"
        coffee.RequiresHandle = true
        coffee.CanBeDropped = true
        
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.8, 1.5, 0.8)
        handle.BrickColor = BrickColor.new("Brown")
        handle.Material = Enum.Material.Plastic
        handle.Parent = coffee
        
        coffee.Activated:Connect(function()
            local player = game.Players.LocalPlayer
            local char = player.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 25
                    wait(5)
                    humanoid.WalkSpeed = 16 * Settings.SpeedMultiplier
                end
            end
        end)
        
        coffee.Parent = LocalPlayer.Backpack
    end
end

-- CHỨC NĂNG: AUTO COLLECT
function StartAutoCollect()
    StopAutoCollect()
    autoCollectConnection = RunService.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") and object.Parent and 
               (object.Parent.Name:lower():find("coin") or 
                object.Parent.Name:lower():find("money") or
                object.Parent.Name:lower():find("collect") or
                object.Parent.Name:lower():find("item") or
                object.Parent.Name:lower():find("gem") or
                object.Parent.Name:lower():find("diamond")) then
                
                local distance = (object.Position - rootPart.Position).Magnitude
                if distance < 20 then
                    object.CFrame = rootPart.CFrame
                end
            end
        end
    end)
    addConnection(autoCollectConnection)
end

function StopAutoCollect()
    if autoCollectConnection then
        autoCollectConnection:Disconnect()
        autoCollectConnection = nil
    end
end

-- CHỨC NĂNG: INFINITE JUMP
function EnableInfiniteJump()
    DisableInfiniteJump()
    if currentHumanoid then
        infiniteJumpConnection = currentHumanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Landed then
                currentHumanoid.Jump = true
            end
        end)
        addConnection(infiniteJumpConnection)
    end
end

function DisableInfiniteJump()
    if infiniteJumpConnection then
        infiniteJumpConnection:Disconnect()
        infiniteJumpConnection = nil
    end
end

-- CHỨC NĂNG: SUPER SPEED
function EnableSuperSpeed()
    DisableSuperSpeed()
    if currentHumanoid then
        currentHumanoid.WalkSpeed = 16 * Settings.SpeedMultiplier
    end
    speedConnection = RunService.RenderStepped:Connect(function()
        if currentHumanoid and Settings.SuperSpeedEnabled then
            currentHumanoid.WalkSpeed = 16 * Settings.SpeedMultiplier
        end
    end)
    addConnection(speedConnection)
end

function DisableSuperSpeed()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    if currentHumanoid then
        currentHumanoid.WalkSpeed = 16
    end
end

-- CHỨC NĂNG: NO CLIP
function EnableNoClip()
    DisableNoClip()
    noclipConnection = RunService.Stepped:Connect(function()
        if currentCharacter and Settings.NoClipEnabled then
            for _, part in ipairs(currentCharacter:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    addConnection(noclipConnection)
end

function DisableNoClip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    if currentCharacter then
        for _, part in ipairs(currentCharacter:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- CHỨC NĂNG: ESP PLAYERS
function StartESPPlayers()
    StopESPPlayers()
    espPlayersConnection = RunService.RenderStepped:Connect(function()
        for _, esp in ipairs(espObjects) do
            if esp and esp.Parent then esp:Destroy() end
        end
        espObjects = {}
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlight.FillColor = Settings.ESPColor
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.7
                highlight.OutlineTransparency = 0
                table.insert(espObjects, highlight)
            end
        end
    end)
    addConnection(espPlayersConnection)
end

function StopESPPlayers()
    if espPlayersConnection then
        espPlayersConnection:Disconnect()
        espPlayersConnection = nil
    end
    for _, esp in ipairs(espObjects) do
        if esp and esp.Parent then esp:Destroy() end
    end
    espObjects = {}
end

-- CHỨC NĂNG: ESP ENTITIES
function FindEntities()
    local entities = {}
    
    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") or object:IsA("BasePart") then
            local name = object.Name:lower()
            local parentName = object.Parent and object.Parent.Name:lower() or ""
            
            if name:find("burn") or name:find("chay") or name:find("fire") or name:find("flame") or
               parentName:find("burn") or parentName:find("chay") or parentName:find("fire") then
                table.insert(entities, {Object = object, Type = "BURNED", Color = Color3.fromRGB(255, 100, 0)})
            end
            
            if name:find("walker") or parentName:find("walker") or
               name:find("zombie") or parentName:find("zombie") then
                table.insert(entities, {Object = object, Type = "WALKER", Color = Settings.WalkerESPColor})
            end
            
            if name:find("mimic") or parentName:find("mimic") or
               name:find("fake") or parentName:find("fake") or
               name:find("doppelganger") or parentName:find("doppelganger") then
                table.insert(entities, {Object = object, Type = "MIMIC", Color = Settings.MimicESPColor})
            end
        end
    end
    
    return entities
end

function StartESPEntities()
    StopESPEntities()
    espEntitiesConnection = RunService.RenderStepped:Connect(function()
        for _, esp in ipairs(entityESPObjects) do
            if esp and esp.Parent then esp:Destroy() end
        end
        entityESPObjects = {}
        
        local entities = FindEntities()
        for _, entity in ipairs(entities) do
            local object = entity.Object
            if object and object.Parent then
                local highlight = Instance.new("Highlight")
                highlight.Parent = object
                highlight.Adornee = object
                highlight.FillColor = entity.Color
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                table.insert(entityESPObjects, highlight)
            end
        end
    end)
    addConnection(espEntitiesConnection)
end

function StopESPEntities()
    if espEntitiesConnection then
        espEntitiesConnection:Disconnect()
        espEntitiesConnection = nil
    end
    for _, esp in ipairs(entityESPObjects) do
        if esp and esp.Parent then esp:Destroy() end
    end
    entityESPObjects = {}
end

function StartESPWalker()
    if not Settings.ESPEntitiesEnabled then
        StartESPEntities()
    end
    Settings.ESPWalkerEnabled = true
end

function StopESPWalker()
    Settings.ESPWalkerEnabled = false
    if not Settings.ESPEntitiesEnabled and not Settings.ESPMimicEnabled then
        StopESPEntities()
    end
end

function StartESPMimic()
    if not Settings.ESPEntitiesEnabled then
        StartESPEntities()
    end
    Settings.ESPMimicEnabled = true
end

function StopESPMimic()
    Settings.ESPMimicEnabled = false
    if not Settings.ESPEntitiesEnabled and not Settings.ESPWalkerEnabled then
        StopESPEntities()
    end
end

-- CHỨC NĂNG: CẢNH BÁO JUMPSCARE
function CreateWarningGUI()
    if warningGUI then
        warningGUI:Destroy()
    end
    
    warningGUI = Instance.new("ScreenGui")
    warningGUI.Name = "JumpscareWarning"
    warningGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
    warningGUI.ResetOnSpawn = false
    warningGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    warningGUI.Enabled = false
    
    local warningFrame = Instance.new("Frame")
    warningFrame.Name = "WarningFrame"
    warningFrame.Size = UDim2.new(0, 400, 0, 150)
    warningFrame.Position = UDim2.new(0.5, -200, 0.3, 0)
    warningFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    warningFrame.BorderSizePixel = 0
    warningFrame.Parent = warningGUI
    
    local warningCorner = Instance.new("UICorner")
    warningCorner.CornerRadius = UDim.new(0, 10)
    warningCorner.Parent = warningFrame
    
    local warningText = Instance.new("TextLabel")
    warningText.Name = "WarningText"
    warningText.Size = UDim2.new(1, 0, 1, 0)
    warningText.BackgroundTransparency = 1
    warningText.Text = "⚠️ CẢNH BÁO ⚠️\n\nNGUY HIỂM ĐANG ĐẾN GẦN!\nCHẠY NGAY!"
    warningText.TextColor3 = Color3.fromRGB(255, 255, 255)
    warningText.Font = Enum.Font.GothamBold
    warningText.TextSize = 24
    warningText.TextScaled = true
    warningText.Parent = warningFrame
end

function StartJumpscareWarning()
    StopJumpscareWarning()
    CreateWarningGUI()
    
    jumpscareWarningConnection = RunService.RenderStepped:Connect(function()
        if not Settings.JumpscareWarningEnabled then return end
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local dangerDetected = false
        local dangerType = ""
        local dangerDistance = math.huge
        
        local entities = FindEntities()
        for _, entity in ipairs(entities) do
            local object = entity.Object
            if object and object.Parent then
                local objectPosition = object.Position or (object:IsA("Model") and object:GetPivot().Position)
                
                if objectPosition then
                    local distance = (objectPosition - rootPart.Position).Magnitude
                    
                    if distance < Settings.WarningDistance then
                        dangerDetected = true
                        dangerType = entity.Type
                        dangerDistance = distance
                        break
                    end
                end
            end
        end
        
        for _, object in ipairs(workspace:GetDescendants()) do
            if object:IsA("BasePart") or object:IsA("Model") then
                local name = object.Name:lower()
                local parentName = object.Parent and object.Parent.Name:lower() or ""
                
                if name:find("jumpscare") or name:find("scare") or name:find("brain") or name:find("nao") or
                   parentName:find("jumpscare") or parentName:find("scare") or parentName:find("brain") then
                    
                    local objectPosition = object.Position or (object:IsA("Model") and object:GetPivot().Position)
                    if objectPosition then
                        local distance = (objectPosition - rootPart.Position).Magnitude
                        if distance < Settings.WarningDistance then
                            dangerDetected = true
                            dangerType = "JUMPSCARE"
                            dangerDistance = distance
                            break
                        end
                    end
                end
            end
        end
        
        if dangerDetected then
            if warningGUI then
                warningGUI.Enabled = true
                
                local warningText = warningGUI:FindFirstChild("WarningFrame"):FindFirstChild("WarningText")
                if warningText then
                    warningText.Text = "⚠️ CẢNH BÁO ⚠️\n\n" .. dangerType .. " ĐANG ĐẾN GẦN!\nKHOẢNG CÁCH: " .. math.floor(dangerDistance) .. "m\nCHẠY NGAY!"
                end
                
                local warningFrame = warningGUI:FindFirstChild("WarningFrame")
                if warningFrame then
                    local hue = (tick() * 10) % 1
                    warningFrame.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                end
            end
        else
            if warningGUI then
                warningGUI.Enabled = false
            end
        end
    end)
    addConnection(jumpscareWarningConnection)
end

function StopJumpscareWarning()
    if jumpscareWarningConnection then
        jumpscareWarningConnection:Disconnect()
        jumpscareWarningConnection = nil
    end
    if warningGUI then
        warningGUI:Destroy()
        warningGUI = nil
    end
end

-- CHỨC NĂNG: FLY
function EnableFly()
    DisableFly()
    if not currentCharacter or not currentHumanoid then return end
    local rootPart = currentCharacter:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 100000
    bodyGyro.D = 1000
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if Settings.FlyEnabled and currentCharacter and rootPart.Parent then
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection += workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection -= workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection -= workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection += workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection -= Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                bodyVelocity.Velocity = moveDirection.Unit * Settings.FlySpeed
            end
        else
            bodyGyro:Destroy()
            bodyVelocity:Destroy()
        end
    end)
    addConnection(flyConnection)
end

function DisableFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if currentCharacter then
        local rootPart = currentCharacter:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, child in ipairs(rootPart:GetChildren()) do
                if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end
        end
    end
end

-- Kết nối nhân vật
local function setupCharacter(character)
    currentCharacter = character
    currentHumanoid = character:WaitForChild("Humanoid")
    if Settings.SuperSpeedEnabled then
        currentHumanoid.WalkSpeed = 16 * Settings.SpeedMultiplier
    end
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

-- Xử lý phím tắt
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Settings.KeyToggleMenu then
        Settings.MenuVisible = not Settings.MenuVisible
        MainFrame.Visible = Settings.MenuVisible
    end
end)

-- Dọn dẹp khi script bị xóa
script.Destroying:Connect(function()
    cleanupConnections()
    if ScreenGui then
        ScreenGui:Destroy()
    end
    if shopGUI then
        shopGUI:Destroy()
    end
    if warningGUI then
        warningGUI:Destroy()
    end
end)

-- Khởi tạo menu
MainFrame.Visible = Settings.MenuVisible

-- Bật cảnh báo jumpscare mặc định
StartJumpscareWarning()

-- Thông báo
print("========================================")
print("  ANIMAL HOSPITAL HACK - ULTIMATE SHOP")
print("  Tác giả: mi va linh cu to")
print("  Phiên bản: 5.0.0")
print("  Menu: RightShift để hiện/ẩn")
print("  Chức năng:")
print("  - Auto Collect: Tự động thu thập vật phẩm")
print("  - Infinite Jump: Nhảy vô hạn")
print("  - Super Speed: Tăng tốc độ chạy")
print("  - Tùy chỉnh tốc độ: 0.5x - 10x")
print("  - No Clip: Xuyên tường")
print("  - Anti Ban: Chống bị kick/ban")
print("  - ESP Players: Hiển thị người chơi qua tường")
print("  - ESP Patients (Cháy): Hiển thị bệnh nhân bị cháy")
print("  - ESP Walker: Hiển thị Walker")
print("  - ESP Mimic: Hiển thị Mimic")
print("  - Cảnh Báo Jumpscare: Cảnh báo khi entity đến gần")
print("  - Fly: Bay tự do")
print("  - Lấy Kìm Chích Điện: Nhận vũ khí")
print("  - Lấy Cà Phê: Nhận vật phẩm tăng tốc")
print("  - Hiện Vật Phẩm Shop: ESP cho vật phẩm trong shop")
print("  - Tự Động Mua Đồ: Tự động mua vật phẩm")
print("  - Mở Shop Vật Phẩm: Hiển thị danh sách vật phẩm")
print("  - Teleport: Dịch chuyển đến người chơi khác")
print("========================================")