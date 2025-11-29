-- SavedLocation.lua
-- Sistem Save / Teleport / Reset Lokasi

local SavedLocation = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Lokasi tersimpan (Vector3 atau nil)
SavedLocation.Current = nil

----------------------------------------------------
-- 🔵 Save lokasi saat ini
----------------------------------------------------
function SavedLocation.Save()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    SavedLocation.Current = root.Position

    print("💾 Lokasi berhasil disimpan:", SavedLocation.Current)
    return true
end

----------------------------------------------------
-- 🔵 Teleport ke lokasi tersimpan
----------------------------------------------------
function SavedLocation.Teleport()
    if not SavedLocation.Current then
        warn("⚠️ Tidak ada lokasi tersimpan!")
        return false
    end

    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")

    root.CFrame = CFrame.new(SavedLocation.Current)
    print("📍 Teleported ke lokasi tersimpan:", SavedLocation.Current)

    return true
end

----------------------------------------------------
-- 🔵 Reset lokasi tersimpan
----------------------------------------------------
function SavedLocation.Reset()
    SavedLocation.Current = nil
    print("🗑️ Lokasi yang tersimpan sudah dihapus.")
end

return SavedLocation
