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
function _OnInit()
    if GAME_ID == 0x431219CC and ENGINE_TYPE == "BACKEND" then
        ConsolePrint('PC version detected. Running script.')
		Btl0 = 0x2A74880-0x56454E --Btlbin
    end
end

function _OnFrame()
ReadInput = ReadShort(0x1ACF3C)
ReadStick = ReadByte(0x29F89F0-0x56454E) --Stick reads in 10 byte intervals. 
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
		WriteByte(Btl0+0x202A9, 3) --Vicinity Break: Type
		WriteByte(Btl0+0x202E8, 0) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x202B0, 170)
	end
	
	--Below: Giant block of conditions. This is just to ensure our command input deactivates properly, and sets the attacks back to their normal state. Can probably be optimized.
		if ReadByte(Btl0+0x202A9) == 3 and Slapshot == true or Slapshot == true and ReadByte(Btl0+0x202B0) == 170 or SingleTarget == true and ReadByte(Btl0+0x202B0) == 165 or AoE == true and ReadByte(Btl0+0x2004C) == 197 or HoriSlash == true and ReadByte(Btl0+0x2004C) == 193 or FinishingLeap == true and ReadByte(Btl0+0x202B0) == 167 or SlideDash == true and ReadByte(Btl0+0x20084) == 192 or FlashStep == true and ReadByte(Btl0+0x20084) == 196 or Spin == true and ReadByte(Btl0+0x202B0) == 170 then --ReadByte(Btl0+0x202A9) == 170 then --If Vicinity Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Command Input timer ran out!")
			Timer = 50 
			WriteByte(Btl0+0x202A9, 2)
			WriteByte(Btl0+0x202E8, 180)
			WriteByte(Btl0+0x202B0, 170)
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
			WriteByte(Btl0+0x2004C, 1) 	 
			WriteByte(Btl0+0x20045, 97) 
			WriteByte(Btl0+0x20084, 191)
			WriteByte(Btl0+0x20048, 10)
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
	end	
	
	--Flash Step Stuff
	if L2 == true and Up == true and FlashStep ~= true then --Flash Step Conditions Met
		FlashStep = true
		print("Flash Step ready!")
		WriteByte(Btl0+0x202B0, 169)
		WriteByte(Btl0+0x202A9, 3)
		WriteByte(Btl0+0x202E8, 0)
		--Aerial stuff: Input is shared wtih Aerial Dive
		WriteByte(Btl0+0x2004C, 196) --Aerial Sweep animation
		WriteByte(Btl0+0x20045, 3) --Aerial Sweep type
		WriteByte(Btl0+0x20084, 0) --Aerial Sweep ability
		WriteByte(Btl0+0x20048, 1) --Aerial Sweep Flags (Will not activate without this)
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		--Aerial stuff: Input is shared with Aerial Dive
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)

	end


	--Slide Dash Stuff
	if L2 == true and Down == true and SlideDash ~= true then --Flash Step Conditions Met
		SlideDash = true
		print("Slide Dash ready!")
		WriteByte(Btl0+0x202B0, 164)
		WriteByte(Btl0+0x202A9, 3)
		WriteByte(Btl0+0x202E8, 0)
		--Aerial stuff: Input is shared wtih Aerial Dive
		WriteByte(Btl0+0x2004C, 192) --Aerial Sweep animation
		WriteByte(Btl0+0x20045, 3) --Aerial Sweep type
		WriteByte(Btl0+0x20084, 0) --Aerial Sweep ability
		WriteByte(Btl0+0x20048, 1) --Aerial Sweep Flags (Will not activate without this)
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		--Aerial stuff: Input is shared with Aerial Spiral
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
	end


	if L2 == true and Down == true and DownRight == true and Right == true and FinishingLeap ~= true then --Flash Step Conditions Met
		FinishingLeap = true
		print("Finishing Leap ready!")
		WriteByte(Btl0+0x202B0, 167)
		WriteByte(Btl0+0x202A9, 3)
		WriteByte(Btl0+0x202E8, 0)
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
	end



