#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #get element by atomic number
    ELEMENT_BY_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements using(atomic_number) inner join types using(type_id) WHERE atomic_number='$ELEMENT_BY_ATOMIC_NUMBER'")
  # if not a number
  else  

    # get element by symbol
    ELEMENT_BY_SYMBOL=$($PSQL "SELECT symbol from elements WHERE symbol='$1'")
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements using(atomic_number) inner join types using(type_id) WHERE symbol='$ELEMENT_BY_SYMBOL'")

    # if not found
    if [[ -z $ELEMENT_BY_SYMBOL ]]
    then
      # get element by name
      ELEMENT_BY_NAME=$($PSQL "SELECT name from elements WHERE name='$1'")
      ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements using(atomic_number) inner join types using(type_id) WHERE name='$ELEMENT_BY_NAME'")

      # if not found
      if [[ -z $ELEMENT_BY_NAME ]]
      then
        # output message that did not find element
        echo I could not find that element in the database.
      fi
      
    fi
  fi

  if [[ -n $ELEMENT_DATA ]]
  then
  echo "$ELEMENT_DATA" | sed 's/|/ /g' | (read NUM NAME SYMBOL TYPE MASS MELT_POINT BOIL_POINT; 
  echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a nonmetal, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius." )
  fi
  
  
fi
