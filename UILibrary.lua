-- UILibrary v1.0
-- Glassmorphic UI components for Roblox
-- By LxckStxp

local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- iOS Color Palette
UILibrary.Colors = {
    Red = Color3.fromRGB(255, 59, 48),
    Orange = Color3.fromRGB(255, 149, 0),
    Yellow = Color3.fromRGB(255, 204, 0),
    Green = Color3.fromRGB(52, 199, 89),
    Blue = Color3.fromRGB(0, 122, 255),
    Purple = Color3.fromRGB(175, 82, 222),
    Pink = Color3.fromRGB(255, 45, 85),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
    Gray = Color3.fromRGB(142, 142, 147)
}

-- Glassmorphic styling presets
UILibrary.Glass = {
    Primary = {
        BackgroundTransparency = 0.85,
        BorderTransparency = 0.7,
        BorderThickness = 1.5
    },
    Secondary = {
        BackgroundTransparency = 0.9,
        BorderTransparency = 0.8,
        BorderThickness = 1
    },
    Subtle = {
        BackgroundTransparency = 0.95,
        BorderTransparency = 0.85,
        BorderThickness = 0.5
    }
}

-- Animation presets
UILibrary.Animations = {
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Quart),
    Smooth = TweenInfo.new(0.3, Enum.EasingStyle.Quart),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
}

-- Create a glassmorphic frame
function UILibrary:CreateGlassFrame(properties)
    local frame = Instance.new("Frame")
    
    -- Default properties
    frame.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.White
    frame.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Glass.Primary.BackgroundTransparency
    frame.BorderSizePixel = 0
    frame.Size = properties.Size or UDim2.new(0, 200, 0, 100)
    frame.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    
    if properties.Parent then
        frame.Parent = properties.Parent
    end
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, properties.CornerRadius or 16)
    corner.Parent = frame
    
    -- Glass border
    local border = Instance.new("UIStroke")
    border.Color = properties.BorderColor or UILibrary.Colors.White
    border.Transparency = properties.BorderTransparency or UILibrary.Glass.Primary.BorderTransparency
    border.Thickness = properties.BorderThickness or UILibrary.Glass.Primary.BorderThickness
    border.Parent = frame
    
    return frame
end

-- Create a glassmorphic button
function UILibrary:CreateGlassButton(properties)
    local button = Instance.new("TextButton")
    
    -- Default properties
    button.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.White
    button.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Glass.Secondary.BackgroundTransparency
    button.BorderSizePixel = 0
    button.Size = properties.Size or UDim2.new(0, 100, 0, 30)
    button.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    button.Text = properties.Text or "Button"
    button.TextColor3 = properties.TextColor or UILibrary.Colors.Black
    button.TextTransparency = properties.TextTransparency or 0.3
    button.TextSize = properties.TextSize or 14
    button.Font = properties.Font or Enum.Font.GothamMedium
    
    if properties.Parent then
        button.Parent = properties.Parent
    end
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, properties.CornerRadius or 10)
    corner.Parent = button
    
    -- Glass border
    local border = Instance.new("UIStroke")
    border.Color = properties.BorderColor or UILibrary.Colors.White
    border.Transparency = properties.BorderTransparency or UILibrary.Glass.Secondary.BorderTransparency
    border.Thickness = properties.BorderThickness or UILibrary.Glass.Secondary.BorderThickness
    border.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            BackgroundTransparency = (properties.BackgroundTransparency or UILibrary.Glass.Secondary.BackgroundTransparency) - 0.15,
            TextTransparency = (properties.TextTransparency or 0.3) - 0.15
        })
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local hoverTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Glass.Secondary.BackgroundTransparency,
            TextTransparency = properties.TextTransparency or 0.3
        })
        hoverTween:Play()
    end)
    
    return button
end

-- Create a glassmorphic label
function UILibrary:CreateGlassLabel(properties)
    local label = Instance.new("TextLabel")
    
    -- Default properties
    label.BackgroundTransparency = 1
    label.Size = properties.Size or UDim2.new(0, 100, 0, 20)
    label.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    label.Text = properties.Text or "Label"
    label.TextColor3 = properties.TextColor or UILibrary.Colors.Black
    label.TextTransparency = properties.TextTransparency or 0.3
    label.TextSize = properties.TextSize or 14
    label.Font = properties.Font or Enum.Font.GothamMedium
    label.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    
    if properties.Parent then
        label.Parent = properties.Parent
    end
    
    return label
end

-- Create a glassmorphic container with header
function UILibrary:CreateSection(properties)
    local container = self:CreateGlassFrame({
        Size = properties.Size or UDim2.new(1, -30, 0, 100),
        Position = properties.Position or UDim2.new(0, 15, 0, 0),
        BackgroundColor = properties.BackgroundColor or UILibrary.Colors.White,
        BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Glass.Secondary.BackgroundTransparency,
        CornerRadius = properties.CornerRadius or 16,
        Parent = properties.Parent
    })
    
    -- Header if provided
    if properties.HeaderText then
        local header = self:CreateGlassLabel({
            Size = UDim2.new(1, -30, 0, 24),
            Position = UDim2.new(0, 15, 0, 8),
            Text = properties.HeaderText,
            TextColor = properties.HeaderColor or UILibrary.Colors.Black,
            TextTransparency = 0.3,
            TextSize = properties.HeaderSize or 14,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container
        })
    end
    
    return container
