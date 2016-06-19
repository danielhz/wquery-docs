---
layout: page
title: Queries
top: true
---

# Quin queries

Quin queries are based in a quin with the following components:

- `?x0` Item (s).
- `?x1` Claim property (p).
- `?x2` Property value (o).
- `?x3` Qualifier property (qp).
- `?x4` Qualifier value (qv).

For each bitmask a file with 300 quins is used. For example, the following quin
is in the CSV file `query_parameters/quins/quins_01110.csv` of the repository
(that corresponds to the bitmask `01110`).

```
?x0 P2239 Q21402571 P636 ?x4
```

Note 1: The variables `?x1` to `?x3` are replaced with constants because
the bitmask contains a 1 in these positions.

Note 2: The property value and the qualifier value are value items.

These quins where generated using the commands:

```
cd $WD_HOME
bin/generate_quins.rb
```

The queries corresponding to the first of these quins are respectively:

### SPARQL (n-ary relations)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX ps: <http://www.wikidata.org/prop/statement/>
SELECT ?s ?qo
WHERE { ?s p:P2239 ?c . ?c ps:P2239 wd:Q21402571 ; p:P636 ?qo . }
LIMIT 10000
```

### SPARQL (named graphs)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
SELECT ?s ?qo
WHERE { GRAPH ?c { ?s p:P2239 wd:Q21402571 . ?c p:P636 ?qo } .
        FILTER (?s != ?c) }
LIMIT 10000
```

### SPARQL (singleton properties)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s ?qo
WHERE { ?s ?c wd:Q21402571 .
        ?c rdf:singletonPropertyOf p:P2239 ; p:P636 ?qo . }
LIMIT 10000
```

### SPARQL (standard reification)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?s ?qo
WHERE { ?c rdf:subject ?s ;
           rdf:predicate p:P2239 ;
           rdf:object wd:Q21402571 ;
           p:P636 ?qo . }
LIMIT 10000
```

### Cypher

```
MATCH (s:Item)-[:PROP_FROM]->(c:Claim)-[:PROP_TO]->(o),
      (c)-[:PROPERTY]->(p:Property),
      (c)-[:QUAL_FROM]->(qn:Qualifier)-[:QUAL_TO]->(q),
      (qn)-[:PROPERTY]->(qp:Property)
WHERE p.id='P2239' AND
      o.id='Q21402571' AND
      qp.id='P636'
RETURN s.id, q.id
LIMIT 10000;
```

### SQL

```
SELECT
  claims.entity_id,
  qualifiers.datavalue_entity
FROM
  claims,
  qualifiers
WHERE
  qualifiers.claim_id = claims.id AND
  claims.property = 'P2239' AND
  claims.datavalue_entity = 'Q21402571' AND
  qualifiers.property = 'P636'
```

### Notes

Note 3: In the RDF model, queries are generated with the `build` method of the
class `Wikidata::QuinQueryBuilder` (see the file `lib/wikidata.rb` in the
repository).

```
quin = %w{?x0 P2239 Q21402571 P636 ?x4}
query_builder = Wikidata::QuinQueryBuilder.new :ostdreif, '01110'
query = query_builder.build quin, 10000
```

Note 4: If the qualifier property or the qualifier value are not specified,
then a left outer join is used. Thus, the operators `OPTIONAL`,
`OPTIONAL MATCH` and `LEFT OUTER JOIN` are used in the SPARQL, Cypher and
SQL implementations, respectively.

# Snowflake queries

Snowflake queries are generated using a list of nodes (codified in JSON).
Each node represents an item (identified with the attribute `entity_id`)
of such nodes. For each node, a set of claims is selected. Each claim, is
codified with a pair `[P,X]`, where `P` is the claim property and `X` is a
item value id, a 0 (the item value of the claim is not projected in the
solution) or a 1 (the item value of the claim is projected in the solution).
Also, the attribute `property` codifies the property that join nodes in the
snowflake.
For example, the following is a snowflake list of the file:

```
[{"entity_id":"Q6260140",
  "claims":[["P102",0],["P735","Q4925477"],["P31",0]],
  "property":"P27"},
 {"entity_id":"Q30"
  "claims":[["P1792",1]],
  "property":"P530"},
 {"entity_id":"Q408",
  "claims":[["P1343",1],["P1792",1]]}]
```

The snowflake parameters are stored in the folder
`query_parameters/paths` of the code repository. To generate these
parameters we first generate the tables containing tuples with items
that are connected and that have at least out-degree of properties to
other items of 5. This tables are generated with the SQL scripts in
the folder `wikidata-experiments/sql/parameters_2`. Then we run the
following command:

