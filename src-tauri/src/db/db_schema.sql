CREATE TABLE IF NOT EXISTS media_types (
    media_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO media_types (name) VALUES ("tv"), ("anime_tv"), ("movie"), ("anime_movie"); -- ("game"), ("board_game"), ("video_game"), ("book"), ("comic"), ("manga"), ("novel"), ("light_novel"), ("music");
-- media types allow you to know which table to look for the rest of the entry's metadata in. for example, if the media type is "anime_tv", you know to look in the "anime_tv_shows" table for the rest of the metadata.

CREATE TABLE IF NOT EXISTS entries (
    entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    summary TEXT, -- summary of the series
    media_type INTEGER NOT NULL REFERENCES media_types(id),
    tags TEXT, -- json string
    settings TEXT, -- json string
    characters INTEGER[], -- references to characters table
    series INTEGER[], -- references to series table; an entry can be a part of multiple series, especially when they're nested
    order NUMERIC, -- order within series. TODO how to handle this for entries with multiple series?
    rating INTEGER REFERENCES ratings(rating_id),
    notes TEXT, -- user's notes about the series
    streaming_url TEXT, -- url to stream the series
    file_path TEXT, -- path to the local file/folder
    date_modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS tv_shows (
    tv_show_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS anime_tv_shows (
    anime_tv_show_id INTEGER PRIMARY KEY AUTOINCREMENT,
    -- tv_show_id INTEGER NOT NULL, -- TODO join them together to get all data, i guess? then you could just have an anime table that contains both tv and movies maybe, since they'd have similar extra metadata. consider this.
    -- FOREIGN KEY (tv_show_id) REFERENCES tv_shows(id)
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS movies (
    movie_id INTEGER PRIMARY KEY AUTOINCREMENT,
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS anime_movies (
    anime_movie_id INTEGER PRIMARY KEY AUTOINCREMENT,
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
-- music types are easier than stuff like anime since most music types will have the same metadata. it's fine if some stuff is null, like a single without a tracklist of a live album without a studio, or the inverse: a studio album without a live performance location.
-- );

CREATE TABLE IF NOT EXISTS tags (
    tag_id INTEGER PRIMARY KEY AUTOINCREMENT,
    parent_tags INTEGER[], -- references to tags table
    name TEXT NOT NULL UNIQUE,
    rating INTEGER REFERENCES ratings(id), -- the user's rating of the tag
    description TEXT, -- user's description of the tag
    color TEXT -- hex color code
    -- photo_id INTEGER REFERENCES photos(id), -- photo of the tag; for now i'm not going to implement this
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS characters (
    character_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    rating INTEGER REFERENCES ratings(id), -- the user's rating of the character
    tags TEXT, -- json string
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS series (
    series_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    rating INTEGER REFERENCES ratings(id), -- the user's rating of the series as a whole
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL, -- can be changed to an episode key if needed
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    date_started TIMESTAMP,
    date_finished TIMESTAMP,
    watched_count INTEGER, -- how many episodes/chapters have been watched/read
    speed NUMERIC, -- how fast the user is watching, for criminals like me who watch at 2x speed
    rating INTEGER REFERENCES ratings(id), -- for this specific watch so we can see how the user's opinion changes over time
    notes TEXT, -- user's notes about this specific watch
    -- TODO add more columns
)

CREATE TABLE IF NOT EXISTS ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rating NUMERIC NOT NULL CHECK (rating >= 0 AND rating <= 1), -- user's rating of the series out of 1 on a floating-point scale. can be handled differently by the frontend, e.g. if you only want to use 5 stars or 10
    custom_rating TEXT, -- json for user's custom ratings; see docs
    notes TEXT, -- user's notes about the entry
    -- TODO add more columns
)

CREATE TABLE IF NOT EXISTS alternate_title_types (
    type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE
)

INSERT INTO alternate_title_types (title) VALUES ("synonym"), ("abbreviation"), ("acronym"), ("nickname"), ("misspelling"), ("romanization"), ("translation"), ("fan_translation"), ("common_title"), ("other");

INSERT INTO alternate_title_types (title) VALUES
    ("official"), -- the original title; if it's japanese media, this is probably kanji, for example
    ("official_romanized"), -- the official romanized (but not translated) title
    ("official_translation"), -- the official translated title
    ("common"), -- nicknames, like "The Slime Isekai", etc.
    ("acronym"), -- (/abbreviation) KnY, SnK, and so on
    ("shortened"), -- DanMachi, TenSura, KonoSuba (note: sometimes, this is the official TL, how to handle that is up to the user)
    ("literal_translation"),
    ("romanization"), -- an unofficial romanization
    ("other"); -- for anything else

CREATE TABLE IF NOT EXISTS alternate_titles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL,
    FOREIGN KEY (entry_id) REFERENCES entries(id),
    title TEXT NOT NULL,
    type_id INTEGER NOT NULL REFERENCES alternate_title_types(id)
    -- see ALTERNATE_TITLES.md for more info; these are mostly for anime and other foreign media.
)

-- TODO how can we use views here?
-- TODO how can we use triggers here?
-- TODO how much faster/slower is rust compared to sql functions? what kind of functions does sqlite support?