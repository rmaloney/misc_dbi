misc_dbi
========

Lightweight collection of miscellaneous helper functions and subroutines for Perl DBI, specifically for Oracle.

Current version only has three utility functions I cleaned up from various scripts:

NOTE Scripts assume you are running within your personal schema. This can be adjusted by changed the config variable at top.

run_query($str) - prepares and executes a string of sql.

table_exists($table) - checks for existence of table.

export_with_headers($table, $export_path) - exports table or query result to a specified file. Default appends headers to file.
