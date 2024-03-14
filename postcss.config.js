const path = require("path");
const { fluidScaleRem } = require("./tailwind/helper");

module.exports = {
  plugins: {
    "postcss-mixins": {
      mixinsDir: path.join(__dirname, "./app/assets/stylesheets/mixins"),
      mixins: {
        fluidScaleRem,
      },
    },
    "postcss-import": require("postcss-import"),
    "tailwindcss/nesting": require("postcss-nested")({ bubble: ["container"] }),
    autoprefixer: require("autoprefixer"),
    tailwindcss: require("tailwindcss"),
  },
};