--AERIALS:
	if L2 == true and Right == true and HoriSlash ~= true or L2 == true and Left == true and HoriSlash ~= true then --Flash Step Conditions Met
		HoriSlash = true
		print("HoriSlash ready!")
		WriteByte(Btl0+0x2004C, 193) --Aerial Sweep animation
		WriteByte(Btl0+0x20045, 3) --Aerial Sweep type
		WriteByte(Btl0+0x20084, 0) --Aerial Sweep ability
		WriteByte(Btl0+0x20048, 1) --Aerial Sweep Flags (Will not activate without this)
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
		WriteByte(Btl0+0x2004C, 1) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x20045, 97) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
	end


--AoE Finishers: Magnet Burst & Explosion
	if Down == true and R2 == true and AoE ~= true then
		AoE = true
		print("AoE Finisher queued up!")
		WriteByte(Btl0+0x202A9, 3) --Vicinity Break: Type
		WriteByte(Btl0+0x202E8, 0) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x202B0, 166)
		WriteByte(Btl0+0x2026C, 166) --Finisher Single entry. Change this to allow inputting Explosion after Flash Step.
		WriteByte(Btl0+0x202AC, 4)
		WriteByte(Btl0+0x202AB, 4) --Vicinity Break: Combo Offset. Should allow comboing Guard Break into Explosion.
		WriteByte(Btl0+0x2004C, 197) --Aerial Sweep animation
		WriteByte(Btl0+0x20045, 3) --Aerial Sweep type
		WriteByte(Btl0+0x20084, 0) --Aerial Sweep ability
		WriteByte(Btl0+0x20048, 5) --Aerial Sweep Flags (Will not activate without this)
		WriteByte(Btl0+0x20047, 4) --Aerial Sweep: Combo Offset. Will allow aerials to be inputted immediately.
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		WriteByte(Btl0+0x2026C, 155)
		--Aerial stuff: Input shared w/ Magnet Splash
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
		WriteByte(Btl0+0x20047, 0) --Return Combo Offset to Normal. Allows you to immediately start your combo with a magnet burst/aerial finish.

	end

--Single Target Finishers: Guard Break & Aerial Finish
	if R2 == true and Up == true and SingleTarget ~= true then
		SingleTarget = true
		print("Single Target Finisher queued up!")
		WriteByte(Btl0+0x202A9, 3) --Vicinity Break: Type
		WriteByte(Btl0+0x202E8, 0) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x202B0, 165)
		WriteByte(Btl0+0x202AC, 4) --Vicinity Break: Flags. Should allow comboing Guard Break into Explosion.
		WriteByte(Btl0+0x202AB, 4) --Vicinity Break: Combo Offset. Should allow comboing Guard Break into Explosion.
		WriteByte(Btl0+0x2026C, 165) --Finisher Single entry. Allows you to input commands to instantly go to guard break from Flash step/Sliding Dash.
		--WriteByte(Btl0+0x2004C, 194) --Aerial Sweep animation		Aerial Finish. Commented out for now.
		--WriteByte(Btl0+0x20045, 3) --Aerial Sweep type		
		--WriteByte(Btl0+0x20084, 0) --Aerial Sweep ability
		--WriteByte(Btl0+0x20048, 5) --Aerial Sweep Flags (Will not activate without this)
		--WriteByte(Btl0+0x20047, 4) --Aerial Sweep: Combo Offset. Will allow aerial finishes to be inputted immediately.
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		WriteByte(Btl0+0x2026C, 155) --Finisher Single entry. Allows you to input commands to instantly go to guard break from Flash step/Sliding Dash.
		--Aerial stuff: Input is shared with Aerial Finish
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
		WriteByte(Btl0+0x20047, 0)
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
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
		WriteByte(Btl0+0x20047, 0)
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		WriteByte(Btl0+0x2026C, 155)
		end
	end

	if L3 == true and Slapshot ~= true then
		Slapshot = true
		print("Slapshot queued up!")
		WriteByte(Btl0+0x202A9, 3) --Vicinity Break: Type
		WriteByte(Btl0+0x202E8, 0) --Vicinity Break: Ability Required
		WriteByte(Btl0+0x202B0, 162)
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
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
	end
end