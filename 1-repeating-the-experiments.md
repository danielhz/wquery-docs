---
layout: page
title: Repeating the experiments
top: true
---

The list below enumerate the task required to perform the experiments. The
figure below show what tasks can be done in parallel. Tasks that are enclosed
in squares must be done in a dedicate machine (without other processes running
on background). We recommend execute these tasks with
[GNU Screen](https://www.gnu.org/software/screen/).

*Note:* Along the documentation of these task, shell variables (e.g. `$USER`,
`$WD_HOME`) will be used. You have to set these shell variables according with
your own settings.

### List of tasks

1. [Download the code](1.1-download-the-code).
2. [Download the dataset](1.2-download-the-dataset).
3. Setup Virtuoso.
4. Setup Blazegraph.
5. Setup Neo4j.
6. Setup PostgreSQL.
7. Setup Ruby 2.3.
8. Setup Python2.
9. [Translate the data to RDF](1.9-translate-the-data-to-rdf).
10. [Load the data in Virtuoso](1.10-load-the-data-in-virtuoso).
11. [Run experiments in Virtuoso](1.11-run-experiments-in-virtuoso).
12. [Load the data in Blazegraph](1.12-load-the-data-in-blazegraph).
13. [Run experiments in Blazegraph](1.13-run-experiments-in-blazegraph).
14. [Translate the data to the SQL data model](1.14-translate-the-data-to-the-sql-data-model).
15. [Load the data in PostgreSQL](1.15-load-the-data-in-postgresql).
16. [Run experiments in PostgreSQL](1.16-run-experiments-in-postgresql).
17. [Translate the data to the Neo4j data model](1.17-translate-the-data-to-the-neo4j-data-model).
18. [Load the data in Neo4j](1.18-load-the-data-in-neo4j).
19. [Run experiments in Neo4j](1.19-run-experiments-in-neo4j).

### Diagram of tasks

![Tasks]({{url}}images/tasks-general.png)
