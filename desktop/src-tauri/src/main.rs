#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::Manager;
mod utils;

#[tauri::command]
async fn authenticate(handle: tauri::AppHandle) {
    let auth = handle.state::<utils::auth::AuthState>();
    let (auth_url, _) = auth
        .client
        .authorize_url(|| auth.csrf_token.clone())
        // .add_scope(...)
        .set_pkce_challenge(auth.pkce.0.clone())
        .url();
    tauri::async_runtime::spawn(async move { utils::auth::run_server(handle).await });
    open::that(auth_url.to_string()).unwrap();
}

#[tokio::main]
async fn main() {
    let state = utils::auth::init().await;
    tauri::Builder::default()
        .manage(state)
        .invoke_handler(tauri::generate_handler![authenticate])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
