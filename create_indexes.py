from neo4jrestclient.client import GraphDatabase

import sys

connection_string = "http://neo4j:"+ sys.argv[1] + "@geco.deib.polimi.it:7474/db/data/"
graph = GraphDatabase(connection_string)
tx = graph.transaction(for_query=True)

donor_index = "CREATE INDEX ON :Donor(donor_source_id)"
tx.append(donor_index)
tx.commit()

biosample_index = "CREATE INDEX ON :Biosample(biosample_source_id)"
tx.append(biosample_index)
tx.commit()

replicate_index = "CREATE INDEX ON :Replicate(replicate_source_id)"
tx.append(replicate_index)
tx.commit()

item_index = "CREATE INDEX ON :Item(item_source_id)"
tx.append(item_index)
tx.commit()

case_index = "CREATE INDEX ON :Case(case_source_id)"
tx.append(case_index)
tx.commit()

pair_index_key = "CREATE INDEX ON :Pair(key)"
tx.append(pair_index_key)
tx.commit()

pair_index_value = "CREATE INDEX ON :Pair(value)"
tx.append(pair_index_value)
tx.commit()

pair_index_key_value = "CREATE INDEX ON :Pair(key,value)"
tx.append(pair_index_key_value)
tx.commit()
