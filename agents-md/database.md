## Database

- **Never change the database by executing SQL.** No `INSERT`, `UPDATE`, `DELETE` or DDL through a
  database client, a container exec or an ad-hoc script — not even to set up or tweak state while
  testing. A migration is the only way to edit schema or data, so that any environment can be
  rebuilt from the migration history alone and every change arrives reviewed. Reading (`SELECT`)
  is fine and needs no ceremony.
- **Where the application is the only writer, let it own enum values.** Store an enum as text
  equal to the application's own enum name, with no `CHECK` constraint, no database enum type and
  no conversion layer, so adding a value is a code change instead of a code change plus a
  migration. The rule follows from single ownership, not from a dislike of constraints: if
  anything else writes to the table, the database has to constrain the column instead.
