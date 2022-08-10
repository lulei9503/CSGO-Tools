::批处理窗口设置
@echo off& pushd %~dp0 & title CSGO 工具箱
mode con cols=50 lines=35
color 0f


::::::::::::::::::::权限申请 Start::::::::::::::::::::

cls
echo.
echo          *===========================*
echo          #    管理员权限申请中．．． #
echo          *===========================*

:init
setlocal disabledelayedexpansion
set cmdinvoke=1
set winsysfolder=system32
set "batchpath=%~0"
for %%k in ( %0 ) do set batchname=%%~nk
set "vbsgetprivileges=%temp%\oegetpriv_%batchname%.vbs"
setlocal enabledelayedexpansion

:checkprivileges
net file 1>nul 2>nul
if '%errorlevel%' == '0' ( goto gotprivileges ) else ( goto getprivileges )

:getprivileges
if '%1'=='elev' ( echo elev & shift /1 & goto gotprivileges)

echo.
echo       $***********************************$
echo       *     正在调用 UAC 进行权限提升     *
echo       $***********************************$
echo.
echo  ☆ 请选择 [是] 同意批处理调用管理员权限。
echo.

echo set uac = createobject^( "shell.application"^ ) > "%vbsgetprivileges%"
echo args = "elev " >> "%vbsgetprivileges%"
echo for each strarg in wscript.arguments >> "%vbsgetprivileges%"
echo args = args ^& strarg ^& " "  >> "%vbsgetprivileges%"
echo next >> "%vbsgetprivileges%"

if '%cmdinvoke%'=='1' goto invokecmd 

echo uac.shellexecute "!batchpath!", args, "", "runas", 1 >> "%vbsgetprivileges%"
goto execelevation

