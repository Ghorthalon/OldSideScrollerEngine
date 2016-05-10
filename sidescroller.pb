InitSound()
InitKeyboard()
InitSprite()
;TTSInit(0,0,0)
EnableExplicit
Structure Teleporter
  Active.l
  x.f
  OnMove.l
  OnTime.l
  TimeOut.l
  Timer.l
  Where.s  
EndStructure
Structure Music
  volume.l
  file.s
  id.l
  playing.l
  Active.l  
EndStructure
Structure CutSceneItem
  active.l
  file.s
  x.f
  OnMovement.l
  OnTime.l
  Timer.l
  TimeOut.l
  ID.l  
EndStructure
Structure player
  x.f
  jumping.l
  Jumptime.l
  JumpTimer.l
  attacking.l
  speed.f
  StepSpeed.l 
  StepCounter.l
  health.l
  running.l
  RunTimer.l
  RunFactor.f
  direction.l
  sounds.l[20]
EndStructure
Structure Weapon
  ammo.l
  range.l
  active.l
  sounds.l[20]
  Damage.l
  firerate.l
EndStructure 
Structure Mob
  x.f
  speed.f
  StepSpeed.l
  StepCounter.l
  jumping.l
  type.l
  attacking.l
  running.l
  health.l
  direction.l
  friendly.l
  active.l
  sounds.l[20]
EndStructure
Structure MapItem
  x.f
  type.l
  InstaDeath.l
  passable.l
  jumpable.l
  
EndStructure
Structure obsticle
  x.f
  InstaDeath.l
  HealthTake.l
  active.l
  ActiveDistance.l
  sounds.l[20]
EndStructure
Structure AmbienceItem
  x.f
  sound.l
  playing.l
  Distance.l  
  Stationary.l  
EndStructure
Global folder$ = "Data/Stories/Test"
Global Music.music

Global Teleporter.Teleporter
Global Dim cutscenes.cutsceneitem(1000)
Global me.player
Global TempX.f = 0
Global Story$ = "test"
Global I = 0
Global J = 0
Global config_PanStep = 10
Global Config_VolumeStep = 20
Global Dim Map.MapItem(1000)
Global Dim Obsticles.obsticle(1000)
Global Dim Ambience.ambienceItem(1000)
Global Dim AI.mob(1000)

Global FPSTimer = 0
Global delta_x.f=0;

Global final_pan.f=0;
Global final_volume.f=100
Global NewMap KeysPressed()

me\attacking = 0
me\direction = 1
me\health = 100
me\jumping = 0
me\Jumptime = 1000
me\running = 0
me\speed = 0.05
me\stepspeed = 30
me\x = 1
me\RunFactor = 2


Declare HandleTeleporter()
Declare ReInitVars()

Declare CharacterDie()
Declare CharacterHurt(Amount.l)
Declare PlayCutScene(*value.cutsceneItem)
Declare HandleCharacter()
Declare HandlePositions()
Declare HandleCutScenes()
Declare Distance(X1.f, X2.f, range.f)
Declare HandleInput()
Declare KeyboardPressed(x)
Declare HandleMenu()
Declare GameLoop()
Declare LoadMap(filename$)

Declare Move(direction.l)
Declare MoveLeft()
Declare MoveRight()
Declare InitiateJump()
Declare HandleAI()
Declare generate_pan(Listener_X.f, source_X.f, PanStep.f, VolumeStep.f, SoundHandle.l)
Declare Showmenu(file.s, Music2Play.s)
Declare ShowText(Text.s, Music2Play.s)
Declare ReadMenu()
Declare RenderWorld_()
Declare InitGame()
Declare FreeGameMap()
Procedure ReInitVars()
  Global folder$ = "Data/Stories/Test"
  Global Music.music
  
  Global Dim cutscenes.cutsceneitem(1000)
  Global me.player
  Global TempX.f = 0
  Global Story$ = "test"
  Global I = 0
  Global J = 0
  Global config_PanStep = 5
  Global Config_VolumeStep = 5
  Global Dim Map.MapItem(1000)
  Global Dim Obsticles.obsticle(1000)
  Global Dim Ambience.ambienceItem(1000)
  Global Dim AI.mob(1000)
  
  Global FPSTimer = 0
  Global delta_x.f=0;
  
  Global final_pan.f=0;
  Global final_volume.f=100
  Global NewMap KeysPressed()
  
  me\attacking = 0
  me\direction = 1
  me\health = 100
  me\jumping = 0
  me\Jumptime = 1000
  me\running = 0
  me\speed = 0.05
  me\stepspeed = 30
  me\x = 1
  me\RunFactor = 2
