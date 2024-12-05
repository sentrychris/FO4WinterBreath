Scriptname WinterBreath extends Quest

; ------------------------------- Properties -------------------------------

Actor Property Player Auto Const

VisualEffect Property WinterBreath1stVFX Auto
VisualEffect Property WinterBreath3rdVFX Auto

int BreathTimer

int[] clearWeatherFormIDs

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
			If Player.IsInInterior() || IsClearWeather(Weather.GetCurrentWeather())
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

Bool Function IsClearWeather(Weather weatherToCheck)
	clearWeatherFormIDs = new int[8]
	clearWeatherFormIDs[0] = 0x0002B52A ; CommonwealthClear
	clearWeatherFormIDs[1] = 0x002385FD ; CommonwealthClear_VBFog
	clearWeatherFormIDs[2] = 0x002486A4 ; CommonwealthClear2
	clearWeatherFormIDs[3] = 0x00216A98 ; CommonwealthClearBackup
	clearWeatherFormIDs[4] = 0x0023AB9C ; CommonwealthClearBackup2
	clearWeatherFormIDs[5] = 0x001D670E ; CommonwealthClearestSkies
	clearWeatherFormIDs[6] = 0x0021A563 ; CommonwealthClearTrailer1
	clearWeatherFormIDs[7] = 0x0021A564 ; CommonwealthClearTrailer2
	
	int weatherFormID = weatherToCheck.GetFormID()
	
	int i = 0
	While i < clearWeatherFormIDs.Length
		Bool Valid = True
		
		If !clearWeatherFormIDs[i]
			Valid = False
		EndIf
		
		If Valid && weatherFormID == clearWeatherFormIDs[i]
			Return True
		EndIf
		
		i += 1
	EndWhile
	
	Return False
EndFunction