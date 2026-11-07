-- Link details TheBrain returns in /graph. Raw values, nullable:
-- a CRO-made edge or an old row has none.
ALTER TABLE edges ADD COLUMN link_name      text;
ALTER TABLE edges ADD COLUMN link_meaning   smallint;
ALTER TABLE edges ADD COLUMN link_direction smallint;

-- "What points at this node?" and the dangling-edge check look up by target.
CREATE INDEX edges_to_idx ON edges (to_type, to_id);
