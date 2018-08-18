![UCenfotec][UCenfotecLogo]

- [Bases of empires](#bases-of-empires)
  * [The database](#the-database)
  * [Stored procedures](#stored-procedures)
    + [restart_game](#restart-game)
    + [buy](#buy)
    + [sell](#sell)
    + [train](#train)
    + [defenses](#defenses)
    + [upgrade](#upgrade)
    + [attack](#attack)
    + [monitor](#monitor)
    
# Bases of empires

This project is the final part of the "Database programming" course at UCenfotec. The purpose of the course is to learn how create functions, stored procedures and other database functionalities rather then just running SQL queries.

The members of the group are:

* Rodrigo Carvajal ([ksco92](https://github.com/ksco92))
* Leo Madrigal ([JLeo7](https://github.com/JLeo7))
* Nicolas Chi ([warmspring9](https://github.com/warmspring9))

## The database

Bases of empires utilizes Oracle as its database engine. In order to create the necessary DB, please follow these steps:

* Connect to the DB using your SQL client of preference with the `system` user.
* Run the `create_user.sql` file.
* Re-connect to the DB using the newly created `WAR_MASTER` user.
* Run the `create_db.sql` file. This will create the necessary tables and inserts to begin the game.

## Stored procedures

The game has a set of stored procedures that will allow you to play the game. You must create all the stored procedures in the `stored_procedures` directory.

### restart_game

Resets the game to its original parameters and deletes all transactions form the previous game.

### buy

Receives the following parameters:
* `p_material -> varchar`
* `p_amount_bought -> number`
* `p_kingdom -> number`

Allows a kingdom to buy wood or iron from the central reserve. Follows these steps:
* Adds the amount of material bought to the kingdom.
* Subtracts gold from the kingdom based on the central reserve price of that material.
* Adds 5 crows to the kingdom.
* Adds the subtracted gold to the central reserve.
* Subtracts the amount of material bought from the central reserve.
* Increase the central reserve price of that material.

### sell

Receives the following parameters:
* `p_material -> varchar`
* `p_amount_sold -> number`
* `p_kingdom -> number`

Allows a kingdom to buy wood or iron from the central reserve. Follows these steps:
* Subtracts the amount of material sold from the kingdom.
* Adds gold to the kingdom based on the central reserve price of that material.
* Adds 10 crows to the kingdom.
* Subtracts the added gold from the central reserve.
* Adds the amount of material bought to the central reserve.
* Decrease the central reserve price of that material.

### train

Receives the following parameters:
* `p_troop -> varchar`
* `p_amount -> number`
* `p_kingdom -> number`

Allows a kingdom to train troops. Follows these steps:
* Subtracts the amount of materials needed to train the amount requested.
* Adds the selected troop to the kingdom.
* Adds the amount of crowns corresponding to the troop and the amount.
* Adds the spent materials into the central reserve.
* Decrease the central reserve price of the materials.

### defenses

Receives the following parameters:
* `p_defense -> varchar`
* `p_amount -> number`
* `p_kingdom -> number`

Allows the kingdom to build defenses. Follows these steps:
* Subtracts the amount of materials needed to build the amount requested.
* Increse the defense of the kingdom.
* Adds the amount of crowns corresponding to the defense and the amount.
* Adds the spent materials into the central reserve.
* Decrese the central reserve price of the materials.

### upgrade

Receives the following parameters:
* `upgrade_type -> varchar`
* `kingdom_id -> number`

Allows the kingdom to upgrade either it's base defense or attack. Follows these steps:
* Checks the upgrade type and subtracts the amount of materials accordingly.
* Boosts either the attack or the defense of the kingdom.
* Adds the subtracted materials to the central reserve and recalculates the prices.
* Generate a transaction based on the upgrade type.

### attack

Receives the following parameters:
* `attaking_kd_id -> number`
* `defending_kd_id -> number`

Allows a kingdom to attack another kingdom. Follows these steps:
* Checks if the attacking kingdom has enough gold to commence the attack.
* Calculates the attack points of the attacking kingdom.
* Calculates the defence points of the defending kingdom.
* Compares the attack points and the defence points to see if the attack is successful or not.
* Calculates the losses and the rewards of the two kingdoms.
* Generate a transaction of 'ATK' type.

### monitor

Provides an overall view of the state of the game.
* Displays how much materials the central reserve has and its prices.
* Displays a ranking of the kingdoms based on a calculation of its attack, defence, armies and crowns.
* Displays a log with each transaction made.


[UCenfotecLogo]: https://www.cenfotec.com.pa/wp-content/themes/ucenfotec_pa-1-2/imagenes/logo-cenfotec-fb.png