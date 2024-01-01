/* @refresh reload */
import { render } from "solid-js/web";

import "./index.css";
import App from "./App";
import { Route, Router } from "@solidjs/router";

render(
    () => (
        <Router>
            <Route path="/" component={App} />
        </Router>
    ),
    document.getElementById("root") as HTMLElement
);
