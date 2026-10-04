
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

plr = game.Players.LocalPlayer
char = plr.Character
hrp = char.HumanoidRootPart
hum = char.Humanoid
cam = workspace.CurrentCamera

file = "NM_Settings.json"

ts = game.TweenService
rs = game.RunService

if getgenv().SimulationRadiusCon then getgenv().SimulationRadiusCon:Disconnect() end
getgenv().SimulationRadiusCon = rs.Stepped:Connect(function()
    sethiddenproperty(plr, "SimulationRadius", math.huge)
    sethiddenproperty(plr, "MaximumSimulationRadius", math.huge)
end)

function sound(id, v)
    local a = Instance.new("Sound", workspace)
    a.SoundId = "rbxassetid://" .. id
    a.PlayOnRemove = true
    a.Volume = v
    a:Destroy()
end

function getclosestnpc(radius)
    local dist = radius or math.huge
    local closest = nil

    for i,v in next, workspace:GetDescendants() do
        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart")
        and v:FindFirstChild("Humanoid") then
            local model = v
            local phrp = v.HumanoidRootPart            
            local phum = v.Humanoid
            if model ~= char and (hrp.Position - phrp.Position).Magnitude < dist 
            and phum.Health > 0 and phrp.ReceiveAge == 0 then
                dist = (hrp.Position - phrp.Position).Magnitude
                closest = model
            end
        end
    end
    return closest
end

function stylish(par) -- crossattic i will copy your gui because why not lol
    par.BackgroundColor3 = Color3.new(1,1,1)
    local stroke = Instance.new("UIStroke", par)
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = "Border"    

    local gradient = Instance.new("UIGradient", par)
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
    })
end

function GetTarget()
    return getgenv().Selection.Adornee or nil
end

function Gui()
    pcall(function() gethui().NPC_Manipulator:Destroy() end)
    local gui = Instance.new("ScreenGui", gethui())
    gui.Name = "NPC_Manipulator"

    local secbuttons = {}
    local buttons = {}
            
    local frame = Instance.new("Frame", gui)
    stylish(frame)    
    frame.AnchorPoint = Vector2.new(.5, .5)
    frame.Name = "Buttons_Frame"
    frame.Position = UDim2.fromScale(.5, .5)    
    frame.Draggable = true       
    frame.Size = UDim2.fromScale(.55, .55)
    Instance.new("UIDragDetector", frame)
    Instance.new("UIAspectRatioConstraint", frame)

    local f = Instance.new("Frame", frame)
    f.AnchorPoint = Vector2.new(.5, .5)    
    f.Size = UDim2.fromScale(.25, 1)
    f.Position = UDim2.fromScale(-0.175,.5)
    f.Name = "Secondary_Frame"
    stylish(f)    
    
    local f2 = f:Clone()
    f2.Parent = f
    f2.Position = UDim2.fromScale(.5, .5)
    f2.Size = UDim2.fromScale(.8, .95)    
    f2.BackgroundTransparency = 1
    f2.Name = "Secondary"
    f2:ClearAllChildren()

    local grad = Instance.new("UIGridLayout", f2)
    grad.HorizontalAlignment = "Center"
    grad.CellPadding = UDim2.fromOffset(10,10)
    grad.CellSize = UDim2.fromScale(.9, .2)    
    grad.SortOrder = "LayoutOrder"

    for i = 1, 4 do
        if i > 2 then
            local img = Instance.new("ImageButton", f2)            
            Instance.new("UIStroke", img)
            stylish(img)
            table.insert(secbuttons, img)

            continue
        end
        local button = Instance.new("TextButton", f2)
        button.TextScaled = true
        button.TextColor3 = Color3.new(1,1,1)        
        button.Text = "?"

        Instance.new("UIStroke", button)
        stylish(button)
        table.insert(secbuttons, button)
    end

    local fr = frame:Clone()
    fr.Parent = frame
    fr.Name = "Buttons"
    fr.Size = UDim2.fromScale(.95,.9)
    fr.BackgroundTransparency = 1
    fr.Position = UDim2.fromScale(.5, .5)
    fr:ClearAllChildren()    
   
    local UIGridLayout = Instance.new("UIGridLayout", fr)
    UIGridLayout.CellPadding = UDim2.fromOffset(10, 10)
    UIGridLayout.CellSize = UDim2.fromScale(.45, .15)
    UIGridLayout.SortOrder = "LayoutOrder"
    UIGridLayout.HorizontalAlignment = "Center"

    local toggle = Instance.new("TextButton", gui)
    toggle.AnchorPoint = Vector2.new(.5, .5)
    toggle.Position = UDim2.fromScale(.25, .5)
    toggle.Text = "X"
    toggle.Name = "Toggle"
    toggle.Font = "FredokaOne"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextScaled = true
    toggle.Draggable = true
    toggle.Size = UDim2.fromScale(.125, .125)
    Instance.new("UIAspectRatioConstraint", toggle)
    Instance.new("UIStroke", toggle)    
    stylish(toggle)

    toggle.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible        
    end)
    
    local function button(name, index)
        local b = Instance.new("TextButton", fr)        
        stylish(b)        
        b.Text = name
        b.Name = name
        b.TextScaled = true
        b.Font = "FredokaOne"
        b.TextColor3 = Color3.new(1,1,1)
        b.LayoutOrder = index                 
        b.Modal = true
        
        local stroke = Instance.new("UIStroke", b)
        stroke.Thickness = 1                
        
        return b
    end    

    local names = {
        "Kill",
        "Delete",
        "Velocity",
        "Drag",
        "Trip",
        "Control",
        "Spin",
        "CFrame",
        "Lil' Dance",
        "Fuck",
    }    

    for i = 1, 10  do
        table.insert(buttons, button(names[i], i))
    end    

    for _,k in next, {buttons, secbuttons} do
        for _,v in next, k do
            v.MouseEnter:Connect(function()
                v.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                ts:Create(v, TweenInfo.new(.2), {["BackgroundColor3"] = Color3.new(1,1,1)}):Play()
                sound(12222170, 5)
            end)            
        end
    end
        
    secbuttons[1].Text = "⚙️"    
    secbuttons[1].LayoutOrder = 3

    secbuttons[2].Text = "C"   
    secbuttons[2].LayoutOrder = 2

    secbuttons[3].Image = "rbxassetid://14219414360"
    secbuttons[3].ImageColor3 = Color3.new(1,0,0)    
    secbuttons[3].LayoutOrder = 1

    secbuttons[4].Image = "rbxassetid://75786737406833"    
    secbuttons[4].ImageColor3 = Color3.new(0,0,1)
    secbuttons[4].LayoutOrder = 4
    
    local settings, pause, getclosest, link = secbuttons[1], secbuttons[3], secbuttons[2], secbuttons[4]
    
    return gui, frame, {pause, getclosest, settings, link}, buttons
