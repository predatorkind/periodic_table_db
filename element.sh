#!/bin/bash
if [[ $1 ]]
then
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"
  # get element based on input
  # check if input is an atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    WHERE_CLAUSE="WHERE atomic_number = $1"
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    WHERE_CLAUSE="WHERE symbol = '$1'"
  else
    WHERE_CLAUSE="WHERE name = '$1'"
  fi
  # Query periodic_table db
  QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) $WHERE_CLAUSE LIMIT 1;")
  # if not found return error
  if [[ -z $QUERY_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    # return info about element
    echo $QUERY_RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi


else
  # prompt for arguments
  echo Please provide an element as an argument.
fi