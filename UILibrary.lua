-- UILibrary v2.1 - Grok-inspired Minimalistic Design
-- Sleek, sharp, and modern UI components for Roblox
-- By LxckStxp

local UILibrary = {}
UILibrary.__index = UILibrary
UILibrary._VERSION = "2.1"
UILibrary._instances = {} -- Track active instances

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Grok-inspired Color Palette - High Contrast for Readability
UILibrary.Colors = {
    -- Primary Colors
    Primary = Color3.fromRGB(15, 15, 15),        -- Very Dark Gray (not pure black)
    Secondary = Color3.fromRGB(30, 30, 30),      -- Dark Gray
    Accent = Color3.fromRGB(245, 245, 245),      -- Off-White (easier on eyes)
    
    -- Functional Colors
    Success = Color3.fromRGB(34, 197, 94),       -- Vibrant Green
    Warning = Color3.fromRGB(251, 191, 36),      -- Golden Yellow  
    Error = Color3.fromRGB(239, 68, 68),         -- Strong Red
    Info = Color3.fromRGB(59, 130, 246),         -- Clear Blue
    
    -- Text Colors for High Contrast
    TextPrimary = Color3.fromRGB(255, 255, 255), -- Pure White for main text
    TextSecondary = Color3.fromRGB(200, 200, 200), -- Light Gray for secondary text
    TextMuted = Color3.fromRGB(160, 160, 160),   -- Medium Gray for subtle text
    TextDark = Color3.fromRGB(30, 30, 30),       -- Dark text for light backgrounds
    
    -- Background Colors
    Background = Color3.fromRGB(25, 25, 25),     -- Main background
    Surface = Color3.fromRGB(40, 40, 40),        -- Surface elements
    Overlay = Color3.fromRGB(0, 0, 0),           -- For overlays
    
    -- Legacy support (keeping old names but updating values)
    Muted = Color3.fromRGB(140, 140, 140),       -- Brighter gray for visibility
    Light = Color3.fromRGB(248, 249, 250),       -- Off-white
    Dark = Color3.fromRGB(20, 20, 20),           -- Very dark
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

-- ═══════════════════════════════════════════════════════════════════════════
-- INSTANCE MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

-- Create a new UI instance with unique identifier
function UILibrary.new(identifier)
    local self = setmetatable({}, UILibrary)
    self.identifier = identifier or tostring(tick())
    self.windows = {}
    self.connections = {}
    self._destroyed = false
    
    -- Register instance
    UILibrary._instances[self.identifier] = self
    
    return self
end

-- Check if an instance exists
function UILibrary.exists(identifier)
    return UILibrary._instances[identifier] ~= nil
end

-- Get existing instance or create new one
function UILibrary.getInstance(identifier)
    if UILibrary.exists(identifier) then
        return UILibrary._instances[identifier]
    end
    return UILibrary.new(identifier)
end

-- Destroy instance and cleanup
function UILibrary:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    
    -- Destroy all windows
    for _, window in pairs(self.windows) do
        if window and window.ScreenGui then
            pcall(function() window.ScreenGui:Destroy() end)
        end
    end
    
    -- Disconnect all connections
    for _, conn in pairs(self.connections) do
        pcall(function() conn:Disconnect() end)
    end
    
    self.windows = {}
    self.connections = {}
    UILibrary._instances[self.identifier] = nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- CORE UI COMPONENTS
-- ═══════════════════════════════════════════════════════════════════════════


-- Create a minimalistic glass frame
function UILibrary:CreateFrame(properties)
    if self._destroyed then warn("Cannot create frame on destroyed UILibrary instance") return end
    
    local frame = Instance.new("Frame")
    
    -- Sharp, modern styling
    frame.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.Accent
    frame.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Light
    frame.BorderSizePixel = 0
    frame.Size = properties.Size or UDim2.new(0, 200, 0, 100)
    frame.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    frame.ZIndex = properties.ZIndex or 1
    
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
    if self._destroyed then warn("Cannot create button on destroyed UILibrary instance") return end
    
    local button = Instance.new("TextButton")
    
    -- Clean button styling with better contrast
    button.BackgroundColor3 = properties.BackgroundColor or UILibrary.Colors.Surface
    button.BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Subtle
    button.BorderSizePixel = 0
    button.Size = properties.Size or UDim2.new(0, 100, 0, 32)
    button.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    button.Text = properties.Text or "Button"
    button.TextColor3 = properties.TextColor or UILibrary.Colors.TextPrimary
    button.TextTransparency = properties.TextTransparency or 0
    button.TextSize = properties.TextSize or 13
    button.Font = properties.Font or Enum.Font.GothamMedium
    button.AutoButtonColor = false -- Disable default button animations
    button.ZIndex = properties.ZIndex or 2
    
    -- Add text stroke for better readability
    button.TextStrokeTransparency = properties.TextStroke == false and 1 or 0.8
    button.TextStrokeColor3 = UILibrary.Colors.Primary
    
    if properties.Parent then
        button.Parent = properties.Parent
    end
    
    -- Sharp corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, properties.CornerRadius or 4)
    corner.Parent = button
    
    -- Subtle border for better definition
    if properties.Border ~= false then
        local border = Instance.new("UIStroke")
        border.Color = properties.BorderColor or UILibrary.Colors.TextMuted
        border.Transparency = properties.BorderTransparency or UILibrary.Transparency.Light
        border.Thickness = properties.BorderThickness or 0.5
        border.Parent = button
    end
    
    -- Fluid hover animations
    local originalTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Subtle
    local originalTextTransparency = properties.TextTransparency or 0
    local originalSize = properties.Size or UDim2.new(0, 100, 0, 32)
    
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            BackgroundTransparency = math.max(0, originalTransparency - 0.15)
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
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 2, originalSize.Y.Scale, originalSize.Y.Offset - 1)
        })
        pressTween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        local releaseTween = TweenService:Create(button, UILibrary.Animations.Quick, {
            Size = originalSize
        })
        releaseTween:Play()
    end)
    
    return button
