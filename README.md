# Bases of empires

## The database

Bases of empires utilizes Oracle as its database engine. In order to create the necessary DB, please follow these steps:

* Connect to the DB using your SQL client of preference with the `system` user.
* Run the `create_user.sql` file.
* Re-connect to the DB using the newly created `WAR_MASTER` user.
* Run the `create_db.sql` file. This will create the necessary tables and inserts to begin the game.
