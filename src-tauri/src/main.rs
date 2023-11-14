// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use serde::Serialize;
use rusqlite::{Connection, Result};
use crate::tauri_error::Error;
use crate::db::media_types;

pub mod db;
pub mod tauri_error;

fn main() {
  tauri::Builder::default()
    .invoke_handler(tauri::generate_handler![greet])
    .invoke_handler(tauri::generate_handler![get_entries])
    .run(tauri::generate_context!())
    .expect("error while running tauri application");
}

#[tauri::command]
fn greet(name: &str) -> String {
  format!("Hello, {}!", name)
}

#[derive(Serialize, Debug)]
struct Entry {
  entry_id: i32,
  entry_name: String,
  entry_type: i32,
  // TODO obviously update this struct to match the database schema
}

#[tauri::command]
fn get_entries() -> Result<Vec<Entry>, Error> {
  println!("get_entries called");
  // first, we need to connect to the database
  // let conn = Connection::open_in_memory()?;
  let conn = Connection::open("src/test/test.sqlite")?; // TODO use globals for this

  media_types::make_media_types(&conn)?;

  // then we'll create the table
  let sql = std::fs::read_to_string("src/db/db_schema.sql")?; // TODO use globals for this especially
  conn.execute_batch(&sql)?; // no params

  // then we'll make some test entries
  let test_entry_1 = Entry {
    entry_id: 1,
    entry_name: "Test".to_string(),
    entry_type: 1,
  };
  let test_entry_2 = Entry {
    entry_id: 2,
    entry_name: "Test2".to_string(),
    entry_type: 2,
  };

  // then we'll insert them into the database
  conn.execute(
    "INSERT INTO entries (title, media_type) VALUES (?1, ?2);",
    (&test_entry_1.entry_name, test_entry_1.entry_type),
  )?;
  conn.execute(
    "INSERT INTO entries (title, media_type) VALUES (?1, ?2)",
    (&test_entry_2.entry_name, test_entry_2.entry_type),
  )?;

  // then we'll query and return the entries
  let mut stmt = conn.prepare("SELECT entry_id, title, media_type FROM entries")?;

  let entries = stmt
    .query_map([], |row| {
      Ok(Entry {
        entry_id: row.get(0)?,
        entry_name: row.get(1)?,
        entry_type: row.get(2)?,
      })
    })?
    .map(|entry| entry.unwrap())
    .collect::<Vec<Entry>>();

  Ok(entries)
}

// fn create_tables
// TODO: create a function that creates the tables if they don't exist

// TODO: create another file for the database functions maybe, don't just have some huge main file
// also maybe learn proper rust conventions
// and make sure to write good unit tests

// fn clear_tables
// essentially just wipes out the test.sqlite file

#[cfg(test)]
mod test {
  use super::*;

  #[test]
  fn test_greet() {
    assert_eq!(greet("World"), "Hello, World!");
  }

  #[test]
  fn test_get_entries() {
    // a temporary test since get_entries is a temporary function
    let entries = get_entries().unwrap();
    assert_eq!(entries.len(), 2);
    assert_eq!(entries[0].entry_id, 1);
    assert_eq!(entries[0].entry_name, "Test");
    assert_eq!(entries[0].entry_type, 1);
    assert_eq!(entries[1].entry_id, 2);
    assert_eq!(entries[1].entry_name, "Test2");
    assert_eq!(entries[1].entry_type, 2);
  }
}