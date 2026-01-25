import "../css/app.css";

import { StrictMode } from "react";
import { createRoot, hydrateRoot } from "react-dom/client";
import axios from "axios";
import { createInertiaApp } from "@inertiajs/react";
import { resolvePage } from "@/lib/pageHelpers";
import { PageProps } from "@/types";

axios.defaults.xsrfHeaderName = "x-csrf-token";

createInertiaApp({
  resolve: resolvePage,
  setup({ App, el, props }) {
    const { ssr } = props.initialPage.props as PageProps;

    const app = (
      <StrictMode>
        <App {...props} />
      </StrictMode>
    );

    if (ssr) {
      hydrateRoot(el, app);
    } else {
      createRoot(el).render(app);
    }
  },
});
