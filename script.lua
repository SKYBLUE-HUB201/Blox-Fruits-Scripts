-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- CONFIGURACIÓN (Inspiración Onion13)
_G.AimbotActive = true
_G.Smoothness = 0.5 -- Cuanto menor sea el número, más rápido seguirá al enemigo
_G.AjusteAltura = -0.8 -- Ajuste específico para que la X de Light no vuele por arriba

-- BUSCADOR DEL MÁS CERCANO (OPTIMIZADO)
local function GetClosestPlayer()
    local target = nil
    local shortestDistance = 1000 

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
            local root = v.Character:FindFirstChild("HumanoidRootPart")
            local hum = v.Character.Humanoid
            
            if root and hum.Health > 0 and v.Team ~= LocalPlayer.Team then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then -- Solo apunta si está en tu rango visual
                    local dist = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        target = root
                    end
                end
            end
        end
    end
    return target
end

-- BUCLE DE MOVIMIENTO SUAVE (TIPO ONION13)
RunService.RenderStepped:Connect(function()
    if _G.AimbotActive then
        local target = GetClosestPlayer()
        if target then
            -- Calculamos el punto de impacto exacto
            local lookAtPos = target.Position + Vector3.new(0, _G.AjusteAltura, 0)
            
            -- INTERPOLACIÓN: Esto crea el efecto de seguimiento rápido y fluido
            local targetCFrame = CFrame.new(Camera.CFrame.Position, lookAtPos)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.Smoothness)
        end
    end
end)

-- INTERFAZ MEJORADA
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Button = Instance.new("TextButton", ScreenGui)

Button.Size = UDim2.new(0, 90, 0, 90)
Button.Position = UDim2.new(0.15, 0, 0.5, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
Button.Text = "SKYBLUE V3: ON"
Button.TextColor3 = Color3.new(1, 1, 1)
Button.Draggable = true
Button.Active = true

local Corner = Instance.new("UICorner", Button)
Corner.CornerRadius = UDim.new(1, 0)

Button.MouseButton1Click:Connect(function()
    _G.AimbotActive = not _G.AimbotActive
    Button.Text = _G.AimbotActive and "SKYBLUE V3: ON" or "SKYBLUE V3: OFF"
    Button.BackgroundColor3 = _G.AimbotActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
end)
