// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]
use rust_lib::auth;

#[tokio::main]
async fn main() {
    let state = auth::init().await;
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![auth::authenticate])
        .manage(state)
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
