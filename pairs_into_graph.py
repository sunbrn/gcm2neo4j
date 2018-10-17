from neo4jrestclient.client import GraphDatabase

import csv

graph = GraphDatabase("http://neo4j:yellow@localhost:7474/db/data/")

with open('import/gcm_entities/pairs.csv', 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter='\t')

    cur = next(csvreader)
    last_read_line = cur

    pair_dict = {}
    pair_dict.setdefault(cur[1], []).append(cur[2])

    for cur in csvreader:

        if cur[0] == last_read_line[0]:
            pair_dict.setdefault(cur[1], []).append(bytes(cur[2], 'utf-8').decode('utf-8', 'ignore'))
        else:
            current_query_node = "CREATE (pair:PairsOfItem {pair_id:'pa" + last_read_line[0] + "', " \
                                 + ', '.join("{!s}:{!r}".format(k, v) for (k, v) in pair_dict.items()) \
                                 + "}) RETURN pair"
            graph.query(current_query_node)

            current_query_rel = "MATCH (i:Item),(pa:PairsOfItem) WHERE i.item_id='i" + last_read_line[0] + "' "\
                                + "AND pa.pair_id='pa" + last_read_line[0] + "' " \
                                + "CREATE (i)-[r:HasPairs]->(pa)"
            graph.query(current_query_rel)

            pair_dict.clear()
            pair_dict.setdefault(cur[1], []).append(cur[2])

        last_read_line = cur

    current_query_node = "CREATE (pair:PairsOfItem {pair_id:'pa" + last_read_line[0] + "', " \
                         + ', '.join("{!s}:{!r}".format(k, v) for (k, v) in pair_dict.items()) \
                         + "}) RETURN pair"
    graph.query(current_query_node)

    current_query_rel = "MATCH (i:Item),(pa:PairsOfItem) WHERE i.item_id='i" + last_read_line[0] + "' "\
                                + "AND pa.pair_id='pa" + last_read_line[0] + "' " \
                                + "CREATE (i)-[r:HasPairs]->(pa)"
    graph.query(current_query_rel)



