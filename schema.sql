CREATE TABLE IF NOT EXISTS guild_settings (
    guild_id BIGINT UNIQUE,
    prefix TEXT DEFAULT NULL, 
    nsfw_restricted BOOLEAN DEFAULT FALSE
);

CREATE OR REPLACE FUNCTION toggle_nsfw(guildid BIGINT) RETURNS integer AS $$
    BEGIN
        IF (SELECT nsfw_restricted FROM guild_settings WHERE guild_id=guildid) = TRUE THEN
            UPDATE guild_settings SET nsfw_restricted = FALSE WHERE guild_id=guildid;
            RETURN 1;
        ELSE
            INSERT INTO guild_settings 
            VALUES(guildid) 
            ON CONFLICT (guild_id)
            DO UPDATE 
            SET nsfw_restricted = TRUE;
            RETURN 2;
                
        END IF;
    END; $$
LANGUAGE PLPGSQL;
    


