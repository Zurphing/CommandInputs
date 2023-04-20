LUAGUI_NAME = "Command Inputs"
LUAGUI_AUTH = "Zurphing"
LUAGUI_DESC = "Turns nearly every combo modifier into command inputs, using L3/L2/R2/Left Stick"

--Script recently adjusted to separate Explosion/Magnet Burst & Flash Step/Slide Dash from Aerial Dive/Aerial Spiral
--Now there is a "free-use" ability you start the game with.

Timer = 50
Timer2 = 50
local canExecute = false
local CanUseInput = false
local CommandInput = false
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

--Values to be populated per-form.
local CITypeV = 0x00 --Unsigned Byte
local CISubV = 0xFF --Signed Byte
local CICombOffsetV = 0x00 --Signed Byte
local CIFlagsV = 0x00 --Unsigned 32-byte int
local CINextMotionV = 0x0000 --Unsigned 16-byte short
local CIJumpV = 0 --Float
local CIJumpMaxV = 0 --Float
local CIJumpMinV = 0 --Float
local CISpeedMinV = 0 --Float
local CISpeedMaxV = 0 --Float
local CINearV = 0 --Float
local CIFarV = 0 --Float
local CILowV = 0 --Float
local CIHighV = 0 --Float
local CIInnerMin = 0 --Float
local CIInnerMaxV = 0 --Float
local CIBlendTimeV = 0 --Float
local CIDistanceV = 0 --Float
local CIAbilityV = 0x0000 --Unsigned 16-byte short
local CIScoreV = 0x0000  --Unsigned 16-byte short

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

--Original Conditions: Modifying both Aerial Sweep & Aerial Dive.
--This outprioritizes literally every other move in Soras arsenal, so there shouldnt be any weird overrides.
--Note: V = Vanilla, for vanilla values.
--Flags: 0x4 is ONLY flag 3.
--0x1 means Flag 1 is on
--0x2 means Flag 2 is on
--0x8 means Flag 4 is on
--Add flag values to get them working in tandem.
ASTypeV = 0x01 --Unsigned Byte
ASSubV = 0xFF --Signed Byte
ASCombOffsetV = 0x0 --Signed Byte
ASFlagsV = 0xA --Unsigned 32-byte int
ASMotionV = 0xBF --Unsigned 16-byte short
ASNextMotionV = 0x4 --Unsigned 16-byte short
ASJumpV = 17 --Float
ASJumpMaxV = 117 --Float
ASJumpMinV = 17 --Float
ASSpeedMinV = -8 --Float
ASSpeedMaxV = 18 --Float
ASNearV = 0 --Float
ASFarV = 260 --Float
ASLowV = -110 --Float
ASHighV = -250 --Float
ASInnerMin = 0.9999619 --Float
ASInnerMaxV = 1 --Float
ASBlendTimeV = 0 --Float
ASDistanceV = 55 --Float
ASAbilityV = 0x61 --Unsigned 16-byte short
ASScoreV = 0x14  --Unsigned 16-byte short

ADTypeV = 0x01 --Unsigned Byte
ADSubV = 0xFF --Signed Byte
ADCombOffsetV = 0x00 --Signed Byte
ADFlagsV = 0x0A --Unsigned 32-byte int
ADMotionV = 0xC4
ADNextMotionV = 0x0004 --Unsigned 16-byte short
ADJumpV = 41 --Float
ADJumpMaxV = 117 --Float
ADJumpMinV = 41 --Float
ADSpeedMinV = 0 --Float
ADSpeedMaxV = 32 --Float
ADNearV = 0 --Float
ADFarV = 650 --Float
ADLowV = -110 --Float
ADHighV = -250 --Float
ADInnerMin = 0.9999619 --Float
ADInnerMaxV = 1 --Float
ADBlendTimeV = 0 --Float
ADDistanceV = 55 --Float
ADAbilityV = 0x0061 --Unsigned 16-byte short
ADScoreV = 0x0014  --Unsigned 16-byte short

