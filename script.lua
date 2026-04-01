-- SERVICIOS BÁSICOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURACIÓN GLOBAL
_G.AimbotActive = true
_G.MaxDistance = 800

-- FUNCIÓN PARA BUSCAR AL ENEMIGO (Lógica del video: Menos Vida)
local function GetTarget()
    local target = nil
    local lowestHealth = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local h = v.Character.Humanoid
            local hrt = v.Character:FindFirstChild("HumanoidRootPart")

            if hrt and h.Health > 0 then
                local dist = (hrt.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < _G.MaxDistance and v.Team ~= LocalPlayer.Team then
                    if h.Health < lowestHealth then
                        lowestHealth = h.Health
                        target = hrt
                    end
                end
            end
        end
    end
    return target
end

-- EJECUCIÓN (Este método es más compatible con ejecutores móviles)
RunService.RenderStepped:Connect(function()
    if _G.AimbotActive then
        local target = GetTarget()
        if target then
            -- En lugar de "engañar" al mouse, movemos la cámara suavemente
            -- hacia el objetivo solo cuando lanzas un ataque.
            local targetPos = Camera:WorldToViewportPoint(target.Position)
            -- Si quieres que sea 100% como el video, esto fija la mirada:
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- INTERFAZ SIMPLE (BOTÓN FLOTANTE)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Button = Instance.new("TextButton", ScreenGui)

Button.Size = UDim2.new(0, 80, 0, 80)
Button.Position = UDim2.new(0.2, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
Button.Text = "AIM: ON"
Button.Draggable = true
Button.Active = true

-- Redondear botón
local Corner = Instance.new("UICorner", Button)
Corner.CornerRadius = UDim.new(1, 0)

-- LÓGICA DE APAGADO REAL
Button.MouseButton1Click:Connect(function()
    _G.AimbotActive = not _G.AimbotActive
    if _G.AimbotActive then
        Button.Text = "AIM: ON"
        Button.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    else
        Button.Text = "AIM: OFF"
        Button.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    end
end)

