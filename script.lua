-- SERVICIOS BÁSICOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURACIÓN GLOBAL
_G.AimbotActive = true
_G.MaxDistance = 800 

-- FUNCIÓN PARA BUSCAR AL ENEMIGO MÁS CERCANO
local function GetTarget()
    local target = nil
    local shortestDistance = _G.MaxDistance 

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local h = v.Character.Humanoid
            local hrt = v.Character:FindFirstChild("HumanoidRootPart")

            if hrt and h.Health > 0 then
                local dist = (hrt.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                
                -- Verificamos distancia y equipo
                if dist < shortestDistance and v.Team ~= LocalPlayer.Team then
                    shortestDistance = dist
                    target = hrt
                end
            end
        end
    end
    return target
end

-- EJECUCIÓN DEL AIMBOT (AJUSTADO PARA LA X DE LUZ)
RunService.RenderStepped:Connect(function()
    if _G.AimbotActive then
        local target = GetTarget()
        if target then
            -- AJUSTE: Bajamos el punto de mira un poco (Vector3.new(0, -0.5, 0))
            -- Esto evita que ataques como la X de Luz se vayan por arriba.
            local aimPosition = target.Position + Vector3.new(0, -0.5, 0)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPosition)
        end
    end
end)

-- INTERFAZ (BOTÓN FLOTANTE)
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Button = Instance.new("TextButton", ScreenGui)

Button.Size = UDim2.new(0, 80, 0, 80)
Button.Position = UDim2.new(0.2, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
Button.Text = "AIM: ON"
Button.Draggable = true
Button.Active = true

local Corner = Instance.new("UICorner", Button)
Corner.CornerRadius = UDim.new(1, 0)

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

