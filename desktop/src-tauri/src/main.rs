#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use oauth2::basic::BasicClient;
use tauri::Manager;
use oauth2::{PkceCodeChallenge, CsrfToken, ClientId, AuthUrl, TokenUrl, RedirectUrl, PkceCodeVerifier, AuthorizationCode};
use std::sync::Arc;
use std::net::{TcpListener, SocketAddr};
use axum::{Router, extract::Extension};
use serde::Deserialize;

#[derive(Clone)]
struct AuthState {
    csrf_token: CsrfToken,
    pkce: Arc<(PkceCodeChallenge, String)>,
    client: Arc<BasicClient>,
    socket_addr: SocketAddr
}

#[derive(Deserialize)]
struct CallbackQuery {
    code: AuthorizationCode,
    state: CsrfToken,
}

fn create_client(redirect_url: RedirectUrl) -> BasicClient {
    let client_id = ClientId::new(/* env!("OAUTH2_CLIENT_ID", "Missing AUTH0_CLIENT_ID!") */"6mz_UAzjwlIUh7Dd0diXnxXKs6VvJIIl2JaSd3xbGhw".to_string());
    let auth_url = AuthUrl::new("https://humane-bluejay-overly.ngrok-free.app/oauth/authorize".to_string());
    let token_url = TokenUrl::new("https://humane-bluejay-overly.ngrok-free.app/oauth/token".to_string());
    BasicClient::new(client_id, None, auth_url.unwrap(), token_url.ok())
        .set_redirect_uri(redirect_url)
}


async fn authorize(handle: Extension<tauri::AppHandle>, query: axum::extract::Query<CallbackQuery>) -> impl axum::response::IntoResponse {
    let auth = handle.state::<AuthState>();
    if query.state.secret() != auth.csrf_token.secret() {
        println!("Suspected Man in the Middle attack!");
        return "authorized".to_string(); // never let them know your next move
    }

    let token = auth
        .client
        .exchange_code(query.code.clone())
        .set_pkce_verifier(PkceCodeVerifier::new(auth.pkce.1.clone()))
        .request_async(oauth2::reqwest::async_http_client)
        .await
        .unwrap();

    "authorized".to_string()
}

async fn run_server(
    handle: tauri::AppHandle,
) -> Result<(), axum::Error> {
    let app = Router::new()
        .route("/callback", axum::routing::get(authorize))
        .layer(Extension(handle.clone()));

    let _ = axum::Server::bind(&handle.state::<AuthState>().socket_addr.clone())
        .serve(app.into_make_service())
        .await;

    Ok(())
}

#[tauri::command]
async fn authenticate(handle: tauri::AppHandle) {
    let auth = handle.state::<AuthState>();
    let (auth_url, _) = auth
        .client
        .authorize_url(|| auth.csrf_token.clone())
        // .add_scope(...)
        .set_pkce_challenge(auth.pkce.0.clone())
        .url();
    let server_handle = tauri::async_runtime::spawn(async move { run_server(handle).await });
    open::that(auth_url.to_string()).unwrap();
}

#[tokio::main]
async fn main() {
    let (pkce_code_challenge,pkce_code_verifier) = PkceCodeChallenge::new_random_sha256();
    let socket_addr = SocketAddr::new(std::net::IpAddr::V4(std::net::Ipv4Addr::new(127, 0, 0, 1)), 1426); // or any other port
    let redirect_url = format!("http://{socket_addr}/callback").to_string();
    let state = AuthState {
        csrf_token: CsrfToken::new_random(),
        pkce: Arc::new((pkce_code_challenge, PkceCodeVerifier::secret(&pkce_code_verifier).to_string())),
        client: Arc::new(create_client(RedirectUrl::new(redirect_url).unwrap())),
        socket_addr
    };

    tauri::Builder::default()
        .manage(state)
        .invoke_handler(tauri::generate_handler![authenticate])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
