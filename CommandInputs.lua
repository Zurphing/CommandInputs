LUAGUI_NAME = "Spin Attack"
LUAGUI_AUTH = "Zurphing"
LUAGUI_DESC = "Rotate your control stick or the D-Pad to activate a spin attack. You'll only have one second to activate it before you lose it!"

Timer = 70
Timer2 = 90
local Down = false
local Up = false
local Right = false
local Left = false
local DownRight = false
local R2 = false
local L2 = false
local Spin = false
local FlashStep = false
local SlideDash = false
local FinishingLeap = false
local HoriSlash = false
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
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
	end
	if ReadByte(Btl0+0x202A9) == 3 and Spin == true then --ReadByte(Btl0+0x202A9) == 170 then --If Vicinity Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Spin attack timer ran out!")
			Timer = 70 
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
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
		end
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
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		--Aerial stuff: Input is shared with Aerial Dive
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)

	end


--Swapped from reading byte to check animation to just checking if Command Input == true. Much more stable.
	if ReadByte(Btl0+0x202A9) == 3 and FlashStep == true then --ReadByte(Btl0+0x202A9) == 169 then --If Flash Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Flash Step timer ran out!")
			Timer = 70 
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
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
			--Aerial stuff: Input is shared with Aerial Dive
			WriteByte(Btl0+0x2004C, 1) 	 
			WriteByte(Btl0+0x20045, 97) 
			WriteByte(Btl0+0x20084, 191)
			WriteByte(Btl0+0x20048, 10)

		end
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
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
		--Aerial stuff: Input is shared with Aerial Spiral
		WriteByte(Btl0+0x2004C, 1) 	 
		WriteByte(Btl0+0x20045, 97) 
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
	end


--Swapped from reading byte to check animation to just checking if Command Input == true. Much more stable.
	if ReadByte(Btl0+0x202A9) == 3 and SlideDash == true then --ReadByte(Btl0+0x202A9) == 169 then --If Flash Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Slide Dash timer ran out!")
			Timer = 70 
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
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
			--Aerial stuff: Input is shared with Aerial Spiral
			WriteByte(Btl0+0x2004C, 1) 	 
			WriteByte(Btl0+0x20045, 97) 
			WriteByte(Btl0+0x20084, 191)
			WriteByte(Btl0+0x20048, 10)
		end
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
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		WriteByte(Btl0+0x202A9, 2) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x202E8, 180) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x202B0, 170)
	end


--Swapped from reading byte to check animation to just checking if Command Input == true. Much more stable.
	if ReadByte(Btl0+0x202A9) == 3 and FinishingLeap == true then --ReadByte(Btl0+0x202A9) == 169 then --If Flash Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Finishing Leap timer ran out!")
			Timer = 70 
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
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
		end
	end


--AERIALS:
	if L2 == true and Right == true and Left == true and HoriSlash ~= true then --Flash Step Conditions Met
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
		Spin = false
		FlashStep = false
		SlideDash = false
		FinishingLeap = false
		HoriSlash = false
		WriteByte(Btl0+0x2004C, 1) 	 --Return Vicinity Break to normal.
		WriteByte(Btl0+0x20045, 97) --Return Vicinity Break to requiring an ability.
		WriteByte(Btl0+0x20084, 191)
		WriteByte(Btl0+0x20048, 10)
	end


--Swapped from reading byte to check animation to just checking if Command Input == true. Much more stable.
	if ReadByte(Btl0+0x20045) == 3 and HoriSlash == true then --ReadByte(Btl0+0x202A9) == 169 then --If Flash Command Input is entered.
		Timer = Timer - 1
		if Timer == 0 then
			print("Hori Slash timer ran out!")
			Timer = 70 
			WriteByte(Btl0+0x2004C, 1) 	 
			WriteByte(Btl0+0x20045, 97) 
			WriteByte(Btl0+0x20084, 191)
			WriteByte(Btl0+0x20048, 10)
			Up = false
			Down = false
			Left = false
			Right = false
			DownRight = false
			L2 = false
			R2 = false
			Spin = false
			FlashStep = false
			SlideDash = false
			FinishingLeap = false
			HoriSlash = false
		end
	end


--if Up == true or Down == true or Right == true or DownRight == true or Down == true or L2 == true or R2 == true then
	--Timer2 = Timer2 - 1
	--if Timer2 == 0 then
	--	print("Inputs not fast enough! Voided!")
	--	Timer2 = 90 
	--	Up = false
	--	Down = false
	--	Left = false
	--	Right = false
	--	DownRight = false
	--	L2 = false
	--	R2 = false
	--	Spin = false
	--	FlashStep = false
	--	SlideDash = false
	--	FinishingLeap = false
	--	end
	--end
end