#!/bin/bash
set echo off

if [ ! -f ${YYprojectDir}/scripts/GMLive/GMLive.gml ]; then
	echo "GMLive script is amiss, copying fallback"
	cp ${YYprojectDir}/scripts/GMLive/GMLive.fallback.gml ${YYprojectDir}/scripts/GMLive/GMLive.gml
fi
