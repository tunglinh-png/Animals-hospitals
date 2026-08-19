-- Script mô phỏng bypass robux - KHÔNG hoạt động thực tế
-- Chỉ hiển thị robux giả trên màn hình

local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BypassRobux"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "Bypass Robux"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.Parent = frame

local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(1, 0, 0, 35)
balanceLabel.Position = UDim2.new(0, 0, 0, 45)
balanceLabel.Text = "Robux: 0"
balanceLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
balanceLabel.BackgroundTransparency = 1
balanceLabel.Font = Enum.Font.SourceSansBold
balanceLabel.TextSize = 16
balanceLabel.Parent = frame

local amountBox = Instance.new("TextBox")
amountBox.Size = UDim2.new(0.8, 0, 0, 30)
amountBox.Position = UDim2.new(0.1, 0, 0, 90)
amountBox.PlaceholderText = "Nhập số robux"
amountBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
amountBox.TextColor3 = Color3.fromRGB(255, 255, 255)
amountBox.Parent = frame

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(0.8, 0, 0, 35)
bypassBtn.Position = UDim2.new(0.1, 0, 0, 130)
bypassBtn.Text = "BYPASS"
bypassBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
bypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bypassBtn.Font = Enum.Font.SourceSansBold
bypassBtn.TextSize = 13
bypassBtn.Parent = frame

local fakeBalance = 0

bypassBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(amountBox.Text)
    if amount and amount > 0 then
        fakeBalance = fakeBalance + amount
        balanceLabel.Text = "Robux: " .. fakeBalance
        amountBox.Text = ""
        -- Cố gắng gửi lên server (sẽ bị từ chối)
        local success = pcall(function()
            game:GetService("ReplicatedStorage"):FindFirstChild("RobuxEvent"):FireServer(amount)
        end)
        if not success then
            print("Server từ chối yêu cầu thêm robux")
        end
    end
end)

frame.Draggable = true
frame.Active = true