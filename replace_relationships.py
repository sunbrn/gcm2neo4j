from neo4jrestclient.client import GraphDatabase

import sys

connection_string = "http://neo4j:"+ sys.argv[1] + "@geco.deib.polimi.it:7474/db/data/"
graph = GraphDatabase(connection_string)
tx = graph.transaction(for_query=True)

sources_without_replicate = {"Roadmap Epigenomics","TCGA"}

#sources_without_case = {"Cistrome","Annotation","TADs"}

#sources_without_rep_bs = {"Annotation"}

for s in sources_without_replicate:
    create_rel = "MATCH " \
                         "p1=(i:Item)-[*..2]-(p:Project), " \
                         "p2=(i:Item)--(r:Replicate), " \
                         "p3=(r:Replicate)--(b:Biosample), " \
                         "p4=(b:Biosample)--(d:Donor) " \
                         "WHERE p.source='" + s + "' " \
                         "CREATE (i)-[re:Item2Biosample]->(b)"

    tx.append(create_rel)

    delete_rel = "MATCH " \
                 "p1=(i:Item)-[*..2]-(p:Project), " \
                 "p2=(i:Item)--(r:Replicate), " \
                 "p3=(r:Replicate)--(b:Biosample), " \
                 "p4=(b:Biosample)--(d:Donor) " \
                 "WHERE p.source='" + s + "' " \
                 "DETACH DELETE r"

    tx.append(delete_rel)

tx.commit()


#for s in sources_without_case:
#    create_rel = "MATCH " \
#                         "p1=(i:Item)--(c:Case), " \
#                         "p2=(c:Case)--(p:Project) " \
#                         "WHERE p.source='" + s + "' " \
#                         "CREATE (i)-[re:Item2Project]->(p)"
#
#    tx.append(create_rel)
#
#   create_rel = "MATCH " \
#                         "p1=(i:Item)--(c:Case), " \
#                         "p2=(c:Case)--(p:Project) " \
#                         "WHERE p.source='" + s + "' " \
#                         "DETACH DELETE c"
#
#    tx.append(create_rel)
#
#tx.commit()



#for s in sources_without_rep_bs:
#    create_rel = "MATCH " \
#                         "p1=(i:Item)-[*..2]-(p:Project), " \
#                         "p2=(i:Item)--(r:Replicate), " \
#                         "p3=(r:Replicate)--(b:Biosample), " \
#                         "p4=(b:Biosample)--(d:Donor) " \
#                         "WHERE p.source='" + s + "' " \
#                         "CREATE (i)-[re:Item2Donor]->(d)"
#
#    tx.append(create_rel)
#
#    delete_rel = "MATCH " \
#                 "p1=(i:Item)-[*..2]-(p:Project), " \
#                 "p2=(i:Item)--(r:Replicate), " \
#                 "p3=(r:Replicate)--(b:Biosample), " \
#                 "p4=(b:Biosample)--(d:Donor) " \
#                 "WHERE p.source='" + s + "' " \
#                 "DETACH DELETE r,b"
#
#    tx.append(delete_rel)
#
#tx.commit()




