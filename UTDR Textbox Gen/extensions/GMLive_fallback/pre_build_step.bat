@echo off
if not exist "%YYprojectDir%\scripts\GMLive\GMLive.gml" (
	echo GMLive script is amiss, copying fallback
	copy "%YYprojectDir%\scripts\GMLive\GMLive.fallback.gml" "%YYprojectDir%\scripts\GMLive\GMLive.gml"
	cscript /nologo "%~dp0pre_build_step_warn.vbs"
)