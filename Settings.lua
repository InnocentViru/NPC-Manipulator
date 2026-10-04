    
--[[
    Note: This was my first time doing a whole functional settings gui, don't expect it to be that good in design and coding.
--]]

file = "NM_Settings.json"
if not isfile(file) then
    local t = {
        ["Velocity"] = {
            X = 0,
            Y = 100,
            Z = 0,
            Relative = false
        },
        ["Responsiveness"] = 0.2,
        ["Trip"] = 3,
        ["SpinAmount"] = 4,
        ["CFrame"] = {
            X = 0,
            Y = 100,
            Z = 0,
            Relative = false
        },        
        ["DanceSpeed"] = 6,
        ["FuckSpeed"] = 15
    }
    writefile(file, game.HttpService:JSONEncode(t))
end

pcall(function() gethui().Settings_NM:Destroy() end)

function stylish(par, nostroke)
    par.BackgroundColor3 = Color3.new(1,1,1)
    if not nostroke then
        local stroke = Instance.new("UIStroke", par)
        stroke.Thickness = 3
        stroke.ApplyStrokeMode = "Border"    
    end

    local gradient = Instance.new("UIGradient", par)
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
    })
end


local g = Instance.new("ScreenGui", gethui())
g.Name = "Settings_NM"

local frame = Instance.new("Frame", g)
frame.AnchorPoint = Vector2.new(.5, .5)
frame.Position = UDim2.fromScale(.5, .5)
frame.ClipsDescendants = true
frame.Size = UDim2.fromScale(.65, .65)
frame.BackgroundColor3 = Color3.new(1,1,1)

stylish(frame)
Instance.new("UIDragDetector", frame)
Instance.new("UIAspectRatioConstraint", frame).AspectRatio = 1.25

local x = Instance.new("TextButton", frame)
x.Font = "FredokaOne"
x.TextScaled = true
x.Text = "X" -- duh
x.BackgroundColor3 = Color3.new(1,1,1)
x.TextColor3 = Color3.new(1,0,0)
x.Size = UDim2.fromScale(.125,.125)
x.AnchorPoint = Vector2.new(.5, .5)
x.Position = UDim2.fromScale(.945, .06)
x.BackgroundTransparency = 1
x.Name = "Close"

x.MouseButton1Click:Connect(function()
    g:Destroy()
end)

Instance.new("UIAspectRatioConstraint", x)
stylish(x, true)
Instance.new("UIStroke", x)

local Next = Instance.new("TextButton", frame)
Next.Text = ">"
Next.BackgroundTransparency = 1
Next.TextScaled = true
Next.Font = "FredokaOne"
Next.Name = "Next"
Next.AnchorPoint = Vector2.new(.5, .5)
Next.Position = UDim2.fromScale(.95, .5)
Next.TextColor3 = Color3.new(1,1,1)
Next.ZIndex = 10
Next.Size = UDim2.fromScale(0.2, 0.2)
stylish(Next, true)
Instance.new("UIAspectRatioConstraint", Next)
Instance.new("UIStroke", Next)

local previous = Next:Clone()
previous.Parent = frame
previous.Visible = false
previous.Name = "Previous"
previous.Position = UDim2.fromScale(0.05, 0.5)
previous.Text = "<"

local f = frame:Clone()
f.Parent = frame
f:ClearAllChildren()
f.BackgroundTransparency = 1
f.Size = UDim2.fromScale(1,1)

local page = Instance.new("UIPageLayout", f)
page.TouchInputEnabled = false
page.EasingStyle = "Quart"
page.SortOrder = "LayoutOrder"
page.TweenTime = 0.75

local names = {
    "Velocity",
    "Drag",
    "Trip",
    "Spin",
    "CFrame",
    "Little Dance",
    "Fuck"
}

local function updatearrows()
    previous.Visible = page.CurrentPage ~= f:FindFirstChild(names[1])
    Next.Visible = page.CurrentPage ~= f:FindFirstChild(names[#names])
end

previous.MouseButton1Click:Connect(function()
    page:Previous()    
    updatearrows()
end)

Next.MouseButton1Click:Connect(function()    
    page:Next()       
    updatearrows()
end)

function FrameWithTitle(name, order)
    local fr = Instance.new("Frame", f)
    fr.Size = UDim2.fromScale(1,1)
    fr.Name = name
    fr.LayoutOrder = order
    fr.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", fr)
    label.Text = name
    label.Font = "FredokaOne"
    label.AnchorPoint = Vector2.new(.5, .5)
    label.Position = UDim2.fromScale(.5, .1)
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Size = UDim2.fromScale(.8, .2)
    Instance.new("UIStroke", label)

    return fr
end

local frames = {}
for i,v in next, names do
    table.insert(frames, FrameWithTitle(v, i))
end

function setnotif(add)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Success",
        Text = not add and "Successfully set changes." or "Successfully set changes, " .. add .. ".",
        Duration = 1.5,
        Icon = "rbxassetid://12690727184"
    })
