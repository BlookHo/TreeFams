class AddPostgresTriggerFunction < ActiveRecord::Migration
  def up

    # execute = %q{
    #   CREATE FUNCTION notify_trigger() RETURNS trigger AS $$
    #   DECLARE
    #   BEGIN
    #   PERFORM
    #   pg_notify('pg_observer', '{"table":"' || TG_TABLE_NAME || '","row":{"id":"' || NEW.id || '","name":"' || NEW.name || '"}}');
    #   RETURN new;
    #   END;
    #   $$ LANGUAGE plpgsql;
    # }

    # table_name :users

    execute = %q{
      CREATE OR REPLACE FUNCTION notify_trigger() RETURNS trigger AS $BODY$
      DECLARE
        channel varchar;
        JSON varchar;
      BEGIN
        channel = 'postgres_observer';
        JSON = (SELECT row_to_json(new));
        PERFORM pg_notify( channel, JSON );
        RETURN new;
      END;
      $BODY$ LANGUAGE plpgsql VOLATILE;
    }

    execute = %q{
      CREATE TRIGGER watched_table
      AFTER INSERT OR UPDATE OR DELETE
      ON users
      FOR EACH ROW
      EXECUTE PROCEDURE notify_trigger();
    }
  end
end



# CREATE OR REPLACE FUNCTION notify_trigger() RETURNS trigger AS $BODY$
# DECLARE
#   channel varchar;
#   JSON varchar;
# BEGIN
#   -- TG_TABLE_NAME is the name of the table who's trigger called this function
#   -- TG_OP is the operation that triggered this function: INSERT, UPDATE or DELETE.
#   -- channel is formatted like 'users_INSERT'
#   channel = TG_TABLE_NAME || '_' || TG_OP;
#   JSON = (SELECT row_to_json(new));
#   PERFORM pg_notify( channel, JSON );
#   RETURN new;
# END;
# $BODY$
#   LANGUAGE plpgsql VOLATILE
#   COST 100;
# ALTER FUNCTION notify_trigger()
#   OWNER TO austin;
