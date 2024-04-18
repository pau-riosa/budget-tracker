import Chart from "chart.js/auto";
import { transparentize } from "./utils";
export const BarChart = {
  dataset() {
    return JSON.parse(this.el.dataset.items);
  },
  mounted() {
    let list_of_data = this.dataset().map((item) => ({
      borderColor: item.color,
      borderWidth: 2,
      backgroundColor: transparentize(item.color, 0.5),
      label: item.category,
      data: [{ x: item.category, y: item.amount }],
    }));

    const ctx = this.el;
    const data = {
      type: "bar",
      label: "transactions",
      data: {
        // random data to validate chart generation
        //
        labels: this.dataset().map((item) => item.category),
        datasets: list_of_data,
      },
    };
    const chart = new Chart(ctx, data);
  },
};
