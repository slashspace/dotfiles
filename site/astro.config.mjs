import { defineConfig } from "astro/config";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  site: "https://slashspace.github.io",
  base: "/dotfiles",
  vite: {
    plugins: [tailwindcss()],
  },
});
