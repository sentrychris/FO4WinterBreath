Scriptname WinterBreath extends Quest

; ------------------------------- Properties -------------------------------

Actor Property Player Auto Const

VisualEffect Property WinterBreath1stVFX Auto
VisualEffect Property WinterBreath3rdVFX Auto

int BreathTimer

int[] clearWeatherFormIDs
int[] overcastWeatherFormIDs
int[] rainWeatherFormIDs
int[] fogWeatherFormIDs
int[] radWeatherFormIDs

Group Camera
	bool Property IsFirstPerson Hidden
		bool Function Get()
			return Player.GetAnimationVariableBool("IsFirstPerson")
		EndFunction
	EndProperty
EndGroup

; ------------------------------- Events ------------------------------- 

Event OnInit()
	GoToState("ActiveState")
EndEvent

Event OnTimer(int aiTimerID)
	If aiTimerID == BreathTimer
		If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingEnabled:Main") == true
			If Player.IsInInterior() || !IsWeatherEnabled(Weather.GetCurrentWeather())
				StartTimer(4, BreathTimer)
			Else
				If(IsFirstPerson)
					WinterBreath1stVFX.Play(Player, 2.4)
					WinterBreath1stVFX.Play(Player, 2.2)
					WinterBreath1stVFX.Play(Player, 2.0)
					WinterBreath1stVFX.Play(Player, 1.8)
				Else
					WinterBreath3rdVFX.Play(Player, 2.4)
					WinterBreath3rdVFX.Play(Player, 2.2)
					WinterBreath3rdVFX.Play(Player, 2.0)
					WinterBreath3rdVFX.Play(Player, 1.8)
				EndIf
		
				If Player.IsTalking()
					StartTimer(1, BreathTimer)
				ElseIf Player.IsSprinting()
					StartTimer(0.7, BreathTimer)
				ElseIf Player.IsInCombat() || Player.IsRunning()
					StartTimer(2.5, BreathTimer)
				Else
					StartTimer(4, BreathTimer)
				EndIf
			EndIf
		Else
			StartTimer(4, BreathTimer)
		EndIf
	EndIf
EndEvent

; ------------------------------- Methods -------------------------------

State ActiveState
	Event OnBeginState(string asOldState)
		Debug.Trace("Initiating winter breathing...")
		StartTimer(3, BreathTimer)
	EndEvent
	
	Event OnEndState(string asNewState)
		CancelTimer(BreathTimer)
	EndEvent
EndState


