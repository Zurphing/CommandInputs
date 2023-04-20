LUAGUI_NAME = "Command Inputs"
LUAGUI_AUTH = "Zurphing"
LUAGUI_DESC = "Turns nearly every combo modifier into command inputs, using L3/L2/R2/Left Stick"

--Script recently adjusted to separate Explosion/Magnet Burst & Flash Step/Slide Dash from Aerial Dive/Aerial Spiral
--Now there is a "free-use" ability you start the game with.

Timer = 50
Timer2 = 50
local canExecute = false
local CanUseInput = false
local FStepOn = false
local SlapOn = false
local GBreakOn = false
local ExplOn = false
local FLeapOn = false
local VicOn = false		--Vicinity Break
local HoriOn = false
local MBurst = false
local ADiveOn = false
local SlideOn = false
local ASpiralOn = false
local Ability = 0x4450A6
local Down = false
local Up = false
local Right = false
local Left = false
local DownRight = false
local DownLeft = false
local Down2 = false
local R2 = false
local L2 = false
local L3 = false
local Spin = false
local FlashStep = false
local SlideDash = false
local FlashStep1 = false --Aerial Dive
local SlideDash1 = false --Aerial Spiral
local FinishingLeap = false
local HoriSlash = false
local AoE = false
local SingleTarget = false
local AoE1 = false --Magnet Burst. 
local SingleTarget1 = false  --Aerial Finish
local Slapshot = false
local Pretzel = true
--local Btl0pointer = 0x02AE3558-0x56454E
local PtyaPointer = 0x02AE2EB8-0x56454E
local Btl0 = 0x00
function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
        ConsolePrint('PC version detected. Running script.')
		canExecute = true
		--Btl0 = 0x2A74880-0x56454E --Btlbin
    end
end

function _OnFrame()
Btl0Plrp = ReadLong(0x02A22AD0-0x56454E), true
SysBinItem = ReadLong(0x02A22A70-0x56454E), true
if ReadShort(Btl0Plrp+0x4E, true) ~= 0x00D8 then	--Gives Override ability in Sora Slot 42. This is Brave Shot.
	WriteShort(Btl0Plrp+0x4E, 0x00D8, true)
	ConsolePrint("DEBUG: Given Override Ability!")
end
if ReadByte(SysBinItem+0x1227, true) ~= 0x01 then
	WriteByte(SysBinItem+0x1227, 0x01, true)
	ConsolePrint("DEBUG: Set Override Ability AP to 1!")
end

