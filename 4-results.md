---
layout: page
title: Results
top: true
---

Raw results of ellapsing times are published in the folder `results`
in
[the code repository](https://bitbucket.org/danielhz/wikidata-experiments).
In that follows we present the ellapsed times and the size that
databases use after loading the data.

## Loading times and database sizes

###  RDF data

The following table present the statistics of data in each schema.

|---------+------------|
| Model   | Statements |
|:--------+-----------:|
| naryrel |  563678588 |
| ngraphs |  482371357 |
| sgprop  |  563676547 |
| stdreif |  644981737 |
|---------+------------|

The following table presents the loading times of Virtuoso for each schema.

|------------------+-------+-------+------+-------+
|                  |naryrel|ngraphs|sgprop|stdreif|
|------------------+------:+------:+-----:+------:|
|Loading files (s) |  8265 | 10844 | 8344 |  8818 |
|Indexing (s)      |  5701 |  4023 | 5514 |  5118 |
|Total (s)         | 13966 | 14867 |13858 | 13936 |
|------------------+-------+-------+------+-------+

Times and data sizes used by Virtuoso are summarized in the following table.

|---------+--------------+-------+-------------------+---------|
| Model   | Elapsed time |       | Size              |         |
|:--------+-------------:+------:|------------------:+--------:|
| naryrel |      13966 s | 3.9 h | 49169825792 bytes |     46G |
| ngraphs |      14867 s | 4.1 h | 50413436928 bytes |     47G |
| sgprop  |      13858 s | 3.9 h | 49715085312 bytes |     47G |
| stdreif |      13936 s | 3.9 h | 49027219456 bytes |     46G |
|---------+--------------+-------+-------------------+---------|

The following table presents the loading times and space used by Blazegraph
for each schema.

|---------+--------------+--------+-------------------+---------|
| Model   | Elapsed time |        | Size              |         |
|:--------+-------------:+-------:|------------------:+--------:|
| naryrel | 105693.640 s | 23.4 h | 65205960704 bytes |     61G |
| ngraphs | 240486.333 s | 66.8 h |127813812224 bytes |    120G |
| sgprop  |  93865.713 s | 26.1 h | 65205960704 bytes |     61G |
| stdreif | 107242.764 s | 29.8 h | 65205960704 bytes |     61G |
|---------+--------------+--------+-------------------+---------|

Note that in the case of the named graphs schema, we use a quad store backend.
On the other hand, in the other schemas we use a triple store backend.

### Neo4j

The size of the database with labels before creating the indexes is of 47 GB.
It contains:

* 214348455 nodes.
* 435080654 relationships.
* 661150129 properties.

The size of the database without the indexes is of 32 GB. It contains:

* 214348455 nodes
* 435080654 relationships
* 409258592 properties

The times used to create the indexes are presented in the table below.

| Index          | Time           |
| :------------- | -------------: |
| Entities       | 5min 20s       |
| Item           | 5min 10s       |
| Property       | 1min 20s       |

### PostgreSQL

| Task             | Elapsed time   |
| :--------------- | -------------: |
| Loading data     |     5184.8438s |
| Index generation |     2065.7545s |

The following tables present the size used for each table in PostgreSQL.

|         table_name          | table_size | indexes_size | total_size   |
| :-------------------------- | ---------: | -----------: + -----------: |
| "public"."claims"           | 13 GB      | 11 GB        | 24 GB        |
| "public"."descriptions"     | 10 GB      | 7616 MB      | 18 GB        |
| "public"."labels"           | 5882 MB    | 4873 MB      | 11 GB        |
| "public"."entities"         | 818 MB     | 574 MB       | 1392 MB      |
| "public"."aliases"          | 612 MB     | 474 MB       | 1087 MB      |
| "public"."qualifiers"       | 480 MB     | 235 MB       | 715 MB       |
| "pg_catalog"."pg_depend"    | 384 kB     | 424 kB       | 808 kB       |
| "pg_catalog"."pg_proc"      | 496 kB     | 256 kB       | 752 kB       |
| "pg_catalog"."pg_attribute" | 408 kB     | 224 kB       | 632 kB       |
| "pg_catalog"."pg_statistic" | 464 kB     | 40 kB        | 504 kB       |
