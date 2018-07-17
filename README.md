# Bases of empires

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

Recives the following parameters:
* `p_troop -> varchar`
* `p_amount -> number`
* `p_kingdom -> number`

Allows a kingdom to train troops. Follows these steps:
* Subtracts the amount of materials needed to train the amount requested.
* Adds the selected troop to the kingdom.
* Adds the amount of crowns corresponding to the troop and the amount.
* Adds the spent materials into the central reserve.
* Decrese the central reserve price of the materials.

### defences

Recives the following parameters:
* `p_defense -> varchar`
* `p_amount -> number`
* `p_kingdom -> number`

Allows the kingdom to build defenses. Follows these steps:
* Subtracts the amount of materials needed to build the amount requested.
* Increse the defense of the kingdom.
* Adds the amount of crowns corresponding to the defense and the amount.
* Adds the spent materials into the central reserve.
* Decrese the central reserve price of the materials.