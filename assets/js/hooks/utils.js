// https://www.chartjs.org/docs/latest/samples/utils.html
import colorLib from "@kurkle/color";

export function transparentize(value, opacity) {
  var alpha = opacity === undefined ? 0.5 : 1 - opacity;
  return colorLib(value).alpha(alpha).rgbString();
}