end

local gui, frame, secondary, buttons = Gui()
getgenv().Stop = 0
GlobalDB = false

if getgenv().Selection and getgenv().Selection.Adornee then
    getgenv().Selection.Adornee = nil
end

secondary[1].MouseButton1Click:Connect(function()
    Stop += 1
    GlobalDB = false
    getgenv().Selection.Adornee = nil
end)

secondary[2].MouseButton1Click:Connect(function()    
    local npc = getclosestnpc()
    if npc then
        if not getgenv().Selection or not getgenv().Selection.Parent then
            getgenv().Selection = Instance.new("SelectionBox")
        end
        getgenv().Selection.Adornee = npc
        getgenv().Selection.Name = "Tuff NPC Outline yeah"
        getgenv().Selection.Parent = workspace
        getgenv().Selection.Color3 = Color3.new(1,0,0)        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Success",
            Text = `Found NPC by the name of '{npc.Name}'.`,
            Duration = 1.5,
            Icon = "rbxassetid://12690727184"
        })
        sound(12221944, 10)
    else 
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Error",
            Text = "No NPCs found.",
            Duration = 3,
            Icon = "rbxassetid://71503984286896"
        })
    end
end)

secondary[3].MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InnocentViru/NPC-Manipulator/refs/heads/main/Settings.lua?t=" .. tick()))()
end)

secondary[4].MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/5xEktGhuDF")

    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Copied",
        Text = "Discord link copied, pls join :>",
        Duration = 3,
        Icon = "rbxassetid://75786737406833" 
    })
end)

-- // -- // -- // -- // -- // -- //  -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- // -- //

buttons[1].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    local t = GetTarget()
    if t then
        local h = t:FindFirstChild("Humanoid")
        if h then
            h.Health = -1
            h:TakeDamage(9e9)
            h:ChangeState("Dead")
            getgenv().Selection.Adornee = nil
        end
    end
end)

buttons[2].MouseButton1Click:Connect(function()
    if GlobalDB then return end    
    local t = GetTarget()
    if t then
        local phrp = t:FindFirstChild("HumanoidRootPart")
        if phrp then
            local height = workspace.FallenPartsDestroyHeight
            local vec = Vector3.new(hrp.Position.X, height, hrp.Position.Z)
            local dis = (hrp.Position - vec).Magnitude
            phrp.CFrame *= CFrame.new(0, (-dis)+3,0)
            sound(12222140, 10)
        end
    end
end)