--Framework for toggling inputs based on current ability.
--Iterate through the ability list in the save file, and if the ability is detected, turn on the specific input.
if canExecute == true then
	for i = 0, 80, 1 do
	local AbilityLocation = ReadShort(Ability + 0x02*i)
		--if AbilityLocation == 0x8107 and CanUseInput ~= true then
		--	CanUseInput = true
		--	ConsolePrint("Test ON(Dodge Slash)")
		--	i = 51
		--elseif AbilityLocation == 0x0107 and CanUseInput ~= false then
		--	CanUseInput = false
		--	ConsolePrint("Test OFF(DodgeSlash)")
		--end
		if AbilityLocation == 0x80D8 and Override ~= true then
			Override = true
			ConsolePrint("Override enabled.")
			i = 51
		elseif AbilityLocation == 0x00D8 and Override ~= false then --Uses Brave Shot, ID 0x0D8
			Override = false
			ConsolePrint("Override disabled.")
		end
		if AbilityLocation == 0x022F and FStepOn ~= false then
			FStepOn = false
			ConsolePrint("Test OFF (FStep)")
		elseif AbilityLocation == 0x822F and FStepOn ~= true then
			FStepOn = true
			ConsolePrint("Test ON (FStep)")
			i = 51
		end
		if AbilityLocation == 0x0106 and SlapOn ~= false then
			SlapOn = false
			ConsolePrint("Test OFF (Slapshot)")
		elseif AbilityLocation == 0x8106 and SlapOn ~= true then
			SlapOn = true
			ConsolePrint("Test ON (Slapshot)")
			i = 51
		end
		if AbilityLocation == 0x010F and HoriOn ~= false then
			HoriOn = false
			ConsolePrint("Test OFF (HoriSlash)")
		elseif AbilityLocation == 0x810F and HoriOn ~= true then
			HoriOn = true
			ConsolePrint("Test ON (HoriSlash)")
			i = 51
		end
		if AbilityLocation == 0x010B and FLeapOn ~= false then
			FLeapOn = false
			ConsolePrint("Test OFF (FLeap)")
		elseif AbilityLocation == 0x810B and FLeapOn ~= true then
			FLeapOn = true
			ConsolePrint("Test ON (FLeap)")
			i = 51
		end
		if AbilityLocation == 0x0108 and SlideOn ~= false then
			SlideOn = false
			ConsolePrint("Test OFF (SlideDash)")
		elseif AbilityLocation == 0x8108 and SlideOn ~= true then
			SlideOn = true
			ConsolePrint("Test ON (SlideDash)")
			i = 51
		end
		if AbilityLocation == 0x0232 and VicOn ~= false then
			VicOn = false
			ConsolePrint("Test OFF (VicinityBreak)")
		elseif AbilityLocation == 0x8232 and VicOn ~= true then
			VicOn = true
			ConsolePrint("Test ON (VicinityBreak)")
			i = 51
		end
		if AbilityLocation == 0x0109 and GBreakOn ~= false then
			GBreakOn = false
			ConsolePrint("Test OFF (GuardBreak)")
		elseif AbilityLocation == 0x8109 and GBreakOn ~= true then
			GBreakOn = true
			ConsolePrint("Test ON (GuardBreak)")
			i = 51
		end
		if AbilityLocation == 0x010A and ExplOn ~= false then
			ExplOn = false
			ConsolePrint("Test OFF (Explosion)")
		elseif AbilityLocation == 0x810A and ExplOn ~= true then
			ExplOn = true
			ConsolePrint("Test ON (Explosion)")
			i = 51
		end
		if AbilityLocation == 0x0230 and ADiveOn ~= false then
			ADiveOn = false
			ConsolePrint("Test OFF (Aerial Dive)")
		elseif AbilityLocation == 0x8230 and ADiveOn ~= true then
			ADiveOn = true
			ConsolePrint("Test ON (AerialDive)")
			i = 51
		end
		if AbilityLocation == 0x0231 and MBurstOn ~= false then
			MBurstOn = false
			ConsolePrint("Test OFF (Magnet Burst)")
		elseif AbilityLocation == 0x8231 and MBurstOn ~= true then
			MBurstOn = true
			ConsolePrint("Test ON (Magnet Burst)")
			i = 51
		end
		if AbilityLocation == 0x010E and ASpiralOn ~= false then
			ASpiralOn = false
			ConsolePrint("Test OFF (Air Spiral)")
		elseif AbilityLocation == 0x810E and ASpiralOn ~= true then
			ASpiralOn = true
			ConsolePrint("Test ON (AirSpiral)")
			i = 51
		end
	end
end

--invincibility = 0x3D3966-0x56454E
--72 = on, 74 = off
if Btl0 == 0 then
	Btl0 = ReadLong(PtyaPointer)
