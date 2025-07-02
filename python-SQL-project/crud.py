import mysql.connector
try:
    conn = mysql.connector.connect(
        host='127.0.0.1',
        user = 'root',
        password = '',
        database = 'indigo'
    )
    mycursor = conn.cursor()
    print('Connection established')
except:
    print('Connection error')

# create a data abse
#mycursor.execute("CREATE DATABASE indigo")
#conn.commit()

#create a table
mycursor.execute("""
    CREATE TABLE IF NOT EXISTS aierport (
        airport_id int PRIMARY KEY,
        code varchar(10) NOT NULL,
        city varchar(10) NOT NULL,
        name varchar(10) NOT NULL
)
""")
conn.commit()

#insert data
#mycursor.execute("""
#Insert into aierport values (1,'del','new delhi','igia'),
#(2,'ccu','Kolkata','NSCA'),(3,'BOM','Mumbai','CSMA')
#""")
#conn.commit()

#featch data
mycursor.execute("Select * from aierport where airport_id>1")
data=mycursor.fetchall()
print(data)

for i in data:
    print(i[3])

#mycursor.execute("""
#update aierport
#set name= 'Bombay'
#where airport_id=3
#""")
#conn.commit()
mycursor.execute("Select * from aierport where airport_id>1")
data=mycursor.fetchall()
print(data)


# DELETE
mycursor.execute("DELETE FROM aierport WHERE airport_id = 3")
conn.commit()

mycursor.execute("SELECT * FROM aierport")
data = mycursor.fetchall()
print(data)