--CI = CommandInput
--CI

	if VicOn == true or Override == true then
		if Up == true and Down == true and Left == true and Right == true and Spin ~= true then
			Spin = true
			--print("Spin attack queued up!")
			--All of these use Aerial Sweeps PTYA Entry.
			ConsolePrint("Spin attack ready to use!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 0, true) --Flags
			WriteShort(Btl0+0x12C, 170, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 20, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 0, true) --ComboOffset
			WriteInt(Btl0+0x16C, 0, true) --Flags
			WriteShort(Btl0+0x170, 170, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 20, true) --Score
			CommandInput = true
		end
	end
		
	--if Pretzel == true and CanUseInput == true then
	--	WriteByte(Btl0+0x389, 3, true) --Vicinity Break: Type
	--	WriteByte(Btl0+0x3C8, 0, true) --Vicinity Break: Ability Required
	--	WriteByte(Btl0+0x390, 163, true)
	--end
	--ConsolePrint(Timer)
	--Reset back to vanilla. Much simpler than requiring like 10 different statements like before.
	if ReadShort(Btl0+0x12C) ~= 191 and CommandInput == true then
		Timer = Timer - 1
		if Timer == 0 then
			ConsolePrint("Input ran out. Resetting to vanilla.")
			WriteByte(Btl0+0x125, 1, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, ASSubV, true) --Sub
			WriteByte(Btl0+0x127, ASCombOffsetV, true) --ComboOffset
			WriteInt(Btl0+0x128, ASFlagsV, true) --Flags
			WriteShort(Btl0+0x12C, ASMotionV, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, ASNextMotionV, true) --NextMotionID 
			WriteFloat(Btl0+0x130, ASJumpV, true) --Jump
			WriteFloat(Btl0+0x134, ASJumpMaxV, true) --JumpMax
			WriteFloat(Btl0+0x138, ASJumpMinV, true) --JumpMin
			WriteFloat(Btl0+0x13C, ASSpeedMinV, true) --SpeedMin
			WriteFloat(Btl0+0x140, ASSpeedMaxV, true) --SpeedMax
			WriteFloat(Btl0+0x144, ASNearV, true) --Near
			WriteFloat(Btl0+0x148, ASFarV, true) --Far
			WriteFloat(Btl0+0x14C, ASLowV, true) --Low
			WriteFloat(Btl0+0x150, ASHighV, true) --High
			WriteFloat(Btl0+0x154, ASInnerMin, true) --InnerMin
			WriteFloat(Btl0+0x158, ASInnerMaxV, true) --InnerMax
			WriteFloat(Btl0+0x15C, ASBlendTimeV, true) --BlendTime
			WriteFloat(Btl0+0x160, ASDistanceV, true) --DistanceAdjust
			WriteShort(Btl0+0x164, ASAbilityV, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 20, true) --Score

			WriteByte(Btl0+0x169, 1, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, ADSubV, true) --Sub
			WriteByte(Btl0+0x16B, ADCombOffsetV, true) --ComboOffset
			WriteInt(Btl0+0x16C, ADFlagsV, true) --Flags
			WriteShort(Btl0+0x170, ADMotionV, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, ADNextMotionV, true) --NextMotionID 
			WriteFloat(Btl0+0x174, ADJumpV, true) --Jump
			WriteFloat(Btl0+0x178, ADJumpMaxV, true) --JumpMax
			WriteFloat(Btl0+0x17C, ADJumpMinV, true) --JumpMin
			WriteFloat(Btl0+0x180, ADSpeedMinV, true) --SpeedMin
			WriteFloat(Btl0+0x184, ADSpeedMaxV, true) --SpeedMax
			WriteFloat(Btl0+0x188, ADNearV, true) --Near
			WriteFloat(Btl0+0x18C, ADFarV, true) --Far
			WriteFloat(Btl0+0x190, ADLowV, true) --Low
			WriteFloat(Btl0+0x194, ADHighV, true) --High
			WriteFloat(Btl0+0x198, ADInnerMin, true) --InnerMin
			WriteFloat(Btl0+0x19C, ADInnerMaxV, true) --InnerMax
			WriteFloat(Btl0+0x1A0, ADBlendTimeV, true) --BlendTime
			WriteFloat(Btl0+0x1A4, ADDistanceV, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, ADAbilityV, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 20, true) --Score
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
			CommandInput = false
			Spin = false
			Timer = 50
		end
	end

	if FStepOn == true or Override == true then
		if L2 == true and Up == true and FlashStep ~= true then --Flash Step Conditions Met
			FlashStep = true
			print("Flash Step ready!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 0, true) --Flags
			WriteShort(Btl0+0x12C, 169, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 0, true) --ComboOffset
			WriteInt(Btl0+0x16C, 0, true) --Flags
			WriteShort(Btl0+0x170, 169, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score
			CommandInput = true
		end
	end

	if SlideOn == true or Override == true then
		if L2 == true and Down == true and SlideDash ~= true then --Flash Step Conditions Met
			SlideDash = true
			print("Slide Dash Ready!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 0, true) --Flags
			WriteShort(Btl0+0x12C, 164, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 0, true) --ComboOffset
			WriteInt(Btl0+0x16C, 0, true) --Flags
			WriteShort(Btl0+0x170, 164, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score
			CommandInput = true
		end
	end

	if ADiveOn == true or Override == true then
		if L2 == true and Up == true and FlashStep1 ~= true then --Flash Step Conditions Met
			FlashStep1 = true
			print("Aerial Dive Ready!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 1, true) --Flags
			WriteShort(Btl0+0x12C, 196, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 4, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 14, true) --Jump
			WriteFloat(Btl0+0x134, 75, true) --JumpMax
			WriteFloat(Btl0+0x138, 14, true) --JumpMin
			WriteFloat(Btl0+0x13C, 3, true) --SpeedMin
			WriteFloat(Btl0+0x140, 13.5, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 105, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			CommandInput = true
		end
	end

	if ASpiralOn == true or Override == true then
		if L2 == true and Down == true and SlideDash1 ~= true then --Flash Step Conditions Met
			SlideDash1 = true
			print("Aerial Spiral ready!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 1, true) --Flags
			WriteShort(Btl0+0x12C, 192, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 4, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 14, true) --Jump
			WriteFloat(Btl0+0x134, 75, true) --JumpMax
			WriteFloat(Btl0+0x138, 14, true) --JumpMin
			WriteFloat(Btl0+0x13C, 3, true) --SpeedMin
			WriteFloat(Btl0+0x140, 13.5, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 98, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			CommandInput = true
		end
	end

	if HoriOn == true or Override == true then
		if L2 == true and Right == true and HoriSlash ~= true or L2 == true and Left == true and HoriSlash ~= true then --Flash Step Conditions Met
			HoriSlash = true
			print("HoriSlash ready!")			
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 1, true) --Flags
			WriteShort(Btl0+0x12C, 193, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 4, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 14, true) --Jump
			WriteFloat(Btl0+0x134, 75, true) --JumpMax
			WriteFloat(Btl0+0x138, 14, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 13.5, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 55, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			CommandInput = true
		end
	end

	if ExplOn == true or Override == true then
		if Down == true and R2 == true and AoE ~= true then
			AoE = true
			print("AoE Finisher queued up")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 5, true) --ComboOffset
			WriteInt(Btl0+0x128, 4, true) --Flags
			WriteShort(Btl0+0x12C, 166, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 5, true) --ComboOffset
			WriteInt(Btl0+0x16C, 4, true) --Flags
			WriteShort(Btl0+0x170, 166, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score
			CommandInput = true
		end
	end

	if MBurstOn == true or Override == true then
		if Down == true and R2 == true and AoE1 ~= true then
			AoE1 = true
			print("AoE Finisher Air queued up!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 5, true) --ComboOffset
			WriteInt(Btl0+0x128, 5, true) --Flags
			WriteShort(Btl0+0x12C, 197, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 4, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 14, true) --Jump
			WriteFloat(Btl0+0x134, 42, true) --JumpMax
			WriteFloat(Btl0+0x138, 14, true) --JumpMin
			WriteFloat(Btl0+0x13C, 5, true) --SpeedMin
			WriteFloat(Btl0+0x140, 5, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 55, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			CommandInput = true
		end
	end

	if GBreakOn == true or Override == true then
		if R2 == true and Up == true and SingleTarget ~= true then
			SingleTarget = true
			print("Single-Target Finisher Queued Up!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 5, true) --ComboOffset
			WriteInt(Btl0+0x128, 4, true) --Flags
			WriteShort(Btl0+0x12C, 165, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 5, true) --ComboOffset
			WriteInt(Btl0+0x16C, 4, true) --Flags
			WriteShort(Btl0+0x170, 165, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score
			CommandInput = true
		end
	end

	if FLeapOn == true or Override == true then
		if L2 == true and Down == true and DownRight == true and Right == true and FinishingLeap ~= true then --Flash Step Conditions Met
			FinishingLeap = true
			print("Finishing Leap Queued Up!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 99, true) --ComboOffset
			WriteInt(Btl0+0x128, 4, true) --Flags
			WriteShort(Btl0+0x12C, 167, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 99, true) --ComboOffset
			WriteInt(Btl0+0x16C, 4, true) --Flags
			WriteShort(Btl0+0x170, 167, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score
			CommandInput = true
		end
	end
	if SlapOn == true or Override == true then
		if L3 == true and Slapshot ~= true then
			Slapshot = true
			print("Slapshot queued up!")
			WriteByte(Btl0+0x125, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x126, 0xFF, true) --Sub
			WriteByte(Btl0+0x127, 0, true) --ComboOffset
			WriteInt(Btl0+0x128, 0, true) --Flags
			WriteShort(Btl0+0x12C, 162, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x12E, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x130, 0, true) --Jump
			WriteFloat(Btl0+0x134, 0, true) --JumpMax
			WriteFloat(Btl0+0x138, 0, true) --JumpMin
			WriteFloat(Btl0+0x13C, 0, true) --SpeedMin
			WriteFloat(Btl0+0x140, 0, true) --SpeedMax
			WriteFloat(Btl0+0x144, 0, true) --Near
			WriteFloat(Btl0+0x148, 0, true) --Far
			WriteFloat(Btl0+0x14C, 0, true) --Low
			WriteFloat(Btl0+0x150, 0, true) --High
			WriteFloat(Btl0+0x154, 0, true) --InnerMin
			WriteFloat(Btl0+0x158, 0, true) --InnerMax
			WriteFloat(Btl0+0x15C, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x160, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x164, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x166, 0, true) --Score
			
			WriteByte(Btl0+0x169, 3, true) --Vicinity Break: Type
			WriteByte(Btl0+0x16A, 0xFF, true) --Sub
			WriteByte(Btl0+0x16B, 0, true) --ComboOffset
			WriteInt(Btl0+0x16C, 0, true) --Flags
			WriteShort(Btl0+0x170, 162, true) --MotionID To Use (What we change)
			WriteShort(Btl0+0x172, 0, true) --NextMotionID 
			WriteFloat(Btl0+0x174, 0, true) --Jump
			WriteFloat(Btl0+0x178, 0, true) --JumpMax
			WriteFloat(Btl0+0x17C, 0, true) --JumpMin
			WriteFloat(Btl0+0x180, 0, true) --SpeedMin
			WriteFloat(Btl0+0x184, 0, true) --SpeedMax
			WriteFloat(Btl0+0x188, 0, true) --Near
			WriteFloat(Btl0+0x18C, 0, true) --Far
			WriteFloat(Btl0+0x190, 0, true) --Low
			WriteFloat(Btl0+0x194, 0, true) --High
			WriteFloat(Btl0+0x198, 0, true) --InnerMin
			WriteFloat(Btl0+0x19C, 0, true) --InnerMax
			WriteFloat(Btl0+0x1A0, 4.5912, true) --BlendTime
			WriteFloat(Btl0+0x1A4, 0, true) --DistanceAdjust
			WriteShort(Btl0+0x1A6, 0, true) --Vicinity Break: Ability Required
			WriteShort(Btl0+0x1A8, 0, true) --Score	
			CommandInput = true
		end
	end
	
	if CommandInput == true and ReadInput & 16384 == 16384 then
		ConsolePrint("Input used up. Resetting to vanilla.")
		WriteByte(Btl0+0x125, 1, true) --Vicinity Break: Type
		WriteByte(Btl0+0x126, ASSubV, true) --Sub
		WriteByte(Btl0+0x127, ASCombOffsetV, true) --ComboOffset
		WriteInt(Btl0+0x128, ASFlagsV, true) --Flags
		WriteShort(Btl0+0x12C, ASMotionV, true) --MotionID To Use (What we change)
		WriteShort(Btl0+0x12E, ASNextMotionV, true) --NextMotionID 
		WriteFloat(Btl0+0x130, ASJumpV, true) --Jump
		WriteFloat(Btl0+0x134, ASJumpMaxV, true) --JumpMax
		WriteFloat(Btl0+0x138, ASJumpMinV, true) --JumpMin
		WriteFloat(Btl0+0x13C, ASSpeedMinV, true) --SpeedMin
		WriteFloat(Btl0+0x140, ASSpeedMaxV, true) --SpeedMax
		WriteFloat(Btl0+0x144, ASNearV, true) --Near
		WriteFloat(Btl0+0x148, ASFarV, true) --Far
		WriteFloat(Btl0+0x14C, ASLowV, true) --Low
		WriteFloat(Btl0+0x150, ASHighV, true) --High
		WriteFloat(Btl0+0x154, ASInnerMin, true) --InnerMin
		WriteFloat(Btl0+0x158, ASInnerMaxV, true) --InnerMax
		WriteFloat(Btl0+0x15C, ASBlendTimeV, true) --BlendTime
		WriteFloat(Btl0+0x160, ASDistanceV, true) --DistanceAdjust
		WriteShort(Btl0+0x164, ASAbilityV, true) --Vicinity Break: Ability Required
		WriteShort(Btl0+0x166, 20, true) --Score
		
		WriteByte(Btl0+0x169, 1, true) --Vicinity Break: Type
		WriteByte(Btl0+0x16A, ADSubV, true) --Sub
		WriteByte(Btl0+0x16B, ADCombOffsetV, true) --ComboOffset
		WriteInt(Btl0+0x16C, ADFlagsV, true) --Flags
		WriteShort(Btl0+0x170, ADMotionV, true) --MotionID To Use (What we change)
		WriteShort(Btl0+0x172, ADNextMotionV, true) --NextMotionID 
		WriteFloat(Btl0+0x174, ADJumpV, true) --Jump
		WriteFloat(Btl0+0x178, ADJumpMaxV, true) --JumpMax
		WriteFloat(Btl0+0x17C, ADJumpMinV, true) --JumpMin
		WriteFloat(Btl0+0x180, ADSpeedMinV, true) --SpeedMin
		WriteFloat(Btl0+0x184, ADSpeedMaxV, true) --SpeedMax
		WriteFloat(Btl0+0x188, ADNearV, true) --Near
		WriteFloat(Btl0+0x18C, ADFarV, true) --Far
		WriteFloat(Btl0+0x190, ADLowV, true) --Low
		WriteFloat(Btl0+0x194, ADHighV, true) --High
		WriteFloat(Btl0+0x198, ADInnerMin, true) --InnerMin
		WriteFloat(Btl0+0x19C, ADInnerMaxV, true) --InnerMax
		WriteFloat(Btl0+0x1A0, ADBlendTimeV, true) --BlendTime
		WriteFloat(Btl0+0x1A4, ADDistanceV, true) --DistanceAdjust
		WriteShort(Btl0+0x1A6, ADAbilityV, true) --Vicinity Break: Ability Required
		WriteShort(Btl0+0x1A8, 20, true) --Score
		Timer = 50
		CommandInput = false
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
		FlashStep = false
		SlideDash = false
		FlashStep1 = false --Aerial Dive
		SlideDash1 = false --Aerial Spiral.
		FinishingLeap = false
		HoriSlash = false
		AoE = false
		SingleTarget = false
		AoE1 = false
		SingleTarget1 = false
		Slapshot = false
		Pretzel = false
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
		WriteByte(Btl0+0x125, 1, true) --Vicinity Break: Type
		WriteByte(Btl0+0x126, ASSubV, true) --Sub
		WriteByte(Btl0+0x127, ASCombOffsetV, true) --ComboOffset
		WriteInt(Btl0+0x128, ASFlagsV, true) --Flags
		WriteShort(Btl0+0x12C, ASMotionV, true) --MotionID To Use (What we change)
		WriteShort(Btl0+0x12E, ASNextMotionV, true) --NextMotionID 
		WriteFloat(Btl0+0x130, ASJumpV, true) --Jump
		WriteFloat(Btl0+0x134, ASJumpMaxV, true) --JumpMax
		WriteFloat(Btl0+0x138, ASJumpMinV, true) --JumpMin
		WriteFloat(Btl0+0x13C, ASSpeedMinV, true) --SpeedMin
		WriteFloat(Btl0+0x140, ASSpeedMaxV, true) --SpeedMax
		WriteFloat(Btl0+0x144, ASNearV, true) --Near
		WriteFloat(Btl0+0x148, ASFarV, true) --Far
		WriteFloat(Btl0+0x14C, ASLowV, true) --Low
		WriteFloat(Btl0+0x150, ASHighV, true) --High
		WriteFloat(Btl0+0x154, ASInnerMin, true) --InnerMin
		WriteFloat(Btl0+0x158, ASInnerMaxV, true) --InnerMax
		WriteFloat(Btl0+0x15C, ASBlendTimeV, true) --BlendTime
		WriteFloat(Btl0+0x160, ASDistanceV, true) --DistanceAdjust
		WriteShort(Btl0+0x164, ASAbilityV, true) --Vicinity Break: Ability Required
		WriteShort(Btl0+0x166, 20, true) --Score
		
		WriteByte(Btl0+0x169, 1, true) --Vicinity Break: Type
		WriteByte(Btl0+0x16A, ADSubV, true) --Sub
		WriteByte(Btl0+0x16B, ADCombOffsetV, true) --ComboOffset
		WriteInt(Btl0+0x16C, ADFlagsV, true) --Flags
		WriteShort(Btl0+0x170, ADMotionV, true) --MotionID To Use (What we change)
		WriteShort(Btl0+0x172, ADNextMotionV, true) --NextMotionID 
		WriteFloat(Btl0+0x174, ADJumpV, true) --Jump
		WriteFloat(Btl0+0x178, ADJumpMaxV, true) --JumpMax
		WriteFloat(Btl0+0x17C, ADJumpMinV, true) --JumpMin
		WriteFloat(Btl0+0x180, ADSpeedMinV, true) --SpeedMin
		WriteFloat(Btl0+0x184, ADSpeedMaxV, true) --SpeedMax
		WriteFloat(Btl0+0x188, ADNearV, true) --Near
		WriteFloat(Btl0+0x18C, ADFarV, true) --Far
		WriteFloat(Btl0+0x190, ADLowV, true) --Low
		WriteFloat(Btl0+0x194, ADHighV, true) --High
		WriteFloat(Btl0+0x198, ADInnerMin, true) --InnerMin
		WriteFloat(Btl0+0x19C, ADInnerMaxV, true) --InnerMax
		WriteFloat(Btl0+0x1A0, ADBlendTimeV, true) --BlendTime
		WriteFloat(Btl0+0x1A4, ADDistanceV, true) --DistanceAdjust
		WriteShort(Btl0+0x1A6, ADAbilityV, true) --Vicinity Break: Ability Required
		WriteShort(Btl0+0x1A8, 20, true) --Score
	end
end
end