```
cd wikidata-experiments/sql/parameters_2
./generate_path.rb 1 500
./generate_path.rb 2 500
```

### SPARQL (n-ary relations)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX ps: <http://www.wikidata.org/prop/statement/>
PREFIX wikibase: <http://wikiba.se/ontology-beta#>
SELECT ?x0 ?x1 ?x1y0 ?x2 ?x2y0 ?x2y1
WHERE {
  ?x0 p:P102 ?claim_x0y0 .
  ?claim_x0y0 ps:P102 ?x0y0 .
  ?x0 p:P735 ?claim_x0y1 .
  ?claim_x0y1 ps:P735 wd:Q4925477 .
  ?x0 p:P31 ?claim_x0y2 .
  ?claim_x0y2 ps:P31 ?x0y2 .
  ?x0 p:P27 ?claim_x0 .
  ?claim_x0 ps:P27 ?x1 .
  ?x1 p:P1792 ?claim_x1y0 .
  ?claim_x1y0 ps:P1792 ?x1y0 .
  ?x1 p:P530 ?claim_x1 .
  ?claim_x1 ps:P530 ?x2 .
  ?x2 p:P1343 ?claim_x2y0 .
  ?claim_x2y0 ps:P1343 ?x2y0 .
  ?x2 p:P1792 ?claim_x2y1 .
  ?claim_x2y1 ps:P1792 ?x2y1 . }
LIMIT 10000
```

### SPARQL (named graphs)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
SELECT ?x0 ?x1 ?x1y0 ?x2 ?x2y0 ?x2y1
WHERE {
  GRAPH ?claim_x0y0 { ?x0 p:P102 ?x0y0 } .
  GRAPH ?claim_x0y1 { ?x0 p:P735 wd:Q4925477 } .
  GRAPH ?claim_x0y2 { ?x0 p:P31 ?x0y2 } .
  GRAPH ?claim_x0 { ?x0 p:P27 ?x1 } .
  GRAPH ?claim_x1y0 { ?x1 p:P1792 ?x1y0 } .
  GRAPH ?claim_x1 { ?x1 p:P530 ?x2 } .
  GRAPH ?claim_x2y0 { ?x2 p:P1343 ?x2y0 } .
  GRAPH ?claim_x2y1 { ?x2 p:P1792 ?x2y1 } . }
LIMIT 10000
```

### SPARQL (singleton properties)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX p: <http://www.wikidata.org/prop/>
SELECT ?x0 ?x1 ?x1y0 ?x2 ?x2y0 ?x2y1
WHERE {
  ?x0 ?claim_x0y0 ?x0y0 . ?claim_x0y0 rdf:singletonPropertyOf p:P102 .
  ?x0 ?claim_x0y1 wd:Q4925477 . ?claim_x0y1 rdf:singletonPropertyOf p:P735 .
  ?x0 ?claim_x0y2 ?x0y2 . ?claim_x0y2 rdf:singletonPropertyOf p:P31 .
  ?x0 ?claim_x0 ?x1 . ?claim_x0 rdf:singletonPropertyOf p:P27 .
  ?x1 ?claim_x1y0 ?x1y0 . ?claim_x1y0 rdf:singletonPropertyOf p:P1792 .
  ?x1 ?claim_x1 ?x2 . ?claim_x1 rdf:singletonPropertyOf p:P530 .
  ?x2 ?claim_x2y0 ?x2y0 . ?claim_x2y0 rdf:singletonPropertyOf p:P1343 .
  ?x2 ?claim_x2y1 ?x2y1 . ?claim_x2y1 rdf:singletonPropertyOf p:P1792 . }
LIMIT 10000
```

### SPARQL (standard reification)

```
PREFIX wd: <http://www.wikidata.org/entity/>
PREFIX p: <http://www.wikidata.org/prop/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
SELECT ?x0 ?x1 ?x1y0 ?x2 ?x2y0 ?x2y1
WHERE {
  ?claim_x0y0 rdf:subject ?x0 .
  ?claim_x0y0 rdf:predicate p:P102 .
  ?claim_x0y0 rdf:object ?x0y0 .
  ?claim_x0y1 rdf:subject ?x0 .
  ?claim_x0y1 rdf:predicate p:P735 .
  ?claim_x0y1 rdf:object wd:Q4925477 .
  ?claim_x0y2 rdf:subject ?x0 .
  ?claim_x0y2 rdf:predicate p:P31 .
  ?claim_x0y2 rdf:object ?x0y2 .
  ?claim_x0 rdf:subject ?x0 .
  ?claim_x0 rdf:predicate p:P27 .
  ?claim_x0 rdf:object ?x1 .
  ?claim_x1y0 rdf:subject ?x1 .
  ?claim_x1y0 rdf:predicate p:P1792 .
  ?claim_x1y0 rdf:object ?x1y0 .
  ?claim_x1 rdf:subject ?x1 .
  ?claim_x1 rdf:predicate p:P530 .
  ?claim_x1 rdf:object ?x2 .
  ?claim_x2y0 rdf:subject ?x2 .
  ?claim_x2y0 rdf:predicate p:P1343 .
  ?claim_x2y0 rdf:object ?x2y0 .
  ?claim_x2y1 rdf:subject ?x2 .
  ?claim_x2y1 rdf:predicate p:P1792 .
  ?claim_x2y1 rdf:object ?x2y1 . }
