// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use serde::Serialize;

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
}

#[tauri::command]
fn get_entries() -> Vec<Entry> {
  let mut entries: Vec<Entry> = Vec::new();
  entries.push(Entry {
    entry_id: 1,
    entry_name: "Test".to_string(),
    entry_type: 1,
  });
  entries.push(Entry {
    entry_id: 2,
    entry_name: "Test2".to_string(),
    entry_type: 2,
  });
  entries
}

#[cfg(test)]
mod test {
  use super::*;

  #[test]
  fn test_greet() {
    assert_eq!(greet("World"), "Hello, World!");
  }
}