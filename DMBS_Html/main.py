from flask import Flask, render_template, jsonify, request, redirect, url_for,send_from_directory
import mysql.connector


app = Flask(__name__)


@app.route('/')
def index():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    # Fetch data from the database
    cursor.execute("SELECT Pos, Team_Name, Total_Points FROM constructor_standings")
    standings_data = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()

    cursor = connection.cursor(dictionary=True)

    # Fetch data from the database
    cursor.execute("SELECT Pos, Driver_Name, Total_Points FROM driver_standings")
    standings_data2 = cursor.fetchall()

    # Close the cursor and connection
    cursor.close()

    connection.close()

    return render_template('index.html', constructorStandings=standings_data, driverStandings=standings_data2)


@app.route('/allteams')
def allteams():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    cursor.execute('''SELECT 
    c.Pos,
    d1.Driver_Name AS Driver_1_Name,
    d2.Driver_Name AS Driver_2_Name,
    t.Team_Name,
    c.Total_Points
FROM 
    constructor_standings c
JOIN 
    teams t ON c.Team_id = t.Team_id
JOIN 
    drivers d1 ON t.Driver_1 = d1.Driver_Id
JOIN 
    drivers d2 ON t.Driver_2 = d2.Driver_Id;
''')
    allteam_data=cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('allteams.html', teams=allteam_data)

@app.route('/races')
def races():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    cursor.execute("select Race_Name,Date from races;")
    araces=cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('racesall.html', racesa=araces)


users = [
    {'username': 'user1', 'password': 'pass1'},
    {'username': 'user2', 'password': 'pass2'},
    # Add more users as needed
]


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Check if the user credentials are valid
        for user in users:
            if user['username'] == username and user['password'] == password:
                # Redirect to the home page after successful login
                return redirect(url_for('fiaAdmin'))

        # If credentials are not valid, render the login page again with an error message
        return render_template('login.html', error='Invalid credentials')

    # If it's a GET request, just render the login page
    return render_template('login.html')


@app.route('/fiaAdmin')
def fiaAdmin():
    return render_template('fia-home.html')


# Function to fetch available drivers who are not part of any existing team
def get_available_drivers():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)
    cursor.execute('''SELECT Driver_Id, Driver_Name 
                      FROM drivers 
                      WHERE Driver_Id NOT IN 
                          (SELECT Driver_1 FROM teams 
                           UNION 
                           SELECT Driver_2 FROM teams)''')
    drivers = cursor.fetchall()
    cursor.close()
    connection.close()
    return drivers


@app.route('/fiaAdmin/createteam', methods=['GET', 'POST'])
def createteam():
    if request.method == 'POST':
        team_id = request.form['teamId']
        team_name = request.form['teamName']
        team_origin = request.form['teamOrigin']
        driver1 = request.form['driver1']
        driver2 = request.form['driver2']

        # Insert the new team into the database
        connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
        cursor = connection.cursor()

        # Insert new team into teams table
        cursor.execute('''INSERT INTO teams (Team_Id, Team_Name, Origin, Driver_1, Driver_2) 
                          VALUES (%s, %s, %s, %s, %s)''', (team_id, team_name, team_origin, driver1, driver2))
        connection.commit()

        # Calculate the next Pos value based on the highest Pos value in constructor_standings table
        cursor.execute("SELECT MAX(Pos) AS max_pos FROM constructor_standings")
        max_pos = cursor.fetchone()[0]
        next_pos = max_pos + 1 if max_pos is not None else 1

        # Add a new row with calculated Pos value into constructor_standings table
        cursor.execute('''INSERT INTO constructor_standings (Team_id, Pos,Team_name,Wins,Podiums, Total_Points) 
                          VALUES (%s, %s, %s, 0, 0, 0)''', (team_id, next_pos, team_name))
        connection.commit()

        cursor.close()
        connection.close()

        return redirect(url_for('fiaAdmin'))

    else:
        # Fetch available drivers
        available_drivers = get_available_drivers()
        return render_template('createteam.html', drivers=available_drivers)


@app.route('/fiaAdmin/createdriver', methods=['GET', 'POST'])
def createdriver():
    if request.method == 'POST':
        driver_id = request.form['driverId']
        driver_name = request.form['driverName']
        driver_nationality = request.form['driverNationality']
        driver_age = request.form['driverAge']

        # Insert the new driver into the database
        connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
        cursor = connection.cursor()
        cursor.execute('''INSERT INTO drivers (Driver_Id, Driver_Name, Nationality, Age) 
                          VALUES (%s, %s, %s, %s)''', (driver_id, driver_name, driver_nationality, driver_age))
        connection.commit()
        cursor.execute("SELECT MAX(Pos) AS max_pos FROM driver_standings")
        max_pos = cursor.fetchone()[0]
        next_pos = max_pos + 1 if max_pos is not None else 1

        cursor.execute('''INSERT INTO driver_standings (Pos,Driver_id,Driver_Name,Wins,Podiums,Total_points) 
                                  VALUES (%s, %s, %s, 0, 0, 0)''', (next_pos, driver_id, driver_name))
        connection.commit()

        cursor.close()
        connection.close()

        return redirect(url_for('fiaAdmin'))

    else:
        return render_template('createdriver.html')