end

-- Create sharp text label
function UILibrary:CreateLabel(properties)
    if self._destroyed then warn("Cannot create label on destroyed UILibrary instance") return end
    
    local label = Instance.new("TextLabel")
    
    -- Clean text styling with high contrast
    label.BackgroundTransparency = 1
    label.Size = properties.Size or UDim2.new(0, 100, 0, 20)
    label.Position = properties.Position or UDim2.new(0, 0, 0, 0)
    label.Text = properties.Text or "Label"
    label.TextColor3 = properties.TextColor or UILibrary.Colors.TextPrimary
    label.TextTransparency = properties.TextTransparency or 0
    label.TextSize = properties.TextSize or 13
    label.Font = properties.Font or Enum.Font.Gotham
    label.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    label.ZIndex = properties.ZIndex or 2
    
    -- Add subtle text stroke for better readability on transparent backgrounds
    label.TextStrokeTransparency = properties.TextStroke == false and 1 or 0.8
    label.TextStrokeColor3 = UILibrary.Colors.Primary
    
    if properties.Parent then
        label.Parent = properties.Parent
    end
    
    return label
end


-- Create minimalistic container
function UILibrary:CreateContainer(properties)
    if self._destroyed then warn("Cannot create container on destroyed UILibrary instance") return end
    
    local container = self:CreateFrame({
        Size = properties.Size or UDim2.new(1, -16, 0, 100),
        Position = properties.Position or UDim2.new(0, 8, 0, 0),
        BackgroundColor = properties.BackgroundColor or UILibrary.Colors.Surface,
        BackgroundTransparency = properties.BackgroundTransparency or UILibrary.Transparency.Light,
        CornerRadius = properties.CornerRadius or 6,
        BorderTransparency = UILibrary.Transparency.Medium,
        BorderColor = UILibrary.Colors.TextMuted,
        ZIndex = properties.ZIndex or 1,
        Parent = properties.Parent
    })
    
    -- Optional header with better contrast
    if properties.HeaderText then
        local header = self:CreateLabel({
            Size = UDim2.new(1, -16, 0, 20),
            Position = UDim2.new(0, 8, 0, 6),
            Text = properties.HeaderText,
            TextColor = properties.HeaderColor or UILibrary.Colors.TextSecondary,
            TextTransparency = 0,
            TextSize = properties.HeaderSize or 11,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = properties.ZIndex and properties.ZIndex + 1 or 2,
            Parent = container
        })
    end
    
    return container
