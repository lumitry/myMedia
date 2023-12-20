DROP TABLE IF EXISTS entries; -- TODO remove this for production, only using it for testing
-- DROP TABLE IF EXISTS media_types; -- TODO remove this for production, only using it for testing
-- TODO how to handle schema migrations? there are going to be A LOT of changes, especially for the first few months. right now i'm just dropping the tables but that won't work once there's real data in there.
-- might be worth either looking into migration libraries or doing it on my own. maybe instead of just calling this big file, creating any tables with code that way we can use rich if statements and so on.

-- TODO pragma version statement

CREATE TABLE IF NOT EXISTS ratings (
    rating_id INTEGER PRIMARY KEY AUTOINCREMENT,
    rating NUMERIC NOT NULL CHECK (rating >= 0 AND rating <= 1), -- user's rating of the series out of 1 on a floating-point scale. can be handled differently by the frontend, e.g. if you only want to use 5 stars or 10
    custom_rating TEXT, -- json for user's custom ratings; see docs
    notes TEXT -- user's notes about the entry, maybe should be a blob idk
    -- TODO add more columns ??
);

CREATE TABLE IF NOT EXISTS entries (
    entry_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    cover_photo TEXT, -- uri to cover art (i.e. poster/book cover/album art)
    banner_image TEXT, -- uri to banner image (like on Anilist, or in Notion)
    summary TEXT, -- summary of the series
    media_type INTEGER NOT NULL REFERENCES media_types(media_type_id),
    release_date_start TEXT, -- JSON string (not timestamp to support ambiguity); when the entry started its release/season/syndication/etc.
    release_date_end TEXT, -- JSON string; when the entry ended its release/etc.
    rating INTEGER REFERENCES ratings(rating_id), -- the user's rating of the entry
    tags TEXT, -- json string
    settings TEXT, -- json string
    characters INTEGER[], -- references to characters table
    series INTEGER[], -- references to series table; an entry can be a part of multiple series, especially when they're nested
    order_in_series NUMERIC, -- order within series. TODO how to handle this for entries with multiple series?\nrating INTEGER REFERENCES ratings(rating_id),
    notes TEXT, -- user's notes about the series
    streaming_url TEXT, -- url to stream the series
    file_path TEXT, -- path to the local file/folder
    date_modified TEXT -- not sure how to do a default for the json strings
    date_created TEXT
    -- TODO add more columns?
);

CREATE TABLE IF NOT EXISTS tv_shows (
    tv_show_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS animation_studios (
    studio_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS anime_tv_shows (
    anime_tv_show_id INTEGER PRIMARY KEY AUTOINCREMENT,
    studio_id INTEGER REFERENCES animation_studios(studio_id)
    -- tv_show_id INTEGER NOT NULL, -- TODO join them together to get all data, i guess? then you could just have an anime table that contains both tv and movies maybe, since they'd have similar extra metadata. consider this.
    -- FOREIGN KEY (tv_show_id) REFERENCES tv_shows(id)
    --TODO add more columns
);

CREATE TABLE IF NOT EXISTS movies (
    movie_id INTEGER PRIMARY KEY AUTOINCREMENT
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS anime_movies (
    anime_movie_id INTEGER PRIMARY KEY AUTOINCREMENT,
    studio_id INTEGER REFERENCES animation_studios(studio_id)
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
    rating INTEGER REFERENCES ratings(rating_id), -- the user's rating of the tag
    description TEXT, -- user's description of the tag
    color TEXT, -- hex color code
    related_tags INTEGER[] -- references to tags table
    -- photo_id INTEGER REFERENCES photos(id), -- photo of the tag; for now i'm not going to implement this
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS characters (
    character_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    rating INTEGER REFERENCES ratings(rating_id), -- the user's rating of the character
    tags TEXT -- json string
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS series (
    series_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    rating INTEGER REFERENCES ratings(rating_id) -- the user's rating of the series as a whole
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_id INTEGER NOT NULL REFERENCES entries(id), -- can be changed to an episode key if needed
    date_started TEXT,
    date_finished TEXT,
    watched_count INTEGER, -- how many episodes/chapters have been watched/read
    speed NUMERIC, -- how fast the user is watching, for criminals like me who watch at 2x speed
    rating INTEGER REFERENCES ratings(rating_id), -- for this specific watch so we can see how the user's opinion changes over time
    notes TEXT -- user's notes about this specific watch
    -- TODO add more columns
);

CREATE TABLE IF NOT EXISTS alternate_title_types (
    type_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL UNIQUE
);

INSERT OR IGNORE INTO alternate_title_types (title) VALUES
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
    entry_id INTEGER NOT NULL REFERENCES entries(entry_id), -- the entry this alternate title applies to
    title TEXT NOT NULL,
    type_id INTEGER NOT NULL REFERENCES alternate_title_types(type_id)
    -- see ALTERNATE_TITLES.md for more info; these are mostly for anime and other foreign media.
);

-- TODO how can we use views here?
-- TODO how can we use triggers here?
-- TODO how much faster/slower is rust compared to sql functions? what kind of functions does sqlite support?