@app.route('/fiaAdmin/deletedriver')
def deletedriver():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    # Fetch drivers for the dropdown
    cursor.execute("SELECT Driver_Id, Driver_Name FROM drivers")
    drivers_data = cursor.fetchall()

    cursor.close()
    connection.close()

    return render_template('deletedriver.html', drivers=drivers_data)


@app.route('/delete-driver', methods=['POST'])
def delete_driver():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    # Get the selected driver ID to delete
    driver_id_to_delete = request.form.get('driverId')

    # Execute the delete query
    cursor.execute("UPDATE teams SET Driver_1 = NULL WHERE Driver_1 = %s", (driver_id_to_delete,))
    cursor.execute("UPDATE teams SET Driver_2 = NULL WHERE Driver_2 = %s", (driver_id_to_delete,))
    cursor.execute("DELETE FROM driver_standings WHERE Driver_id = %s", (driver_id_to_delete,))
    cursor.execute("DELETE FROM drivers WHERE Driver_id = %s", (driver_id_to_delete,))

    # Commit the changes
    connection.commit()

    cursor.close()
    connection.close()

    return redirect(url_for('deletedriver'))


@app.route('/delete_team', methods=['GET', 'POST'])
def delete_team():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    try:
        if request.method == 'POST':
            selected_team_id = request.form['teamToDelete']

            # Update results table to make team_id NULL
            cursor.execute("UPDATE results SET team_id = NULL WHERE team_id = %s", (selected_team_id,))

            # Delete data from constructors_standings table
            cursor.execute("DELETE FROM constructor_standings WHERE Team_id = %s", (selected_team_id,))

            # Delete data from teams table
            cursor.execute("DELETE FROM teams WHERE Team_id = %s", (selected_team_id,))

            # Commit the changes
            connection.commit()

            return redirect(url_for('allteams'))

        # Fetch available teams for dropdown
        cursor.execute("SELECT Team_id, Team_Name FROM teams")
        teams_data = cursor.fetchall()

        return render_template('delete_team.html', teams=teams_data)

    finally:
        cursor.close()
        connection.close()




@app.route('/modify_team', methods=['GET', 'POST'])
def modify_team():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    try:
        if request.method == 'POST':
            selected_team_id = request.form['teamSelect']
            new_team_name = request.form['newName']
            new_team_origin = request.form['newOrigin']

            # Update the team details in the teams table
            cursor.execute("UPDATE teams SET Team_Name = %s, Origin = %s WHERE Team_id = %s", (new_team_name, new_team_origin, selected_team_id))

            # Commit the changes
            connection.commit()

            return redirect(url_for('fiaAdmin'))  # Redirect to fia_home on success

        # Fetch available teams for dropdown
        cursor.execute("SELECT Team_id, Team_Name, Origin FROM teams")
        teams_data = cursor.fetchall()

        return render_template('modify_team.html', teams=teams_data)

    except mysql.connector.Error as e:
        # Log the error
        app.logger.error('MySQL error: %s', e)

        # Rollback the changes in case of an error
        connection.rollback()

        return render_template('error.html')  # Render error template if SQL query fails

    finally:
        # Close the cursor and connection
        cursor.close()
        connection.close()


def get_all_drivers():
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    # Fetch all drivers from the database
    cursor.execute("SELECT Driver_Id, Driver_Name FROM drivers")
    drivers = cursor.fetchall()

    cursor.close()
    connection.close()
    return drivers

@app.route('/fiaAdmin/updatedriver', methods=['GET', 'POST'])
def updatedriver():
    if request.method == 'POST':
        driver_id = request.form['driverSelect']
        new_name = request.form['newName']
        new_age = request.form['newAge']
        new_nationality = request.form['newNationality']

        # Update driver details in the database
        connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
        cursor = connection.cursor()

        cursor.execute('''UPDATE drivers 
                          SET Driver_Name = %s, Age = %s, Nationality = %s 
                          WHERE Driver_Id = %s''', (new_name, new_age, new_nationality, driver_id))
        connection.commit()

        cursor.close()
        connection.close()

        return redirect(url_for('fiaAdmin'))

    else:
        # Fetch all drivers
        all_drivers = get_all_drivers()
        return render_template('updatedriver.html', drivers=all_drivers)


@app.route('/team/<team_id>')
def team_detail(team_id):
    connection = mysql.connector.connect(host="localhost", user="root", password="steaninav", database="formula")
    cursor = connection.cursor(dictionary=True)

    cursor.execute('''SELECT 
                        t.Team_Name, 
                        t.Origin, 
                        d1.Driver_Name AS Driver1_Name, 
                        d2.Driver_Name AS Driver2_Name,
                        d1.Image AS Driver1_Image,
                        d2.Image AS Driver2_Image
                    FROM 
                        teams t
                    JOIN 
                        drivers d1 ON t.Driver_1 = d1.Driver_Id
                    JOIN 
                        drivers d2 ON t.Driver_2 = d2.Driver_Id
                    WHERE 
                        t.Team_Id = %s''', (team_id,))

    team_details = cursor.fetchone()

    cursor.close()
    connection.close()

    return render_template('team_detail.html', **team_details)

if __name__ == '__main__':
    app.run(debug=True)