end
ReadInput = ReadShort(0x1ACF3C)
ReadStick = ReadInt(0x29F89F0-0x56454E) --Stick reads in 10 byte intervals. 
--Counterclockwise: 16 -> 64 -> 32 -> 128.
	if ReadInput & 512 == 512 and R2 == false then
		R2 = true
		print("R2 activated!")
	end
	if ReadInput & 256 == 256 and L2 == false then
		L2 = true
		print("L2 activated!")
	end
	if ReadStick == 16 and Up == false then
		Up = true
		print("Up activated!")
		--ConsolePrint("DEBUG: Up direction")
	end
	if ReadStick == 64 and Left == false then
		Left = true
		print("Left activated!")
		--ConsolePrint("DEBUG: Left direction")
	end
	if ReadStick == 32 and Down == false then
		Down = true
		print("Down activated!")
		--ConsolePrint("DEBUG: Right direction")
	end
	if ReadInput & 2 == 2 and L3 == false then
		L3 = true
		print("L3 activated!")
	end
	if ReadStick == 128 and Right == false then
		Right = true
		print("Right activated!")
		--ConsolePrint("DEBUG: Down direction")
	end
	if ReadStick == 160 and DownRight == false then
		DownRight = true
		print("Diagonal input activated!")
	end
	if ReadStick == 96 and DownLeft == false then
		DownLeft = true
		print("Diagonal input (L) activated!")
	end
	
	if Down == true and Left == true and ReadStick == 32 and Down2 == false then --or Down == true and Right == true and ReadStick == 32 and Down2 == false then
		Down2 = true
		print("Down-2 activated")
	end
	if Down == true and Left == true and Down2 == true and Right == true then --or Down == true and Right == true and Down2 == true and 
		--ConsolePrint("Complex input detected!")
		Pretzel = true
	end

	if VicOn == true or Override == true then
		if Up == true and Down == true and Left == true and Right == true and Spin ~= true then
			Spin = true
			print("Spin attack queued up!")
			WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
			WriteByte(Btl0+0x390, 170, true)
		end
	end
		
	if Pretzel == true and CanUseInput == true then
		WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
		WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x390, 163, true)
	end
		
	
	--Below: Giant block of conditions. This is just to ensure our command input deactivates properly, and sets the attacks back to their normal state. Can probably be optimized.
		if ReadByte(Btl0+0x389) == 3 and Slapshot == true or Slapshot == true and ReadByte(Btl0+0x390) == 170 or SingleTarget == true and ReadByte(Btl0+0x390) == 165 or AoE == true and ReadByte(Btl0+0x12C) == 197 or HoriSlash == true and ReadByte(Btl0+0x12C) == 193 or FinishingLeap == true and ReadByte(Btl0+0x390) == 167 or SlideDash == true and ReadByte(Btl0+0x164) == 192 or FlashStep == true and ReadByte(Btl0+0x164) == 196 or Spin == true and ReadByte(Btl0+0x390) == 170 or Pretzel == true and ReadByte(Btl0+0x390) == 163 then --ReadByte(Btl0+0x389) == 170 then --If Vicinity Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Command Input timer ran out!")
			Timer = 50 
			WriteByte(Btl0+0x389, 2, true)
			WriteByte(Btl0+0x3C8, 180, true)
			WriteByte(Btl0+0x390, 170, true)
			WriteByte(Btl0+0x34C, 155, true)
			Up = false
			Down = false
			Left = false
			Right = false
			DownRight = false
			DownLeft = false
			Down2 = false
			L2 = false
			R2 = false
			L3 = false
			Spin = false
			FlashStep = false
			SlideDash = false
			FlashStep1 = false --Aerial Dive
			SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
			FinishingLeap = false
			HoriSlash = false
			AoE = false
			SingleTarget = false
			AoE1 = false		--Magnet Burst. Too lazy to rename variables.
			SingleTarget1 = false
			Slapshot = false
			Pretzel = false
			WriteByte(Btl0+0x12C, 1, true) 	 
			WriteByte(Btl0+0x125, 97, true) 
			WriteByte(Btl0+0x164, 191, true)
			WriteByte(Btl0+0x128, 10, true)
		end
	end

	if Spin == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Spin attack used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end	
	
	--Flash Step Stuff
	if FStepOn == true or Override == true then
		if L2 == true and Up == true and FlashStep ~= true then --Flash Step Conditions Met
			FlashStep = true
			print("Flash Step ready!")
			WriteByte(Btl0+0x390, 169, true)
			WriteByte(Btl0+0x389, 3, true)
			WriteByte(Btl0+0x3C8, 0, true)
			ConsolePrint("Flash Step Activated!")
		end
	end

	if FlashStep == true and ReadInput & 16384 == 16384 then
		print("Flash Step used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		--Aerial stuff: Input is shared with Aerial Dive
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)

	end


	--Slide Dash Stuff
	if SlideOn == true or Override == true then
		if L2 == true and Down == true and SlideDash ~= true then --Flash Step Conditions Met
			SlideDash = true
			print("Slide Dash ready!")
			WriteByte(Btl0+0x390, 164, true)
			WriteByte(Btl0+0x389, 3, true)
			WriteByte(Btl0+0x3C8, 0, true)
			ConsolePrint("Slide Dash Activated!")
		end
	end

	if SlideDash == true and ReadInput & 16384 == 16384 then
		print("Slide Dash used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end

	--Flash Step Stuff
	if ADiveOn == true or Override == true then
		if L2 == true and Up == true and FlashStep1 ~= true then --Flash Step Conditions Met
			FlashStep1 = true
			print("Flash Step ready!")
			--Aerial stuff: Input is shared wtih Aerial Dive
			WriteByte(Btl0+0x12C, 196, true) --Aerial Sweep animation
			WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
			WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
			WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
			ConsolePrint("Flash Step Activated!")
		end
	end

	if FlashStep1 == true and ReadInput & 16384 == 16384 then
		print("Flash Step used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		--Aerial stuff: Input is shared with Aerial Dive
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)

	end


	--Slide Dash Stuff
	if ASpiralOn == true or Override == true then
		if L2 == true and Down == true and SlideDash1 ~= true then --Flash Step Conditions Met
			SlideDash1 = true
			print("Aerial Spiral ready!")
			--Aerial stuff: Input is shared wtih Aerial Dive
			WriteByte(Btl0+0x12C, 192, true) --Aerial Sweep animation
			WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
			WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
			WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
			ConsolePrint("Aerial Spiral ready!")
		end
	end

	if SlideDash1 == true and ReadInput & 16384 == 16384 then
		print("Aerial Spiral used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		--Aerial stuff: Input is shared with Aerial Spiral
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10)
	end

	if FLeapOn == true or Override == true then
		if L2 == true and Down == true and DownRight == true and Right == true and FinishingLeap ~= true then --Flash Step Conditions Met
			FinishingLeap = true
			print("Finishing Leap ready!")
			WriteByte(Btl0+0x390, 167, true)
			WriteByte(Btl0+0x389, 3, true)
			WriteByte(Btl0+0x3C8, 0, true)
			WriteByte(Btl0+0x34C, 167, true)
			ConsolePrint("Finishing Leap Activated!")
		end
	end

	if FinishingLeap == true and ReadInput & 16384 == 16384 then
		print("Finishing Leap used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true)
	end



--AERIALS:
	if HoriOn == true or Override == true then
		if L2 == true and Right == true and HoriSlash ~= true or L2 == true and Left == true and HoriSlash ~= true then --Flash Step Conditions Met
			HoriSlash = true
			print("HoriSlash ready!")
			WriteByte(Btl0+0x12C, 193, true) --Aerial Sweep animation
			WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
			WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
			WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
			ConsolePrint("Hori Slash Activated!")
		end
	end
	
	if HoriSlash == true and ReadInput & 16384 == 16384 then
		print("Hori Slash used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x12C, 1, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x125, 97, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
	end


--AoE Finishers: Magnet Burst & Explosion
	if ExplOn == true or Override == true then
		if Down == true and R2 == true and AoE ~= true then
			AoE = true
			print("AoE Finisher queued up!")
			WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
			WriteByte(Btl0+0x390, 166, true)
			WriteByte(Btl0+0x34C, 166, true) --Finisher Single entry. Change this to allow inputting Explosion after Flash Step.
			WriteByte(Btl0+0x38C, 4, true)
			WriteByte(Btl0+0x38B, 4, true) --Vicinity Break: Combo Offset. Should allow comboing Guard Break into Explosion.
		end
	end
	if AoE == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("AoE Finisher used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true)
		--Aerial stuff: Input shared w/ Magnet Splash
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
		WriteByte(Btl0+0x127, 0, true) --Return Combo Offset to Normal. Allows you to immediately start your combo with a magnet burst/aerial finish.

	end
	
	if MBurstOn == true or Override == true then
		if Down == true and R2 == true and AoE1 ~= true then
			AoE1 = true
			print("AoE Finisher queued up!")
			WriteByte(Btl0+0x12C, 197, true) --Aerial Sweep animation
			WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
			WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
			WriteByte(Btl0+0x128, 5, true) --Aerial Sweep Flags (Will not activate without this)
			WriteByte(Btl0+0x127, 4, true) --Aerial Sweep: Combo Offset. Will allow aerials to be inputted immediately.
		end
	end
	if AoE1 == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("AoE Finisher used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true)
		--Aerial stuff: Input shared w/ Magnet Splash
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
		WriteByte(Btl0+0x127, 0, true) --Return Combo Offset to Normal. Allows you to immediately start your combo with a magnet burst/aerial finish.

	end

--Single Target Finishers: Guard Break & Aerial Finish
	if GBreakOn == true or Override == true then
		if R2 == true and Up == true and SingleTarget ~= true then
			SingleTarget = true
			print("Single Target Finisher queued up!")
			WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
			WriteByte(Btl0+0x390, 165, true)
			WriteByte(Btl0+0x38C, 4, true) --Vicinity Break: Flags. Should allow comboing Guard Break into Explosion.
			WriteByte(Btl0+0x38B, 4, true) --Vicinity Break: Combo Offset. Should allow comboing Guard Break into Explosion.
			WriteByte(Btl0+0x34C, 165, true) --Finisher Single entry. Allows you to input commands to instantly go to guard break from Flash step/Sliding Dash.
			--WriteByte(Btl0+0x12C, 194) --Aerial Sweep animation		Aerial Finish. Commented out for now.
			--WriteByte(Btl0+0x125, 3) --Aerial Sweep type		
			--WriteByte(Btl0+0x164, 0) --Aerial Sweep ability
			--WriteByte(Btl0+0x128, 5) --Aerial Sweep Flags (Will not activate without this)
			--WriteByte(Btl0+0x127, 4) --Aerial Sweep: Combo Offset. Will allow aerial finishes to be inputted immediately.
		end
	end
	if SingleTarget == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Single Target Finisher used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true) --Finisher Single entry. Allows you to input commands to instantly go to guard break from Flash step/Sliding Dash.
		--Aerial stuff: Input is shared with Aerial Finish
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
		WriteByte(Btl0+0x127, 0, true)
	end

--Reset input windows to prevent unwanted commands from coming out. Time is 50 frames, so a little less than a second.
if Up == true or Down == true or Right == true or DownRight == true or Down == true or L2 == true or R2 == true or L3 == true then
	Timer2 = Timer2 - 1
	if Timer2 == 0 then
		print("Inputs not fast enough! Voided!")
		Timer2 = 50 
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
		WriteByte(Btl0+0x127, 0, true)
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true)
		end
	end

	if SlapOn == true or Override == true then
		if L3 == true and Slapshot ~= true then
			Slapshot = true
			print("Slapshot queued up!")
			WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
			WriteByte(Btl0+0x390, 162, true)
		end
	end


	if Slapshot == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Slapshot activated!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end
	if Pretzel == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Slapshot activated!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		DownLeft = false
		Down2 = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral. Too lazy to rename variables.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false		--Magnet Burst. Too lazy to rename variables.
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end
end
