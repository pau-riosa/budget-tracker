import Chart from "chart.js/auto";
import { transparentize } from "./utils";
export const PieChart = {
  dataset() {
    return JSON.parse(this.el.dataset.items);
  },
  mounted() {
    const ctx = this.el;
    const data = {
      type: "pie",
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "right",
          },
          title: {
            display: true,
            text: "Transaction Analytics By Category",
          },
        },
      },
      data: {
        // random data to validate chart generation
        labels: this.dataset().map((item) => item.category),
        datasets: [
          {
            label: "Transaction Analytics",
            data: this.dataset().map((item) => item.amount),
            backgroundColor: this.dataset().map((item) =>
              transparentize(item.color, 0.8),
            ),
            borderColor: this.dataset().map((item) =>
              transparentize(item.color, 0),
            ),
            borderWidth: 2,
          },
        ],
      },
    };
    const chart = new Chart(ctx, data);
  },
};

export const BarChart = {
  dataset() {
    return JSON.parse(this.el.dataset.items);
  },
  mounted() {
    let list_of_data = this.dataset().map((item) => ({
      borderColor: transparentize(item.color, 0),
      borderWidth: 3,
      backgroundColor: transparentize(item.color, 0.8),
      label: item.category,
      data: [{ x: item.category, y: item.amount }],
    }));

    const ctx = this.el;
    const data = {
      type: "bar",
      options: {
        responsive: true,
        plugins: {
          legend: {
            position: "top",
          },
          title: {
            display: true,
            text: "Overall Transaction Analytics By Type",
          },
        },
      },
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
