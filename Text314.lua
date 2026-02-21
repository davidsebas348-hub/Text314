local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local SHOOT_INTERVAL = 0.1
local MAX_DISTANCE = 1000 -- distancia máxima opcional, ajusta si quieres

-- Función principal para disparar
local function autoShoot(character)
    while character and character.Parent do
        local gun = character:FindFirstChild("Gun")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if gun and hrp then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local targetHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                    local knife = plr.Character:FindFirstChild("Knife") 
                                  or plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild("Knife")
                    if knife and targetHRP then
                        -- opcional: solo disparar si está dentro de MAX_DISTANCE studs
                        if (targetHRP.Position - hrp.Position).Magnitude <= MAX_DISTANCE then
                            local args = {
                                CFrame.new(hrp.Position, targetHRP.Position),
                                CFrame.new(targetHRP.Position)
                            }
                            gun.Shoot:FireServer(unpack(args))
                        end
                    end
                end
            end
        end
        wait(SHOOT_INTERVAL)
    end
end

-- Ejecutar al inicio
spawn(function()
    autoShoot(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())
end)

-- Reconectar cada vez que reaparezca
LocalPlayer.CharacterAdded:Connect(function(char)
    spawn(function()
        autoShoot(char)
    end)
end)
