#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

# Check if the input is numeric (atomic number)
if [[ $1 =~ ^[0-9]+$ ]]
then
  QUERY_CONDITION="atomic_number = $1"
else
  QUERY_CONDITION="symbol = '$1' OR name = '$1'"
fi

ELEMENT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius
  FROM elements 
  INNER JOIN properties USING(atomic_number) 
  INNER JOIN types USING(type_id)
  WHERE $QUERY_CONDITION;")

if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
fi
