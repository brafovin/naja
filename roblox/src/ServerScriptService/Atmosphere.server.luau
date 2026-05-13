--!strict
-- Atmosphere: setzt Lighting-Werte für eine düstere Horror-Stimmung
local Lighting = game:GetService("Lighting")

Lighting.Ambient = Color3.fromRGB(20, 18, 22)
Lighting.OutdoorAmbient = Color3.fromRGB(10, 10, 15)
Lighting.Brightness = 1
Lighting.ClockTime = 0
Lighting.GeographicLatitude = 0
Lighting.FogEnd = 70
Lighting.FogStart = 10
Lighting.FogColor = Color3.fromRGB(10, 10, 12)
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 0.2
Lighting.EnvironmentSpecularScale = 0.2

-- Vorhandene Effekte aufräumen, dann neu setzen
for _, child in Lighting:GetChildren() do
	if child:IsA("PostEffect") or child:IsA("Atmosphere") or child:IsA("Sky") then
		child:Destroy()
	end
end

local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.4
atmosphere.Offset = 0.25
atmosphere.Color = Color3.fromRGB(180, 170, 170)
atmosphere.Decay = Color3.fromRGB(60, 50, 60)
atmosphere.Glare = 0
atmosphere.Haze = 2
atmosphere.Parent = Lighting

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Saturation = -0.5
colorCorrection.Contrast = 0.15
colorCorrection.TintColor = Color3.fromRGB(220, 210, 210)
colorCorrection.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Intensity = 0.4
bloom.Size = 16
bloom.Threshold = 1.6
bloom.Parent = Lighting

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Name = "AmbientBlur"
blur.Parent = Lighting