EndProcedure
Procedure generate_pan(Listener_X.f, source_X.f, PanStep.f, VolumeStep.f, SoundHandle.l)
  delta_x.f=0;
  
  final_pan.f=0;
  final_volume.f=100
  If source_x<listener_x
    
    delta_x=listener_x-source_x;
    final_pan=Final_Pan-(delta_x*panstep);
    final_volume=final_volume-(delta_x*volumestep);
  EndIf
  If source_x>listener_x
    
    delta_x=source_x-listener_x;
    final_pan=Final_Pan+(delta_x*panstep);
    final_volume=final_volume-(delta_x*volumestep);
    
  EndIf
  
  
  If final_volume < 0 : final_volume = 0 : EndIf
  If final_pan < -100 : final_pan = -100 : EndIf
  If final_pan > 100 : final_pan = 100 : EndIf
  
  SoundVolume(SoundHandle, Final_Volume)
  SoundPan(SoundHandle, Final_Pan)
  
EndProcedure
Procedure ShowMenu(file.s, Music2Play.s)
  Global MOpen = LoadSound(#PB_Any, Folder$ + "/Sounds/menu/M_Open.wav")
  PlaySound(MOpen)
  Global MClick = LoadSound(#PB_Any, Folder$ + "/Sounds/Menu/M_Click.wav")
  Global MSelect = LoadSound(#PB_Any, Folder$ + "//Sounds/Menu/M_Select.wav")
  Global MUnavailable = LoadSound(#PB_Any, Folder$ + "/Sounds/Menu/M_Unavailable.wav")
  Global MWrap = LoadSound(#PB_Any, Folder$ + "/Sounds/Menu/M_Wrap.wav")
  ;Global tempMusic = LoadSound(#PB_Any, "sounds/music/" + Music2Play + ".wav")
  ;PlaySound(TempMusic, #PB_Sound_Loop)
  ;SoundVolume(TempMusic, 25)
  
  
  Global TempFile = ReadFile(#PB_Any, "data/Stories/" + Story$ +"/menu/" + file + ".mnu")
  Global MenuName$ = ReadString(tempFile)
  Global Dim Items.s(1000)
  Global TempString$ = ""
  Global Menupos = 0
  Global FoundItems = 0
  Repeat
    
    Menupos + 1
    FoundItems + 1
    Items(menupos) = ReadString(TempFile)
  Until Eof(TempFile)
  
  ;TTSSpeak(MenuName$)
  Menupos = 0
  Repeat
    
    ExamineKeyboard()
    
    
    WaitWindowEvent(1)  
    
    
    
    If GetActiveWindow() <> -1
      
      
      ;If KeyboardPushed(#PB_Key_PageUp) : If MusicVolume < 100 : MusicVolume + 1 : SoundVolume(Tempmusic, MusicVolume) : EndIf : EndIf
      ;If KeyboardPushed(#PB_Key_PageDown) : If MusicVolume > 0 : MusicVolume - 1 : SoundVolume(Tempmusic, MusicVolume) : EndIf : EndIf
      If KeyboardPressed(#PB_Key_Down)
        If Menupos < FoundItems
          Menupos + 1 
        Else
          PlaySound(MWrap)
          MenuPos = 1
        EndIf
        PlaySound(MClick)
        readMenu()
      EndIf
      If KeyboardPressed(#PB_Key_Up)
        If Menupos > 1
          Menupos - 1 
        Else
          PlaySound(MWrap)
          MenuPos = FoundItems
        EndIf
        PlaySound(MClick)  
        ReadMenu()
        
      EndIf
      If KeyboardPressed(#PB_Key_Home) : PlaySound(MWrap) : MenuPos = 1 : ReadMenu() : EndIf
      If KeyboardPressed(#PB_Key_End) : PlaySound(MWrap) : MenuPos = FoundItems : ReadMenu() : EndIf
      If KeyboardPressed(#PB_Key_1) : If FoundItems => 1 : PlaySound(MClick) : MenuPos = 1 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_2) : If FoundItems => 2 : PlaySound(MCLick) : MenuPos = 2 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_3) : If FoundItems => 3 : PlaySound(MClick) : MenuPos = 3 : ReadMenu() : EndIf : EndIf
      
      If KeyboardPressed(#PB_Key_4) : If FoundItems => 4 : PlaySound(MClick) : MenuPos = 4 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_5) : If FoundItems => 5 : PlaySound(MClick) : MenuPos = 5 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_6) : If FoundItems => 6 : PlaySound(MClick) : MenuPos = 6 : ReadMenu() : EndIf : EndIf
      
      If KeyboardPressed(#PB_Key_7) : If FoundItems => 7 : PlaySound(MClick) : MenuPos = 7 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_8) : If FoundItems => 8  : PlaySound(MClick) : MenuPos = 8 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_9) : If FoundItems => 9 : PlaySound(MClick) : MenuPos = 9 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_0) : If FoundItems => 10 : PlaySound(MClick) : MenuPos = 10 : ReadMenu() : EndIf : EndIf
      If KeyboardPressed(#PB_Key_Return) And menuPos > 0 : 
        PlaySound(MSelect) 
        ;StopSound(TempMusic)
        
        Delay(1000)
        FreeSound(MOpen)
        FreeSound(MClick)
        FreeSound(MSelect)
        
      ProcedureReturn Menupos : EndIf
    EndIf            
    Delay(16)  
  ForEver
EndProcedure

Procedure ReadMenu()
  ;TTSStop()
  ;TTSSpeak(Items(Menupos))
EndProcedure
Procedure KeyboardPressed(x)
  If KeyboardReleased(X)
    KeysPressed(Str(x)) = 0
    ProcedureReturn 0
  EndIf
  If KeysPressed(Str(x))
    ProcedureReturn 0
  EndIf
  If KeyboardPushed(x)
    KeysPressed(Str(x)) = 1
    ProcedureReturn 1
  EndIf
  
  
EndProcedure
ExamineDesktops()
Global width = DesktopWidth(0)
Global height = DesktopHeight(0)
;width - 100
;height - 100
Global GameWindow = OpenWindow(0, 0, 0, Width, height, "The Road To Rage I : Fires Of War", #PB_Window_SystemMenu|#PB_Window_ScreenCentered)
SetWindowColor(0, 000000) 
OpenWindowedScreen(WindowID(0), 0, 0, width, height, #True, 0, 0)
ReInitVars()
LoadMap("test")
InitGame()
GameLoop()
Procedure LoadMap(FileName$)
  SetWindowTitle(0, Story$)
  Global MapFile = ReadFile(#PB_Any, Folder$ + "/levels/" + FileName$ + ".lvl")
  
  If MapFile = 0 : ProcedureReturn 0 : EndIf
  Global TempString$ = ""
  Global TempString2$ = ""
  Global TempX = 0
  Global Dim Map.MapItem(1000)
  Global ObsticleCounter = 0
  Global AmbienceCounter = 0
  Global CutsceneCounter = 0
  Global Dim Obsticles.obsticle(1000)
  Global Dim Ambience.ambienceItem(1000)
  Global Dim AI.mob(1000)
  Repeat
    TempString$ = ReadString(MapFile)
    If Left(TempString$, 1) = "W"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global ChFrom = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global ChTo = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global ChWithWhat = Val(TempString$)
      TempString$ = ""
      Global I = 0
      Debug "From " + Str(ChFrom) + " to " + Str(ChTo) + " with " + Str(ChWithWhat)
      For I = ChFrom To ChTo
        Map(I)\X = ChFrom
        Map(I)\type = ChWithWhat
        Map(I)\instadeath = 0
        Map(I)\Passable = 1
        Map(I)\Jumpable = 1
      Next
    EndIf
    If Left(TempString$, 1) = "U"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global ChFrom = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global ChTo = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global ChWithWhat = Val(TempString$)
      TempString$ = ""
      Global I = 0
      Debug "Unpassable from " + Str(ChFrom) + " to " + Str(ChTo) + " with " + Str(ChWithWhat)
      For I = ChFrom To ChTo
        Map(I)\X = ChFrom
        Map(I)\type = ChWithWhat
        Map(I)\instadeath = 0
        Map(I)\Passable = 0
        Map(I)\Jumpable = 1
      Next
    EndIf
    If Left(TempString$, 1) = "O"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global ChWhere = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global InstaDeath = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global HealthTake = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global EffectRange = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global Type = Val(TempString$)
      TempString$ = ""
      
      ObsticleCounter + 1
      Debug " Obsticle " + Str(ObsticleCounter) + " is effective for " + Str(EffectRange) + " Takes " + Str(HealthTake) + " health, instadeath is " + Str(InstaDeath) + " Will be at " + Str(ChWhere) + " with type " + Str(Type)
      Obsticles(ObsticleCounter)\active = 1
      obsticles(ObsticleCounter)\ActiveDistance = EffectRange
      obsticles(ObsticleCounter)\HealthTake = HealthTake
      obsticles(ObsticleCounter)\InstaDeath = InstaDeath
      obsticles(ObsticleCounter)\x = ChWhere
      obsticles(ObsticleCounter)\sounds[1] = LoadSound(#PB_Any, Folder$ + "/sounds/obst/"+Str(Type)+".wav")
      obsticles(ObsticleCounter)\sounds[2] = LoadSound(#PB_Any, Folder$ + "/sounds/obst/"+Str(Type)+"_hit.wav")  
    EndIf
    If Left(TempString$, 1) = "A"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global ChWhere = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global Distance = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")),0,0,1)
      Global Type = Val(TempString$)
      TempString$ = ""
      AmbienceCounter + 1
      Debug "Ambience " + Str(AmbienceCounter) + ", at " + Str(ChWhere)+", distance of " + Str(Distance) + ", and type " + Str(Type)
      Ambience(AmbienceCounter)\x = ChWhere
      Ambience(AmbienceCounter)\Distance = Distance
      ambience(AmbienceCounter)\sound = LoadSound(#PB_Any, Folder$ + "/sounds/ambience/"+Str(Type)+".wav")
    EndIf  
    If Left(TempString$, 1) = "S"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      
      Global Type = Val(TempString$)
      TempString$ = ""
      AmbienceCounter + 1
      Debug "Ambience " + Str(AmbienceCounter) + ", at " + Str(ChWhere)+", distance of " + Str(Distance) + ", and type " + Str(Type)
      
      
      ambience(AmbienceCounter)\sound = LoadSound(#PB_Any, Folder$ + "/sounds/ambience/"+Str(Type)+".wav")
      ambience(AmbienceCounter)\Stationary = 1
    EndIf  
    If Left(TempString$, 1) = "C"
      
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global X = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global OnMov = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global OnTime = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 1)
      Global TimeOut = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 1, 1)
      Global Value$ = TempString$
      TempString$ = ""
      
      CutsceneCounter + 1
      cutscenes(CutsceneCounter)\file = Value$
      CutScenes(CutsceneCounter)\active = 1
      CutScenes(CutsceneCounter)\OnMovement = OnMov
      CutScenes(CutsceneCounter)\OnTime = OnTime
      CutScenes(CutsceneCounter)\TimeOut = TimeOut
      CutScenes(CutsceneCounter)\x = X
    EndIf  
    If Left(TempString$, 1) = "T"
      
      TempString$ = Right(TempString$, Len(TempString$)-2)
      Global X = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global OnMov = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 0, 1)
      Global OnTime = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 1)
      Global TimeOut = Val(Left(TempString$, FindString(TempString$, ",")-1))
      TempString$ = RemoveString(TempString$, Left(TempString$, FindString(TempString$, ",")), 0, 1, 1)
      Global Value$ = TempString$
      TempString$ = ""
      Teleporter\Active = 1
      Teleporter\OnMove = OnMov
      Teleporter\OnTime = OnTime
      Teleporter\TimeOut = TimeOut
      Teleporter\Where = Value$
      Teleporter\x = X
    EndIf
    If Left(TempString$, 2) = "PS"
      TempString$ = Right(TempString$, Len(TempString$)-3)
      
      Global Value.f = ValF(TempString$)
      TempString$ = ""
      me\speed = Value
    EndIf  
    If Left(TempString$, 1) = "M"
      TempString$ = Right(TempString$, Len(TempString$)-2)
      
      Global Value$ = TempString$
      TempString$ = ""
      music\Active = 1
      music\file = Value$
      music\volume = 25
    EndIf  
    If Left(TempString$, 2) = "PR"
      TempString$ = Right(TempString$, Len(TempString$)-3)
      
      Global Value = Val(TempString$)
      TempString$ = ""
      me\RunFactor = Value
    EndIf  
    If Left(TempString$, 2) = "RT"
      TempString$ = Right(TempString$, Len(TempString$)-3)
      
      Global Value = Val(TempString$)
      TempString$ = ""
      me\RunTimer = Value
    EndIf  
    If Left(TempString$, 2) = "PF"
      TempString$ = Right(TempString$, Len(TempString$)-3)
      
      Global Value = Val(TempString$)
      TempString$ = ""
      me\Stepspeed = Value
    EndIf    
    If Left(TempString$, 2) = "PJ"
      TempString$ = Right(TempString$, Len(TempString$)-3)
      
      Global Value = Val(TempString$)
      TempString$ = ""
      me\Jumptime = Value
    EndIf    
    
  Until Eof(MapFile)
EndProcedure
Procedure InitGame()
  
  
  For i = 1 To AmbienceCounter
    If Ambience(i)\Stationary = 0
      PlaySound(Ambience(I)\sound, #PB_Sound_Loop, 0)
    Else
      PlaySound(Ambience(I)\sound, #PB_Sound_Loop, 100)
    EndIf  
  Next
  For i = 1 To ObsticleCounter
    PlaySound(Obsticles(I)\sounds[1], #PB_Sound_Loop, 0)
  Next
  If music\active = 1
    
    music\id = LoadSound(#PB_Any, Folder$ + "/Sounds/Music/"+music\file)
    SoundVolume(Music\ID, Music\volume)
    PlaySound(Music\ID, #PB_Sound_Loop)
  EndIf
  If CutsceneCounter > 0
    For i = 1 To CutsceneCounter
      If CutScenes(i)\OnTime = 1
        CutScenes(i)\Timer = timeGetTime_()
      EndIf
    Next
  EndIf
  
EndProcedure
Procedure GameLoop()
  Repeat
    
    If timeGetTime_()-FPSTimer => 16
      FPSTimer = timeGetTime_()
      ExamineKeyboard()
      HandleInput()
      HandleAI()
      HandleCutscenes()
      HandlePositions()
      HandleCharacter()
      HandleTeleporter()
      RenderWorld_()
    EndIf
    
    WaitWindowEvent(1)
  ForEver
EndProcedure
Procedure HandleTeleporter()
  If teleporter\Active = 1
    If Teleporter\OnMove = 1
      If Int(me\X) = Int(Teleporter\X)
        FreeGameMap()
        ReInitVars()
        LoadMap(Teleporter\Where)
        InitGame()
        GameLoop()
      EndIf
    EndIf
    If Teleporter\OnTime = 1
      If timeGetTime_()-teleporter\Timer > teleporter\TimeOut
        FreeGameMap()
        ReInitVars()
        LoadMap(Teleporter\Where)
        InitGame()
        GameLoop()
      EndIf
    EndIf
    
    
  EndIf
EndProcedure
Procedure HandleCharacter()
  If me\jumping = 1 And timeGetTime_()-me\Jumptimer > me\Jumptime
    me\Jumping = 0
    If IsSound(Me\sounds[2]) : FreeSound(Me\Sounds[2]) : EndIf
    Me\Sounds[2] = LoadSound(#PB_Any, Folder$ + "/Sounds/Steps/" + Str(Map(Int(Me\X))\Type) + "/" + Str(Random(3)+1) + ".wav")
    PlaySound(Me\Sounds[2])
  EndIf
EndProcedure
Procedure RenderWorld_()
  For i = 1 To AmbienceCounter
    
    If Ambience(i)\stationary = 0
      generate_pan(me\x, ambience(i)\x, Config_PanStep, ambience(i)\Distance, ambience(i)\sound)
      
    EndIf  
  Next
  For i = 1 To ObsticleCounter
    
    generate_pan(me\x, Obsticles(i)\x, config_PanStep, config_VolumeStep, Obsticles(i)\sounds[1])
    
  Next  
EndProcedure
Procedure HandleInput()
  If KeyboardPressed(#PB_Key_Escape) : End : EndIf
  If KeyboardPushed(#PB_Key_Right) : Move(1) : EndIf
  If KeyboardPushed(#PB_Key_Left) : Move(-1) : EndIf
  If KeyboardPushed(#PB_Key_LeftShift) And me\running = 0
    me\running = 1
    me\speed * me\RunFactor
  EndIf
  If Not KeyboardPushed(#PB_Key_LeftShift) And me\running = 1
    me\speed / me\RunFactor
    me\running = 0
    
  EndIf
  If KeyboardPressed(#PB_Key_Up) : InitiateJump() : EndIf
  If KeyboardPressed(#PB_Key_X) : MessageRequester("Info", Str(me\x)) : EndIf  
EndProcedure
Procedure InitiateJump()
  If Me\Jumping = 0
    me\jumping = 1
    Me\JumpTimer = timeGetTime_()
    If IsSound(Me\Sounds[2]) : FreeSound(Me\Sounds[2]) : EndIf
    Me\Sounds[2] = LoadSound(#PB_Any, Folder$ + "/Sounds/Player/Jump.wav")
    PlaySound(Me\Sounds[2])
  EndIf
EndProcedure
Procedure HandleAI()
EndProcedure
Procedure Distance(X1.f, X2.f, range.f)
  If X1.f < x2.f+range And X1.f > X2.f-range : ProcedureReturn 1 : EndIf
EndProcedure
Procedure Move(Direction.l)
  
  If Direction <> me\direction
    me\direction = Direction
    ProcedureReturn
  EndIf
  If me\jumping = 0
    TempX = me\X
    
    If Direction = 1 : TempX + me\speed : EndIf
    If Direction = -1 : TempX - me\speed : EndIf
    If Map(Int(TempX))\Passable = 1
      me\x = TempX
      me\StepCounter + 1
      If me\running = 0
        
        If me\StepCounter > me\StepSpeed
          
          If IsSound(Me\sounds[1]) : FreeSound(Me\sounds[1]) : EndIf
          me\sounds[1] = LoadSound(#PB_Any, Folder$ + "/sounds/steps/"+Str(Map(Int(Me\X))\Type)+"/"+Str(Random(3)+1)+".wav")
          
          PlaySound(Me\sounds[1])
          Me\StepCounter = 0
        EndIf
      Else
        
        If me\StepCounter > me\StepSpeed/2
          If IsSound(Me\sounds[1]) : FreeSound(Me\sounds[1]) : EndIf
          me\sounds[1] = LoadSound(#PB_Any, Folder$ + "/sounds/steps/"+Str(Map(Int(Me\X))\Type)+"/"+Str(Random(3)+1)+".wav")
          PlaySound(Me\sounds[1])
          Me\StepCounter = 0
        EndIf
        
      EndIf  
    EndIf  
  Else
    If Direction = 1 : TempX + me\speed : EndIf
    If Direction = -1 : TempX - me\speed : EndIf
    If Map(Int(TempX))\Jumpable = 1
      me\x = TempX
    EndIf
  EndIf  
EndProcedure
Procedure HandleCutScenes()
  If CutsceneCounter > 0
    
    For i = 1 To CutsceneCounter
      If cutscenes(i)\Active = 1
        If cutscenes(i)\OnMovement = 1
          If Int(me\x) = Int(CutScenes(i)\X) : PlayCutScene(cutscenes(i)) : EndIf
        EndIf
        If CutScenes(i)\OnTime = 1
          
          If timeGetTime_()-CutScenes(i)\Timer > CutScenes(i)\TimeOut : PlayCutScene(CutScenes(i)) : EndIf
        EndIf
      EndIf  
    Next
  EndIf
  
EndProcedure
Procedure HandlePositions()
  If me\jumping = 0
    If ObsticleCounter > 0
      For I = 1 To ObsticleCounter
        If Obsticles(I)\active = 1
          
          If Distance(Me\X, Obsticles(i)\X, Obsticles(i)\ActiveDistance)
            PlaySound(obsticles(i)\sounds[2])
            StopSound(Obsticles(i)\sounds[1])
            If Obsticles(i)\InstaDeath = 1
              CharacterDie()
            Else
              CharacterHurt(obsticles(i)\HealthTake)
            EndIf
            obsticles(i)\active = 0  
          EndIf
        EndIf
      Next
    EndIf
  EndIf  
EndProcedure
Procedure PlayCutScene(*value.cutsceneItem)
  If IsSound(*value\ID) : FreeSound(*value\ID): EndIf
  *value\ID = LoadSound(#PB_Any, Folder$ + "/Sounds/CutScenes/"+*value\file)
  PlaySound(*Value\ID)
  Repeat
    WaitWindowEvent(1)
    ExamineKeyboard()
    If KeyboardPressed(#PB_Key_Space) : Break : EndIf
  ForEver
  FreeSound(*Value\ID)
  *value\active = 0  
EndProcedure
Procedure CharacterHurt(Amount.l)
  me\health - Amount
  If me\health =< 0 : CharacterDie() : ProcedureReturn : EndIf
  If IsSound(me\sounds[3]) : FreeSound(me\sounds[3]) : EndIf
  me\sounds[3] = LoadSound(#PB_Any, Folder$ + "/Sounds/Player/Hurt"+Str(Random(5)+1)+".wav")
  PlaySound(me\sounds[3])
  
EndProcedure
Procedure CharacterDie()
  If IsSound(me\sounds[3]) : FreeSound(me\sounds[3]) : EndIf
  me\sounds[3] = LoadSound(#PB_Any, Folder$ + "/Sounds/Player/Die1.wav")
  PlaySound(me\sounds[3])
  Repeat
    ExamineKeyboard()
    WaitWindowEvent(5)  
  Until KeyboardPressed(#PB_Key_Return)
  FreeGameMap()
  ReInitVars()
  LoadMap(Story$)
  InitGame()
  GameLoop()
  
EndProcedure
Procedure FreeGameMap()
  
  For I = 1 To ObsticleCounter
    FreeSound(Obsticles(i)\Sounds[1])
    FreeSound(Obsticles(i)\Sounds[2])  
  Next
  
  For I = 1 To AmbienceCounter
    FreeSound(Ambience(I)\sound)
  Next
  
  FreeSound(Music\ID)
  ;                                                                              FreeArray(Map)
  ;FreeArray(Obsticles)
  ;                                                                              FreeArray(Ambience)
  ;FreeArray(AI)
  ;FreeArray(CutScenes)  
EndProcedure
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 151
; FirstLine = 105
; Folding = ----
; EnableXP
; DisableDebugger