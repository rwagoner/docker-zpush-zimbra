#!/bin/sh +x

ZPUSH_CONFIG='/var/www/html/config.php'

#Prepare config file

if [ ! -f  "${ZPUSH_CONFIG}.bkp" ]; then
    # Backun original file
    cp $ZPUSH_CONFIG $ZPUSH_CONFIG.bkp
     cat <<- EOF >> $ZPUSH_CONFIG
     #Zimbra config
    define('MAPI_SERVER', 'file:///var/run/zarafa');
    define('ZPUSH_URL', '');
    define('ZIMBRA_URL','');
EOF
fi

if [ -z  $ZPUSH_URL_IN_HTTP ]; then
    ZPUSH_URL_PROTO="https:\/\/"
else
     ZPUSH_URL_PROTO="http:\/\/"
fi 

if [ -z  $ZIMBRA_URL_IN_HTTP ]; then
    ZIMBRA_URL_PROTO="https:\/\/"
else
     ZIMBRA_URL_PROTO="http:\/\/"
fi 

# Config Zimbra backend
sed -i "/BACKEND_PROVIDER/s/'[^']*'/'BackendZimbra'/2" $ZPUSH_CONFIG
sed -i "/ZPUSH_URL/s/'[^']*'/'$ZPUSH_URL_PROTO$ZPUSH_URL\/Microsoft-Server-ActiveSync'/2" $ZPUSH_CONFIG
sed -i "/ZIMBRA_URL/s/'[^']*'/'$ZIMBRA_URL_PROTO$ZIMBRA_URL'/2" $ZPUSH_CONFIG

# Set timezone if exist
if  [ ! -z $TIMEZONE ]; then  
    TIMEZONE=$(echo "$TIMEZONE" | sed 's/\//\\\//g')
    sed -i "/TIMEZONE/s/'[^']*'/'$TIMEZONE'/2" $ZPUSH_CONFIG
fi

apache2-foreground 
