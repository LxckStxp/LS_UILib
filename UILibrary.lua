-- UILibrary v2.0 - Grok-inspired Minimalistic Design
-- Sleek, sharp, and modern UI components for Roblox
-- By LxckStxp

local UILibrary = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Grok-inspired Color Palette - Sharp and Modern
UILibrary.Colors = {
    -- Primary Colors
    Primary = Color3.fromRGB(0, 0, 0),           -- Pure Black
    Secondary = Color3.fromRGB(20, 20, 20),      -- Dark Gray
    Accent = Color3.fromRGB(255, 255, 255),      -- Pure White
    
    -- Functional Colors
    Success = Color3.fromRGB(0, 255, 127),       -- Bright Green
    Warning = Color3.fromRGB(255, 193, 7),       -- Amber
    Error = Color3.fromRGB(255, 71, 87),         -- Red
    Info = Color3.fromRGB(0, 123, 255),          -- Blue
    
    -- Subtle Colors
    Muted = Color3.fromRGB(108, 117, 125),       -- Gray
    Light = Color3.fromRGB(248, 249, 250),       -- Off-white
    Dark = Color3.fromRGB(33, 37, 41),           -- Almost black
    
    -- Transparency overlays
    Overlay = Color3.fromRGB(0, 0, 0),           -- For overlays
    Glass = Color3.fromRGB(255, 255, 255),       -- For glass effects
}

-- Modern Transparency Presets
UILibrary.Transparency = {
    Invisible = 1.0,
    Subtle = 0.95,      -- Barely visible
    Light = 0.85,       -- Light transparency
    Medium = 0.7,       -- Moderate transparency
    Heavy = 0.5,        -- Strong visibility
    Solid = 0.0,        -- Fully opaque
}

-- Grok-style Animation Presets - Fast and snappy
UILibrary.Animations = {
    Instant = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Quick = TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Smooth = TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Fluid = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
}

-- Create a minimalistic glass frame
function UILibrary:CreateFrame(properties)
    local frame = Instance.new("Frame")
    
    -- Sharp, modern styling
    frame.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.Accent
    frame.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Light
    frame.BorderSizePixel = 0
    frame.Size = properties.Size or UDim2.new(0, 200, 0, 100)
    frame.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    
    if properties.Parent then
        frame.Parent = properties.Parent
    end
    
    -- Minimal corner rounding - sharp but not harsh
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, properties.CornerRadius or 4)
    corner.Parent = frame
    
    -- Subtle border for definition
    if properties.Border ~= false then
        local border = Instance.new("UIStroke")
        border.Color = properties.BorderColor or UILibrary.Colors.Muted
        border.Transparency = properties.BorderTransparency or UILibrary.Transparency.Medium
        border.Thickness = properties.BorderThickness or 0.5
        border.Parent = frame
    end
    
    return frame
end

-- Create a sleek button
function UILibrary:CreateButton(properties)
    local button = Instance.new("TextButton")
    
    -- Clean button styling
    button.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.Primary
    button.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Subtle
    button.BorderSizePixel = 0
    button.Size = properties.Size or UDim2.new(0, 100, 0, 32)
    button.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    button.Text = properties.Text or "Button"
    button.TextColor3 = properties.TextColor or UILibrary.Colors.Accent
    button.TextTransparency = properties.TextTransparency or 0
    button.TextSize = properties.TextSize or 13
    button.Font = properties.Font or Enum.Font.GothamMedium
    button.AutoButtonColor = false -- Disable default button animations
    
    if properties.Parent then
        button.Parent = properties.Parent
    end
    
    -- Sharp corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, properties.CornerRadius or 4)
    corner.Parent = button
    
    -- Subtle border
    if properties.Border ~= false then
        local border = Instance.new("UIStroke")
        border.Color = properties.BorderColor or UILibrary.Colors.Muted
        border.Transparency = properties.BorderTransparency or UILibrary.Transparency.Light
        border.Thickness = properties.BorderThickness or 0.5
        border.Parent = button
    end
    
    -- Fluid hover animations
    local originalTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Subtle
    local originalTextTransparency = properties.TextTransparency or 0
    
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            BackgroundTransparency = math.max(0, originalTransparency - 0.1)
        })
        local textTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            TextTransparency = math.max(0, originalTextTransparency - 0.1)
        })
        hoverTween:Play()
        textTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local hoverTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            BackgroundTransparency = originalTransparency
        })
        local textTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            TextTransparency = originalTextTransparency
        })
        hoverTween:Play()
        textTween:Play()
    end)
    
    -- Press animation
    button.MouseButton1Down:Connect(function()
        local pressTween = TweenService:Create(button, UILibrary.Animations.Instant, {
            Size = UDim2.new(button.Size.X.Scale, button.Size.X.Offset - 2, button.Size.Y.Scale, button.Size.Y.Offset - 1)
        })
        pressTween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local releaseTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            Size = properties.Size or UDim2.new(0, 100, 0, 32)
        })
        releaseTween:Play()
    end)
    
    return button
