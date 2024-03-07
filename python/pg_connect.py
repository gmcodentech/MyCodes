import psycopg2 as pg

conn = pg.connect(host="localhost",port="5432",database="ProductsDB",user="postgres",password="1234")

cur = conn.cursor()

cur.execute('Select * From public."Products"')

result = cur.fetchall()

for row in result:
    for col in row:
        print(col,end=' ')
    print()

conn.close()
#thanks for watching this video...