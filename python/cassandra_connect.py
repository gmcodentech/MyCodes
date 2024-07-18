from cassandra.cluster import Cluster
cluster = Cluster(['127.0.0.1'],port=9042)
session = cluster.connect('testingks')
result = session.execute('select id,name,price,units from products')
for row in result:
 print(row[0],row[1],row[2],row[3])
