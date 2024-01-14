import { invoke } from "@tauri-apps/api/tauri";

function App() {
    return (
        <>
            <h1 class="text-4xl">Image Sync</h1>
            <button onClick={() => invoke("authenticate")}>Login</button>
        </>
    );
}

export default App;