Bool Function IsWeatherEnabled(Weather weatherToCheck)
	int weatherFormID = weatherToCheck.GetFormID()

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherAllEnabled:Main") == true
		Return True
	EndIf

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherClearEnabled:Main") == true
		clearWeatherFormIDs = new int[12]
		clearWeatherFormIDs[0]  = 0x000A1588 ; NeutralWeather
		clearWeatherFormIDs[1]  = 0x0002B52A ; CommonwealthClear
		clearWeatherFormIDs[2]  = 0x002385FD ; CommonwealthClear2
		clearWeatherFormIDs[3]  = 0x002486A4 ; CommonwealthClear_VBFog
		clearWeatherFormIDs[4]  = 0x00216A98 ; CommonwealthClearBackup
		clearWeatherFormIDs[5]  = 0x0023AB9C ; CommonwealthClearBackup2
		clearWeatherFormIDs[6]  = 0x001D670E ; CommonwealthClearestSkies
		clearWeatherFormIDs[7]  = 0x0021A563 ; CommonwealthClearTrailer1
		clearWeatherFormIDs[8]  = 0x0021A564 ; CommonwealthClearTrailer2
		clearWeatherFormIDs[9]  = 0X0012A18E ; CommonwealthSanctuaryClear
		clearWeatherFormIDs[10] = 0x002392A6 ; CommonwealthSanctuaryClearBackup
		clearWeatherFormIDs[11] = 0x00225922 ; CommonwealthSanctuaryClearNoAttach
		clearWeatherFormIDs[12] = 0x001A6994 ; CommonwealthSanctuaryClearNukeFog

		If IsWeatherInList(weatherFormID, clearWeatherFormIDs)
			Return True
		EndIf
	EndIf

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherOvercastEnabled:Main") == true
		overcastWeatherFormIDs = new int[11]
		overcastWeatherFormIDs[0]  = 0x001209AF ; NeutralOvercast
		overcastWeatherFormIDs[1]  = 0x001E5E60 ; CommonwealthDarkSkies
		overcastWeatherFormIDs[2]  = 0X002385FB ; CommonwealthDarkSkies2
		overcastWeatherFormIDs[3]  = 0X00226448 ; CommonwealthDarkSkies3
		overcastWeatherFormIDs[4]  = 0X000F1033 ; CommonwealthGSOvercast
		overcastWeatherFormIDs[5]  = 0X001C8556 ; CommonwealthOvercast
		overcastWeatherFormIDs[6]  = 0X002486A5 ; CommonwealthOvercast_VBFog
		overcastWeatherFormIDs[7]  = 0X0020F46C ; CommonwealthOvercastBackup
		overcastWeatherFormIDs[8]  = 0x0021A564 ; CommonwealthClearTrailer2
		overcastWeatherFormIDs[9]  = 0x001F2529 ; CommOvercastTest2
		overcastWeatherFormIDs[10] = 0X0010F781 ; TCommonwealthMarshOvercast


		If IsWeatherInList(weatherFormID, overcastWeatherFormIDs)
			Return True
		EndIf
	EndIf

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherRainEnabled:Main") == true
		rainWeatherFormIDs = new int[4]
		rainWeatherFormIDs[0] = 0x001CA7E4 ; CommonwealthRain
		rainWeatherFormIDs[1] = 0x0022239A ; CommonwealthRainBackup
		rainWeatherFormIDs[2] = 0x001CD096 ; CommonwealthMistyRainy
		rainWeatherFormIDs[3] = 0x002115D7 ; CommonwealthMistyRainyBackup

		If IsWeatherInList(weatherFormID, rainWeatherFormIDs)
			Return True
		EndIf
	EndIf

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherFogEnabled:Main") == true
		fogWeatherFormIDs = new int[7]
		fogWeatherFormIDs[0] = 0X001C3473 ; CommonwealthFoggy
		fogWeatherFormIDs[1] = 0X002392A2 ; CommonwealthFoggyBackup
		fogWeatherFormIDs[2] = 0X001BD481 ; CommonwealthGSFoggy
		fogWeatherFormIDs[3] = 0X002392A4 ; CommonwealthGSFoggyBackup
		fogWeatherFormIDs[4] = 0X001CC186 ; CommonwealthMisty
		fogWeatherFormIDs[5] = 0X002392A5 ; CommonwealthMistyBackup
		fogWeatherFormIDs[6] = 0x001F61A1 ; CommonwealthDusty


		If IsWeatherInList(weatherFormID, fogWeatherFormIDs)
			Return True
		EndIf
	EndIf

	If MCM.GetModSettingBool("WinterBreathing", "bWinterBreathingWeatherRadEnabled:Main") == true
		radWeatherFormIDs = new int[6]
		radWeatherFormIDs[0] = 0X001C3D5E ; CommonwealthGSRadstorm
		radWeatherFormIDs[1] = 0x002392A3 ; CommonwealthGSRadstormBackup
		radWeatherFormIDs[2] = 0x00222394 ; CommonwealthGSRadtsormOld
		radWeatherFormIDs[3] = 0x001EB2FF ; CommonwealthPolluted
		radWeatherFormIDs[4] = 0X001CC186 ; CommonwealthMisty
		radWeatherFormIDs[5] = 0X002392A5 ; CommonwealthMistyBackup

		If IsWeatherInList(weatherFormID, radWeatherFormIDs)
			Return True
		EndIf
	EndIf

	Return False
EndFunction

Bool Function IsWeatherInList(int weatherFormID, int[] weatherFormIDs)
	int i = 0

	While i < weatherFormIDs.Length
		If weatherFormID == weatherFormIDs[i]
				Return True
		EndIf
		i += 1
	EndWhile

	Return False
EndFunction