end

local velocity = Instance.new("TextBox", frames[1])
velocity.TextScaled = true
velocity.Text = "?, ?, ?"
velocity.PlaceholderText = "Insert Axis (X, Y, Z)"
velocity.AnchorPoint = Vector2.new(.5, .5)
velocity.TextColor3 = Color3.new(1,1,1)
velocity.TextSize = 32
velocity.Position = UDim2.fromScale(.5, .35)
velocity.PlaceholderColor3 = Color3.new(1,1,1)
velocity.Size = UDim2.fromScale(.75, .2)
velocity.Font = "FredokaOne"
Instance.new("UIStroke", velocity)
stylish(velocity)

velocity.FocusLost:Connect(function()
    if velocity.Text == "" then
        velocity.Text = "?,?,?"
        return
    end
    local fi = readfile(file)
    local t = game.HttpService:JSONDecode(fi)
    local digits = {}
    for digit in string.gmatch(velocity.Text, "-?%d+") do
        table.insert(digits, tonumber(digit))
    end
    if #digits < 3 then velocity.Text = "?,?,?" return end
    
    t.Velocity.X = digits[1] or 0
    t.Velocity.Y = digits[2] or 100
    t.Velocity.Z = digits[3] or 0
    setnotif()
    velocity.Text = "?,?,?"
    writefile(file, game.HttpService:JSONEncode(t))
end)

local velocityb = Instance.new("TextButton", frames[1])
velocityb.TextScaled = true
velocityb.Text = "Stacks: " .. (game.HttpService:JSONDecode(readfile(file)).Velocity.Relative and "ON" or "OFF")
velocityb.AnchorPoint = Vector2.new(.5, .5)
velocityb.TextColor3 = Color3.new(1,1,1)
velocityb.Position = UDim2.fromScale(.5, .6)
velocityb.Size = UDim2.fromScale(.6, .2)
velocityb.Font = "FredokaOne"
Instance.new("UIStroke", velocityb)
stylish(velocityb)

