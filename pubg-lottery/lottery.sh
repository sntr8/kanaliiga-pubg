#!/bin/bash

function tension {
    echo -ne "."
    sleep 1
#    echo -ne "."
#    sleep 1
#    echo -ne "."
#    sleep 1
}

function writeATeam () {
    printf "$1\n" >> groupAdisplay.txt
}

function writeBTeam () {
    printf "$1\n" >> groupBdisplay.txt
}

APRESEED=groupApreseed.txt
BPRESEED=groupBpreseed.txt

ATEAMS=0
BTEAMS=0

if [[ -f "$APRESEED" ]];
then
    ATEAMS=$(wc -l $APRESEED |awk '{print $1}')
fi

if [[ -f "$BPRESEED" ]];
then
    BTEAMS=$(wc -l $BPRESEED |awk '{print $1}')
fi

TEAMCOUNT=$(($(wc -l teams.txt |awk '{print $1}')+ATEAMS+BTEAMS))

echo $TEAMCOUNT

echo "Teams in file: $TEAMCOUNT"

LIMIT=$(bc -l <<< "scale = 1; $TEAMCOUNT / 2")

if [[ $LIMIT == *".5"* ]];
then
    LIMIT=$(echo "$LIMIT+0.5" |bc |awk -F "." '{print $1}')
fi

echo "Using group size limit: $LIMIT"

cp teams.txt teams.txt.temp

i=0

sleep 10

cat Kanaliiga-logo.txt > graphic.txt

sleep 5

echo "" > graphic.txt

sleep 1

printf "\n\n\n\n"

echo "Starting group lottery"

printf "\nLet's start the lottery for Kanaliiga PUBG Duo 3/2020 Lower Bracket" > graphic.txt

tension

printf "\n\n"

printf "\nGame LB1 1.12.\n##############\n" > groupAdisplay.txt
printf "\nGame LB2 3.12.\n##############\n" > groupBdisplay.txt

cat groupApreseed.txt >> groupAdisplay.txt
cat groupBpreseed.txt >> groupBdisplay.txt

pr -m -t groupAdisplay.txt groupBdisplay.txt > groupDisplay.txt

while (($i < $TEAMCOUNT));
do
    if [ "$i" == "0" ];
    then
        echo -ne "The first team is"
        printf "\nThe first team is" > graphic.txt
    elif [ "$i" -eq "$(( $TEAMCOUNT-1 ))" ];
    then
        echo -ne "And the last team is"
        printf "\nAnd the last team is" > graphic.txt
    else
        echo -ne "The next team is"
        printf "\nThe next team is" > graphic.txt
    fi

    tension

    TEAM=$(shuf -n 1 teams.txt.temp)

    printf "\n" > graphic.txt
    figlet "$TEAM" >> graphic.txt

    sleep 1

    printf "\n\n\n and $TEAM goes to game" >> graphic.txt

    echo -ne "$TEAM! And the team goes to the game"
    tension

    GROUP=$(shuf -i1-2 -n1)

    if [ "$GROUP" == "1" ];
    then
        if [ "$ATEAMS" == "$LIMIT" ];
        then
            echo -ne "LB2!"
            printf "\n" > graphic.txt
            figlet "LB2" >> graphic.txt
            BTEAMS=$(( BTEAMS+1 ))
            writeBTeam "$TEAM"
        else
            echo -ne "LB1!"
            printf "\n" > graphic.txt
            figlet "LB1" >> graphic.txt
            ATEAMS=$(( ATEAMS+1 ))
            writeATeam "$TEAM"
        fi
    else
        if [ "$BTEAMS" == "$LIMIT" ];
        then
            echo -ne "LB1!"
            printf "\n" > graphic.txt
            figlet "LB1" >> graphic.txt
            ATEAMS=$(( ATEAMS+1 ))
            writeATeam "$TEAM"
        else
            echo -ne "LB2!"
            printf "\n" > graphic.txt
            figlet "LB2" >> graphic.txt
            BTEAMS=$(( BTEAMS+1 ))
            writeBTeam "$TEAM"
        fi
    fi
    sed -i '' "/^$TEAM\$/d" teams.txt.temp

    tension

    printf "\n\n"

    i=$(( i+1 ))
    pr -m -t groupAdisplay.txt groupBdisplay.txt > groupDisplay.txt
done

rm teams.txt.temp

tail -n+3 groupAdisplay.txt > groupA.txt
tail -n+3 groupBdisplay.txt > groupB.txt

rm groupAdisplay.txt groupBdisplay.txt

sort groupA.txt > groupAsorted.txt
sort groupB.txt > groupBsorted.txt
rm groupA.txt
rm groupB.txt

printf "Game LB1 1.12.\n##############\n" |cat - groupAsorted.txt > temp && mv temp groupAsorted.txt
printf "Game LB2 3.12.\n##############\n" |cat - groupBsorted.txt > temp && mv temp groupBsorted.txt

printf "\n\nTeams have now been divided to Lower Brackets groups. Have fun playing!" >> groupDisplay.txt

sleep 7

echo "Lottery is now compelete!"
echo "Lower bracket groups are:"
pr -m -t groupAsorted.txt groupBsorted.txt

cat Kanaliiga-logo.txt > graphic.txt
