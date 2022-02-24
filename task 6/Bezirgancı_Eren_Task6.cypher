MATCH (laws:Bill)-[r:SPONSORED_BY]->(person:Legislator{party:"republican" })-[r2:REPRESENTS]->(state:State{code:"CA"})
WHERE duration.between(date(person.birthday),date()).years > 65
RETURN
laws;




MATCH (p:Legislator{lastName:"Aderholt", firstName:"Robert"})-[r:VOTED_ON]->(b:Bill)					
WHERE r.vote="Aye" OR r.vote="Yea"					
RETURN count(DISTINCT b);					





MATCH (b:Bill)-[PROPOSED_DURING]->(c:Congress{number:"114"}) 
RETURN count(DISTINCT b)
MATCH (b:Bill{active:"True"})-[PROPOSED_DURING]->(c:Congress{number:"114"}) 
RETURN count(DISTINCT b)





MATCH (n:State)
CALL{
    WITH n
    MATCH (n)<-[REPRESENT]-(p:Legislator)
    WHERE p.currentParty = "Democrat"

    WITH count(p) as democrats, n
    RETURN democrats
}
CALL{
    WITH n
    MATCH (n)<-[REPRESENT]-(p:Legislator)
    WITH count(p) as total, n
    RETURN total
}
WITH n AS states, democrats, total
WHERE democrats >  total-democrats
RETURN  states, democrats,total





MATCH(p:Legislator{state:"OH"})-[r:ELECTED_TO]->(b:Body)
CALL{
    WITH p
    MATCH (p)-[r2:IS_MEMBER_OF]->(k:Party)
    RETURN k,r2
} RETURN *








MATCH (n:State)
CALL{
    WITH n
    MATCH (n)<-[REPRESENT]-(p:Legislator)-[SERVES_ON]->(c:Committee)
    WITH count(DISTINCT c) as total, n as state
    RETURN total, state
}

CALL{
  
    MATCH (n:State)<-[REPRESENT]-(p:Legislator)-[SERVES_ON]->(c:Committee)
    WITH count(DISTINCT c) as total, n as state
    WITH max(total) as max
    RETURN max

}
WITH state, max, total
WHERE total>= max
RETURN state, max, total








 
MATCH (n:State)
CALL{
  WITH n
  MATCH (n)<-[REPRESENT]-(p:Legislator)
  WITH n, count(distinct p) as number
  RETURN number
}
CALL{  
  MATCH (n:State)<-[REPRESENT]-(p:Legislator)
  WITH n, count(distinct p) as per
  WITH avg(per) as avg
  RETURN avg
}

CALL{
    WITH n
    MATCH (n)<-[REPRESENT]-(p:Legislator)
    WHERE p.currentParty = "Democrat"

    WITH count(p) as democrats, n
    RETURN democrats
}
CALL{
    WITH n
    MATCH (n)<-[REPRESENT]-(p:Legislator)
    WITH count(p) as total, n
    RETURN total
}
WITH n,avg, number,democrats,total
WHERE number > avg and democrats >  total-democrats
Return n as state ,  avg, number







MATCH (n1:Character)-[a:ATTACT]->(n2:Character)
WITH n1,count(DISTINCT a) as int
RETURN  min(int) as minimum ,  max(int) as maximumn, avg(int) as average







MATCH (n1:Character{Label:"Elrond"}), (n2:Character{Label:"Sauron"}),p=shortestPath((n1)-[*]-(n2))
RETURN  p







MATCH (n1:Character)-[a:ATTACT]->(n2:Character)
WITH n1,count(DISTINCT a) as int
ORDER BY int DESC
WITH collect(n1.Label + ": " + int +" connections") as col
WITH col[0..5] AS maximum_connection, col[size(col)-5..size(col)] AS minimum_connection
RETURN maximum_connection, minimum_connection








CALL gds.graph.create('myGraph', 'Character', 'ATTACT') 

CALL gds.betweenness.stream('myGraph')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).Label AS name, score
ORDER BY score DESC
