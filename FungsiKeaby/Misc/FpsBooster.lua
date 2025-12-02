-- ==============================================================
--                ⭐ FPS BOOSTER MODULE ⭐
-- ==============================================================

local FPSBooster = {}

local originalStates = {
    materials = {},
    lighting = {},
    effects = {},
}

function FPSBooster.Enable()
    local Lighting = game:GetService("Lighting")

    -----------------------------------------
    -- 1. Matikan semua textures & materials
    -----------------------------------------
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            -- simpan material asli
            originalStates.materials[obj] = obj.Material
            obj.Material = Enum.Material.SmoothPlastic
            obj.Reflectance = 0
        end
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end

    -----------------------------------------
    -- 2. Optimasi Lighting
    -----------------------------------------
    originalStates.lighting.GlobalShadows = Lighting.GlobalShadows
    originalStates.lighting.FogEnd = Lighting.FogEnd

    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 1000000

    -----------------------------------------
    -- 3. Matikan post-processing effects
    -----------------------------------------
    for _, effect in ipairs(Lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or
           effect:IsA("ColorCorrectionEffect") or
           effect:IsA("DepthOfFieldEffect") or
           effect:IsA("SunRaysEffect") then

            originalStates.effects[effect] = effect.Enabled
            effect.Enabled = false
        end
    end

    -----------------------------------------
    -- 4. Turunkan render quality client
    -----------------------------------------
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end


function FPSBooster.Disable()
    local Lighting = game:GetService("Lighting")

    -----------------------------------------
    -- 1. Kembalikan Materials
    -----------------------------------------
    for part, mat in pairs(originalStates.materials) do
        if part and part.Parent then
            part.Material = mat
        end
    end

    -----------------------------------------
    -- 2. Kembalikan Lighting
    -----------------------------------------
    if originalStates.lighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = originalStates.lighting.GlobalShadows
    end

    -----------------------------------------
    -- 3. Restore post processing
    -----------------------------------------
    for effect, state in pairs(originalStates.effects) do
        if effect then
            effect.Enabled = state
        end
    end

    -----------------------------------------
    -- 4. Kembalikan render quality Auto
    -----------------------------------------
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
end


return FPSBooster
