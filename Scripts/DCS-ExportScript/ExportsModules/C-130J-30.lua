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
				--line = line:gsub(":", "%%3A") uncomment if colons cause problems in output
				--line = line:gsub("°", "*")  uncomment if degrees cause problems in output
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
			ExportScript.Tools.WriteToLog("findIndexBySubstring Returned "..i)
			return i 
		end 
	end
	ExportScript.Tools.WriteToLog("findIndexBySubstring Returned nil")
    return nil -- Returns nil if the substring isn't found anywhere
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
}
ExportScript.ConfigArguments = 
{
	--[[
	arguments for export in low tick interval
	based on "clickabledata.lua"
	]]
	
	--FIRE HANDLES
	[314] = "%1d",			--Engine 1 Fire Handle, push/pull {0,1}
	[315] = "%0.1f",		--Engine 1 Fire Handle, CCW/NORM/CW {-0.5, 0.0, 0.5}
	[316] = "%1d",			--Engine 2 Fire Handle, push/pull {0,1}
	[317] = "%0.1f",		--Engine 2 Fire Handle, CCW/NORM/CW {-0.5, 0.0, 0.5}
	[318] = "%1d",			--Engine 3 Fire Handle, push/pull {0,1}
	[319] = "%0.1f",		--Engine 3 Fire Handle, CCW/NORM/CW {-0.5, 0.0, 0.5}
	[320] = "%1d",			--Engine 4 Fire Handle, push/pull {0,1}
	[321] = "%0.1f",		--Engine 4 Fire Handle, CCW/NORM/CW {-0.5, 0.0, 0.5}
	
	--ENGINE PANEL
	[310] = "%0.2f",			--Engine 1 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[311] = "%0.2f",			--Engine 2 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[312] = "%0.2f",			--Engine 3 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	[313] = "%0.2f",			--Engine 4 Start Switch, MOTOR/STOP/RUN/START {-0.33, 0.00, 0.50, 1.00}
	
	[46] = "%1d",			--Engine 1 LSGI Switch
	[47] = "%1d",			--Engine 2 LSGI Switch
	[48] = "%1d",			--Engine 3 LSGI Switch
	[49] = "%1d",			--Engine 4 LSGI Switch
	
	[19] = "%1d",			--Autothrottle Disconnect Button Left
	[20] = "%1d",			--Autothrottle Disconnect Button Right
	
	--LANDING GEAR LIGHTS PANEL
	[126] = "%1d",			--Gear Handle
	[36] = "%1d",			--Down Lock Release
	[32] = "%1d",			--Landing Light Switch Left
	[33] = "%1d",			--Landing Light Switch Right
	[30] = "%1d",			--Landing Light Motor Switch Left, EXTEND/HOLD/RETRACT {-1.0, 0.0, 1.0}
	[31] = "%1d",			--Landing Light Motor Switch Right, EXTEND/HOLD/RETRACT {-1.0, 0.0, 1.0}
	[34] = "%1d",			--Taxi Light Switch
	[35] = "%1d",			--Wingtip Taxi Light Switch
	
	--AMU PANEL
	[116] = "%1d",			--HDD 1 Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	[117] = "%1d",			--HDD 2 Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	[118] = "%1d",			--HDD 3 Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	[119] = "%1d",			--HDD 4 Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	
	[200] = "%1d",			--Pilot AMU Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	[202] = "%1d",			--CoPilot AMU Brightness, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	
	[133] = "%1d",			--Pilot left AMU LSK L1
	[134] = "%1d",			--Pilot left AMU LSK L2
	[135] = "%1d",			--Pilot left AMU LSK L3
	[136] = "%1d",			--Pilot left AMU LSK L4
	[137] = "%1d",			--Pilot left AMU LSK R1
	[138] = "%1d",			--Pilot left AMU LSK R2
	[139] = "%1d",			--Pilot left AMU LSK R3
	[140] = "%1d",			--Pilot left AMU LSK R4
	
	[141] = "%1d",			--Pilot Right AMU LSK L1
	[142] = "%1d",			--Pilot Right AMU LSK L2
	[143] = "%1d",			--Pilot Right AMU LSK L3
	[144] = "%1d",			--Pilot Right AMU LSK L4
	[145] = "%1d",			--Pilot Right AMU LSK R1
	[146] = "%1d",			--Pilot Right AMU LSK R2
	[147] = "%1d",			--Pilot Right AMU LSK R3
	[148] = "%1d",			--Pilot Right AMU LSK R4
	
	[174] = "%1d",			--CoPilot left AMU LSK L1
	[175] = "%1d",			--CoPilot left AMU LSK L2
	[176] = "%1d",			--CoPilot left AMU LSK L3
	[177] = "%1d",			--CoPilot left AMU LSK L4
	[178] = "%1d",			--CoPilot left AMU LSK R1
	[179] = "%1d",			--CoPilot left AMU LSK R2
	[180] = "%1d",			--CoPilot left AMU LSK R3
	[181] = "%1d",			--CoPilot left AMU LSK R4
	
	[182] = "%1d",			--CoPilot Right AMU LSK L1
	[183] = "%1d",			--CoPilot Right AMU LSK L2
	[184] = "%1d",			--CoPilot Right AMU LSK L3
	[185] = "%1d",			--CoPilot Right AMU LSK L4
	[186] = "%1d",			--CoPilot Right AMU LSK R1
	[187] = "%1d",			--CoPilot Right AMU LSK R2
	[188] = "%1d",			--CoPilot Right AMU LSK R3
	[189] = "%1d",			--CoPilot Right AMU LSK R4
	
	--COMM NAV ECB PANEL
	[159] = "%1d",			--CNBP COMM Key
	[160] = "%1d",			--CNBP NAV Key
	[161] = "%1d",			--CNBP ECB Key
	
	[151] = "%1d",			--CNBP LSK L1
	[152] = "%1d",			--CNBP LSK L2
	[153] = "%1d",			--CNBP LSK L3
	[154] = "%1d",			--CNBP LSK L4
	[155] = "%1d",			--CNBP LSK R1
	[156] = "%1d",			--CNBP LSK R2
	[157] = "%1d",			--CNBP LSK R4
	[158] = "%1d",			--CNBP LSK R5
	
	[162] = "%1d",			--CNBP 1 Key
	[163] = "%1d",			--CNBP 2 Key
	[164] = "%1d",			--CNBP 3 Key
	[165] = "%1d",			--CNBP 4 Key
	[166] = "%1d",			--CNBP 5 Key
	[167] = "%1d",			--CNBP 6 Key
	[168] = "%1d",			--CNBP 7 Key
	[169] = "%1d",			--CNBP 8 Key
	[170] = "%1d",			--CNBP 9 Key
	[171] = "%1d",			--CNBP Decimal Key
	[172] = "%1d",			--CNBP 0 Key
	
	[173] = "%1d",			--CNBP CLR Key
	[201] = "%1d",			--CNBP Brightness Rocker, DECREASE/NEUTRAL/INCREASE {-1, 0, 1}
	
	--Pilot CNI-MU Panel
	[1100] = "%1d",			--Pilot CNI-MU LSK L1
	[1101] = "%1d",			--Pilot CNI-MU LSK L2
	[1102] = "%1d",			--Pilot CNI-MU LSK L3
	[1103] = "%1d",			--Pilot CNI-MU LSK L4
	[1104] = "%1d",			--Pilot CNI-MU LSK L5
	[1105] = "%1d",			--Pilot CNI-MU LSK L6
	[1106] = "%1d",			--Pilot CNI-MU LSK R1
	[1107] = "%1d",			--Pilot CNI-MU LSK R2
	[1108] = "%1d",			--Pilot CNI-MU LSK R3
	[1109] = "%1d",			--Pilot CNI-MU LSK R4
	[1110] = "%1d",			--Pilot CNI-MU LSK R5
	[1111] = "%1d",			--Pilot CNI-MU LSK R6
	
	[1112] = "%1d",			--Pilot CNI-MU COMM TUNE Key
	[1113] = "%1d",			--Pilot CNI-MU NAV TUNE Key
	[1114] = "%1d",			--Pilot CNI-MU IFF Key
	[1115] = "%1d",			--Pilot CNI-MU NAV CTRL Key
	[1116] = "%1d",			--Pilot CNI-MU MSN Key
	[1117] = "%1d",			--Pilot CNI-MU DIR INTC Key
	[1118] = "%1d",			--Pilot CNI-MU TOLD Key
	[1119] = "%1d",			--Pilot CNI-MU INDX Key
	[1120] = "%1d",			--Pilot CNI-MU MC INDX TUNE Key
	[1121] = "%1d",			--Pilot CNI-MU CAPS Key
	[1122] = "%1d",			--Pilot CNI-MU EXEC Key
	[1123] = "%1d",			--Pilot CNI-MU LEGS Key
	[1124] = "%1d",			--Pilot CNI-MU MARK Key
	[1125] = "%1d",			--Pilot CNI-MU PREV PAGE Key
	[1126] = "%1d",			--Pilot CNI-MU NEXT PAGE Key
	[1127] = "%0.1f",		--Pilot CNI-MU Brightness Rocker, DECREASE/NEUTRAL/INCREASE {0, 0.5, 1}
	
	[1137] = "%1d",			--Pilot CNI-MU 0 Key
	[1128] = "%1d",			--Pilot CNI-MU 1 Key
	[1129] = "%1d",			--Pilot CNI-MU 2 Key
	[1130] = "%1d",			--Pilot CNI-MU 3 Key
	[1131] = "%1d",			--Pilot CNI-MU 4 Key
	[1132] = "%1d",			--Pilot CNI-MU 5 Key
	[1133] = "%1d",			--Pilot CNI-MU 6 Key
	[1134] = "%1d",			--Pilot CNI-MU 7 Key
	[1135] = "%1d",			--Pilot CNI-MU 8 Key
	[1136] = "%1d",			--Pilot CNI-MU 9 Key
	[1138] = "%1d",			--Pilot CNI-MU Decimal Key
	[1139] = "%1d",			--Pilot CNI-MU Minus Key

	[1140] = "%1d",			--Pilot CNI-MU A Key
	[1141] = "%1d",			--Pilot CNI-MU B Key
	[1142] = "%1d",			--Pilot CNI-MU C Key
	[1143] = "%1d",			--Pilot CNI-MU D Key
	[1144] = "%1d",			--Pilot CNI-MU E Key
	[1145] = "%1d",			--Pilot CNI-MU F Key
	[1146] = "%1d",			--Pilot CNI-MU G Key
	[1147] = "%1d",			--Pilot CNI-MU H Key
	[1148] = "%1d",			--Pilot CNI-MU I Key
	[1149] = "%1d",			--Pilot CNI-MU J Key
	[1150] = "%1d",			--Pilot CNI-MU K Key
	[1151] = "%1d",			--Pilot CNI-MU L Key
	[1152] = "%1d",			--Pilot CNI-MU M Key
	[1153] = "%1d",			--Pilot CNI-MU N Key
	[1154] = "%1d",			--Pilot CNI-MU O Key
	[1155] = "%1d",			--Pilot CNI-MU P Key
	[1156] = "%1d",			--Pilot CNI-MU Q Key
	[1157] = "%1d",			--Pilot CNI-MU R Key
	[1158] = "%1d",			--Pilot CNI-MU S Key
	[1159] = "%1d",			--Pilot CNI-MU T Key
	[1160] = "%1d",			--Pilot CNI-MU U Key
	[1161] = "%1d",			--Pilot CNI-MU V Key
	[1162] = "%1d",			--Pilot CNI-MU W Key
	[1163] = "%1d",			--Pilot CNI-MU X Key
	[1164] = "%1d",			--Pilot CNI-MU Y Key
	[1165] = "%1d",			--Pilot CNI-MU Z Key
	[1167] = "%1d",			--Pilot CNI-MU DEL Key
	[1169] = "%1d",			--Pilot CNI-MU CLR Key
	[1166] = "%1d",			--Pilot CNI-MU Unused Key
	[1168] = "%1d",			--Pilot CNI-MU Slash Key
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
	
	
	
	   
	   
	--uncomment to split line list length and values to log
	
	local lTEST = splitLines(list_indication(18))
	--ExportScript.Tools.WriteToLog(ExportScript.Tools.dump(lTEST))
	--[[
	local lParams = list_cockpit_params()
	ExportScript.Tools.WriteToLog("MASTER_AV_STATE - "..getIndexValue(lParams, "MASTER_AV_STATE"))
	ExportScript.Tools.WriteToLog("AUTONAV_STATE - "..getIndexValue(lParams, "AUTONAV_STATE"))
	ExportScript.Tools.WriteToLog(lParams)
	]]
	--ExportScript.Tools.WriteToLog('TEST: '..ExportScript.Tools.dump(list_indication(22)))		--uncomment to output to log raw list before splitting lines
	
	ExportScript.Tools.WriteToLog('\nlTEST Length: ' .. #lTEST)

	for i=1, #lTEST, 1 do
		if lTEST ~= nil and lTEST[i] ~= nil then
			ExportScript.Tools.WriteToLog('Index:'.. i .. '   Value:' .. lTEST[i])
		end
	end
	lTEST = splitLines(list_indication(19))
	for i=1, #lTEST, 1 do
		if lTEST ~= nil and lTEST[i] ~= nil then
			ExportScript.Tools.WriteToLog('Index:'.. i .. '   Value:' .. lTEST[i])
		end
	end
	
	
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
	
	--Pilot AMU
	local lAMUL = splitLines(list_indication(18))
	local lAMUR = splitLines(list_indication(19))
	
	--Left AMU
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



	--Right AMU
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

