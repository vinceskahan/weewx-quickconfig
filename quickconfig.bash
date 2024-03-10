#-----------------------------------------------------------
# this does a quick report of basic os and weewx installations
# to aid in debugging.  See the README file for usage
#
# tested on debian, ubuntu, almalinux
#
# this will very very likely fail on mac or other os
#-----------------------------------------------------------

DPKG_PRESENT=`which dpkg 2>/dev/null`
YUM_PRESENT=`which yum 2>/dev/null`
ARCH_PRESENT=`which arch 2>/dev/null`

# we supersede this on debian systems because on pi it reports
#       incorrectly yet dpkg knows what is really running
if [ "x${ARCH_PRESENT}" != "x" ]
then
        ARCH=`arch`
fi

# we will assume os-release is present rather than
# rely on lsb_release which we know is not always present
if [ -f /etc/os-release ]
then
        source /etc/os-release
fi

if [ "x${DPKG_PRESENT}" != "x" ]
then
        #------- debian systems -------------
        VERSION=`cat /etc/debian_version`
        ARCH=`dpkg --print-architecture`

        # debianish
        INSTALLED_WEEWX_PKG=`dpkg -l | grep weewx | awk '{print $3}'`
        if [ "x${INSTALLED_WEEWX_PKG}" = "x" ]
        then
                INSTALLED_WEEWX_PKG="no_pkg_installed"
        fi

        # supersede the 'arch' command because on a pi it reports
        # the wrong thing, but dpkg knows reality
        ARCH=`dpkg --print-architecture`

else
        #------- redhat systems -------------
        INSTALLED_WEEWX_PKG=`rpm -q weewx`
        if [ "x${INSTALLED_WEEWX_PKG}" = "x" ]
        then
                INSTALLED_WEEWX_PKG="no_pkg_installed"
        fi
fi

        RUNNING_WEEWX_PROCESSES=`ps -eo cmd | grep weewxd | grep -v grep`
        if [ "x${RUNNING_WEEWX_PROCESSES}" = "x" ]
        then
                RUNNING_WEEWX_PROCESSES="     none"
        fi

#-----------------------------------------

# look for weewx in a few likely places
if [ -d /home/weewx ]
then
        HOME_WEEWX_EXISTS="true"
else
        HOME_WEEWX_EXISTS="false"
fi

if [ -d /home/pi/weewx-venv ]
then
        HOME_PI_VENV_EXISTS="true"
else
        HOME_PI_VENV_EXISTS="false"
fi

if [ -d /etc/weewx ]
then
	ETC_WEEWX_EXISTS="true"
else
	ETC_WEEWX_EXISTS="false"
fi

# TODO: this could even output JSON if needed
# TODO: this could even output JSON if needed
# TODO: this could even output JSON if needed
# TODO: this could even output JSON if needed

echo ""
echo "basic system configuration:"
echo "     os        = ${PRETTY_NAME}"
echo "     arch      = ${ARCH}"
echo ""
echo "looking for weewx installations"
echo "     /home/weewx:         ${HOME_WEEWX_EXISTS}"
echo "     /home/pi/weewx-venv: ${HOME_PI_VENV_EXISTS}"
echo "     /etc/weewx:          ${ETC_WEEWX_EXISTS}"
echo ""
echo "installed weewx package:"
echo "     weewx_pkg = ${INSTALLED_WEEWX_PKG}"
echo ""
echo "running weewx processes:"
echo "${RUNNING_WEEWX_PROCESSES}"
echo ""
