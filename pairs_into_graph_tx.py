from neo4jrestclient.client import GraphDatabase

import csv

from datetime import datetime

graph = GraphDatabase("http://neo4j:yellow@geco.deib.polimi.it:17474/db/data/")
tx = graph.transaction(for_query=True)

i=0

with open('import/gcm_entities/pairs.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter='\t')

    cur = next(csvreader)
    last_read_line = cur

    pair_dict = {}
    pair_dict.setdefault(cur[1], []).append(cur[2])

    for cur in csvreader:

        if cur[0] == last_read_line[0]:
            pair_dict.setdefault(cur[1], []).append(bytes(cur[2], 'utf-8').decode('utf-8','ignore'))
        else:
            i = i+1
            
            current_query_node = "CREATE (pair:PairsOfItem {pair_id:'pa" + last_read_line[0] + "', " \
                                 + ', '.join("{!s}:{!r}".format(k, v) for (k, v) in pair_dict.items()) \
                                 + "}) RETURN pair"
            tx.append(current_query_node)
            
            pair_dict.clear()
            pair_dict.setdefault(cur[1], []).append(cur[2])

            if i%100 == 0:
                tx.commit()
                print(i)
                print(datetime.now())

        last_read_line = cur

    current_query_node = "CREATE (pair:PairsOfItem {pair_id:'pa" + last_read_line[0] + "', " \
                         + ', '.join("{!s}:{!r}".format(k, v) for (k, v) in pair_dict.items()) \
                         + "}) RETURN pair"
    tx.append(current_query_node)
    tx.commit()

    query_rel = "MATCH (i:Item),(p:PairsOfItem) WHERE replace(i.item_id,'i','') = replace(p.pair_id,'pa','')  CREATE (i)-[r:HasPairs]->(p)"
    tx.append(query_rel)
    tx.commit()