buttons[3].MouseButton1Click:Connect(function()
    if GlobalDB then return end    
    local t = GetTarget()
    if t then
        local phrp = t:FindFirstChild("HumanoidRootPart")
        if phrp then
            if game.HttpService:JSONDecode(readfile(file)).Velocity.Relative then
                phrp.Velocity += Vector3.new(
                    game.HttpService:JSONDecode(readfile(file)).Velocity.X,
                    game.HttpService:JSONDecode(readfile(file)).Velocity.Y,
                    game.HttpService:JSONDecode(readfile(file)).Velocity.Z
                )
            else
                phrp.Velocity = Vector3.new(
                    game.HttpService:JSONDecode(readfile(file)).Velocity.X,
                    game.HttpService:JSONDecode(readfile(file)).Velocity.Y,
                    game.HttpService:JSONDecode(readfile(file)).Velocity.Z
                )
            end
        end
    end
end)

buttons[4].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop

    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")
    local phum = t:FindFirstChild("Humanoid")

    local responsiveness = game.HttpService:JSONDecode(readfile(file)).Responsiveness
    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t
    and phrp.ReceiveAge == 0 do
        phrp.CFrame = phrp.CFrame:Lerp(cam.CFrame * CFrame.new(0,0,-15), responsiveness)
        phrp.Velocity = Vector3.new(0,3,0)
    end
    GlobalDB = false
end)

buttons[5].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop
    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")
    local phum = t:FindFirstChild("Humanoid")

    local duration = game.HttpService:JSONDecode(readfile(file)).Trip

    local start = tick()
    sound(12222046, 7.5)
    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t 
    and tick() - start < duration and phrp.ReceiveAge == 0 do
        phum.PlatformStand = true      
    end
    phum.PlatformStand = false
    GlobalDB = false
end)

buttons[6].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop
    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")

    local phum = t:FindFirstChild("Humanoid")
    hrp.Anchored = true
    cam.CameraSubject = t
    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t
    and phrp.ReceiveAge == 0 do
        if phum.WalkSpeed <= 0 then
            phum.WalkSpeed = 16
        end                
        phum:MoveTo(phrp.Position + hum.MoveDirection*3)        
        phum.Jump = hum.Jump
    end        
    hrp.Anchored = false
    GlobalDB = false
    cam.CameraSubject = hum
    hrp.Anchored = false
end)

buttons[7].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop
    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")
    local phum = t:FindFirstChild("Humanoid")
    local amount = game.HttpService:JSONDecode(readfile(file)).SpinAmount   
    
    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t
    and phrp.ReceiveAge == 0 do
        phrp.CFrame *= CFrame.Angles(0, math.rad(amount), 0)
    end
    GlobalDB = false
end)

buttons[8].MouseButton1Click:Connect(function()
    if GlobalDB then return end    
    local t = GetTarget()
    if t then
        local phrp = t:FindFirstChild("HumanoidRootPart")
        if phrp then
            if game.HttpService:JSONDecode(readfile(file)).CFrame.Relative then
                phrp.CFrame *= CFrame.new(
                    game.HttpService:JSONDecode(readfile(file)).CFrame.X,
                    game.HttpService:JSONDecode(readfile(file)).CFrame.Y,
                    game.HttpService:JSONDecode(readfile(file)).CFrame.Z
                )
            else
                phrp.CFrame = CFrame.new(
                    game.HttpService:JSONDecode(readfile(file)).CFrame.X,
                    game.HttpService:JSONDecode(readfile(file)).CFrame.Y,
                    game.HttpService:JSONDecode(readfile(file)).CFrame.Z
                )
            end
        end
    end
end)

buttons[9].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop
    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")
    local phum = t:FindFirstChild("Humanoid")
    local oldpos = phrp and phrp.CFrame
    local speed = game.HttpService:JSONDecode(readfile(file)).DanceSpeed

    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t
    and phrp.ReceiveAge == 0 do
        phrp.CFrame = oldpos * CFrame.Angles(math.cos(tick()*2) / 2, 0, math.sin(tick() * speed) / 3)
        phrp.Velocity = Vector3.new(0,3,0)        
        phum.PlatformStand = true
    end        
    if phum then phum.PlatformStand = false end
    GlobalDB = false
end)

buttons[10].MouseButton1Click:Connect(function()
    if GlobalDB then return end
    GlobalDB = true
    local id = getgenv().Stop
    local t = GetTarget()
    if not t then
        GlobalDB = false
        return
    end
    local phrp = t:FindFirstChild("HumanoidRootPart")
    local phum = t:FindFirstChild("Humanoid")
    local speed = game.HttpService:JSONDecode(readfile(file)).FuckSpeed

    while t and t.Parent and id == getgenv().Stop and phrp and phrp.Parent
    and phum and phum.Parent and phum.Health > 0 and wait() 
    and GlobalDB and getgenv().Selection and getgenv().Selection.Adornee == t
    and phrp.ReceiveAge == 0 do
        phrp.CFrame = hrp.CFrame 
        * CFrame.new(0,-1.2,-(1.5 + math.abs(math.sin(tick()*speed))))
        * CFrame.Angles(math.rad(-90),0,0)

        phrp.Velocity = Vector3.new(0,3,0)
        phum.PlatformStand = true
    end
    phum.PlatformStand = false
    GlobalDB = falze
end)