end

-- Create sharp text label
function UILibrary:CreateLabel(properties)
    local label = Instance.new("TextLabel")
    
    -- Clean text styling
    label.BackgroundTransparency = 1
    label.Size = properties.Size or UDim2.new(0, 100, 0, 20)
    label.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    label.Text = properties.Text or "Label"
    label.TextColor3 = properties.TextColor or UILibrary.Colors.Primary
    label.TextTransparency = properties.TextTransparency or 0
    label.TextSize = properties.TextSize or 13
    label.Font = properties.Font or Enum.Font.Gotham
    label.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    label.TextStrokeTransparency = properties.TextStroke and 0.7 or 1
    label.TextStrokeColor3 = UILibrary.Colors.Primary
    
    if properties.Parent then
        label.Parent = properties.Parent
    end
    
    return label
end

-- Create minimalistic container
function UILibrary:CreateContainer(properties)
    local container = self:CreateFrame({
        Size = properties.Size or UDim2.new(1, -16, 0, 100),
        Position = properties.Position or UDim2.new(0, 8, 0, 0),
        BackgroundColor = properties.BackgroundColor or UILibrary.Colors.Accent,
        BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Light,
        CornerRadius = properties.CornerRadius or 6,
        BorderTransparency = UILibrary.Transparency.Medium,
        Parent = properties.Parent
    })
    
    -- Optional header
    if properties.HeaderText then
        local header = self:CreateLabel({
            Size = UDim2.new(1, -16, 0, 20),
            Position = UDim2.new(0, 8, 0, 6),
            Text = properties.HeaderText,
            TextColor = properties.HeaderColor or UILibrary.Colors.Muted,
            TextTransparency = 0.2,
            TextSize = properties.HeaderSize or 11,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = container
        })
    end
    
    return container
end

-- Create compact score display
function UILibrary:CreateScoreCard(properties)
    local scoreFrame = self:CreateFrame({
        Size = properties.Size or UDim2.new(0.45, 0, 0, 36),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Primary,
        BackgroundTransparency = UILibrary.Transparency.Subtle,
        CornerRadius = 4,
        Parent = properties.Parent
    })
    
    -- Score number - larger and prominent
    local scoreLabel = self:CreateLabel({
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        Text = properties.Score or "0",
        TextColor = properties.ScoreColor or UILibrary.Colors.Accent,
        TextTransparency = 0,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = scoreFrame
    })
    
    -- Name label - compact and subtle
    local nameLabel = self:CreateLabel({
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0.6, 0, 0, 0),
        Text = properties.Name or "SCORE",
        TextColor = properties.NameColor or UILibrary.Colors.Muted,
        TextTransparency = 0.3,
        TextSize = 10,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = scoreFrame
    })
    
    return scoreFrame, scoreLabel, nameLabel
end

-- Create slim probability bar
function UILibrary:CreateProbabilityBar(properties)
    local barFrame = self:CreateFrame({
        Size = properties.Size or UDim2.new(0.32, 0, 0, 24),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Info,
        BackgroundTransparency = UILibrary.Transparency.Subtle,
        CornerRadius = 2,
        Parent = properties.Parent
    })
    
    local probLabel = self:CreateLabel({
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "0%",
        TextColor = UILibrary.Colors.Accent,
        TextTransparency = 0,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        Parent = barFrame
    })
    
    return barFrame, probLabel
end

-- Create card button with state management
function UILibrary:CreateCardButton(properties)
    local cardBtn = self:CreateButton({
        Size = properties.Size or UDim2.new(0, 28, 0, 22),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "1",
        BackgroundColor = UILibrary.Colors.Accent,
        BackgroundTransparency = UILibrary.Transparency.Light,
        TextColor = UILibrary.Colors.Primary,
        TextTransparency = 0,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        CornerRadius = 2,
        Parent = properties.Parent
    })
    
    return cardBtn
end

-- Create target selector button
function UILibrary:CreateTargetButton(properties)
    local targetBtn = self:CreateButton({
        Size = properties.Size or UDim2.new(0, 64, 0, 24),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "21",
        BackgroundColor = properties.Color or UILibrary.Colors.Info,
        BackgroundTransparency = properties.Selected and UILibrary.Transparency.Heavy or UILibrary.Transparency.Subtle,
        TextColor = UILibrary.Colors.Accent,
        TextTransparency = properties.Selected and 0 or 0.3,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        CornerRadius = 2,
        Parent = properties.Parent
    })
    
    return targetBtn
end

