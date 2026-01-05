-- Module Name Export

ExportScript.FoundDCSModule = true
ExportScript.Version.C130J = "1.2.1"
local CNBPinit = false
local keyset={}


local function splitLines(input)
    local lines = {}

    -- Append a newline to capture the last line correctly
    input = input .. "\n"

    for line in input:gmatch("(.-)\r?\n") do
	--ExportScript.Tools.WriteToLog(#line) -- for debugging
        -- apply filters
		if 	not (#line == 41)
			and not line:match("^%{")
			and not line:match("^%}")
			and not line:match("^children") then
				--line = line:gsub(":", "%%3A") --uncomment if colons cause problems in output
				line = line:gsub("%^", "°")  --uncomment if degrees cause problems in output
				table.insert(lines, line)
		end
    end

    return lines
end



function getIndexValue(input, indexName)
    local pattern = "^" .. indexName .. ":([%-]?%d+%.?%d*)$"

    for line in input:gmatch("[^\r\n]+") do
        local value = line:match(pattern)
        if value then
            return tonumber(value)
        end
    end

    return nil
end

local function findIndexBySubstring(list, substring)
    -- Returns 'i' immediately when a match is found
    for i, v in ipairs(list) do 
		if string.find(v, substring) then 
			--ExportScript.Tools.WriteToLog("findIndexBySubstring Returned "..i)
			return i 
		end 
	end
	--ExportScript.Tools.WriteToLog("findIndexBySubstring Returned nil")
    return nil -- Returns nil if the substring isn't found anywhere
end

local function findIndex(tbl, valueToFind)
    -- Iterate through the table using the numeric indices
    for index, value in ipairs(tbl) do
        -- Ensure the value we are checking is actually a string before calling :find() on it
        if type(value) == "string" and value:find(valueToFind) then
            -- :find returns the start/end index if found, which evaluates to true in the if statement
            return index -- Return the key once a partial match is found
        end
    end
    return nil -- Return nil if the value is not found after the loop
end


ExportScript.ConfigEveryFrameArguments = 
{
	--[[
	every frames arguments
	based of "mainpanel_init.lua"
	Example (http://www.lua.org/manual/5.1/manual.html#pdf-string.format)
	[DeviceID] = "Format"
	  [4] = "%.4f",  <- floating-point number with 4 digits after point
	 [19] = "%0.1f", <- floating-point number with 1 digit after point
	[129] = "%1d",   <- decimal number
	  [5] = "%.f",   <- floating point number rounded to a decimal number
	]]
	
	
	[4045] = "%1d", -- MASTER WARNING light
	[4046] = "%1d", -- MASTER CAUTION light
}
ExportScript.ConfigArguments = 
{
	--[[
	arguments for export in low tick interval
	based on "clickabledata.lua"
	]]
	
	--INDICATOR LIGHTS
	--Unable to find Landing Light Extension Indicator Lights
	
	[3990] = "%0.1f", 		-- P CNI-MU EXE light
	[3992] = "%0.1f", 		-- CP CNI-MU EXE light
	[3994] = "%0.1f", 		-- AUG CNI-MU EXE light
		
	[4011] = "%0.1f", 		-- P HUD VIS light
	[4012] = "%0.1f", 		-- P HUD CAT 2 light
	[4013] = "%0.1f", 		-- P HUD O/S light
	[4014] = "%0.1f", 		-- P HUD UNCG light
	[4015] = "%0.1f", 		-- P HUD NAV light
	[4016] = "%0.1f", 		-- P HUD TACT light
	
	[4017] = "%0.1f", 		-- CP HUD VIS light
	[4018] = "%0.1f", 		-- CP HUD CAT 2 light
	[4019] = "%0.1f", 		-- CP HUD O/S light
	[4020] = "%0.1f", 		-- CP HUD UNCG light
	[4021] = "%0.1f", 		-- CP HUD NAV light
	[4022] = "%0.1f", 		-- CP HUD TACT light
	
	[4023] = "%0.1f", 		-- ENG 1 START light
	[4024] = "%0.1f", 		-- ENG 2 START light
	[4025] = "%0.1f", 		-- ENG 3 START light
	[4026] = "%0.1f", 		-- ENG 4 START light
	[4027] = "%0.1f", 		-- APU START light
	
	[4028] = "%0.1f", 		-- SPR DRAIN light
	
	[4032] = "%0.1f", 		-- NLG Locked light
	[4033] = "%0.1f", 		-- L MLG Locked light
	[4034] = "%0.1f", 		-- R MLG Locked light
	[4035] = "%0.1f", 		-- Gear Handle light
	
	[4036] = "%0.1f", 		-- GEN 1 light
	[4037] = "%0.1f", 		-- GEN 2 light
	[4038] = "%0.1f", 		-- GEN 3 light
	[4039] = "%0.1f", 		-- GEN 4 light
	
	[4041] = "%0.1f", 		-- AUX Pump light
	
	[4047] = "%0.1f", 		-- ALT ON light
	[4048] = "%0.1f", 		-- VS ON light	
	[4049] = "%0.1f", 		-- SEL ON light
	[4050] = "%0.1f", 		-- IAS ON light	
	[4051] = "%0.1f", 		-- HDG ON light
	[4052] = "%0.1f", 		-- NAV ON light
	[4053] = "%0.1f", 		-- CAPS ON light
	[4054] = "%0.1f", 		-- APPR ON light
	[4055] = "%0.1f", 		-- A/T ON light
	
	[4056] = "%0.1f", 		-- P AP ON Annunciator
	[4057] = "%0.1f", 		-- P PTCH OFF Annunciator
	[4058] = "%0.1f", 		-- P NAV ARM Annunciator
	[4059] = "%0.1f", 		-- P GS ARM Annunciator
	[4060] = "%0.1f", 		-- P GO ARND Annunciator
	[4061] = "%0.1f", 		-- P CAT2 ARM Annunciator
	[4062] = "%0.1f", 		-- P AP DSGN Annunciator
	[4063] = "%0.1f", 		-- P LAT OFF Annunciator
	[4064] = "%0.1f", 		-- P NAV CAPT Annunciator
	[4065] = "%0.1f", 		-- P GS CAPT Annunciator
	[4066] = "%0.1f", 		-- P BACK LOC Annunciator
	[4067] = "%0.1f", 		-- P CAT2 Annunciator
	
	[4068] = "%0.1f", 		-- EMER BRAKE SEL light
	[4069] = "%0.1f", 		-- Engine Pump 1 light
	[4070] = "%0.1f", 		-- Engine Pump 2 light
	[4071] = "%0.1f", 		-- Engine Pump 3 light
	[4072] = "%0.1f", 		-- Engine Pump 4 light
	[4073] = "%0.1f", 		-- Suction Boost Util Pump light
	[4074] = "%0.1f", 		-- Suction Boost Pump light
	
	[4075] = "%0.1f", 		-- ADS RAMP/DOOR FULL Light
	
	[4077] = "%0.1f", 		-- LPCR PRCN light
	[4078] = "%0.1f", 		-- LPCR MAP light
	[4079] = "%0.1f", 		-- LPCR WX light
	[4080] = "%0.1f", 		-- LPCR SP light
	[4081] = "%0.1f", 		-- LPCR MGM light
	[4082] = "%0.1f", 		-- LPCR WS light
	[4083] = "%0.1f", 		-- LPCR BCN light
	[4084] = "%0.1f", 		-- LPCR PSEL light
	[4085] = "%0.1f", 		-- LPCR OFS light
	[4086] = "%0.1f", 		-- LPCR FRZ light
	[4087] = "%0.1f", 		-- LPCR PEN light
	[4088] = "%0.1f", 		-- LPCR SCTR light
	
	[4089] = "%0.1f", 		-- AFCS PITCH OFF light
	[4090] = "%0.1f", 		-- AFCS LAT OFF light
	
	[4091] = "%0.1f", 		-- ENG 1 LSGI light
	[4092] = "%0.1f", 		-- ENG 2 LSGI light
	[4093] = "%0.1f", 		-- ENG 3 LSGI light
	[4094] = "%0.1f", 		-- ENG 4 LSGI light
	
	[4095] = "%0.1f", 		-- ADS CAUTION light
	[4096] = "%0.1f", 		-- ADS JUMP light
	
	[4097] = "%0.1f", 		-- RWR SRCH light
	[4098] = "%0.1f", 		-- RWR MODE light
	[4099] = "%0.1f", 		-- RWR HAND OFF light
	[4100] = "%0.1f", 		-- RWR ALT light
	[4101] = "%0.1f", 		-- RWR TGT SEP light
	
	[4102] = "%0.1f", 		-- AIR COND FLT STA POWER light
	[4103] = "%0.1f", 		-- AIR COND CARGO COMPT POWER light
	[4104] = "%0.1f", 		-- AIR COND FLT STA MAN light
	[4105] = "%0.1f", 		-- AIR COND CARGO COMPT MAN light
	[4106] = "%0.1f", 		-- AIR COND CROSS FLOW VALVE MAN light
	
	[4107] = "%0.1f", 		-- FUEL PANEL FLCV light
	
	[4108] = "%0.1f", 		-- BLEED AIR PANEL APU OPEN light
	
	[4114] = "%0.1f", 		-- CP AP ON Annunciator
	[4115] = "%0.1f", 		-- CP PTCH OFF Annunciator
	[4116] = "%0.1f", 		-- CP NAV ARM Annunciator
	[4117] = "%0.1f", 		-- CP GS ARM Annunciator
	[4118] = "%0.1f", 		-- CP GO ARND Annunciator
	[4119] = "%0.1f", 		-- CP CAT2 ARM Annunciator
	[4120] = "%0.1f", 		-- CP AP DSGN Annunciator
	[4121] = "%0.1f", 		-- CP LAT OFF Annunciator
	[4122] = "%0.1f", 		-- CP NAV CAPT Annunciator
	[4123] = "%0.1f", 		-- CP GS CAPT Annunciator
	[4124] = "%0.1f", 		-- CP BACK LOC Annunciator
	[4125] = "%0.1f", 		-- CP CAT2 Annunciator
	
	[4131] = "%1d", 		-- FIRE HANDLE ENG 1 light
	[4132] = "%1d", 		-- FIRE HANDLE ENG 2 light
	[4133] = "%1d", 		-- FIRE HANDLE ENG 3 light
	[4134] = "%1d", 		-- FIRE HANDLE ENG 4 light
	[4135] = "%1d", 		-- FIRE HANDLE APU light
	
	[4137] = "%0.1f", 		-- P CNI-MU DSPY light
	[4138] = "%0.1f", 		-- P CNI-MU MSG light
	[4139] = "%0.1f", 		-- P CNI-MU FAIL light
	[4140] = "%0.1f", 		-- P CNI-MU OFST light
	[4141] = "%0.1f", 		-- CP CNI-MU DSPY light
	[4142] = "%0.1f", 		-- CP CNI-MU MSG light
	[4143] = "%0.1f", 		-- CP CNI-MU FAIL light
	[4144] = "%0.1f", 		-- CP CNI-MU OFST light
	[4145] = "%0.1f", 		-- AUG CNI-MU DSPY light
	[4146] = "%0.1f", 		-- AUG CNI-MU MSG light
	[4147] = "%0.1f", 		-- AUG CNI-MU FAIL light
	[4148] = "%0.1f", 		-- AUG CNI-MU OFST light
	
	
	
	--FIRE HANDLES
	[314] = "%1d",			--Engine 1 Fire Handle, push/pull {0,1}
	[316] = "%1d",			--Engine 2 Fire Handle, push/pull {0,1}
	[318] = "%1d",			--Engine 3 Fire Handle, push/pull {0,1}
	[320] = "%1d",			--Engine 4 Fire Handle, push/pull {0,1}
	[324] = "%1d",			--Engine 4 Fire Handle, push/pull {0,1}

	
	--FUEL PANEL
	[356] = "%1d",			--Left External Tank Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[357] = "%1d",			--Main Tank 1 Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[358] = "%1d",			--Main Tank 2 Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[359] = "%1d",			--Left Auxiliary Tank Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[361] = "%1d",			--Right Auxiliary Tank Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[363] = "%1d",			--Main Tank 3 Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[364] = "%1d",			--Main Tank 4 Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	[365] = "%1d",			--Right External Tank Transfer Pump Selector, FROM/OFF/TO {-1, 0, 1}
	
	[360] = "%1d",			--Crosship Separation Valve Switch, CLOSED/OPEN {0, 1}
	[366] = "%1d",			--Engine 1 Crossfeed Valve Switch, CLOSED/OPEN {0, 1}
	[367] = "%1d",			--Engine 2 Crossfeed Valve Switch, CLOSED/OPEN {0, 1}
	[368] = "%1d",			--Engine 3 Crossfeed Valve Switch, CLOSED/OPEN {0, 1}
	[369] = "%1d",			--Engine 4 Crossfeed Valve Switch, CLOSED/OPEN {0, 1}
	
	[332] = "%1d",			--Left Fuel Dump Switch Guard, CLOSED/OPEN {0, 1}
	[333] = "%1d",			--Right Fuel Dump Switch Guard, CLOSED/OPEN {0, 1}
	[1338] = "%1d",			--Left Fuel Dump Switch, OFF/ON {0, 1}
	[1339] = "%1d",			--Right Fuel Dump Switch, OFF/ON {0, 1}
	
	[370] = "%0.3f",		--Fuel Tank Select, OFF/1/2/LA/RA/3/4/LE/RE {0, 0.125 Steps, 1}
	[362] = "%1d",			--SPR Valve Switch, OPEN/CLOSED/DRAIN {-1, 0, 1}
	
	--ENGINE PANEL
	[310] = "%0.2f",		--Engine 1 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[311] = "%0.2f",		--Engine 2 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[312] = "%0.2f",		--Engine 3 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[313] = "%0.2f",		--Engine 4 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[322] = "%0.1f",		--APU Start Switch, STOP/RUN/START {0.00, 0.50, 1.00}
	[425] = "%1d",			--APU Alarm Switch, OFF/ON {0,1}
	
	--LANDING GEAR LIGHTS PANEL
	[126] = "%1d",			--Gear Handle
	[36] = "%1d",			--Down Lock Release
	[32] = "%1d",			--Landing Light Switch Left
	[33] = "%1d",			--Landing Light Switch Right
	[30] = "%1d",			--Landing Light Motor Switch Left, EXTEND/HOLD/RETRACT {-1.0, 0.0, 1.0}
	[31] = "%1d",			--Landing Light Motor Switch Right, EXTEND/HOLD/RETRACT {-1.0, 0.0, 1.0}
	[34] = "%1d",			--Taxi Light Switch
	[35] = "%1d",			--Wingtip Taxi Light Switch
	
	--OIL COOLER FLAP PANEL
	[495] = "%0.1f",		--Oil Cooler Flap Switch 1
	[496] = "%0.1f",		--Oil Cooler Flap Switch 2
	[497] = "%0.1f",		--Oil Cooler Flap Switch 3
	[498] = "%0.1f",		--Oil Cooler Flap Switch 4
	
	--ELECTRICAL PANEL
	[341] = "%1d",			--Generator 1
	[342] = "%1d",			--Generator 2
	[343] = "%1d",			--Generator 3
	[344] = "%1d",			--Generator 4
	[467] = "%1d",			--Ext Power/APU Switch, External/OFF/APU {-1, 0, 1}
	[371] = "%1d",			--Battery Switch
	
	--ICE PROTECTION PANEL
	[386] = "%1d",			--Propeller 1 Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[387] = "%1d",			--Propeller 2 Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[388] = "%1d",			--Propeller 3 Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[389] = "%1d",			--Propeller 4 Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[385] = "%1d",			--Engine Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[384] = "%1d",			--Wing/Empennage Ice Protection Switch, OFF/AUTO/ON {-1, 0, 1}
	[382] = "%1d",			--Anti-Ice/De-Ice Switch, ANTI-ICE/DE-ICE {0, 1}
	[378] = "%1d",			--Pilot Pitot Heat Switch, OFF/ON {0, 1}
	[379] = "%1d",			--CoPilot Pitot Heat Switch, OFF/ON {0, 1}
	[380] = "%1d",			--Center NESA Heat Switch, OFF/ON {0, 1}
	[381] = "%1d",			--Side/Lower NESA Heat Switch, OFF/ON {0, 1}
	
	--BLEED AIR PANEL
	[394] = "%1d",			--Left Wing Isolation Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[395] = "%1d",			--Divider Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[396] = "%1d",			--Right Wing Isolation Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[390] = "%1d",			--Engine 1 Nacelle Shutoff Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[391] = "%1d",			--Engine 2 Nacelle Shutoff Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[392] = "%1d",			--Engine 3 Nacelle Shutoff Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	[393] = "%1d",			--Engine 4 Nacelle Shutoff Valve Switch, CLOSE/AUTO/OPEN {-1, 0, 1}
	
	--AIR CONDITIONING PANEL
	[469] = "%1d",			--Underfloor Heat/Fan Switch, FAN/OFF/HEAT-FAN {-1, 0, 1}

	--LANDING GEAR & LIGHTS PANEL
	[126] = "%1d",			--Landing Gear Handle, DOWN/UP {0, 1}
	[32] = "%1d",			--Left Landing Light Switch, OFF/ON {0, 1}
	[33] = "%1d",			--Right Landing Light Switch, OFF/ON {0, 1}
	[30] = "%1d",			--Left Landing Light Motor Switch, RETRACT/HOLD/EXTEND {-1, 0, 1}
	[31] = "%1d",			--Right Landing Light Motor Switch, RETRACT/HOLD/EXTEND {-1, 0, 1}
	[34] = "%1d",			--Taxi Lights Switch, OFF/ON {0, 1}
	[35] = "%1d",			--Wingtip Taxi Lights Switch, OFF/ON {0, 1}
	
	--HYDRAULIC PANEL
	[45] = "%1d",			--Auxiliary Hydraulic Pump Switch, OFF/ON {0, 1}
	[37] = "%1d",			--Anti-Skid Switch, OFF/ON {0, 1}
	
	--RADAR PANEL
	[485] = "%0.1f",		--Radar Master Power Switch, OFF/ON/TEST {0.0, 0.5, 1.0}
	[486] = "%0.2f",		--Radar Master Power Switch, RM/CUR/SYM/VID {0.0, 0.33, 0.66, 1.0}
	
	--PILOT LIGHTING PANEL
	[1337] = "%1d",			--Lighting Mode Master Switch, TSTORM/NORM/NVIS {-1, 0, 1}
	[1335] = "%0.2f",		--Pilot Master Display Brightness Knob, Rotary {0, 1}
	[1340] = "%0.2f",		--Cockpit Dome Lighting Brightness Knob, Rotary {0, 1}
	[1342] = "%0.2f",		--Pilot Panel Backlighting Brightness Knob, Rotary {0, 1}
	[1343] = "%0.2f",		--Pilot Panel Flood Lighting Brightness Knob, Rotary {0, 1}
	[1341] = "%0.2f",		--Pilot Circuit Breaker Lighting Brightness Knob, Rotary {0, 1}
	[1344] = "%0.2f",		--Floor Lighting Brightness Knob, Rotary {0, 1}
	
	--COPILOT LIGHTING PANEL
	[1349] = "%0.2f",		--CoPilot Master Display Brightness Knob, Rotary {0, 1}
	[1347] = "%0.2f",		--Overhead Panel Backlighting Brightness Knob, Rotary {0, 1}
	[1346] = "%0.2f",		--Overhead Panel Flood Lighting Brightness Knob, Rotary {0, 1}
	[1350] = "%0.2f",		--CoPilot Panel Backlighting Brightness Knob, Rotary {0, 1}
	[1351] = "%0.2f",		--CoPilot Panel Flood Lighting Brightness Knob, Rotary {0, 1}
	[1345] = "%0.2f",		--Copilot Circuit Breaker Lighting Brightness Knob, Rotary {0, 1}
	[1348] = "%0.2f",		--Center Console Backlighting Brightness Knob, Rotary {0, 1}
	
	--PILOT ICS CONTROL PANEL
	[293] = "%0.2f",		--Interphone Mode Switch, CALL/INT/VOX/HOT MIC {0.0, 0.33, 0.66, 1.0}
	[294] = "%0.2f",		--Transmission Selector Switch, PA/INT/U1/U2/V1/V2/H1/H2/SAT/PVT {0.0, 0.1 Steps, 1.0}
	[1355] = "%0.2f",		--Master Volume Knob, Rotary {0, 1}
	[1354] = "%0.2f",		--VOX SENS Knob, Rotary {0, 1}
	[1353] = "%0.2f",		--PA GAIN Knob, Rotary {0, 1}
	[204] = "%1d",			--INT Volume Knob, IN/OUT {0, 1}
	[205] = "%0.2f",		--INT Volume Knob, Rotary {0, 1}
	[206] = "%1d",			--H1 Volume Knob, IN/OUT {0, 1}
	[207] = "%0.2f",		--H1 Volume Knob, Rotary {0, 1}
	[208] = "%1d",			--H2 Volume Knob, IN/OUT {0, 1}
	[209] = "%0.2f",		--H2 Volume Knob, Rotary {0, 1}
	[210] = "%1d",			--PA Volume Knob, IN/OUT {0, 1}
	[211] = "%0.2f",		--PA Volume Knob, Rotary {0, 1}
	[212] = "%1d",			--V1 Volume Knob, IN/OUT {0, 1}
	[213] = "%0.2f",		--V1 Volume Knob, Rotary {0, 1}
	[214] = "%1d",			--V2 Volume Knob, IN/OUT {0, 1}
	[215] = "%0.2f",		--V2 Volume Knob, Rotary {0, 1}
	[216] = "%1d",			--SAT Volume Knob, IN/OUT {0, 1}
	[217] = "%0.2f",		--SAT Volume Knob, Rotary {0, 1}
	[218] = "%1d",			--PVT Volume Knob, IN/OUT {0, 1}
	[219] = "%0.2f",		--PVT Volume Knob, Rotary {0, 1}
	[220] = "%1d",			--VOX/HM Volume Knob, IN/OUT {0, 1}
	[221] = "%0.2f",		--VOX/HM Volume Knob, Rotary {0, 1}
	[222] = "%1d",			--U1 Volume Knob, IN/OUT {0, 1}
	[223] = "%0.2f",		--U1 Volume Knob, Rotary {0, 1}
	[224] = "%1d",			--U2 Volume Knob, IN/OUT {0, 1}
	[225] = "%0.2f",		--U2 Volume Knob, Rotary {0, 1}
	
	--COPILOT ICS CONTROL PANEL
	[295] = "%0.2f",		--Interphone Mode Switch, CALL/INT/VOX/HOT MIC {0.0, 0.33, 0.66, 1.0}
	[296] = "%0.2f",		--Transmission Selector Switch, PA/INT/U1/U2/V1/V2/H1/H2/SAT/PVT {0.0, 0.1 Steps, 1.0}
	[1358] = "%0.2f",		--Master Volume Knob, Rotary {0, 1}
	[1357] = "%0.2f",		--VOX SENS Knob, Rotary {0, 1}
	[1356] = "%0.2f",		--PA GAIN Knob, Rotary {0, 1}
	[226] = "%1d",			--INT Volume Knob, IN/OUT {0, 1}
	[227] = "%0.2f",		--INT Volume Knob, Rotary {0, 1}
	[228] = "%1d",			--H1 Volume Knob, IN/OUT {0, 1}
	[229] = "%0.2f",		--H1 Volume Knob, Rotary {0, 1}
	[230] = "%1d",			--H2 Volume Knob, IN/OUT {0, 1}
	[231] = "%0.2f",		--H2 Volume Knob, Rotary {0, 1}
	[232] = "%1d",			--PA Volume Knob, IN/OUT {0, 1}
	[233] = "%0.2f",		--PA Volume Knob, Rotary {0, 1}
	[234] = "%1d",			--V1 Volume Knob, IN/OUT {0, 1}
	[235] = "%0.2f",		--V1 Volume Knob, Rotary {0, 1}
	[236] = "%1d",			--V2 Volume Knob, IN/OUT {0, 1}
	[237] = "%0.2f",		--V2 Volume Knob, Rotary {0, 1}
	[238] = "%1d",			--SAT Volume Knob, IN/OUT {0, 1}
	[239] = "%0.2f",		--SAT Volume Knob, Rotary {0, 1}
	[240] = "%1d",			--PVT Volume Knob, IN/OUT {0, 1}
	[241] = "%0.2f",		--PVT Volume Knob, Rotary {0, 1}
	[242] = "%1d",			--VOX/HM Volume Knob, IN/OUT {0, 1}
	[243] = "%0.2f",		--VOX/HM Volume Knob, Rotary {0, 1}
	[244] = "%1d",			--U1 Volume Knob, IN/OUT {0, 1}
	[245] = "%0.2f",		--U1 Volume Knob, Rotary {0, 1}
	[246] = "%1d",			--U2 Volume Knob, IN/OUT {0, 1}
	[247] = "%0.2f",		--U2 Volume Knob, Rotary {0, 1}
	
	--AFCS PANEL
	[71] = "%0.2f",			--AFCS Pitch Control Wheel, Rotary {0, 1}
	[70] = "%0.2f",			--AFCS Turn Control Knob / Center Detent, Rotary {-1, 1}
	[52] = "%1d",			--Pilot AFCS Engage Switch, DISENGAGE/ENGAGE {0, 1}
	[53] = "%1d",			--Copilot AFCS Engage Switch, DISENGAGE/ENGAGE {0, 1}
	
	--AERIAL DELIVERY PANEL
	[76] = "%1d",			--Chute Release Button Cover, CLOSED/OPEN {0, 1}
	[478] = "%1d",			--Air Deflector Control Switch, CLOSE/OPEN {0, 1}
	[474] = "%0.1f",		--Computer Drop Switch, MANUAL/AD-MAN TJ-AUTO/AUTO {0, 0.5, 1}
	[479] = "%1d",			--Ramp/Door Control Switch, CLOSE/OFF/OPEN {-1, 0, 1}
	[78] = "%1d",			--Cargo Bay Alarm Switch Guard, CLOSE/OFF/OPEN {0, 1}
	
	--TRIM ELEVATOR TAB
	[1334] = "%1d",			--Elevator Trim Tab Power Switch, EMER/OFF/NORM {-1, 0, 1}
	
	--CURSOR CONTROL PANEL
	[65] = "%0.1f",			--Cursor Priority Switch, P/3RD/CP {0, 0.5, 1}
	[72] = "%0.2f",			--Cursor Display Select Switch, 1/2/3/4/OFF/NA/NA {0, 0.16 Steps, 1}
	
	--DEFENSIVE SYSTEMS PANEL
	[59] = "%1d",			--CMS Jettison Switch Guard, CLOSED/OPEN {0, 1}
	[61] = "%1d",			--Defensive Systems Master Switch, STBY/OPR {0, 1}
	[62] = "%1d",			--ECM Master Switch, STBY/OPR {0, 1}
	[63] = "%1d",			--IRCM Master Switch, STBY/OPR {0, 1}
	[64] = "%0.1f",			--MAN PRGMS Switch, 6/5/1-4 {0, 0.5, 1}
	[74] = "%0.2f",			--CMDS Mode Selector, STBY/MAN/SEMI/AUTO/BYP {0, 0.25 Steps, 1}
	
	--FLAPS
	[16] = "%0.2f",			--Flap Control Lever, Slider {0, 0.05 Steps, 1}
	
	--ARC-210 RCU
	[543] = "%0.2f",		--Operational Mode Switch, OFF/TR+G/TR/ADF/CHG PRST/TEST/ZERO(PULL) {0, 0.16 Steps, 1}
	[545] = "%0.2f",		--Frequency Mode Switch, ECCM MASTER/ECCM/PRST/MAN/MAR/243/121(PULL) {0, 0.16 Steps, 1}
	[532] = "%1d",			--Squelch Switch, OFF/ON {-1, 1}
	
	--PILOT REF/MODE SELECT PANEL
	[110] = "%0.1f",		--Pilot Reference Select Switch, HP/RAD ALT/IAS/FPA/MINS {-0.8, -0.4, 0.0, 0.4, 0.8}
	
	--EXTERIOR LIGHTING PANEL
	[424] = "%0.1f",		--Covert/Formation Light Brightness Control, Rotary {0, 1}
	[421] = "%1d",			--Exterior Lighting Master Switch, NORM/COVERT {0, 1}
	[422] = "%1d",			--Navigation Light Mode Switch, STEADY/OFF/FLASH {-1, 0, 1}
	[423] = "%1d",			--Navigation Light Brightness Switch, BRIGHT/DIM {0, 1}
	[418] = "%1d",			--Top Strobe Light Switch, RED/OFF/WHT {-1, 0, 1}
	[419] = "%1d",			--Bottom Strobe Light Switch, RED/OFF/WHT {-1, 0, 1}
	[417] = "%1d",			--Leading Edge Light Switch, OFF/ON {0, 1}
	
	--FADEC PANEL
	[328] = "%1d",			--Engine 1 FADEC Switch Guard, OPEN/CLOSED {0, 1}
	[329] = "%1d",			--Engine 2 FADEC Switch Guard, OPEN/CLOSED {0, 1}
	[330] = "%1d",			--Engine 3 FADEC Switch Guard, OPEN/CLOSED {0, 1}
	[331] = "%1d",			--Engine 4 FADEC Switch Guard, OPEN/CLOSED {0, 1}
	[327] = "%1d",			--ATCS Switch Guard, OPEN/CLOSED {0, 1}
	[416] = "%1d",			--ATCS Switch, OFF/ON {0, 1}
	[372] = "%1d",			--Propeller 1 Control Switch, UNFEATHER/NORM/FEATHER {-1, 0, 1}
	[373] = "%1d",			--Propeller 2 Control Switch, UNFEATHER/NORM/FEATHER {-1, 0, 1}
	[374] = "%1d",			--Propeller 3 Control Switch, UNFEATHER/NORM/FEATHER {-1, 0, 1}
	[375] = "%1d",			--Propeller 4 Control Switch, UNFEATHER/NORM/FEATHER {-1, 0, 1}
	[376] = "%1d",			--Prop Sync Switch, OFF/ON {0, 1}
	
	--PRESSURIZATION PANEL
	[1333] = "%0.2f",		--Pressurization Rate Control Knob, MIN/NORM/MAX {0, continuous, 1}
	[1332] = "%0.2f",		--Pressurization Rate Control Knob, MIN/NORM/MAX {0, continuous, 1}
	[468] = "%0.2f",		--Pressurization Mode Switch, CONST ALT/MAN/AUTO/NO PRESS/AUX VENT {-0.8, -0.4, 0.0, 0.4, 0.8}
	[334] = "%1d",			--Emergency Depressurize Switch Guard, CLOSED/OPEN {0, 1}
	[1363] = "%1d",			--Emergency Depressurize Switch, NORM/DUMP {0, 1}
	
}

-----------------------------
-- HIGH IMPORTANCE EXPORTS --
-- done every export event --
-----------------------------

-- Pointed to by ProcessIkarusDCSHighImportance
function ExportScript.ProcessIkarusDCSConfigHighImportance(mainPanelDevice)
	--[[
	every frame export to Ikarus
	Example from A-10C
	Get Radio Frequencies
	get data from device
	local lUHFRadio = GetDevice(54)
	ExportScript.Tools.SendData("ExportID", "Format")
	ExportScript.Tools.SendData(2000, string.format("%7.3f", lUHFRadio:get_frequency()/1000000)) -- <- special function for get frequency data
	ExportScript.Tools.SendData(2000, ExportScript.Tools.RoundFreqeuncy((UHF_RADIO:get_frequency()/1000000))) -- ExportScript.Tools.RoundFreqeuncy(frequency (MHz|KHz), format ("7.3"), PrefixZeros (false), LeastValue (0.025))
	]]
end

function ExportScript.ProcessDACConfigHighImportance(mainPanelDevice)
	--[[
	every frame export to DAC
	Example from A-10C
	Get Radio Frequencies
	get data from device
	local UHF_RADIO = GetDevice(54)
	ExportScript.Tools.SendDataDAC("ExportID", "Format")
	ExportScript.Tools.SendDataDAC("ExportID", "Format", HardwareConfigID)
	ExportScript.Tools.SendDataDAC("2000", string.format("%7.3f", UHF_RADIO:get_frequency()/1000000))
	ExportScript.Tools.SendDataDAC("2000", ExportScript.Tools.RoundFreqeuncy((UHF_RADIO:get_frequency()/1000000))) -- ExportScript.Tools.RoundFreqeuncy(frequency (MHz|KHz), format ("7.3"), PrefixZeros (false), LeastValue (0.025))
	]]
end

-----------------------------------------------------
-- LOW IMPORTANCE EXPORTS                          --
-- done every gExportLowTickInterval export events --
-----------------------------------------------------

-- Pointed to by ExportScript.ProcessIkarusDCSConfigLowImportance
function ExportScript.ProcessIkarusDCSConfigLowImportance(mainPanelDevice)
	--[[
	export in low tick interval to Ikarus
	Example from A-10C
	Get Radio Frequencies
	get data from device
	local lUHFRadio = GetDevice(54)
	ExportScript.Tools.SendData("ExportID", "Format")
	ExportScript.Tools.SendData(2000, string.format("%7.3f", lUHFRadio:get_frequency()/1000000)) -- <- special function for get frequency data
	ExportScript.Tools.SendData(2000, ExportScript.Tools.RoundFreqeuncy((UHF_RADIO:get_frequency()/1000000))) -- ExportScript.Tools.RoundFreqeuncy(frequency (MHz|KHz), format ("7.3"), PrefixZeros (false), LeastValue (0.025))
	]]
	
	--[[
	local lREFMODE = ExportScript.Tools.getListIndicatorValue(16)
	--ExportScript.Tools.WriteToLog('REF/MODE Select Panel: '..ExportScript.Tools.dump(lREFMODE))
	if lREFMODE ~= nil and lREFMODE.ref_mode_value ~= nil then
		if lREFMODE.ref_symbol_period ~= nil then
			 ExportScript.Tools.SendData(16000, ExportScript.Tools.DisplayFormat(string.format("%s.%s", string.sub(lREFMODE.ref_mode_value, -4,-2), string.sub(lREFMODE.ref_mode_value, -1)), 5))
		else ExportScript.Tools.SendData(16000, ExportScript.Tools.DisplayFormat(lREFMODE.ref_mode_value, 5))
		end
	else ExportScript.Tools.SendData(16000, "null")
	end
	]]
	
	
	
	local lTEMP   
	   
	
	--uncomment to split line list length and values to log
	--[[
	lTEMP = splitLines(list_indication(24))

	ExportScript.Tools.WriteToLog('\nlTEMP Length: ' .. #lTEMP)

	for i=1, #lTEMP, 1 do
		if lTEMP ~= nil and lTEMP[i] ~= nil then
			ExportScript.Tools.WriteToLog('Index:'.. i .. '   Value:' .. lTEMP[i])
		end
	end
	]]
	
	---------- ELECTRICAL PANEL ----------
	lTEMP = splitLines(list_indication(23))
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(23001, lTEMP[2]..lTEMP[3]..lTEMP[4])
	else
		ExportScript.Tools.SendData(23001, "")
	end
	
		---------- BLEED AIR PANEL ----------
	lTEMP = splitLines(list_indication(35))
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(35001, lTEMP[2])
	else
		ExportScript.Tools.SendData(35001, "")
	end
	
		---------- PRESSURIZATION PANEL ----------
	lTEMP = splitLines(list_indication(38)) 		--RATE
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(38001, lTEMP[2])
	else
		ExportScript.Tools.SendData(38001, "")
	end
	
	lTEMP = splitLines(list_indication(39)) 		--CABIN ALT
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(39001, lTEMP[2])
	else
		ExportScript.Tools.SendData(39001, "")
	end
	
	lTEMP = splitLines(list_indication(40)) 		--DIF PRESS
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(40001, lTEMP[2]..lTEMP[3]..lTEMP[4])
	else
		ExportScript.Tools.SendData(40001, "")
	end
	
	lTEMP = splitLines(list_indication(41)) 		--LDG/CONST
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(41001, lTEMP[2])
	else
		ExportScript.Tools.SendData(41001, "")
	end
	
		---------- FUEL PANEL ----------
	lTEMP = splitLines(list_indication(24))			--TOTAL QTY
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(24001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(24001, "")
	end
	
	lTEMP = splitLines(list_indication(25))			--1 Main
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(25001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(25001, "")
	end
	
	lTEMP = splitLines(list_indication(26))			--2 Main
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(26001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(26001, "")
	end
	
	lTEMP = splitLines(list_indication(27))			--3 Main
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(27001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(27001, "")
	end
	
	lTEMP = splitLines(list_indication(28))			--4 Main
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(28001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(28001, "")
	end
	
	lTEMP = splitLines(list_indication(29))			--L AUX
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(29001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(29001, "")
	end
	
	lTEMP = splitLines(list_indication(30))			--R AUX
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(30001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(30001, "")
	end
	
	lTEMP = splitLines(list_indication(31))			--L EXT
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(31001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(31001, "")
	end
	
	lTEMP = splitLines(list_indication(32))			--R EXT
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(32001, lTEMP[3]..'\n'..lTEMP[2])
	else
		ExportScript.Tools.SendData(32001, "")
	end
	
	lTEMP = splitLines(list_indication(42))			--FUEL PRESS
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(42001, lTEMP[2])
	else
		ExportScript.Tools.SendData(42001, "")
	end

		---------- AIR COND PANEL ----------
	lTEMP = splitLines(list_indication(36))			--FLT STA
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(36001, lTEMP[2]..'\n'..lTEMP[3])--ACTUAL/SET
	else
		ExportScript.Tools.SendData(36001, "")	
	end
	
	lTEMP = splitLines(list_indication(37))			--CARGO COMPT
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(37001, lTEMP[2]..'\n'..lTEMP[3])--ACTUAL/SET
	else
		ExportScript.Tools.SendData(37001, "")
	end
	
		---------- HYDRAULIC PANEL ----------
	lTEMP = splitLines(list_indication(43))			--Aux Hydraulic Pressure
	if lTEMP ~= nil then
		ExportScript.Tools.SendData(43001, lTEMP[2])
	else
		ExportScript.Tools.SendData(43001, "")	
	end
	
	
	---------- CNBP ----------
	local lCNBP = splitLines(list_indication(22))
	if lCNBP ~= nil and lCNBP[12] == "COMM" then																--COMM PAGE
		ExportScript.Tools.SendData(22001, "COMM")
		ExportScript.Tools.SendData(22002, string.sub(lCNBP[3], 1, 2) .. "\n" .. string.sub(lCNBP[3], 3))		--L1 = U1 + Freq
		ExportScript.Tools.SendData(22003, string.sub(lCNBP[4], 1, 2) .. "\n" .. string.sub(lCNBP[4], 3))		--L2 = U2 + Freq
		ExportScript.Tools.SendData(22004, string.sub(lCNBP[5], 1, 2) .. "\n" .. string.sub(lCNBP[5], 3))		--L3 = V1 + Freq
		ExportScript.Tools.SendData(22005, string.sub(lCNBP[6], 1, 2) .. "\n" .. string.sub(lCNBP[6], 3))		--l4 = V2 + Freq
		ExportScript.Tools.SendData(22006, string.sub(lCNBP[8], -2) .. "\n" .. string.sub(lCNBP[8], 1, -3))		--R1 = H1 + Freq
		ExportScript.Tools.SendData(22007, string.sub(lCNBP[9],  -2) .. "\n" .. string.sub(lCNBP[9], 1, -3))		--R2 = H2 + Freq
		ExportScript.Tools.SendData(22008, "")																	--R3 = Blank on COMM Page
		ExportScript.Tools.SendData(22009, string.sub(lCNBP[10], 1, 4) .. "\n" .. string.sub(lCNBP[10], 5))		--R4 = CODE + MODE
		
		if lCNBP[11] ~= "" then																					--Scratchpad + Message
			ExportScript.Tools.SendData(22010, lCNBP[7] .. "\n" .. string.sub(lCNBP[11], 1, 7))
		else ExportScript.Tools.SendData(22010, lCNBP[7] .. "\n ")
		end
		
	elseif lCNBP ~= nil and lCNBP[12] == "NAV" then
		ExportScript.Tools.SendData(22001, "NAV")
		ExportScript.Tools.SendData(22002, string.sub(lCNBP[3], 1, 2) .. "\n" .. string.sub(lCNBP[3], 3))		--L1 = V1 + Freq
		ExportScript.Tools.SendData(22003, string.sub(lCNBP[4], 1, 2) .. "\n" .. string.sub(lCNBP[4], 3))		--L2 = V2 + Freq
		ExportScript.Tools.SendData(22004, string.sub(lCNBP[5], 1, 2) .. "\n" .. string.sub(lCNBP[5], 3))		--L3 = T1 + Freq
		ExportScript.Tools.SendData(22005, string.sub(lCNBP[6], 1, 2) .. "\n" .. string.sub(lCNBP[6], 3))		--l4 = T2 + Freq
		ExportScript.Tools.SendData(22006, string.sub(lCNBP[8], -2) .. "\n" .. string.sub(lCNBP[8], 1, -3))		--R1 = A1 + Freq
		ExportScript.Tools.SendData(22007, string.sub(lCNBP[9], -2) .. "\n" .. string.sub(lCNBP[9], 1, -3))		--R2 = A2 + Freq
		ExportScript.Tools.SendData(22008, "")																	--R3 = Blank on NAV Page
		ExportScript.Tools.SendData(22009, string.sub(lCNBP[10], 1, 4) .. "\n" .. string.sub(lCNBP[10], 5))		--R4 = CODE + MODE
		
		if lCNBP[11] ~= "" then																					--Scratchpad + Message
			ExportScript.Tools.SendData(22010, lCNBP[7] .. "\n" .. string.sub(lCNBP[11], 1, 7))
		else ExportScript.Tools.SendData(22010, lCNBP[7] .. "\n ")
		end
		
	elseif lCNBP ~= nil and lCNBP[3] == "ECB" then
		ExportScript.Tools.SendData(22001, "ECB")
		ExportScript.Tools.SendData(22002, lCNBP[5] .. '\n' .. lCNBP[7])									--L1 = HDD Select
		ExportScript.Tools.SendData(22003, lCNBP[8] .. lCNBP[9] .. lCNBP[10] .. "\n" .. lCNBP[12])			--L2 = SYS/BUS/OPEN Select
		ExportScript.Tools.SendData(22004, "")																	--L3 = Blank on ECB Page
		ExportScript.Tools.SendData(22005, lCNBP[13])															--l4 = SELECT
		ExportScript.Tools.SendData(22006, lCNBP[15])															--R1 = RESET
		ExportScript.Tools.SendData(22007, lCNBP[16])															--R2 = PULL
		ExportScript.Tools.SendData(22008, string.sub(lCNBP[17], 1, 4) .. " " .. string.sub(lCNBP[17], -2))		--R3 = PREV PG
		ExportScript.Tools.SendData(22009, string.sub(lCNBP[18], 1, 4) .. " " .. string.sub(lCNBP[18], -2))		--R4 = NEXT PG
		
		if lCNBP[4] ~= "" then																					--Scratchpad + Message
			ExportScript.Tools.SendData(22010, lCNBP[14] .. "\n" .. string.sub(lCNBP[4], 1, 7))
		else ExportScript.Tools.SendData(22010, lCNBP[14] .. "\n ")
		end
		
	else
		for i=1, 10, 1 do
			ExportScript.Tools.SendData(22000 + i, "")
		end
	end
	
	---------- LEFT SEAT AMU ----------
	local lAMUL = splitLines(list_indication(18))
	local lAMUR = splitLines(list_indication(19))
	
	--Left Seat Left AMU
	if lAMUL ~= nil then
		-- STEP 1: Format by page
		if lAMUL[2] == "MAIN MENU" then
			table.insert(lAMUL, 6, "")
		elseif lAMUL[2] == "PFD" then
			lAMUL[3] = "PILOT\n/COPILOT"
			lAMUL[6] = "BARO\nIN/MB"
			lAMUL[10] = "MAG/TRUE\n/GRID"
			lAMUL[15] = "FD\nSOURCE\nP/CP"
			lAMUL[22] = "ATT REF\nINU 1/2"
			lAMUL[26] = "CADC\n1/2"
			lAMUL[30] = "RAD ALT\n1/2"
			table.remove(lAMUL, 29)
			table.remove(lAMUL, 28)
			table.remove(lAMUL, 27)
			table.remove(lAMUL, 25)
			table.remove(lAMUL, 24)
			table.remove(lAMUL, 23)
			table.remove(lAMUL, 21)
			table.remove(lAMUL, 20)
			table.remove(lAMUL, 19)
			table.remove(lAMUL, 18)
			table.remove(lAMUL, 17)
			table.remove(lAMUL, 16)
			table.remove(lAMUL, 14)
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 12)
			table.remove(lAMUL, 11)
			table.remove(lAMUL, 9)
			table.remove(lAMUL, 8)
			table.remove(lAMUL, 7)
			table.remove(lAMUL, 5)
			table.remove(lAMUL, 4)
		elseif lAMUL[2] == "ENGINE" then
			lAMUL[3] = "<ENG\nDIAGNOSTICS"
			lAMUL[5] = "EMS DATA\nDOWNLOAD"
			lAMUL[6] = "EMS EVENT\nRECORD"
			table.insert(lAMUL, 7, "")
			table.insert(lAMUL, 8, "")
		elseif lAMUL[2] == "ENGINE DIAGNOSTICS" then
			table.insert(lAMUL, 5, "")
			table.insert(lAMUL, 7, "")
			table.insert(lAMUL, 8, "")
		elseif lAMUL[2] == "CAPS DISPLAY" then
			lAMUL[3] = "<PFD\nSYMBOLOGY"
			lAMUL[4] = "CENTER\n/UP/DOWN"
			lAMUL[9] = "MAG/TRUE\n/GRID"
			lAMUL[14] = string.gsub(lAMUL[14], " ", "\n", 2)
			table.insert(lAMUL, 14, "")
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 12)
			table.remove(lAMUL, 11)
			table.remove(lAMUL, 10)
			table.remove(lAMUL, 8)
			table.remove(lAMUL, 7)
			table.remove(lAMUL, 6)
			table.remove(lAMUL, 5)
		elseif lAMUL[4] == "NAV-RADAR DISPLAY" then
			lAMUL[5] = "FULL\n/PART"
			lAMUL[8] = "CENTER\n/OFFSET"
			lAMUL[11] = "MAG/TRUE\n/GRID"
			lAMUL[16] = "HDG\n/TK/N"
			table.insert(lAMUL, 21, "RANGE\n"..lAMUL[2])
			table.remove(lAMUL, 20)
			table.remove(lAMUL, 19)
			table.remove(lAMUL, 18)
			table.remove(lAMUL, 17)
			table.remove(lAMUL, 15)
			table.remove(lAMUL, 14)
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 12)
			table.remove(lAMUL, 10)
			table.remove(lAMUL, 9)
			table.remove(lAMUL, 7)
			table.remove(lAMUL, 6)
			table.remove(lAMUL, 2)
			table.remove(lAMUL, 1)
		elseif lAMUL[3] == "NAV-RADAR DISPLAY" then
			lAMUL[4] = "FULL\n/PART"
			lAMUL[7] = "CENTER\n/OFFSET"
			lAMUL[10] = "MAG/TRUE\n/GRID"
			lAMUL[15] = "HDG\n/TK/N"
			table.insert(lAMUL, 20, "RANGE\n".. string.gsub(lAMUL[1], "^RANGE%s*", ""))
			table.remove(lAMUL, 19)
			table.remove(lAMUL, 18)
			table.remove(lAMUL, 17)
			table.remove(lAMUL, 16)
			table.remove(lAMUL, 14)
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 12)
			table.remove(lAMUL, 11)
			table.remove(lAMUL, 9)
			table.remove(lAMUL, 8)
			table.remove(lAMUL, 6)
			table.remove(lAMUL, 5)
			table.remove(lAMUL, 1)
		elseif lAMUL[2] == "SYS STATUS DISPLAY" then
			table.insert(lAMUL, 3, "")
			table.insert(lAMUL, 4, "")
			table.insert(lAMUL, 5, "")
			table.insert(lAMUL, 6, "")
			table.insert(lAMUL, 7, "")
			table.insert(lAMUL, 8, "")
		elseif lAMUL[2] == "DIG MAP DISPLAY" then
			lAMUL[3] = "<MAP\nCOVERAGE"
			lAMUL[4] = "CENTER\n/OFFSET"
			lAMUL[7] = "MAG/TRUE\n/GRID"
			lAMUL[12] = "HDG\n/NORTH\nUP"
			lAMUL[15] = "WHT/YEL\n/MGN/BLK"
			table.remove(lAMUL, 21)
			table.remove(lAMUL, 20)
			table.remove(lAMUL, 19)
			table.remove(lAMUL, 18)
			table.remove(lAMUL, 17)
			table.remove(lAMUL, 16)
			table.remove(lAMUL, 14)
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 11)
			table.remove(lAMUL, 10)
			table.remove(lAMUL, 9)
			table.remove(lAMUL, 8)
			table.remove(lAMUL, 6)
			table.remove(lAMUL, 5)
		elseif lAMUL[4] == "TAWS DISPLAY" then
			lAMUL[5] = "PILOT\n/COPILOT"
			lAMUL[8] = "CENTER\n/OFFSET"
			lAMUL[11] = "MAG/TRUE\n/GRID"
			lAMUL[16] = "HDG/TK"
			table.insert(lAMUL, 19, "RANGE\n"..lAMUL[2])
			table.remove(lAMUL, 18)
			table.remove(lAMUL, 17)
			table.remove(lAMUL, 15)
			table.remove(lAMUL, 14)
			table.remove(lAMUL, 13)
			table.remove(lAMUL, 12)
			table.remove(lAMUL, 10)
			table.remove(lAMUL, 9)
			table.remove(lAMUL, 7)
			table.remove(lAMUL, 6)
			table.remove(lAMUL, 2)
			table.remove(lAMUL, 1)
		elseif lAMUL[2] == "DEFAULTS" then
			lAMUL[4] = "<TAKEOFF\n/APPROACH"
			table.insert(lAMUL, 6, "")
			table.insert(lAMUL, 7, "")
			table.insert(lAMUL, 8, "")
			table.insert(lAMUL, 9, "")
		elseif lAMUL[3] == "NAV SELECT" then
			lAMUL[2] = "NAV SELECT"
			lAMUL[3] = "PILOT\n/COPILOT"
			lAMUL[6] = "SHIP SOLN\nINAV1/2"
			if lAMUR[2] == "POINTER 1" then
				lAMUL[4] = "<PNTR 1\n"..lAMUL[8]
				lAMUL[5] = "<PNTR 2\n"..lAMUL[9]
				lAMUL[7] = "CDI "..	lAMUL[14]
			elseif lAMUR[2] == "POINTER 2" then
				lAMUL[4] = "<PNTR 1\n"..lAMUL[7]
				lAMUL[5] = string.gsub(lAMUL[18], "(.*%d)%s", "%1\n")
				lAMUL[7] = "CDI "..	lAMUL[13]
			elseif lAMUR[2] == "" or lAMUR[2] == "EGI POWER" then
				lAMUL[4] = "<PNTR 1\n"..lAMUL[7]
				lAMUL[5] = "<PNTR 2\n"..lAMUL[8]
				lAMUL[7] = "CDI "..	lAMUL[13]
			else
				lAMUL[4] = "<PNTR 1\n"..lAMUL[7]
				lAMUL[5] = "<PNTR 2\n"..lAMUL[8]
				lAMUL[7] = lAMUL[1]
			end
			lAMUL[8] = ""
			lAMUL[9] = "EGI POWER>"
			lAMUL[10] = "MAIN MENU>"
		elseif lAMUL[2] == "ACAWS" then
			lAMUL[7] = "OVERLOW\nHDD POS>"
			lAMUL[8] = "FAULT LOG\nHDD POS>"
			lAMUL[9] = "ACAWS\nHDD POS>"
		elseif lAMUL[2] == "DIAGNOSTICS" then
			lAMUL[3] = ""
			lAMUL[4] = "<BUS/RT\nSTATUS"
			lAMUL[5] = "<MAINT"
			lAMUL[6] = "<TIME/\nSYS ORDER"
			lAMUL[7] = "SW QUERY\nHDD POS>"
			lAMUL[8] = "BUS/RT\nHDD POS>"
			lAMUL[9] = "MAINT\nHDD POS>"
			lAMUL[10] = "MAIN MENU>"	
		elseif findIndexBySubstring(lAMUL,"LIGHTING")  then
			lAMUL[3] = "<CVRT\nWNGTP/FSLG\n"..string.match(lAMUL[findIndexBySubstring(lAMUL,"<CVRT WNGTP/FSLG%s*%d+")], "%s*(%d+%%).*$")
			lAMUL[4] = "<CVRT TAIL\n"..string.match(lAMUL[findIndexBySubstring(lAMUL,"<CVRT TAIL%s*%d+")], "%s*(%d+%%).*$")
			lAMUL[7] = "CVRT FORM\n"..string.match(lAMUL[findIndexBySubstring(lAMUL,"CVRT FORM%s*%d+")], "%s*(%d+%%>).*$")
			lAMUL[8] = "CVRT FLASH\nRATE  "..(string.match(lAMUL[findIndexBySubstring(lAMUL,"CVRT FLASH RATE%s*%d+")], "%s*(%d+>).*$") or "ERROR")
			lAMUL[5] = "CVRT ANTI\nCOLLISION\n"
			if findIndexBySubstring(lAMUL,"LO") then
				lAMUL[5] = lAMUL[5].."LO"
			elseif findIndexBySubstring(lAMUL,"DIM") then
				lAMUL[5] = lAMUL[5].."DIM"
			elseif findIndexBySubstring(lAMUL,"HI") then
				lAMUL[5] = lAMUL[5].."HI"
			else 
				lAMUL[5] = lAMUL[5].."SCRIPT ERROR"
			end
			lAMUL[2] = "LIGHTING"
			lAMUL[6] = "<INTERIOR\nLTG TRM"
			lAMUL[10] = "MAIN MENU>"
			lAMUL[9] = ""
		elseif lAMUL[2] == "PREFLIGHT" then
			lAMUL[3] = "SMOKE\nDETECTOR"
			lAMUL[4] = "<PROP\nOVRSPD\nGVNR"
			lAMUL[5] = ""
			lAMUL[6] = "<HUD TEST"
			lAMUL[7] = "FIRE\nDETECTION\nTEST"
			lAMUL[8] = "SENSOR\nDATA>"
			lAMUL[9] = "RAMP/DR\nWOW OVRD\nON/OFF"
			lAMUL[10] = "MAIN MENU>"
		elseif lAMUL[2] == "GCAS/TAWS" then
			lAMUL[3] = "NORMAL\nTACTICAL"
			lAMUL[4] = "GS INHIBIT"
			lAMUL[5] = "FLAP INHIBIT"
			lAMUL[6] = "GCAS\nOFF/ON"
			lAMUL[7] = ""
			lAMUL[8] = ""
			lAMUL[9] = "TAWS\nOFF/ON"
			lAMUL[10] = "MAIN MENU>"	
			if findIndexBySubstring(lAMUL,"POPUP") then
				lAMUL[7] = "POPUP\nINHIBIT"
				lAMUL[8] = "TERRAIN\nINHIBIT"
			end
		else
			lAMUL[2] = "SCRIPT\nERROR"
		end
		
		--STEP 2: loop through SendData calls
		for i = 0, 8 do
			ExportScript.Tools.SendData(18000 + i, lAMUL[i+2] or "") -- +2 because formatted AMU lists always starts with title at index 2
		end
		
	else  -- Fallback to empty strings
		ExportScript.Tools.SendData(18000, "SCRIPT\nERROR")
		for i = 1, 8 do
			ExportScript.Tools.SendData(18000 + i, "") 
		end
	end



	--Left Seat Right AMU
	if lAMUR ~= nil then
		-- STEP 1: Format by page
		if lAMUL[2] == "MAIN MENU" and lAMUR[2] == "MAIN MENU" then
			lAMUR[3] = "<NAV\nSELECT"
			lAMUR[9] = "GCAS/TAWS\nAND STALL>"
			table.insert(lAMUR, 8, "")
		elseif lAMUL[2] == "PFD" and lAMUR[2] == "HDD POS" then
			if lAMUR[3] == "HDD 3" then
				table.insert(lAMUR, 3, "")
				table.insert(lAMUR, 4, "")
			else 
				table.insert(lAMUR, 5, "")
				table.insert(lAMUR, 6, "")
			end
		elseif lAMUL[2] == "ENGINE DIAGNOSTICS" then
			if lAMUR[2] == "ENGINE DATA" then
				lAMUR[3] = "PLA/BETA\n".. string.gsub(lAMUR[4], "^%s*%d+%s+(%+%d?%.%d+)%s*%+(%d?%.%d+)", "%1/%2")
				lAMUR[4] = string.gsub(lAMUR[5], "^%s*%d+%s+(%+%d?%.%d+)%s*%+(%d?%.%d+)", "%1/%2")
				lAMUR[5] = string.gsub(lAMUR[6], "^%s*%d+%s+(%+%d?%.%d+)%s*%+(%d?%.%d+)", "%1/%2")
				lAMUR[6] = string.gsub(lAMUR[7], "^%s*%d+%s+(%+%d?%.%d+)%s*%+(%d?%.%d+)", "%1/%2")
				lAMUR[7] = "FIC\nA B"
				lAMUR[8] = "A B"
				lAMUR[9] = "A B"
				lAMUR[10] = "A B"
			elseif lAMUR[2] == "FADEC CALIBRATION" then
				lAMUR[3] = "ENG\n1/2/3/4"
				table.insert(lAMUR, 5, "")
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 7, "")
			elseif lAMUR[2] == "NIU RESET" then
				lAMUR[3] = "ENG\n1/2/3/4"
				table.insert(lAMUR, 4, "")
				table.insert(lAMUR, 5, "")
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 7, "")
				lAMUR[8] = "RESET NIU"
				table.insert(lAMUR, 9, "")
				table.insert(lAMUR, 10, "")
			end
		elseif lAMUL[2] == "CAPS DISPLAY" and lAMUR[2] == "OVERLAYS" then
			lAMUR[6] = "WPT IDS\n& CRS"
			lAMUR[8] = "CLEAR\nALL"
			table.insert(lAMUR, 8, "")
			table.insert(lAMUR, 9, "")
			
		elseif lAMUL[2] == "NAV-RADAR DISPLAY" then
			if lAMUR[2] == "RANGE" then
				lAMUR[10] = "320(64)\n/160(32)"
			elseif lAMUR[2] == "OVERLAYS" then
				lAMUR[6] = "WPT IDS\n& CRS"
				table.insert(lAMUR, 9, "")
			end
		elseif lAMUL[2] == "DIG MAP DISPLAY" then
			if lAMUR[2] == "OVERLAYS" then
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 7, "")
				table.insert(lAMUR, 8, "")
				table.insert(lAMUR, 9, "")
			elseif lAMUR[2] == "MAP COVERAGE" then
				lAMUR[3] = "EMMU\nSLOT 0"
				lAMUR[4] = "EMMU\nSLOT 1"
			end
		elseif lAMUL[2] == "TAWS DISPLAY" then
			if lAMUR[2] == "RANGE" then
				lAMUR[10] = "320(64)\n/160(32)"
			elseif lAMUR[2] == "OVERLAYS" then
				lAMUR[6] = "WPT IDS\n& CRS"
				table.insert(lAMUR, 9, "")
			elseif lAMUR[2] == "HDD POS" then
				if lAMUR[3] == "HDD 3" then
					table.insert(lAMUR, 3, "")
					table.insert(lAMUR, 4, "")
				else 
					table.insert(lAMUR, 5, "")
					table.insert(lAMUR, 6, "")
				end
			end
		elseif lAMUL[2] == "NAV SELECT" then
			if lAMUR[2] == "POINTER 1" or lAMUR[2] == "POINTER 2" then
				table.insert(lAMUR, 9, "")
			elseif lAMUR[2] == "EGI POWER" then
				lAMUR[3] = "MASTER\nEGI OFF"
				lAMUR[4] = "EGI 1\nRECYCLE"
				table.insert(lAMUR, 5, "")
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 7, "")
				lAMUR[8] = "EGI 2\nRECYCLE"
				table.insert(lAMUR, 9, "")
				lAMUR[10] = string.gsub(lAMUR[10], "(VERIFY EGI)%s", "%1\n")
			end
		elseif lAMUL[2] == "ACAWS" then
			if lAMUR[2] == "OVERFLOW" or lAMUR[2] == "FAULT LOG"then
				table.insert(lAMUR, 3, "")
				table.insert(lAMUR, 4, "")
				table.insert(lAMUR, 5, "")
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 7, "")
				table.insert(lAMUR, 8, "")
			elseif lAMUR[2] == "STORE" then
				lAMUR[3] = string.gsub(lAMUR[3], " ", "\n")
				lAMUR[4] = string.gsub(lAMUR[4], " ", "\n")
				lAMUR[5] = string.gsub(lAMUR[5], " ", "\n")
				lAMUR[6] = string.gsub(lAMUR[6], " ", "\n")
				table.insert(lAMUR, 9, "")
				lAMUR[10] = string.gsub(lAMUR[10], " ", "\n")
			end
		elseif findIndexBySubstring(lAMUL,"LIGHTING")  then
			if lAMUR[2] == "COVERT ANTI-COLLISION" then
				lAMUR[7] = "HI/LO/DIM"
				lAMUR[8] = ""
				lAMUR[9] = ""
				lAMUR[10] = ""
			elseif lAMUR[2] == "COVERT FLASH RATE" then
				lAMUR[2] = string.gsub(lAMUR[2], " ", "\n")
				lAMUR[6] = string.gsub(lAMUR[6], " ", "\n")
			end
		elseif lAMUL[2] == "PREFLIGHT" then
			if lAMUR[2] == "SENSOR DATA" then
				lAMUR[7] = string.match(lAMUR[3], "%s*(%d+%.%d%%)")
				lAMUR[8] = string.match(lAMUR[4], "%s*(%d+)")
				lAMUR[9] = string.match(lAMUR[5], "%s*(%d+)")
				lAMUR[3] = "FLAP POSN"
				lAMUR[4] = "AIL UTIL\nPRESS"
				lAMUR[5] = "AIL BOOST\nPRESS"
				lAMUR[6] = ""
			elseif lAMUR[2] == "COVERT FLASH RATE" then
				lAMUR[2] = string.gsub(lAMUR[2], " ", "\n")
				lAMUR[6] = string.gsub(lAMUR[6], " ", "\n")
			elseif lAMUR[2] == "HUD TEST" then
				table.insert(lAMUR, 6, "")
				table.insert(lAMUR, 9, "")
				lAMUR[5] = "PREV\nHUD MENU"
				lAMUR[10] = "EXIT\nHUD TEST"
			end
		elseif lAMUR[2] == "STALL AND SIDESLIP" then
			lAMUR[3] = "STALL WARN\nOFF/ON"
			lAMUR[4] = "PUSHER\nOFF/ON"
			lAMUR[5] = "PUSHER\nTEST"
			lAMUR[6] = ""
			lAMUR[7] = ""
			lAMUR[8] = "VERIFY\nON"
			lAMUR[9] = ""
			lAMUR[10] = "SIDESLIP\nWARN\nOFF/ON"
		else
			lAMUR[2] = "SCRIPT\nERROR"
		end
		
		--STEP 2: loop through SendData calls
		for i = 0, 8 do
			ExportScript.Tools.SendData(19000 + i, lAMUR[i+2] or "") -- +2 because formatted AMU lists always starts with title at index 2
		end
		
	else  -- Fallback to empty strings
		ExportScript.Tools.SendData(19000, "SCRIPT\nERROR")
		for i = 1, 8 do
			ExportScript.Tools.SendData(19000 + i, "") 
		end
	end

	
	
	
	--[[
	if not CNBPinit then
	
		table.sort(lCNBP)
		
		ExportScript.Tools.WriteToLog('CNBP: '..ExportScript.Tools.dump(lCNBP))
		
		local n=0
		for k,v in pairs(lCNBP) do
		  n=n+1
		  keyset[n]=k
		end
		
		ExportScript.Tools.WriteToLog('keyset: '..ExportScript.Tools.dump(keyset))
		ExportScript.Tools.WriteToLog('keyset elements: '..#keyset)
		
		CNBPinit = true
	end
	
	ExportScript.Tools.WriteToLog('\n'..'Sorted CNBP:')
	
	for  i=1, #keyset, 1 do
		ExportScript.Tools.WriteToLog('index: ' .. i .. '   DATA:  ' .. lCNBP(keyset(i)))
	end
	]]
	
    ---------------
    -- Log Dumps --
    ---------------
    --ExportScript.CockpitParamsLogDump(mainPanelDevice)
    --ExportScript.MetaTableLogDump(mainPanelDevice)
    --ExportScript.ListIndicationLogDump(mainPanelDevice)
end

function ExportScript.ProcessDACConfigLowImportance(mainPanelDevice)
	--[[
	export in low tick interval to DAC
	Example from A-10C
	Get Radio Frequencies
	get data from device
	local UHF_RADIO = GetDevice(54)
	ExportScript.Tools.SendDataDAC("ExportID", "Format")
	ExportScript.Tools.SendDataDAC("ExportID", "Format", HardwareConfigID)
	ExportScript.Tools.SendDataDAC("2000", string.format("%7.3f", UHF_RADIO:get_frequency()/1000000))
	ExportScript.Tools.SendDataDAC("2000", ExportScript.Tools.RoundFreqeuncy((UHF_RADIO:get_frequency()/1000000))) -- ExportScript.Tools.RoundFreqeuncy(frequency (MHz|KHz), format ("7.3"), PrefixZeros (false), LeastValue (0.025))
	]]
end

-----------------------------
--     Custom functions    --
-----------------------------

function ExportScript.CockpitParamsLogDump(mainPanelDevice) -- Get list of cockpit params
   ExportScript.Tools.WriteToLog('list_cockpit_params(): '..ExportScript.Tools.dump(list_cockpit_params()))
end

function ExportScript.MetaTableLogDump(mainPanelDevice) -- getmetatable get function name from devices
    local ltmp1 = 0
    for ltmp2 = 1, 100, 1 do
        ltmp1 = GetDevice(ltmp2)
        ExportScript.Tools.WriteToLog(ltmp2..': '..ExportScript.Tools.dump(ltmp1))
        ExportScript.Tools.WriteToLog(ltmp2..' (metatable): '..ExportScript.Tools.dump(getmetatable(ltmp1)))
    end
end

function ExportScript.ListIndicationLogDump(mainPanelDevice) -- list_indication get the value of cockpit displays
    local ltmp1 = 0
    for ltmp2 = 0, 60, 1 do
        ltmp1 = list_indication(ltmp2)
        ExportScript.Tools.WriteToLog(ltmp2..': '..ExportScript.Tools.dump(ltmp1))
    end
end

