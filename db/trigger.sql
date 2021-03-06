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


--- DROP TRIGGER ON connected_users
DROP TRIGGER watched_table ON connected_users;


-- trigger for trees table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON trees
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for connection_requests table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON connection_requests
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();

-- trigger for common_logs table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON common_logs
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();

-- trigger for common_logs table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON search_results
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for profile_data table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON profile_data
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();

-- trigger for similars_founds table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON similars_founds
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();

-- trigger for similars_founds table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON similars_logs
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();


-- trigger for SupportMessage table
CREATE TRIGGER watched_table
AFTER INSERT OR UPDATE OR DELETE
ON support_messages
FOR EACH ROW
EXECUTE PROCEDURE notify_trigger();
