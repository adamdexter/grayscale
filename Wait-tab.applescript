-- Grayscale Toggle Script
-- Supports macOS 10.14 Mojave through macOS 15.x Sequoia
-- Uses silent Python-based toggle when available (no UI popup)

tell application "Finder" to set vv to version

if vv < 10.14 then
	display dialog "Grayscale is not compatible with macOS versions before Mojave 10.14"
else
	-- Try silent Python-based toggle first (works on macOS 10.14+)
	-- This uses the UniversalAccess private framework and requires no UI
	set pythonToggle to "from ctypes import cdll; lib = cdll.LoadLibrary('/System/Library/PrivateFrameworks/UniversalAccess.framework/UniversalAccess'); lib.UAGrayscaleSetEnabled(lib.UAGrayscaleIsEnabled() == 0)"

	set pythonSuccess to false

	-- Try python3 from various locations
	try
		do shell script "/usr/bin/python3 -c " & quoted form of pythonToggle
		set pythonSuccess to true
	end try

	if not pythonSuccess then
		try
			do shell script "/usr/local/bin/python3 -c " & quoted form of pythonToggle
			set pythonSuccess to true
		end try
	end if

	if not pythonSuccess then
		try
			do shell script "/opt/homebrew/bin/python3 -c " & quoted form of pythonToggle
			set pythonSuccess to true
		end try
	end if

	-- Fallback to GUI scripting if Python approach failed
	if not pythonSuccess then
		if vv < 13 then
			-- macOS 10.14 - 12.x (Mojave through Monterey) - uses System Preferences
			tell application "System Preferences"
				set the current pane to pane id "com.apple.preference.universalaccess"
				delay 0.7
				tell application "System Events" to tell process "System Preferences" to tell window "Accessibility"
					select row 5 of table 1 of scroll area 1
					click radio button "Color Filters" of tab group 1 of group 1
					click checkbox "Enable Color Filters" of tab group 1 of group 1
				end tell
			end tell
			tell application "System Preferences" to quit
		else
			-- macOS 13+ (Ventura, Sonoma, Sequoia) - uses System Settings
			do shell script "open -b com.apple.systempreferences /System/Library/PreferencePanes/UniversalAccessPref.prefPane"

			tell application "System Events"
				tell its application process "System Settings"
					-- Wait for System Settings to load
					set maxWait to 50 -- 5 seconds max
					set waited to 0

					repeat while waited < maxWait
						try
							-- Try to find the Color Filters checkbox in different UI structures
							-- macOS 15.x Sequoia structure
							if exists (checkbox 1 of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1) then
								click checkbox 1 of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1
								exit repeat
							end if
							-- Alternative Sequoia structure
							if exists (checkbox 1 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1) then
								click checkbox 1 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window 1
								exit repeat
							end if
							-- macOS 14.x Sonoma structure
							if exists (checkbox 1 of group 4 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Display") then
								click checkbox 1 of group 4 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Display"
								exit repeat
							end if
							-- macOS 13.x Ventura structure - navigate from Accessibility to Display first
							if exists (UI element 3 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Accessibility") then
								click UI element 3 of group 1 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Accessibility"
								delay 0.3
							end if
						end try
						delay 0.1
						set waited to waited + 1
					end repeat
				end tell
			end tell
			tell application "System Settings" to quit
		end if
	end if
end if
