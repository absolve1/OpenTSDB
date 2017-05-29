#!/bin/bash

#Check internet connection
INTERNET=$(ping -q -w 1 -c 1 `ip r | grep default | cut -d ' ' -f 3` &> /dev/null && echo ok || echo error)
if [ "$INTERNET" == "error" ]
then
    echo "No internet connection"
    exit 1
fi

#Check if curl exists
if ! type "curl" &> /dev/null; then
      echo "Curl not installed!"
      exit 1
fi

#Check if xmlstarlet exists
if ! type "xmlstarlet" &> /dev/null; then
      echo "xmlstarlet not installed!"
      exit 1
fi

WEASTATS=( '44560' '44640' '44730' '46610' '39750' '36330')
STATSNAME=( 'SOLA' 'VALAND' 'ROVIK' 'SAUDA' 'NESET''ARENDAL')
VALAND=( 'RR_01' 'RR_1' 'UU' 'TD' 'TA')
SOLA=( 'UU' 'TD' 'PH' 'AA' 'DD' 'TA' 'NN' 'FF'  )
ROVIK=('TA' 'RR_01' 'WLF_01'  )
SAUDA=( 'UU' 'TD' 'PH' 'AA' 'DD' 'TA' 'NN' 'FF'  )
NESET=( 'UU' 'TD' 'PH' 'AA' 'DD' 'TA' 'FF'  )
ARENDAL=( 'UU' 'TD' 'PH' 'AA' 'DD' 'TA' 'FF'  )
csvFile='result.csv'

AUX=""
#One hour dalay
#HOUR: the hour of the measure
HOUR=$(date +"%H")
#The date of the measure for example: DATE=$(date -d '1 november 2011' +'%Y-%m-%d')
DATE=$(date -d '1 day ago' +'%Y-%m-%d')
#OpenTSDB timestamp: should be like the other but different output: DATE=$(date -d '1 november 2011' +%s)
starttimestamp=$(date +%s)


#We take the values the values VALAND
echo "VALAND"
echo "------------------"
for VAR in "${VALAND[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=44640&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

     if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"

         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}
       echo put $METRIC $starttimestamp $VALUE station=VALAND.${arr[0]} location=Rogaland.${arr[0]} | nc -w 30 127.0.0.1 4242
       echo "Timestamp: "$starttimestamp
       echo "Metric: "$METRIC
       echo "Value: "$VALUE
      fi


done


#We take the values the values SOLA
echo "SOLA"
echo "------------------"
for VAR in "${SOLA[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=44560&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

   if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"
         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}

       echo put $METRIC $starttimestamp $VALUE station=SOLA.${arr[0]} location=Rogaland.${arr[0]} | nc -w 30 127.0.0.1 4242
        echo "Timestamp: "$starttimestamp
        echo "Metric: "$METRIC
        echo "Value: "$VALUE
        echo "Quality: "$QUALITY
      fi


done

#We take the values the values ROVIK

echo "ROVIK"
echo "------------------"
for VAR in "${ROVIK[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=44730&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

     if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"
         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}

       echo put $METRIC $starttimestamp $VALUE station=ROVIK.${arr[0]} location=Trondelag.${arr[0]} | nc -w 30 127.0.0.1 4242
       echo "Timestamp: "$starttimestamp
        echo "Metric: "$METRIC
        echo "Value: "$VALUE
        echo "Quality: "$QUALITY

      fi


done

#We take the values the values SAUDA

echo "SAUDA"
echo "------------------"
for VAR in "${SAUDA[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=46610&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

     if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"
         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}

       echo put $METRIC $starttimestamp $VALUE station=SAUDA.${arr[0]} location=Rogaland.${arr[0]} | nc -w 30 127.0.0.1 4242
       echo "Timestamp: "$starttimestamp
        echo "Metric: "$METRIC
        echo "Value: "$VALUE
        echo "Quality: "$QUALITY
      fi


done

#We take the values the values NESET

echo "NESET"
echo "------------------"
for VAR in "${NESET[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=39750&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

     if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"

         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}

       echo put $METRIC $starttimestamp $VALUE station=NESET.${arr[0]} location=Trondelag.${arr[0]} | nc -w 30 127.0.0.1 4242
       echo "Timestamp: "$starttimestamp
        echo "Metric: "$METRIC
        echo "Value: "$VALUE
        echo "Quality: "$QUALITY
      fi


done

#We take the values the values ARENDAL

echo "ARENDAL"
echo "------------------"
for VAR in "${ARENDAL[@]}"
do

    AUX=$(curl --request GET "http://eklima.met.no/metdata/MetDataService?invoke=getMetData&timeserietypeID=2&format=&from="$DATE"&to="$DATE"&stations=36330&elements="$VAR"&hours="$HOUR"&months=&username=" 2>/dev/null |  xmlstarlet sel --text -t -m '//timeStamp/item' -v 'location/item/weatherElement/item/id' -o ',' -v 'location/item/weatherElement/item/quality' -o ',' -v 'location/item/weatherElement/item/value' -n)

     if [ -z "$AUX" ]
      then
        echo "Missing value $VAR"
      else
         IFS=',' read -a arr <<< "$AUX"
         METRIC="newmodel1"
         QUALITY=${arr[1]}
         VALUE=${arr[2]}

       echo put $METRIC $starttimestamp $VALUE station=ARENDAL.${arr[0]} location=Augder.${arr[0]} | nc -w 30 127.0.0.1 4242
       echo "Timestamp: "$starttimestamp
        echo "Metric: "$METRIC
        echo "Value: "$VALUE
        echo "Quality: "$QUALITY
      fi


done
