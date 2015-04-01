-- trigger function
-- channel name is: users_UPDATE || INSERT || DELETE
-- channel = TG_TABLE_NAME || '_' || TG_OP;
CREATE OR REPLACE FUNCTION notify_trigger() RETURNS trigger AS $BODY$
DECLARE
  channel varchar;
  JSON varchar;
BEGIN
  channel = TG_TABLE_NAME || '__' || TG_OP;
  IF (TG_OP = 'DELETE') THEN
    JSON = (SELECT row_to_json(old));
    PERFORM pg_notify(lower(channel), JSON);
    RETURN old;
  ELSE
    JSON = (SELECT row_to_json(new));
    PERFORM pg_notify(lower(channel), JSON);
    RETURN new;
  END IF;
END;
$BODY$ LANGUAGE plpgsql VOLATILE;


-- trigger for users table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON users
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for profiles table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON profiles
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for names table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON names
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();



-- trigger for profile_keys table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON profile_keys
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for connected_users table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON connected_users
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();