end

-- Create a score display component
function UILibrary:CreateScoreDisplay(properties)
    local scoreFrame = self:CreateGlassFrame({
        Size = properties.Size or UDim2.new(0.4, 0, 0, 40),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Blue,
        BackgroundTransparency = 0.8,
        CornerRadius = 12,
        Parent = properties.Parent
    })
    
    -- Score number
    local scoreLabel = self:CreateGlassLabel({
        Size = UDim2.new(1, 0, 0.65, 0),
        Position = UDim2.new(0, 0, 0.35, 0),
        Text = properties.Score or "0",
        TextColor = UILibrary.Colors.White,
        TextTransparency = 0.1,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        Parent = scoreFrame
    })
    
    -- Label
    local nameLabel = self:CreateGlassLabel({
        Size = UDim2.new(1, 0, 0.35, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = properties.Name or "SCORE",
        TextColor = UILibrary.Colors.White,
        TextTransparency = 0.3,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        Parent = scoreFrame
    })
    
    return scoreFrame, scoreLabel, nameLabel
end

-- Create a probability indicator
function UILibrary:CreateProbabilityIndicator(properties)
    local probFrame = self:CreateGlassFrame({
        Size = properties.Size or UDim2.new(0.31, 0, 0, 28),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Blue,
        BackgroundTransparency = 0.7,
        CornerRadius = 8,
        Parent = properties.Parent
    })
    
    local probLabel = self:CreateGlassLabel({
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "0%",
        TextColor = UILibrary.Colors.White,
        TextTransparency = 0.1,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        Parent = probFrame
    })
    
    return probFrame, probLabel
end

-- Make any frame draggable
function UILibrary:MakeDraggable(frame, dragHandle)
    local dragHandle = dragHandle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Create entrance animation
function UILibrary:AnimateEntrance(frame, direction)
    direction = direction or "left"
    
    local originalPosition = frame.Position
    local startPosition = originalPosition
    
    if direction == "left" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset - 500, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "right" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + 500, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "top" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset - 500)
    elseif direction == "bottom" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + 500)
    end
    
    frame.Position = startPosition
    
    local entranceTween = TweenService:Create(frame, UILibrary.Animations.Slow, {
        Position = originalPosition
    })
    entranceTween:Play()
    
    return entranceTween
end

-- Slide animation
function UILibrary:AnimateSlide(frame, targetPosition, duration, easingStyle)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(frame, tweenInfo, {
        Position = targetPosition
    })
    
    tween:Play()
    return tween
end

-- Fade animation
function UILibrary:AnimateFade(frame, targetTransparency, duration, easingStyle)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart
    )
    
    local properties = {}
    if frame:IsA("TextLabel") or frame:IsA("TextButton") then
        properties.TextTransparency = targetTransparency
    end
    if frame.BackgroundTransparency then
        properties.BackgroundTransparency = targetTransparency
    end
    
    local tween = TweenService:Create(frame, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Create a notification
function UILibrary:CreateNotification(properties)
    local gui = properties.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local notification = self:CreateGlassFrame({
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundColor = properties.BackgroundColor or UILibrary.Colors.White,
        BackgroundTransparency = UILibrary.Glass.Primary.BackgroundTransparency,
        CornerRadius = 16,
        Parent = gui
    })
    
    local titleLabel = self:CreateGlassLabel({
        Size = UDim2.new(1, -20, 0, 24),
        Position = UDim2.new(0, 10, 0, 8),
        Text = properties.Title or "Notification",
        TextColor = UILibrary.Colors.Black,
        TextTransparency = 0.2,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local messageLabel = self:CreateGlassLabel({
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 32),
        Text = properties.Message or "Message content",
        TextColor = UILibrary.Colors.Black,
        TextTransparency = 0.4,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notification
    })
    
    -- Slide in animation
    self:AnimateSlide(notification, UDim2.new(1, -320, 0, 20), 0.5)
    
    -- Auto dismiss after duration
    local duration = properties.Duration or 3
    wait(duration)
    
    self:AnimateSlide(notification, UDim2.new(1, 20, 0, 20), 0.5)
    wait(0.5)
    notification:Destroy()
end

-- Toggle visibility with animation
function UILibrary:ToggleVisibility(frame, visible)
    local targetPosition = visible and UDim2.new(0, 10, 0, 50) or UDim2.new(0, -frame.AbsoluteSize.X - 20, 0, 50)
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = targetPosition}
    )
    
    tween:Play()
    return tween
end

return UILibrary