velocityb.MouseButton1Click:Connect(function()
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.Velocity.Relative = not fi.Velocity.Relative    
    writefile(file, game.HttpService:JSONEncode(fi))
    velocityb.Text = "Stacks: " .. (game.HttpService:JSONDecode(readfile(file)).Velocity.Relative and "ON" or "OFF")
    setnotif()
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local drag = Instance.new("TextBox", frames[2])
drag.Text = ""
drag.PlaceholderText = "Set Responsiveness (Max: 1)"
drag.AnchorPoint = Vector2.new(.5, .5)
drag.TextScaled = true
drag.PlaceholderColor3 = Color3.new(1,1,1)
drag.TextSize = 32
drag.TextColor3 = Color3.new(1,1,1)
drag.Font = "FredokaOne"
drag.Position = UDim2.fromScale(.5, .5)
drag.Size = UDim2.fromScale(.7, .2)
stylish(drag)
Instance.new("UIStroke", drag)

drag.FocusLost:Connect(function()
    if not tonumber(drag.Text) then
        drag.Text = ""
        return
    end
    local num = tonumber(drag.Text)
    if num > 1 then
        num = 1
    elseif num <= 0 then 
        num = .2 
    end
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.Responsiveness = num
    writefile(file, game.HttpService:JSONEncode(fi))    
    drag.Text = num
    setnotif()
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local duration = Instance.new("TextBox", frames[3])
duration.Text = ""
duration.PlaceholderText = "Set Duration (Max: 15)"
duration.AnchorPoint = Vector2.new(.5, .5)
duration.TextScaled = true
duration.PlaceholderColor3 = Color3.new(1,1,1)
duration.TextSize = 32
duration.TextColor3 = Color3.new(1,1,1)
duration.Font = "FredokaOne"
duration.Position = UDim2.fromScale(.5, .5)
duration.Size = UDim2.fromScale(.7, .2)
stylish(duration)
Instance.new("UIStroke", duration)

duration.FocusLost:Connect(function()
    if not tonumber(duration.Text) then
        drag.Text = ""
        return
    end
    local num = tonumber(duration.Text)
    if num > 15 then num = 15 elseif num <= 0 then num = 3 end
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.Trip = num
    writefile(file, game.HttpService:JSONEncode(fi))
    setnotif()
    duration.Text = num
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local spin = Instance.new("TextBox", frames[4]) -- arigato gyro...
spin.Text = ""
spin.PlaceholderText = "Set Spin Speed..."
spin.AnchorPoint = Vector2.new(.5, .5)
spin.TextScaled = true
spin.PlaceholderColor3 = Color3.new(1,1,1)
spin.TextSize = 32
spin.TextColor3 = Color3.new(1,1,1)
spin.Font = "FredokaOne"
spin.Position = UDim2.fromScale(.5, .5)
spin.Size = UDim2.fromScale(.7, .2)
stylish(spin)
Instance.new("UIStroke", spin)

spin.FocusLost:Connect(function()
    if not tonumber(spin.Text) then
        spin.Text = ""
        return
    end
    local num = tonumber(spin.Text)    
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.SpinAmount = num
    writefile(file, game.HttpService:JSONEncode(fi))
    setnotif()
    spin.Text = num
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local cf = Instance.new("TextBox", frames[5])
cf.TextScaled = true
cf.Text = "?, ?, ?"
cf.PlaceholderText = "Insert Axis (X, Y, Z)"
cf.AnchorPoint = Vector2.new(.5, .5)
cf.TextColor3 = Color3.new(1,1,1)
cf.TextSize = 32
cf.Position = UDim2.fromScale(.5, .35)
cf.PlaceholderColor3 = Color3.new(1,1,1)
cf.Size = UDim2.fromScale(.75, .2)
cf.Font = "FredokaOne"
Instance.new("UIStroke", cf)
stylish(cf)

cf.FocusLost:Connect(function()
    if cf.Text == "" then
        cf.Text = "?,?,?"
        return
    end
    local fi = readfile(file)
    local t = game.HttpService:JSONDecode(fi)
    local digits = {}
    for digit in string.gmatch(cf.Text, "-?%d+") do
        table.insert(digits, tonumber(digit))
    end
    if #digits < 3 then cf.Text = "?,?,?" return end
    
    t.CFrame.X = digits[1] or 0
    t.CFrame.Y = digits[2] or 0
    t.CFrame.Z = digits[3] or 10
    setnotif()
    cf.Text = "?,?,?"
    writefile(file, game.HttpService:JSONEncode(t))
end)

local cfb = Instance.new("TextButton", frames[5])
cfb.TextScaled = true
cfb.Text = "Relative: " .. (game.HttpService:JSONDecode(readfile(file)).CFrame.Relative and "ON" or "OFF")
cfb.AnchorPoint = Vector2.new(.5, .5)
cfb.TextColor3 = Color3.new(1,1,1)
cfb.Position = UDim2.fromScale(.5, .6)
cfb.Size = UDim2.fromScale(.6, .2)
cfb.Font = "FredokaOne"
Instance.new("UIStroke", cfb)
stylish(cfb)

cfb.MouseButton1Click:Connect(function()
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.CFrame.Relative = not fi.CFrame.Relative    
    writefile(file, game.HttpService:JSONEncode(fi))
    cfb.Text = "Relative: " .. (game.HttpService:JSONDecode(readfile(file)).CFrame.Relative and "ON" or "OFF")
    setnotif()
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local speed = Instance.new("TextBox", frames[6])
speed.Text = ""
speed.PlaceholderText = "Set Dance Speed..."
speed.AnchorPoint = Vector2.new(.5, .5)
speed.TextScaled = true
speed.PlaceholderColor3 = Color3.new(1,1,1)
speed.TextSize = 32
speed.TextColor3 = Color3.new(1,1,1)
speed.Font = "FredokaOne"
speed.Position = UDim2.fromScale(.5, .5)
speed.Size = UDim2.fromScale(.7, .2)
stylish(speed)
Instance.new("UIStroke", speed)

speed.FocusLost:Connect(function()
    if not tonumber(speed.Text) then
        speed.Text = ""
        return
    end
    local num = tonumber(speed.Text)    
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.DanceSpeed = num
    writefile(file, game.HttpService:JSONEncode(fi))
    setnotif()
    speed.Text = num
end)

-- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

local fuck = Instance.new("TextBox", frames[7])
fuck.Text = ""
fuck.PlaceholderText = "Set Uh, Speed..."
fuck.AnchorPoint = Vector2.new(.5, .5)
fuck.TextScaled = true
fuck.PlaceholderColor3 = Color3.new(1,1,1)
fuck.TextSize = 32
fuck.TextColor3 = Color3.new(1,1,1)
fuck.Font = "FredokaOne"
fuck.Position = UDim2.fromScale(.5, .5)
fuck.Size = UDim2.fromScale(.7, .2)
stylish(fuck)
Instance.new("UIStroke", fuck)

fuck.FocusLost:Connect(function()
    if not tonumber(fuck.Text) then
        fuck.Text = ""
        return
    end
    local num = tonumber(fuck.Text)    
    local fi = game.HttpService:JSONDecode(readfile(file))
    fi.FuckSpeed = num
    writefile(file, game.HttpService:JSONEncode(fi))
    setnotif("i guess 🥀")
    fuck.Text = num
end)

