CREATE TABLE IF NOT EXISTS entries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    tags INTEGER[], -- references to tags table
    settings TEXT, -- json string
    characters INTEGER[], -- references to characters table
    series INTEGER[], -- references to series table; an entry can be a part of multiple series, especially when they're nested
    order NUMERIC, -- order within series. TODO how to handle this for entries with multiple series?
    summary TEXT, -- summary of the series
    notes TEXT, -- user's notes about the series
    streaming_url TEXT, -- url to stream the series
    file_path TEXT, -- path to the local file/folder
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS tv_shows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS anime_tv_shows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    -- tv_show_id INTEGER NOT NULL, -- TODO join them together to get all data, i guess? then you could just have an anime table that contains both tv and movies maybe, since they'd have similar extra metadata. consider this.
    -- FOREIGN KEY (tv_show_id) REFERENCES tv_shows(id)
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS movies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS anime_movies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    -- movie_id INTEGER NOT NULL,
    -- FOREIGN KEY (movie_id) REFERENCES movies(id)
    -- TODO add more columns
);

-- TODO For now, commenting these out to make life simpler.
-- CREATE TABLE IF NOT EXISTS games (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS board_games (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- game_id INTEGER NOT NULL,
--     -- FOREIGN KEY (game_id) REFERENCES games(id)
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS video_games (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- game_id INTEGER NOT NULL,
--     -- FOREIGN KEY (game_id) REFERENCES games(id)
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS books (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS comics (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- book_id INTEGER NOT NULL,
--     -- FOREIGN KEY (book_id) REFERENCES books(id)
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS manga (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- book_id INTEGER NOT NULL,
--     -- FOREIGN KEY (book_id) REFERENCES books(id)
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS novels (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- book_id INTEGER NOT NULL,
--     -- FOREIGN KEY (book_id) REFERENCES books(id)
--     -- TODO add more columns
-- );

-- CREATE TABLE IF NOT EXISTS light_novels (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     -- book_id INTEGER NOT NULL,
--     -- FOREIGN KEY (book_id) REFERENCES books(id)
--     -- TODO add more columns
--     -- todo does this reference books or books *and* novels?
-- );

-- CREATE TABLE IF NOT EXISTS music_artists (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     name TEXT NOT NULL UNIQUE
-- ); -- todo ?? is this a thing we need

-- CREATE TABLE IF NOT EXISTS music_types (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     name TEXT NOT NULL UNIQUE -- e.g. "album" or "single"
-- );

-- INSERT INTO music_types (name) VALUES ("album"), ("single"), ("ep"), ("mixtape"), ("compilation"), ("live"), ("remix");

-- CREATE TABLE IF NOT EXISTS music (
--     id INTEGER PRIMARY KEY AUTOINCREMENT,
--     music_type_id INTEGER NOT NULL,
--     FOREIGN KEY (music_type_id) REFERENCES music_types(id)
--     -- TODO add more columns
-- );

-- TODO how can we use views here?
-- TODO how can we use triggers here?
-- TODO how much faster/slower is rust compared to sql functions? what kind of functions does sqlite support?