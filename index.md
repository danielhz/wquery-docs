---
layout: default
---

# About

This documentation aims to make repeatable the experiments described in the
paper
*Querying Wikidata: Comparing SPARQL, Relational and Graph Databases*
(by
[Daniel Hernández](http://users.dcc.uchile.cl/~dhernand/),
[Aidan Hogan](http://users.dcc.uchile.cl/~ahogan/),
[Cristian Riveros](http://web.ing.puc.cl/~criveros/),
Carlos Rojas and Enzo Zerega).

These pages are generated using [Jekyll](http://jekyllrb.com/) from the
source available in the repository
[wquery-docs](https://github.com/danielhz/wquery-docs). Also, this
documentation is accessible on the following URLs:

* <http://users.dcc.uchile.cl/~dhernand/wquery/> (this website).
* <https://dx.doi.org/10.6084/m9.figshare.3219217.v3> (DOI pointing this website).

## Related resources

To repeat this experiment it is necessary to download and install the
database engines and the following resources:

**Code and results (<https://bitbucket.org/danielhz/wikidata-experiments>).**
The code required to repeat these experiments is published on this repository.
Also, parameters to generate queris and results of experiments are published
in this repository.

**Dataset (<https://dx.doi.org/10.6084/m9.figshare.3208498.v1>).**
All experiments are done using the dump of Wikidata published on
January 04, 2017. The original dump was downloaded from the
[dumps folder](https://dumps.wikimedia.org/other/wikidata/) published by
the Wikimedia Foundation. However, the contents in this folder are frequently
updated and old dumps are discarded. Thus, to make this experiment repeatable
we published the dump used on Figshare.

## License

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

# Contents

1. [Repeating the experiments](1-repeating-the-experiments). It describes
   how to repeat the experiments.
2. [Experimental settings](2-experimental-settings). It describes our
   specific settings the we use to get the results presented in the paper.
3. [Queries](3-queries). It describes the queries corresponding to each
   data model.
4. [Results](4-results). It describes the results of loading and
   querying the data in each engine and data model. 

