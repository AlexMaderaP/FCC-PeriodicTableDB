#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #get element by atomic number
    ELEMENT_BY_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")

  # if not a number
  else  

    # get element by symbol
    ELEMENT_BY_SYMBOL=$($PSQL "SELECT symbol from elements WHERE symbol='$1'")
    
    # if not found
    if [[ -z $ELEMENT_BY_SYMBOL ]]
    then
      # get element by name
      ELEMENT_BY_NAME=$($PSQL "SELECT name from elements WHERE name='$1'")
      
      # if not found
      if [[ -z $ELEMENT_BY_NAME ]]
      then
        # output message that did not find element
        echo I could not find that element in the database.
      fi
      
    fi
  fi
fi
