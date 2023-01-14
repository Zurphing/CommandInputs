LUAGUI_NAME = "Command Inputs"
LUAGUI_AUTH = "Zurphing"
LUAGUI_DESC = "Turns nearly every combo modifier into command inputs, using L3/L2/R2/Left Stick"

Timer = 50
Timer2 = 50
local Down = false
local Up = false
local Right = false
local Left = false
local DownRight = false
local R2 = false
local L2 = false
local L3 = false
local Spin = false
local FlashStep = false
local SlideDash = false
local FinishingLeap = false
local HoriSlash = false
local AoE = false
local SingleTarget = false
local Slapshot = false
--local Btl0pointer = 0x02AE3558-0x56454E
local PtyaPointer = 0x02AE2EB8-0x56454E
local Btl0 = 0x00
function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
        ConsolePrint('PC version detected. Running script.')
		--Btl0 = 0x2A74880-0x56454E --Btlbin
    end
end

function _OnFrame()
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
		print("Right activated!")
		--ConsolePrint("DEBUG: Right direction")
	end
	if ReadInput & 2 == 2 and L3 == false then
		L3 = true
		print("L3 activated!")
	end
	if ReadStick == 128 and Right == false then
		Right = true
		print("Down activated!")
		--ConsolePrint("DEBUG: Down direction")
	end
	if ReadStick == 160 and DownRight == false then
		DownRight = true
		print("Diagonal input activated!")
	end
	if Up == true and Down == true and Left == true and Right == true and Spin ~= true then
		Spin = true
		print("Spin attack queued up!")
		WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
		WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x390, 170, true)
	end
	
	--Below: Giant block of conditions. This is just to ensure our command input deactivates properly, and sets the attacks back to their normal state. Can probably be optimized.
		if ReadByte(Btl0+0x389) == 3 and Slapshot == true or Slapshot == true and ReadByte(Btl0+0x390) == 170 or SingleTarget == true and ReadByte(Btl0+0x390) == 165 or AoE == true and ReadByte(Btl0+0x12C) == 197 or HoriSlash == true and ReadByte(Btl0+0x12C) == 193 or FinishingLeap == true and ReadByte(Btl0+0x390) == 167 or SlideDash == true and ReadByte(Btl0+0x164) == 192 or FlashStep == true and ReadByte(Btl0+0x164) == 196 or Spin == true and ReadByte(Btl0+0x390) == 170 then --ReadByte(Btl0+0x389) == 170 then --If Vicinity Command Input is entered.
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
			L2 = false
			R2 = false
			L3 = false
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
			AoE = false
			SingleTarget = false
			Slapshot = false
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
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end	
	
	--Flash Step Stuff
	if L2 == true and Up == true and FlashStep ~= true then --Flash Step Conditions Met
		FlashStep = true
		print("Flash Step ready!")
		WriteByte(Btl0+0x390, 169, true)
		WriteByte(Btl0+0x389, 3, true)
		WriteByte(Btl0+0x3C8, 0, true)
		--Aerial stuff: Input is shared wtih Aerial Dive
		WriteByte(Btl0+0x12C, 196, true) --Aerial Sweep animation
		WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
		WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
		WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
		ConsolePrint("Flash Step Activated!")
	end

	if FlashStep == true and ReadInput & 16384 == 16384 then
		print("Flash Step used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
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
	if L2 == true and Down == true and SlideDash ~= true then --Flash Step Conditions Met
		SlideDash = true
		print("Slide Dash ready!")
		WriteByte(Btl0+0x390, 164, true)
		WriteByte(Btl0+0x389, 3, true)
		WriteByte(Btl0+0x3C8, 0, true)
		--Aerial stuff: Input is shared wtih Aerial Dive
		WriteByte(Btl0+0x12C, 192, true) --Aerial Sweep animation
		WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
		WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
		WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
		ConsolePrint("Slide Dash Activated!")
	end

	if SlideDash == true and ReadInput & 16384 == 16384 then
		print("Slide Dash used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		--Aerial stuff: Input is shared with Aerial Spiral
		WriteByte(Btl0+0x12C, 1, true) 	 
		WriteByte(Btl0+0x125, 97, true) 
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10)
	end


	if L2 == true and Down == true and DownRight == true and Right == true and FinishingLeap ~= true then --Flash Step Conditions Met
		FinishingLeap = true
		print("Finishing Leap ready!")
		WriteByte(Btl0+0x390, 167, true)
		WriteByte(Btl0+0x389, 3, true)
		WriteByte(Btl0+0x3C8, 0, true)
		WriteByte(Btl0+0x34C, 167, true)
		ConsolePrint("Finishing Leap Activated!")
	end

	if FinishingLeap == true and ReadInput & 16384 == 16384 then
		print("Finishing Leap used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
		WriteByte(Btl0+0x34C, 155, true)
	end



--AERIALS:
	if L2 == true and Right == true and HoriSlash ~= true or L2 == true and Left == true and HoriSlash ~= true then --Flash Step Conditions Met
		HoriSlash = true
		print("HoriSlash ready!")
		WriteByte(Btl0+0x12C, 193, true) --Aerial Sweep animation
		WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
		WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
		WriteByte(Btl0+0x128, 1, true) --Aerial Sweep Flags (Will not activate without this)
		ConsolePrint("Hori Slash Activated!")
	end

	if HoriSlash == true and ReadInput & 16384 == 16384 then
		print("Hori Slash used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
		WriteByte(Btl0+0x12C, 1, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x125, 97, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x164, 191, true)
		WriteByte(Btl0+0x128, 10, true)
	end


--AoE Finishers: Magnet Burst & Explosion
	if Down == true and R2 == true and AoE ~= true then
		AoE = true
		print("AoE Finisher queued up!")
		WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
		WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x390, 166, true)
		WriteByte(Btl0+0x34C, 166, true) --Finisher Single entry. Change this to allow inputting Explosion after Flash Step.
		WriteByte(Btl0+0x38C, 4, true)
		WriteByte(Btl0+0x38B, 4, true) --Vicinity Break: Combo Offset. Should allow comboing Guard Break into Explosion.
		WriteByte(Btl0+0x12C, 197, true) --Aerial Sweep animation
		WriteByte(Btl0+0x125, 3, true) --Aerial Sweep type
		WriteByte(Btl0+0x164, 0, true) --Aerial Sweep ability
		WriteByte(Btl0+0x128, 5, true) --Aerial Sweep Flags (Will not activate without this)
		WriteByte(Btl0+0x127, 4, true) --Aerial Sweep: Combo Offset. Will allow aerials to be inputted immediately.
	end
	if AoE == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("AoE Finisher used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
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
	if SingleTarget == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Single Target Finisher used up!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
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
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
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

	if L3 == true and Slapshot ~= true then
		Slapshot = true
		print("Slapshot queued up!")
		WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
		WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x390, 162, true)
	end


	if Slapshot == true and ReadInput & 16384 == 16384 then
		--ConsolePrint("DEBUG: Spin Attack Activated!")
		print("Slapshot activated!")
		Up = false
		Down = false
		Left = false
		Right = false
		DownRight = false
		L2 = false
		R2 = false
		L3 = false
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		Slapshot = false
		WriteByte(Btl0+0x389, 2, true) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x3C8, 180, true) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x390, 170, true)
	end
end