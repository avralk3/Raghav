APIC_LOGIN=paradhyula3
APIC_PASSWORD=xxxxxx!
APIC_REALM=provider/default-idp-2
APIC_SRV=apic-mgmt-api-manager-apic-cp4i.apps.ocp.cp4i.zint.cloud
APIC_EXE_Full_PATH=/c/CP4I-LAB/apic.exe
APIC_Newowner=paradhyula2
APIC_Porg=porg


# Transfer owner from paradhyula3 to paradhyula 2#



if [ "$COLOR" != "false" ]
then
	RED='\e[31m'
	GREEN='\e[32m'
	BLUE='\e[36m'
	YELLOW='\e[33m'
	RESET='\e[39m'
fi

printf -- $GREEN"* Running tests:\n"$RESET


echo '========== Logging to server ============='

$APIC_EXE_Full_PATH login -s $APIC_SRV -u $APIC_LOGIN -p $APIC_PASSWORD -r $APIC_REALM

echo '======================'
echo ""

printf -- $Yellow"* Get IDs :\n"$RESET
echo '==========Get new member ID Json and configure owner Json file ============='

$APIC_EXE_Full_PATH members:list --scope org --org $APIC_Porg --server $APIC_SRV | grep -w $APIC_Newowner | awk '{print $4}' > porgownerscript1.json

cat porgownerscript1.json

echo "******"



cat > porgownerscript.json <<EOF
{
"new_owner_member_url": "`cat porgownerscript1.json`"
}
EOF

echo "newowner file ******"
cat porgownerscript.json

#echo \
#"{ \
#\"new_owner_member_url\": \"`cat cownerscript1.json`\" \
#};" > cownerscript.json

#echo $var

echo '========== Transfer owner ============='

$APIC_EXE_Full_PATH orgs:transfer-owner -s $APIC_SRV $APIC_Porg porgownerscript.json



echo '========== Log out management server ============='

$APIC_EXE_Full_PATH logout -s $APIC_SRV 

echo '======================'



