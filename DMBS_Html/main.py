from flask import Flask, render_template, jsonify
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

@app.route('/login')
def login():
    return render_template('login.html')


if __name__ == '__main__':
    app.run(debug=True)