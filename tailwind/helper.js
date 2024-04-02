const { fluidScaleRemBase } = require("@castiron/style-mixins");

const screens = {
  xxs: "17.5rem", // 280px
  xs: "23rem", // 368px
  sm: "30rem", // 480px
  md: "48rem", // 768px
  lg: "64rem", // 1024px
  xl: "87.5rem", // 1400px
  xxl: "131.25rem", // 2100px
  nav: "72.8125rem", // 1165px
  /* 3 * table-column-min + gap */
  compare3: "41rem",
  /* 4 * table-column-min + gap  */
  compare4: "54rem",
};

module.exports = {
  screens,
  fluidScaleRem: function (
    max,
    min,
    maxBreak = screens.xl,
    minBreak = screens.xs
  ) {
    return fluidScaleRemBase(max, min, maxBreak, minBreak);
  },
};