-- Create card indicator
function UILibrary:CreateCardIndicator(properties)
    local indicator = self:CreateFrame({
        Size = properties.Size or UDim2.new(0, 28, 0, 16),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Warning,
        BackgroundTransparency = UILibrary.Transparency.Medium,
        CornerRadius = 2,
        Parent = properties.Parent
    })
    
    local numberLabel = self:CreateLabel({
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "1",
        TextColor = UILibrary.Colors.Accent,
        TextTransparency = 0,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        Parent = indicator
    })
    
    return indicator
end

-- Make frame draggable with fluid motion
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

-- Smooth entrance animation
function UILibrary:AnimateEntrance(frame, direction)
    direction = direction or "left"
    
    local originalPosition = frame.Position
    local startPosition = originalPosition
    
    if direction == "left" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset - 400, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "right" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset + 400, originalPosition.Y.Scale, originalPosition.Y.Offset)
    elseif direction == "top" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset - 400)
    elseif direction == "bottom" then
        startPosition = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, originalPosition.Y.Scale, originalPosition.Y.Offset + 400)
    end
    
    frame.Position = startPosition
    
    local entranceTween = TweenService:Create(frame, UILibrary.Animations.Fluid, {
        Position = originalPosition
    })
    entranceTween:Play()
    
    return entranceTween
end

-- Fluid slide animation
function UILibrary:AnimateSlide(frame, targetPosition, duration, easingStyle)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        easingStyle or Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(frame, tweenInfo, {
        Position = targetPosition
    })
    
    tween:Play()
    return tween
end

-- Smooth fade animation
function UILibrary:AnimateFade(frame, targetTransparency, duration, easingStyle)
    local tweenInfo = TweenInfo.new(
        duration or 0.15,
        easingStyle or Enum.EasingStyle.Sine
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

-- Sleek notification system
function UILibrary:CreateNotification(properties)
    local gui = properties.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local notification = self:CreateFrame({
        Size = UDim2.new(0, 280, 0, 60),
        Position = UDim2.new(1, -290, 0, 10),
        BackgroundColor = UILibrary.Colors.Primary,
        BackgroundTransparency = UILibrary.Transparency.Light,
        CornerRadius = 4,
        Parent = gui
    })
    
    local titleLabel = self:CreateLabel({
        Size = UDim2.new(1, -16, 0, 18),
        Position = UDim2.new(0, 8, 0, 4),
        Text = properties.Title or "Notification",
        TextColor = UILibrary.Colors.Accent,
        TextTransparency = 0,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification
    })
    
    local messageLabel = self:CreateLabel({
        Size = UDim2.new(1, -16, 0, 32),
        Position = UDim2.new(0, 8, 0, 22),
        Text = properties.Message or "Message content",
        TextColor = UILibrary.Colors.Muted,
        TextTransparency = 0.2,
        TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = notification
    })
    
    -- Slide in animation
    self:AnimateSlide(notification, UDim2.new(1, -290, 0, 10), 0.3)
    
    -- Auto dismiss
    spawn(function()
        wait(properties.Duration or 2.5)
        self:AnimateSlide(notification, UDim2.new(1, 10, 0, 10), 0.3)
        wait(0.3)
        notification:Destroy()
    end)
end

-- Smooth toggle visibility
function UILibrary:ToggleVisibility(frame, visible)
    local targetPosition = visible and UDim2.new(0, 8, 0, 40) or UDim2.new(0, -frame.AbsoluteSize.X - 16, 0, 40)
    
    local tween = TweenService:Create(
        frame,
        UILibrary.Animations.Fluid,
        {Position = targetPosition}
    )
    
    tween:Play()
    return tween
end

-- Scale animation for emphasis
function UILibrary:AnimateScale(frame, targetScale, duration)
    local originalSize = frame.Size
    local targetSize = UDim2.new(
        originalSize.X.Scale * targetScale,
        originalSize.X.Offset * targetScale,
        originalSize.Y.Scale * targetScale,
        originalSize.Y.Offset * targetScale
    )
    
    local scaleTween = TweenService:Create(frame, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Sine), {
        Size = targetSize
    })
    scaleTween:Play()
    
    return scaleTween
end

-- Pulse animation for notifications
function UILibrary:AnimatePulse(frame, intensity, duration)
    intensity = intensity or 1.05
    duration = duration or 0.5
    
    local originalScale = frame.Size
    local pulseScale = UDim2.new(
        originalScale.X.Scale * intensity,
        originalScale.X.Offset * intensity,
        originalScale.Y.Scale * intensity,
        originalScale.Y.Offset * intensity
    )
    
    local pulseTween = TweenService:Create(frame, TweenInfo.new(duration/2, Enum.EasingStyle.Sine), {
        Size = pulseScale
    })
    
    pulseTween:Play()
    pulseTween.Completed:Connect(function()
        local returnTween = TweenService:Create(frame, TweenInfo.new(duration/2, Enum.EasingStyle.Sine), {
            Size = originalScale
        })
        returnTween:Play()
    end)
    
    return pulseTween
end

return UILibrary
