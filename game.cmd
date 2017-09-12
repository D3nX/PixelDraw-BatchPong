@echo off
title PixelDraw Batch Pong
setlocal enabledelayedexpansion
mode con: lines=42 cols=119
cls

rem PixelDraw Batch Pong - By D3nX
rem Reuse this code as you want =)

:initialize
set WIDTH=960
set HEIGHT=503

set ball.radius=15
set /a ball.x=!WIDTH!/2
set /a ball.y=!HEIGHT!/2
set ball.spd=25
set ball.draw=call :drawBall

set padleWidth=32
set padleHeight=128
set padleSpd=10

set padle[0].width=!padleWidth!
set padle[0].height=!padleHeight!
set padle[0].score=0
set padle[0].x=0
set padle[0].y=0

set padle[1].width=!padleWidth!
set padle[1].height=!padleHeight!
set padle[1].score=0
set /a padle[1].x=!WIDTH!-!padle[1].width!
set /a padle[1].y=0

set AddX=true
set AddY=true

set /a LoseX[0]=-5
set /a loseY[1]=!WIDTH!+1

:loop
rem Update

if !ball.x! LSS -5 (

  set /a padle[1].score+=1

  set /a ball.x=!WIDTH!/2
  set /a ball.y=!HEIGHT!/2

)

if !ball.x! GTR !WIDTH! (

  set /a padle[0].score+=1

  set /a ball.x=!WIDTH!/2
  set /a ball.y=!HEIGHT!/2

)

batbox /g 50 0 /d "Player : %padle[0].score% VS AI : %padle[1].score%"

rem Player
call :padleUpdate 0
call :padleDraw 0

if !addX! EQU true (
  call :padleUpdate 1
)
call :padleDraw 1

rem Ball
call :ballUpdate
call :ballDraw

PIXELDRAW /refresh 07

goto :loop

rem ball and padle label
:padleUpdate

set /a nmb=%1

batbox /k_

rem Down
if %1 EQU 0 (
  if %ERRORLEVEL% EQU 335 (
    set /a nextPos=!padle[0].y!+!padle[0].height!

    if !nextPos! LSS !HEIGHT! (
      set /a padle[0].y+=!padleSpd!
    )
  )

  rem Up
  if %ERRORLEVEL% EQU 327 (
    if !padle[0].y! GTR 1 (
      set /a padle[0].y-=!padleSpd!
    )
  )
) else (

  set /a padleY=!padle[1].y!+!padle[1].height!/2

  if !ball.y! GTR !padleY! (
    set /a padle[1].y+=!padleSpd!

    if !ball.y! LSS !padleY! (
      set /a padle[1].y=!ball.y!
    )
  ) else if !ball.y! LSS !padleY! (
    set /a padle[1].y-=!padleSpd!

    if !ball.y! GTR !padleY! (
      set /a padle[1].y=!ball.y!
    )
  )

)

goto :EOF

:ballUpdate

if !addX! EQU true (
  set /a ball.x+=!ball.spd!

  set /a right=!ball.x!+!ball.radius!

  if !right! GEQ !padle[1].x! if !right! LSS !WIDTH! (

    set /a padleMax=!padle[1].y!+!padle[1].height!

    if !ball.y! GEQ !padle[1].y! if !ball.y! LEQ !padleMax! (
      call :setAddX false
    )
  )
) else (
  set /a ball.x-=!ball.spd!

  set /a left=!ball.x!-!ball.radius!

  set /a padleRight=!padle[0].x!+!padle[0].width!

  if !left! LEQ !padleRight! if !left! GEQ 0 (

    set /a padleMax=!padle[0].y!+!padle[0].height!

    if !ball.y! GEQ !padle[0].y! if !ball.y! LEQ !padleMax! (
        call :setAddX true
    )
  )
)

if !addY! EQU true (
  set /a ball.y+=!ball.spd!

  set /a down=!ball.y!+!ball.radius!

  if !down! GEQ !HEIGHT! (
    call :setAddY false
  )

) else (
  set /a ball.y-=!ball.spd!

  set /a up=!ball.y!-!ball.radius!

  if !up! LEQ 0 (
    call :setAddY true
  )
)

goto :EOF

rem Draw padle
:padleDraw
if "%1" EQU "" goto :EOF
set /a nmb=%1
PIXELDRAW /dr !padle[%nmb%].x! !padle[%nmb%].y! /rd !padle[%nmb%].width! !padle[%nmb%].height! /rgb 255 255 255
goto :EOF

rem Draw ball
:ballDraw
PIXELDRAW /dc !ball.x! !ball.y! /cr !ball.radius! /rgb 255 255 255

goto :EOF

rem System util
:setAddY
set addY=%1
goto :EOF

:setAddX
set addX=%1
goto :EOF
