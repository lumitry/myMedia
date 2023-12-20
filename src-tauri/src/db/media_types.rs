// media types allow you to know which table to look for the rest of the entry's metadata in. for example, if the media type is "anime_tv", you know to look in the "anime_tv_shows" table for the rest of the metadata. this is useful for when you want to display a list of all entries, but you don't want to have to query every single table to get the metadata for each entry. instead, you can just query the "entries" table, and then use the media type to know which table to query for the rest of the metadata.

use rusqlite::{Connection, params};
use crate::tauri_error::Error;
use serde::Serialize;

// create struct for media types in-memory object representation

#[derive(Serialize, Debug)]
pub struct MediaType {
    pub media_type_id: i32,
    pub name: String,
}

impl Clone for MediaType {
    fn clone(&self) -> Self {
        MediaType {
            media_type_id: self.media_type_id,
            name: self.name.clone(),
        }
    }
}

// Default media types. there will be more in the future
const MEDIA_TYPES: [&str; 4] = ["tv", "anime_tv", "movie", "anime_movie"];
// in the future: ("game"), ("board_game"), ("video_game"), ("book"), ("comic"), ("manga"), ("novel"), ("light_novel"), ("music"); (maybe more)

/**
 * Creates the media_types table if it doesn't exist, and populates it with the default media types.
 */
pub fn make_media_types(conn: &Connection) -> Result<Vec<MediaType>, Error> {
    println!("make_meda_types called");

    // this should never need to change
    conn.execute("CREATE TABLE IF NOT EXISTS media_types (
        media_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
    )", [])?;

    // loop over media types and insert
    for media_type in MEDIA_TYPES.iter() {
        let sql = "INSERT OR IGNORE INTO media_types (name) VALUES (?1);".to_string();
        conn.execute(&sql, params![media_type])?;
    }

    // return all available media types
    let mut stmt = conn.prepare("SELECT media_type_id, name FROM media_types")?;

    let types = stmt
        .query_map([], |row| {
        Ok(MediaType {
            media_type_id: row.get(0)?,
            name: row.get(1)?,
        })
        })?
        .map(|entry| entry.unwrap())
        .collect::<Vec<MediaType>>();

    Ok(types)
}

pub fn get_media_type_by_id(conn: &Connection, id: i32) -> Result<MediaType, Error> {
    println!("get_media_type_by_id called");

    let mut stmt = conn.prepare("SELECT media_type_id, name FROM media_types WHERE media_type_id = ?1")?;

    let media_type = stmt
        .query_map(params![id], |row| {
        Ok(MediaType {
            media_type_id: row.get(0)?,
            name: row.get(1)?,
        })
        })?
        .map(|entry| entry.unwrap())
        .collect::<Vec<MediaType>>();

    Ok(media_type[0].clone())
}

pub fn get_media_type_by_name(conn: &Connection, name: &str) -> Result<MediaType, Error> {
    println!("get_media_type_by_name called");

    let mut stmt = conn.prepare("SELECT media_type_id, name FROM media_types WHERE name = ?1")?;

    let media_type = stmt
        .query_map(params![name], |row| {
        Ok(MediaType {
            media_type_id: row.get(0)?,
            name: row.get(1)?,
        })
        })?
        .map(|entry| entry.unwrap())
        .collect::<Vec<MediaType>>();

    Ok(media_type[0].clone())
}

#[cfg(test)]
mod test{
    use super::*;

    #[test]
    fn test_make_media_types() {
        let conn = Connection::open_in_memory().unwrap();
        let types = make_media_types(&conn).unwrap();
        assert_eq!(types.len(), 4);
        assert_eq!(types[0].name, "tv");
        assert_eq!(types[1].name, "anime_tv");
        assert_eq!(types[2].name, "movie");
        assert_eq!(types[3].name, "anime_movie");
    }

    #[test]
    fn test_get_media_type_by_id() {
        let conn = Connection::open_in_memory().unwrap();
        let types = make_media_types(&conn).unwrap();
        let media_type = get_media_type_by_id(&conn, types[0].media_type_id).unwrap();
        assert_eq!(media_type.name, "tv");
    }

    #[test]
    fn test_get_media_type_by_id_not_found() {
        let conn = Connection::open_in_memory().unwrap();
        let media_type = get_media_type_by_id(&conn, 5);
        assert!(media_type.is_err());
    }

    #[test]
    fn test_get_media_type_by_name() {
        let conn = Connection::open_in_memory().unwrap();
        let types = make_media_types(&conn).unwrap();
        let media_type = get_media_type_by_name(&conn, &types[0].name).unwrap();
        assert_eq!(media_type.name, "tv");
    }
}