#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;
use rust_lib::auth;

#[tokio::main]
async fn main() {
    let state = auth::init().await;
    tauri::Builder::default()
    .setup(|app| {
        let handle = app.handle();
            tauri::async_runtime::spawn(async move {
                match handle
                    .updater()
                    .header("Release-Channel", "development") 
                    .unwrap()
                    .check()
                    .await
                {
                    Ok(update) => {
                        let _ = update.download_and_install().await;
                    }
                    Err(e) => {
                        println!("ERROR: {}", e);
                    }
                }
                });
            Ok(())
        })
        .manage(state)
        .invoke_handler(tauri::generate_handler![auth::authenticate])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