:invokecmd
echo args = "/c """ + "!batchpath!" + """ " + args >> "%vbsgetprivileges%"
echo uac.shellexecute "%systemroot%\%winsysfolder%\cmd.exe", args, "", "runas", 1 >> "%vbsgetprivileges%"

:execelevation
"%systemroot%\%winsysfolder%\wscript.exe" "%vbsgetprivileges%" %*
exit /b

:gotprivileges
setlocal & cd /d %~dp0
if '%1'=='elev' ( del "%vbsgetprivileges%" 1>nul 2>nul & shift /1)
cls

:::::::::::::::::::::权限申请 End::::::::::::::::::::


::::::::::::::::::::CSGO路径检测 Start::::::::::::::::::::

::开启延迟环境变量扩展
setlocal enabledelayedexpansion

::结束csgo游戏进程
taskkill /f /im csgo.exe >nul 2>nul

::自动检测CSGO游戏路径
if exist "%cd%\csgo.exe" ( set "csgopath=%cd%" ) else ( echo 正在自动识别csgo路径······ & ping -n 2 127.1 >nul & goto autopath )
goto menu

:autopath
echo wscript.echo CreateObject ( "WScript.Shell" ).RegRead ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 730\InstallLocation" ) > %temp%\csgopath~.vbs & for /f "delims=" %%a in ( 'cscript //nologo %temp%\csgopath~.vbs' ) do set "csgopath=%%a"

:inputpath
if "%csgopath%"=="" ( 
  echo. & set /p a=自动检测路径失败！请移动该程序及CSGOToolbox文件夹至游戏根目录下或手动输入游戏路径 [回车]： & if "!a!"=="" ( 
    echo. & echo 输入为空，请按任意键重新输入。 & pause >nul & cls & echo. & goto inputpath 
  ) else ( 
    if exist "!a!\csgo.exe" ( 
      set "csgopath=!a!" & goto menu 
    ) else ( 
      echo. & echo CSGO路径输入错误，请按任意键重新输入。 & pause >nul & cls & echo. & goto inputpath 
      )
    ) 
) else ( 
  goto menu 
  )

::::::::::::::::::::CSGO路径检测 End::::::::::::::::::::


::::::::::::::::::::主要功能 Start::::::::::::::::::::

:menu
cls
echo.
echo                ┏─────━=====━─────┓
echo                │   CSGO 工具箱   │
echo                ┗─────━=====━─────┛
echo                    『 菜 单 』
echo         ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
echo         ┃   1.CSGO原汁原味 [反和谐]      ┃
echo         ┃   2.切换国际服中文翻译         ┃
echo         ┃   3.切换国际服英文语音         ┃
echo         ┃   4.[ 恢复 完美服和谐版 ]      ┃
echo         ┃                                ┃
echo         ┃   5.安装简易雷达               ┃
echo         ┃   6.[ 卸载 简易雷达 ]          ┃
echo         ┃                                ┃
echo         ┃   7.安装自定义CFG （详见说明） ┃
echo         ┃   8.[卸载 自定义CFG]           ┃
echo         ┃                                ┃
echo         ┃   9.VAC屏蔽修复工具            ┃
echo         ┃                                ┃
echo         ┃   0.查看 [说明+更新日志]       ┃
echo         ┃                                ┃
echo         ┃                  版本：21.5.5  ┃
echo         ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo.
set /p a=请输入选项 [回车]：
echo.
ping -n 2 127.1 >nul
if /i "%a%"=="1" goto original_game
if /i "%a%"=="2" goto original_schinese
if /i "%a%"=="3" goto original_voice
if /i "%a%"=="4" goto recover_perfect_world
if /i "%a%"=="5" goto install_simple_radar
if /i "%a%"=="6" goto uninstall_simple_radar
if /i "%a%"=="7" goto install_CFG
if /i "%a%"=="8" goto uninstall_CFG
if /i "%a%"=="9" goto fix_VAC
if /i "%a%"=="0" goto explain
echo.
echo 输入无效，2秒后请重新输入！
ping -n 2 127.1 >nul
goto menu

:original_game
if exist "%csgopath%\csgo\bak_perfectworld.txt" ( echo 存在 [和谐备份] 文件，正在还原······ & ping -n 2 127.1 >nul )
ren "%csgopath%\csgo\pakxv_perfectworld_*.jqy" *.vpk >nul 2>nul
del "%csgopath%\csgo\pakxv_perfectworld_*.jqy" >nul 2>nul
del "%csgopath%\csgo\bak_perfectworld.txt" >nul 2>nul
echo 正在进行 [反和谐]······
ping -n 2 127.1 >nul
if exist "%csgopath%\csgo\pakxv_perfectworld_*.vpk" ( 
  ( 
    dir "%csgopath%\csgo\pakxv_perfectworld_*.vpk" /b > "%csgopath%\csgo\bak_perfectworld.txt" & for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\bak_perfectworld.txt" ) do ( ren "%csgopath%\csgo\%%a" *.jqy >nul 2>nul ) 
  ) & ( 
    echo 反和谐操作完成，尽情享受原汁原味。 
  )
) else ( 
  echo 未检测到任何和谐文件，请 [验证游戏完整性] 后操作。
  )
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:original_schinese
if not exist "%csgopath%\csgo\resource\csgo_schinese_pw.txt" ( 
  if not exist "%csgopath%\csgo\resource\csgo_schinese_pw.jqy" ( 
    echo 缺少完美服翻译文本及其备份，请 [验证游戏完整性] 后操作。 
  ) else ( 
    echo 当前为国际服中文翻译，无需切换。 
    ) 
) else ( 
  del "%csgopath%\csgo\resource\csgo_schinese_pw.jqy" >nul 2>nul & ren "%csgopath%\csgo\resource\csgo_schinese_pw.txt" csgo_schinese_pw.jqy & echo 国际服中文翻译切换完成。 
  )
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:original_voice
if exist "%csgopath%\csgo\bak_audiochinese.txt" ( echo 存在 [语音备份] 文件，正在还原······ & ping -n 2 127.1 >nul )
ren "%csgopath%\csgo\pakxv_audiochinese_*.jqy" *.vpk >nul 2>nul
del "%csgopath%\csgo\pakxv_audiochinese_*.jqy" >nul 2>nul
del "%csgopath%\csgo\bak_audiochinese.txt" >nul 2>nul
echo 正在切换 [英文语音]······
ping -n 2 127.1>nul
if exist "%csgopath%\csgo\pakxv_audiochinese_*.vpk" ( 
  ( 
    dir "%csgopath%\csgo\pakxv_audiochinese_*.vpk" /b > "%csgopath%\csgo\bak_audiochinese.txt" & for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\bak_audiochinese.txt" ) do ( ren "%csgopath%\csgo\%%a" *.jqy >nul 2>nul ) 
  ) & ( 
    echo 英文语音已切换，随意聆听原版语音。
  )
) else (
  echo 未检测到中文语音文件，请 [验证游戏完整性] 后操作。
  )
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:recover_perfect_world
echo 正在还原 [完美服和谐版]······
ping -n 2 127.1 >nul
echo.
if exist "%csgopath%\csgo\bak_perfectworld.txt" ( 
  echo 正在恢复 [和谐]··· & ping -n 2 127.1 >nul 
  ) else ( 
    if exist "%csgopath%\csgo\pakxv_perfectworld_*.vpk" ( 
      echo 当前为 [和谐版本]，无需恢复。 & ping -n 2 127.1 >nul 
      ) else ( 
        echo 未检测到和谐备份，请通过 [验证游戏完整性] 恢复。 
        ) 
        )
ren "%csgopath%\csgo\pakxv_perfectworld_*.jqy" *.vpk >nul 2>nul
del "%csgopath%\csgo\pakxv_perfectworld_*.jqy" >nul 2>nul
del "%csgopath%\csgo\bak_perfectworld.txt" >nul 2>nul
if exist "%csgopath%\csgo\resource\csgo_schinese_pw.jqy" (
  if exist "%csgopath%\csgo\resource\csgo_schinese_pw.txt" (
    echo 当前为 [完美服翻译]，无需恢复。& del "%csgopath%\csgo\resource\csgo_schinese_pw.jqy" >nul 2>nul
  ) else (
      echo 正在恢复 [完美服翻译]··· & ren "%csgopath%\csgo\resource\csgo_schinese_pw.jqy" csgo_schinese_pw.txt
    )
) else ( 
  if exist "%csgopath%\csgo\resource\csgo_schinese_pw.txt" ( 
    echo 当前为 [完美服翻译]，无需恢复。
  ) else ( 
    echo 缺少完美服翻译文本及其备份，请通过[验证游戏完整性]恢复。
    )
  )

if exist "%csgopath%\csgo\bak_audiochinese.txt" ( 
  echo 正在恢复 [中文语音]··· & ping -n 2 127.1 >nul 
  ) else ( 
    if exist "%csgopath%\csgo\pakxv_audiochinese_*.vpk" ( 
      echo 当前为 [中文语音]，无需恢复。 & ping -n 2 127.1 >nul 
      ) else ( 
        echo 未检测到语音备份，请通过 [验证游戏完整性] 恢复。 
        ) 
        )
ren "%csgopath%\csgo\pakxv_audiochinese_*.jqy" *.vpk >nul 2>nul
del "%csgopath%\csgo\pakxv_audiochinese_*.jqy" >nul 2>nul
del "%csgopath%\csgo\bak_audiochinese.txt" >nul 2>nul
echo.
echo 已恢复完美服和谐版，请憋屈忍耐和谐游戏。
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:install_simple_radar
::检测是否有CSGOToolbox
if not exist "%cd%\CSGOToolbox" echo ☆请将CSGOToolbox文件夹移动到与本程序同一目录 & echo. & echo 按任意键退出··· & pause >nul & goto exit

if exist "%csgopath%\csgo\resource\overviews\simple_radar.txt" (
  ( 
    echo 检测到旧版简易雷达，准备进行卸载······ & ping -n 2 127.1 >nul & echo 正在 [卸载] 旧版简易雷达······ & ping -n 2 127.1 >nul 
  ) & (
    for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\resource\overviews\simple_radar.txt" ) do ( del "%csgopath%\csgo\resource\overviews\%%a" >nul 2>nul )
  ) & ( 
    del "%csgopath%\csgo\resource\overviews\simple_radar.txt" >nul 2>nul & ren "%csgopath%\csgo\resource\overviews\*.jqy" *.dds >nul 2>nul 
    )
)
echo 正在 [安装] 简易雷达······
ping -n 2 127.1 >nul
dir "%cd%\CSGOToolbox\simple radar\*.dds" /b > "%csgopath%\csgo\resource\overviews\simple_radar.txt"
for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\resource\overviews\simple_radar.txt" ) do ( ren "%csgopath%\csgo\resource\overviews\%%a" *.jqy >nul 2>nul & xcopy "%cd%\CSGOToolbox\simple radar\%%a" "%csgopath%\csgo\resource\overviews"  /s /e /y >nul 2>nul )
echo 简易雷达安装完成。
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:uninstall_simple_radar
if exist "%csgopath%\csgo\resource\overviews\simple_radar.txt" (
  ( 
    echo 正在 [卸载] 简易雷达······ & ping -n 2 127.1 >nul
  ) & (
    for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\resource\overviews\simple_radar.txt" ) do ( del "%csgopath%\csgo\resource\overviews\%%a" >nul 2>nul )
  ) & ( 
    del "%csgopath%\csgo\resource\overviews\simple_radar.txt" >nul 2>nul & ren "%csgopath%\csgo\resource\overviews\*.jqy" *.dds >nul 2>nul & echo 简易雷达卸载完成。 
    )
) else (
  ping -n 2 127.1 >nul & echo 未检测到简易雷达无法卸载。 
  )
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:install_CFG
::检测是否有CSGOToolbox
if not exist "%cd%\CSGOToolbox" echo ☆请将CSGOToolbox文件夹移动到与本程序同一目录 & echo. & echo 按任意键退出··· & pause >nul & goto exit

if exist "%csgopath%\csgo\cfg\extra_cfg.txt" (
  ( 
    echo 检测到旧版自定义CFG，准备进行卸载······ & ping -n 2 127.1 >nul & echo 正在 [卸载] 旧版自定义CFG······ & ping -n 2 127.1 >nul
  ) & ( 
    for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\cfg\extra_cfg.txt" ) do ( del "%csgopath%\csgo\cfg\%%a" >nul 2>nul )
  ) & ( 
    del "%csgopath%\csgo\cfg\extra_cfg.txt" >nul 2>nul 
    )
)
echo 正在 [安装] 自定义CFG······
ping -n 2 127.1 >nul
dir "%cd%\CSGOToolbox\cfg\*.cfg" /b >"%csgopath%\csgo\cfg\extra_cfg.txt"
for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\cfg\extra_cfg.txt" ) do ( xcopy "%cd%\CSGOToolbox\cfg\%%a" "%csgopath%\csgo\cfg"  /s /e /y >nul 2>nul )
echo 自定义CFG安装完成。
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:uninstall_CFG
if exist "%csgopath%\csgo\cfg\extra_cfg.txt" (
  ( 
    echo 正在 [卸载] 自定义CFG······ & ping -n 2 127.1 >nul
  ) & ( 
    for /f "usebackq delims=" %%a in ( "%csgopath%\csgo\cfg\extra_cfg.txt" ) do ( del "%csgopath%\csgo\cfg\%%a" >nul 2>nul )
  ) & ( 
    del "%csgopath%\csgo\cfg\extra_cfg.txt" >nul 2>nul & echo 自定义CFG卸载完成。
    )
) else (
  ping -n 2 127.1 >nul & echo 未检测到自定义CFG无法卸载。 
  )
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:fix_VAC
if not exist "%cd%\CSGOToolbox\VAC屏蔽修复工具管理员权限运行.bat" ( echo 未检测到 VAC屏蔽修复工具管理员权限运行.bat。 & echo 文件可能已被移动或者重命名，请还原后再试。 & echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu )
echo 正在启动 [VAC屏蔽修复工具]
ping -n 2 127.1 >nul
start "VAC屏蔽修复工具" "%cd%\CSGOToolbox\VAC屏蔽修复工具管理员权限运行.bat"
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

:explain
echo 正在打开工具箱说明
ping -n 2 127.1 >nul
start "工具箱说明" "%cd%\工具箱说明.txt"
echo. & echo 按任意键返回菜单，退出直接关闭。& pause >nul & cls & goto menu

::::::::::::::::::::主要功能 End::::::::::::::::::::

:exit
pause
exit