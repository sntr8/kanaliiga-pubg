#!/bin/bash

function tension {
    echo -ne "."
    sleep 1
    echo -ne "."
    sleep 1
    echo -ne "."
    sleep 1
}

function writeATeam () {
    printf "$1\n" >> groupAdisplay.txt
}

function writeBTeam () {
    printf "$1\n" >> groupBdisplay.txt
}

cat Kanaliiga-logo.txt > graphic.txt

sleep 5

TEAMCOUNT=$(wc -l teams.txt |awk '{print $1}')
ATEAMS=0
BTEAMS=0

echo "Teams in file: $TEAMCOUNT"

LIMIT=$(bc -l <<< "scale = 1; $TEAMCOUNT / 2")

if [[ $LIMIT == *".5"* ]];
then
    LIMIT=$(echo "$LIMIT+0.5" |bc |awk -F "." '{print $1}')
fi

echo "Using group size limit: $LIMIT"

cp teams.txt teams.txt.temp

i=0

printf "\n\n\n\n"

echo "Starting group lottery"

printf "Let's start the lottery for Kanaliiga PUBG Duo 1/2020 Losers Bracket" > graphic.txt

tension

printf "\n\n"

printf "Game LB1 24.3.\n##############\n" > groupAdisplay.txt
printf "Game LB2 25.3.\n##############\n" > groupBdisplay.txt

pr -m -t groupAdisplay.txt groupBdisplay.txt > groupDisplay.txt

while (($i < $TEAMCOUNT));
do
    if [ "$i" == "0" ];
    then
        echo -ne "The first team is"
        printf "The first team is" > graphic.txt
    elif [ "$i" -eq "$(( $TEAMCOUNT-1 ))" ];
    then
        echo -ne "And the last team is"
        printf "And the last team is" > graphic.txt
    else
        echo -ne "The next team is"
        printf "The next team is" > graphic.txt
    fi

    tension

    TEAM=$(shuf -n 1 teams.txt.temp)

    figlet "$TEAM" > graphic.txt

    sleep 1

    printf "\n\n\n and $TEAM goes to game" >> graphic.txt

    echo -ne "$TEAM! And the team goes to game"
    tension

    GROUP=$(shuf -i1-2 -n1)

    if [ "$GROUP" == "1" ];
    then
        if [ "$ATEAMS" == "$LIMIT" ];
        then
            echo -ne "LB2!"
            figlet "LB2" > graphic.txt
            BTEAMS=$(( BTEAMS+1 ))
            writeBTeam $TEAM
        else
            echo -ne "LB1!"
            figlet "LB1" > graphic.txt
            ATEAMS=$(( ATEAMS+1 ))
            writeATeam $TEAM
        fi
    else
        if [ "$BTEAMS" == "$LIMIT" ];
        then
            echo -ne "LB1!"
            figlet "LB1" > graphic.txt
            ATEAMS=$(( ATEAMS+1 ))
            writeATeam $TEAM
        else
            echo -ne "LB2!"
            figlet "LB2" > graphic.txt
            BTEAMS=$(( BTEAMS+1 ))
            writeBTeam $TEAM
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

printf "Game LB1 24.3.\n##############\n" |cat - groupAsorted.txt > temp && mv temp groupAsorted.txt
printf "Game LB2 25.3.\n##############\n" |cat - groupBsorted.txt > temp && mv temp groupBsorted.txt

printf "Teams have now been divided to Losers Brackets groups. Have fun playing!" > groupDisplay.txt

sleep 7

echo "Lottery is now compelete!"
echo "Losers brackets groups are:"
pr -m -t groupAsorted.txt groupBsorted.txt

cat Kanaliiga-logo.txt > graphic.txt
