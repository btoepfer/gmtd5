explain analyze
SELECT title
FROM notes
WHERE to_tsvector('german', title || ' ' || content) @@ to_tsquery('german', 'UBUNTU');

CREATE INDEX notes_content_idx ON notes USING gin(to_tsvector('german', title || ' ' || content));

create index notes_upper_content_pur on notes using btree(title);
drop index notes_content_idx;

drop index title_content_idx;

CREATE INDEX title_content_idx ON notes USING gin (index_col_title_content);

explain analyze

SELECT title
FROM notes
WHERE index_col_title_content @@ to_tsquery('Ubu:*')
  AND user_id = 7;

select user_id, count(*) from notes
group by user_id;

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
ON notes FOR EACH ROW EXECUTE PROCEDURE
tsvector_update_trigger(tsv, 'pg_catalog.english', title, body);

select id, title, index_col_title_content from notes
where user_id = 7
order by id desc;