---
layout: default
---

This pages aims to make repeatable the experiments described in the paper
*Querying Wikidata: Comparing SPARQL, Relational and Graph Databases* (by
[Daniel Hernández](http://users.dcc.uchile.cl/~dhernand/),
[Aidan Hogan](http://users.dcc.uchile.cl/~ahogan/),
[Cristian Riveros](http://web.ing.puc.cl/~criveros/),
Carlos Rojas and Enzo Zerega).

# Additional resources

Resources that complement the submited paper are:

* This document (<https://dx.doi.org/10.6084/m9.figshare.3219217.v3>).
* The code and results (<https://bitbucket.org/danielhz/wikidata-experiments>).
* The data (<https://dx.doi.org/10.6084/m9.figshare.3208498.v1>).

# The data

All experiments are done using the dump of Wikidata published on
January 04, 2017. The original dump was downloaded from the
[dumps folder](https://dumps.wikimedia.org/other/wikidata/) published by
the Wikimedia Foundation. However, the contains in this folder are frequently
updated and old dumps are discarded. Thus, to make this experiment repeatable
we [archive](https://dx.doi.org/10.6084/m9.figshare.3208498.v1) the dump used.

# Code and results

All the code used to run the experiments and the results is tracked in the
git repository
[wikidata-experiments](https://bitbucket.org/danielhz/wikidata-experiments).
This code allows to:

* Translate the data to different models used in the experiments.
* Load the data into the respective databases.
* Clean and fix the data.
* Generate parameters for queries that are generated randomly.
* Run the experiments.

# License

All our code and documentation is published under the
[Creative Commons CC-BY License](http://creativecommons.org/licenses/by/4.0/).
The Wikidata dump is published under
[Creative Commons CC0 License](https://creativecommons.org/publicdomain/zero/1.0/).
All of the engines used in this experiments are
distributed under open licenses. PostgreSQL uses the
[PostgreSQL License](https://opensource.org/licenses/postgresql),
Virtuoso Opensource uses the
[GPLv2 Licence](https://github.com/openlink/virtuoso-opensource/blob/develop/7/LICENSE),
Blazegraph uses the
[GPLv2 License](https://www.blazegraph.com/services/blazegraph-licensing/)
licence and Neo4j Community Edition uses the
[GPLv3 License](http://neo4j.com/licensing/).

# Experimental settings

**Machine:** All experiments were run on a single machine with 2× Intel Xeon
Six Core E5-2609 V3 CPUs, 32GB of RAM, and 2× 1TB Seagate 7200 RPM
32MB Cache SATA hard-disks in a RAID-1 configuration.

**System:** All experiments where run on a Debian 7 system. The partition
mounted in `/` (which has only 55GB) is not enough for the data used. Thus,
when necessary we use the partition mount in `/home` (which has 1.7TB) for
the data.

**User:** All experiments will be run for a user identified as `$USER` which
home is `/home/$USER`. Also, `$USER` is in the `sudo` group.

**Code:** Code of experiments that use the RDF data model is tracked in
[a git repository](https://bitbucket.org/danielhz/wikidata-experiments).
`$USER` runs the following command inside the `/home/$USER` folder
to get this code.

```
$ git clone https://bitbucket.org/danielhz/wikidata-experiments.git
```      

In that follows we call the folder `/home/$USER/wikidata-experiments` as
`$WD_HOME`.

**Default graph:** In Virtuoso and Blazegraph the default dataset is always,
assumed as the union of all named graphs. Thus, no specific configuration is
needed to get this behavior with the named graphs schema.

**RDF schemas:** We use four schemas to model Wikidata using RDF: n-ary
relations, named graphs, singleton properties and standard reification.
We call this schemas as `naryrel`, `ngraphs`, `sgprop` and `stdreif`,
respectively. Also, we use the environment name `$SCHEMA` for the current
schema in RDF experiments.

## Virtuoso

We used Virtuoso Open Source Edition (7.2.3-dev.3215-pthreads), compiled from
[the source](https://github.com/openlink/virtuoso-opensource/).

For each `$SCHEMA` there is a directory
`$WD_HOME/dbfiles/virtuoso/db-$SCHEMA-1`. Initially, this folder contains
only a file `virtuoso.ini` inside.

By default, Virtuoso stores the data in a folder in the `/` partition
(that has not enough space). Inside this folder we create a symbolic link to
the database folder of each `$SCHEMA`.

```
$ cd /usr/local/virtuoso-opensource/var/lib/virtuoso/
$ ln -s $WD_HOME/dbfiles/virtuoso/db-$SCHEMA-1 db-$SCHEMA-1
```

The following variables are set in `virtuoso.ini` file of each `$SCHEMA`.

```
NumberOfBuffers            = 2720000
MaxDirtyBuffers            = 2000000
MaxQueryCostEstimationTime = 0
MaxQueryExecutionTime      = 60
```

The values for the properties `NumberOfBuffers` and `MaxDirtyBuffers` are the
recommended in the configuration file for a machine with 32GB of memory
(as our machine has).

The property `MaxQueryCostEstimationTime` indicates the maximum estimated time
for a query. If the engine estimates that a query will long more that this
value, then it will not evaluate it. We set this property to 0, that means that
no estimation limits are considered applied, i.e., all queries are evaluated.

Finally, the `MaxQueryExecutionTime` is the timeout for query execution.
Queries that exceed this timeout are aborted in runtime.

## Blazegraph

We used Blazegraph 2.1.0 Community Edition with Java 7. We use the Java
implementation distributed by ORACLE
(Java(TM) SE Runtime Environment build 1.7.0_80-b15).

Some parameters are added into the command line to improve the resource
usage of the process.
We set the JVM heap to 6GB and we use the G1 garbage collector
off the Hostpot JVM (The JVM provides several garbage collectors).
The
[documentation](https://wiki.blazegraph.com/wiki/index.php/PerformanceOptimization)
recommends these parameters.

We use the `exec` primitive in a Ruby script to start Blazegraph
with the following parameters:

```
exec(['java', 'blazegraph'],
  '-Xmx6g',
  '-XX:+UseG1GC',
  '-Djetty.overrideWebXml=override.xml',
  '-Dbigdata.propertyFile=server.properties',
  '-jar',
  'blazegraph.jar')
```

The `override.xml` file define a timeout of 60 seconds for query execution.
And the server.properties define the parameters of the execution and properties
of the storage. Both configuration files can be found in the code repository
of our experiments.

Blazegraph provides several data storages. We use triple stores for
experiments with n-ary relations, singleton properties and standard
reification. For named graphs we use quad stores.

## Neo4j

We used Neo4J-community-2.3.1 with Java 7, using the distribution
available in the system
(OpenJDK Runtime Environment (IcedTea 2.6.6)).

Two databases were created, one with all the data of the JSON dump and the
other without the Labels, Aliases and Descriptions of Wikidata entities, in
order to make the nodes lighter.

We created indexes on labels `:Item(id)`, `:Property(id)` and `:Entity(id)`.
To map from entity ids (e.g., Q42) and property ids (e.g., P1432) to their
respective nodes.

The following variables are set in `conf/neo4j-wrapper.conf` a 20GB heap:

```
wrapper.java.initmemory = 20480
wrapper.java.maxmemory  = 20480
```

Also we set the open file descriptor limit to 40.000 as is recommended in
the [Neo4j documentation](http://neo4j.com/docs/stable/performance-guide.html#_setting_the_number_of_open_files).

## PostgreSQL

We used PostgreSQL 9.1.20 with the folowing variables set in the
`postgres.conf`:

```
default_statistics_target     = 100
maintenance_work_mem          = 1920MB
shared_buffers                = 7680MB
wal_buffers                   = 16MB
effective_cache_size          = 22GB
work_mem                      = 160MB
default_transaction_isolation = 'read uncommitted'
statement_timeout             = 60010
```

We used [pgtune](https://github.com/gregs1104/pgtune#readme), an script to
automatically generate a configuration for PostgresSQL in our server.
This script is based on the recommendations in the
[PostgresSQL Wiki](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)
and set the values of properties `maintenance_work_mem`,
`shared_buffers` and `effective_cache_size`. Also, we set
the lowest of isolation where transactions are isolated only enough to ensure
that physically corrupt data is not read.

We set a B-tree index for primary keys. By default PostgreSQL do not set
any index for foreign keys because these are used for consistency and not
for performance. We create a secondary index for every foreign keys in the
model and for each attribute that stores either entities, properties or data
values (e.g. dates) from Wikidata.

## Translating the data to the RDF model

Before translating the data to the RDF model we need to split the data into
several smaller files. Thus, translating every small file is done by an
independent process. The translating process leaks memory so splitting it
ensure that the process ends without getting an out memory. The commands used
to download the dataset file and split it are:

```
$ cd $WD_HOME
$ mkdir dataset
$ wget https://ndownloader.figshare.com/files/5037784
$ bunzip2 -c wikidata20160104.json.bzip | split -d -a 3 -C 100000000
$ rename '/$/.json/' x*
$ gzip x*.json
$ rm wikidata20160104.json.bz2
```

Then, we are ready to use the translating Ruby script.

```
$ cd $WD_HOME
$ translation/translate_all.rb dataset/
```

Note that the argument `/dataset` is the directory where the files of
the dataset are.

After the commands above, several n-quad files with the keywords `naryrel`,
`ngraphs`, `sgprop` and `stdreif` are created. For example, the file
`x000.json.gz` is translated into the files `x000-naryrel.nq.gz`,
`x000-ngraphs.nq.gz`, `x000-sgprop.nq.gz` and `x000-stdreif.nq.gz`.

## Running the benchmarks

The RDF benchmarks use a configuration file containing the parameters that
are necessary to run each experiment.

```
$ bin/run_quins_benchmark config/virtuoso.rb
$ bin/run_quins_benchmark config/blazegraph.rb
$ bin/run_paths_benchmark config/paths_virtuoso.rb
$ bin/run_paths_benchmark config/paths_blazegraph.rb
```

After running these scripts, a CSV file is created for each set of queries.
In the case of quins, each query file contains a bitmask key that indicates
what quin components are variables (0) and what are considered constant (1).
For example, the file `results_blazegraph_onaryrel_01110.csv` correspond
to the results obtained for the bitmask key 01110 using the Blazegraph engine.

Results for the quin benchmark are published in the folder `results/quins` of
the repository. Similarly, the results for the experiments with snowflake
structure are published in the folder `results/paths`.

## Quin queries

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

Note 3: In the RDF model, queries are generated with the `build` method of the
class `Wikidata::QuinQueryBuilder` (see the file `lib/wikidata.rb` in the
repository).

```
quin = %w{?x0 P2239 Q21402571 P636 ?x4}
query_builder = Wikidata::QuinQueryBuilder.new :ostdreif, '01110'
query = query_builder.build quin, 10000
```

## Snowflake queries

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
  GRAPH ?claim_x0y0 { ?x0 p:P102 ?x0y0} .
  GRAPH ?claim_x0y1 { ?x0 p:P735 wd:Q4925477} .
  GRAPH ?claim_x0y2 { ?x0 p:P31 ?x0y2} .
  GRAPH ?claim_x0 { ?x0 p:P27 ?x1} .
  GRAPH ?claim_x1y0 { ?x1 p:P1792 ?x1y0} .
  GRAPH ?claim_x1 { ?x1 p:P530 ?x2} .
  GRAPH ?claim_x2y0 { ?x2 p:P1343 ?x2y0} .
  GRAPH ?claim_x2y1 { ?x2 p:P1792 ?x2y1} . }
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

Note 4: In the RDF model, queries are generated with the `build` method of the
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
