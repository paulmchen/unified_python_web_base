#!/bin/sh

# This is an entrypoint script for running a Python WebApp docker container
# The script will attempt to find a wsg.py file and will invoke the WSGI.
# If the environment varaibles PY_APP_MODULE_NAME and PY_APP_VARIABLE_NAME
# are not empty, user defined envrionment variables are passed in to start
# the runtime
#

# set default module name and variable name
PY_APP_MODULE_NAME = "server"
PY_APP_VARIABLE_NAME = "app"

if [ -z "${PY_APP_MODULE_NAME}" ]
then
   # python app module is not defined, we will try to discover it from the source
   result=`find . -type f -name 'wsgi.py'`
   
   if [ -z ${result} ] 
   then
      # cannot find wsgi.py, default app module name as 'server' and varaible name as 'app'
      echo "It is not a django web app, use the default model/varailbe ${PY_APP_MODULE_NAME}, ${PY_APP_VARIABLE_NAME}" 
   else
      echo "WSGI module name path ${result}"
      hasmanager=`find . -type f -name 'manage.py'`
      if [ -z "${hasmanager}" ]
      then 
        # set variable name as "app"
        echo "It is not a django web app, but possibly other WSGI app, use the default model/varailbe ${PY_APP_MODULE_NAME}, ${PY_APP_VARIABLE_NAME}"
      else
        counts=`echo ${result} |grep -o "/" |wc -l` 
        modulePackage=`echo "${result}" |cut -d/ -f2` 
        echo "django package name ${modulePackage}"     
        echo "django discover module package name ${modulePackage}.wsdl, and variable name application for Dijango."
        PY_APP_MODULE_NAME="${modulePackage}.wsgi"
        PY_APP_VARIABLE_NAME="application"
      fi
   fi  
else
   # got app module name from environment variable
   # we use the defined environment variable to load both module_name and varaible name
   echo "Python app module name ${PY_APP_MODULE_NAME} is found. " 
   if [ -z "${PY_APP_VARIABLE_NAME}" ]
   then
       echo "Python app module ${PY_APP_MODULE_NAME} has no variable name defined. Set the default as 'application'"
       PY_APP_VARIABLE_NAME = "application"
   fi
fi
echo "PY_APP_MODULE_NAME=${PY_APP_MODULE_NAME}"
echo "PY_APP_VARIABLE_NAME=${PY_APP_VARIABLE_NAME}"

# run gunicron to start Python webapp
gunicorn -w 4  "${PY_APP_MODULE_NAME}:${PY_APP_VARIABLE_NAME}"