LIMIT 10000
```

### Cypher

```
MATCH (x0:Item)-[:PROP_FROM]->(c0:Claim)-[:PROP_TO]->(x1:Item),
      (c0)-[:PROPERTY]->(:Property {id:"P27"}),
      (x0)-[:PROP_FROM]->(cx0y0:Claim)-[:PROP_TO]->(x0y0:Item),
      (cx0y0)-[:PROPERTY]->(:Property {id:"P102"}),
      (x0)-[:PROP_FROM]->(cx0y1:Claim)-[:PROP_TO]->(x0y1:Item {id:"Q4925477"}),
      (cx0y1)-[:PROPERTY]->(:Property {id:"P735"}),
      (x0)-[:PROP_FROM]->(cx0y2:Claim)-[:PROP_TO]->(x0y2:Item),
      (cx0y2)-[:PROPERTY]->(:Property {id:"P31"}),
      (x1:Item)-[:PROP_FROM]->(c1:Claim)-[:PROP_TO]->(x2:Item),
      (c1)-[:PROPERTY]->(:Property {id:"P530"}),
      (x1)-[:PROP_FROM]->(cx1y0:Claim)-[:PROP_TO]->(x1y0:Item),
      (cx1y0)-[:PROPERTY]->(:Property {id:"P1792"}),
      (x2)-[:PROP_FROM]->(cx2y0:Claim)-[:PROP_TO]->(x2y0:Item),
      (cx2y0)-[:PROPERTY]->(:Property {id:"P1343"}),
      (x2)-[:PROP_FROM]->(cx2y1:Claim)-[:PROP_TO]->(x2y1:Item),
      (cx2y1)-[:PROPERTY]->(:Property {id:"P1792"})
RETURN x0.id x1.id x1y0.id x2.id x2y0.id x2y1.id
LIMIT 10000;
```

### SQL

```
SELECT
  c0.entity_id,
  c1.entity_id,
  x1y0.datavalue_entity,
  c2.entity_id,
  x2y0.datavalue_entity,
  x2y1.datavalue_entity
FROM
  claims AS c0,
  claims AS c1,
  claims AS cx0y0,
  claims AS cx0y1,
  claims AS cx0y2,
  claims AS cx1y0,
  claims AS cx2y0,
  claims AS cx2y1
WHERE
  c0.datavalue_entity = c1.entity_id AND
  c0.property = 'P27' AND
  c0.datavalue_entity = cx0y0.entity_id AND
  cx0y0.property = 'P102' AND
  c0.datavalue_entity = cx0y1.entity_id AND
  cx0y1.property = 'P735' AND
  cx0y1.datavalue_entity = 'Q4925477' AND
  c0.datavalue_entity = cx0y2.entity_id AND
  cx0y2.property = 'P31' AND
  c1.datavalue_entity = c2.entity_id AND
  c1.property = 'P530' AND
  c1.datavalue_entity = cx1y0.entity_id AND
  cx1y0.property = 'P1792' AND
  c2.datavalue_entity = cx2y0.entity_id AND
  cx2y0.property = 'P1343' AND
  c2.datavalue_entity = cx2y1.entity_id AND
  cx2y0.property = 'P1792'
```

### Notes

Note 5: In the RDF model, queries are generated with the `build` method of the
class `Wikidata::PathQueryBuilder` (see the file `lib/wikidata.rb` in the
repository).

```
path = [
  {"entity_id"=>"Q6260140",
   "claims"=>[["P102", 0], ["P735", "Q4925477"], ["P31", 0]],
   "property"=>"P27"},
  {"entity_id"=>"Q30",
   "claims"=>[["P1792", 1]],
   "property"=>"P530"},
  {"entity_id"=>"Q408",
   "claims"=>[["P1343", 1], ["P1792", 1]]}]
query_builder = Wikidata::PathQueryBuilder.new :stdreif
query = query_builder.build path, 10000
```