end

-- ═══════════════════════════════════════════════════════════════════════════
-- WINDOW MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

-- Create a managed window with auto-cleanup
function UILibrary:CreateWindow(properties)
    if self._destroyed then warn("Cannot create window on destroyed UILibrary instance") return end
    
    local windowId = properties.Id or ("window_" .. tostring(#self.windows + 1))
    
    -- Check if window already exists
    if self.windows[windowId] then
        warn("Window with ID '" .. windowId .. "' already exists. Destroying old one.")
        self:DestroyWindow(windowId)
    end
    
    local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then
        warn("PlayerGui not found")
        return nil
    end
    
    -- Create ScreenGui
    local sg = Instance.new("ScreenGui")
    sg.Name = properties.Name or ("UILibrary_" .. windowId)
    sg.ResetOnSpawn = properties.ResetOnSpawn ~= nil and properties.ResetOnSpawn or false
    sg.IgnoreGuiInset = properties.IgnoreGuiInset ~= nil and properties.IgnoreGuiInset or true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = properties.DisplayOrder or 100
    
    -- Check for existing ScreenGui with same name and remove it
    local existing = pg:FindFirstChild(sg.Name)
    if existing then
        existing:Destroy()
    end
    
    sg.Parent = pg
    
    -- Create window object
    local window = {
        Id = windowId,
        ScreenGui = sg,
        Visible = true,
        _destroyed = false
    }
    
    self.windows[windowId] = window
    
    return window, sg
end

-- Destroy specific window
function UILibrary:DestroyWindow(windowId)
    local window = self.windows[windowId]
    if not window then return end
    
    if window.ScreenGui then
        pcall(function() window.ScreenGui:Destroy() end)
    end
    
    window._destroyed = true
    self.windows[windowId] = nil
end

-- Toggle window visibility
function UILibrary:ToggleWindow(windowId)
    local window = self.windows[windowId]
    if not window or window._destroyed then return end
    
    window.Visible = not window.Visible
    if window.ScreenGui then
        window.ScreenGui.Enabled = window.Visible
    end
    
    return window.Visible
end

-- ═══════════════════════════════════════════════════════════════════════════
-- SPECIALIZED COMPONENTS
-- ═══════════════════════════════════════════════════════════════════════════

-- Create compact score display
function UILibrary:CreateScoreCard(properties)
    if self._destroyed then return end
    
    local scoreFrame = self:CreateFrame({
        Size = properties.Size or UDim2.new(0.45, 0, 0, 36),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Primary,
        BackgroundTransparency = UILibrary.Transparency.Subtle,
        CornerRadius = 4,
        ZIndex = properties.ZIndex,
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
        ZIndex = properties.ZIndex and (properties.ZIndex + 1),
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
        ZIndex = properties.ZIndex and (properties.ZIndex + 1),
        Parent = scoreFrame
    })
    
    return scoreFrame, scoreLabel, nameLabel
end

-- Create slim probability bar
function UILibrary:CreateProbabilityBar(properties)
    if self._destroyed then return end
    
    local barFrame = self:CreateFrame({
        Size = properties.Size or UDim2.new(0.32, 0, 0, 24),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Info,
        BackgroundTransparency = UILibrary.Transparency.Subtle,
        CornerRadius = 2,
        ZIndex = properties.ZIndex,
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
        ZIndex = properties.ZIndex and (properties.ZIndex + 1),
        Parent = barFrame
    })
    
    return barFrame, probLabel
end

-- Create card button with state management
function UILibrary:CreateCardButton(properties)
    if self._destroyed then return end
    
    local cardBtn = self:CreateButton({
        Size = properties.Size or UDim2.new(0, 28, 0, 22),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "1",
        BackgroundColor = UILibrary.Colors.Surface,
        BackgroundTransparency = UILibrary.Transparency.Light,
        TextColor = UILibrary.Colors.TextPrimary,
        TextTransparency = 0,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        CornerRadius = 2,
        ZIndex = properties.ZIndex,
        Parent = properties.Parent
    })
    
    return cardBtn
end

-- Create target selector button
function UILibrary:CreateTargetButton(properties)
    if self._destroyed then return end
    
    local targetBtn = self:CreateButton({
        Size = properties.Size or UDim2.new(0, 64, 0, 24),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "21",
        BackgroundColor = properties.Color or UILibrary.Colors.Info,
        BackgroundTransparency = properties.Selected and UILibrary.Transparency.Heavy or UILibrary.Transparency.Subtle,
        TextColor = UILibrary.Colors.TextPrimary,
        TextTransparency = properties.Selected and 0 or 0.2,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        CornerRadius = 2,
        ZIndex = properties.ZIndex,
        Parent = properties.Parent
    })
    
    return targetBtn
end

-- Create card indicator
function UILibrary:CreateCardIndicator(properties)
    if self._destroyed then return end
    
    local indicator = self:CreateFrame({
        Size = properties.Size or UDim2.new(0, 28, 0, 16),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = properties.Color or UILibrary.Colors.Warning,
        BackgroundTransparency = UILibrary.Transparency.Medium,
        CornerRadius = 2,
        ZIndex = properties.ZIndex,
        Parent = properties.Parent
    })
    
    local numberLabel = self:CreateLabel({
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Text = properties.Text or "1",
        TextColor = UILibrary.Colors.TextPrimary,
        TextTransparency = 0,
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        ZIndex = properties.ZIndex and (properties.ZIndex + 1),
        Parent = indicator
    })
    
    return indicator
end


-- Make frame draggable with fluid motion
function UILibrary:MakeDraggable(frame, dragHandle)
    if self._destroyed then return end
    
    local dragHandle = dragHandle or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local conn1 = dragHandle.InputBegan:Connect(function(input)
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
    
    local conn2 = UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Store connections for cleanup
    table.insert(self.connections, conn1)
    table.insert(self.connections, conn2)
    
    return conn1, conn2
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
    if self._destroyed then return end
    
    local gui = properties.Parent or (Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui"))
    if not gui then return end
    
    local notification = self:CreateFrame({
        Size = UDim2.new(0, 280, 0, 60),
        Position = UDim2.new(1, -290, 0, 10),
        BackgroundColor = UILibrary.Colors.Primary,
        BackgroundTransparency = UILibrary.Transparency.Light,
        CornerRadius = 4,
        ZIndex = 1000,
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
        ZIndex = 1001,
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
        ZIndex = 1001,
        Parent = notification
    })
    
    -- Slide in animation
    self:AnimateSlide(notification, UDim2.new(1, -290, 0, 10), 0.3)
    
    -- Auto dismiss
    task.spawn(function()
        task.wait(properties.Duration or 2.5)
        self:AnimateSlide(notification, UDim2.new(1, 10, 0, 10), 0.3)
        task.wait(0.3)
        pcall(function() notification:Destroy() end)
    end)
    
    return notification
end

-- ═══════════════════════════════════════════════════════════════════════════
-- LEGACY/STATIC METHODS (for backwards compatibility)
-- ═══════════════════════════════════════════════════════════════════════════

-- Static methods that don't require instance
local StaticUILibrary = {}

function StaticUILibrary:CreateFrame(properties)
    return UILibrary.CreateFrame(UILibrary, properties)
end

function StaticUILibrary:CreateButton(properties)
    return UILibrary.CreateButton(UILibrary, properties)
end

function StaticUILibrary:CreateLabel(properties)
    return UILibrary.CreateLabel(UILibrary, properties)
end

function StaticUILibrary:CreateContainer(properties)
    return UILibrary.CreateContainer(UILibrary, properties)
end

function StaticUILibrary:MakeDraggable(frame, dragHandle)
    return UILibrary.MakeDraggable(UILibrary, frame, dragHandle)
end

-- Copy static methods
for k, v in pairs(StaticUILibrary) do
    if not UILibrary[k] then
        UILibrary[k] = v
    end
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
