const { fluidScaleRemBase } = require("@castiron/style-mixins");
const plugin = require("tailwindcss/plugin");
const { screens } = require("./helper");

function fluidScaleRem(property, value) {
  if (!value.includes(",")) return { [property]: value };

  const [max, min] = value.split(",");

  const scale = fluidScaleRemBase(max, min, screens.xl, screens.xs);
  return { [property]: scale };
}

module.exports = plugin(function ({ matchUtilities, theme }) {
  matchUtilities({
    // Fluid padding
    fpt: (value) => fluidScaleRem("padding-block-start", value),
    fpb: (value) => fluidScaleRem("padding-block-end", value),
    fps: (value) => fluidScaleRem("padding-inline-start", value),
    fpe: (value) => fluidScaleRem("padding-inline-end", value),
    fpy: (value) => fluidScaleRem("padding-block", value),
    fpx: (value) => fluidScaleRem("padding-inline", value),
    // Fluid margin
    fmt: (value) => fluidScaleRem("margin-block-start", value),
    fmb: (value) => fluidScaleRem("margin-block-end", value),
    fms: (value) => fluidScaleRem("margin-inline-start", value),
    fme: (value) => fluidScaleRem("margin-inline-end", value),
    fmy: (value) => fluidScaleRem("margin-block", value),
    fmx: (value) => fluidScaleRem("margin-inline", value),
  });
});
