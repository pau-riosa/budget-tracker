import Chart from "chart.js/auto";
import { transparentize, months, returnMonths } from "./utils";
const d = new Date();
let month_name = returnMonths()[d.getMonth()];
export const HorizontalBarChart = {
  dataset() {
    return JSON.parse(this.el.dataset.items);
  },
  datatitle() {
    return this.el.dataset.title;
  },
  mounted() {
    const ctx = this.el;
    console.log(this.dataset());
    const data = {
      type: "bar",
      options: {
        indexAxis: "y",
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false,
            position: "right",
          },
          title: {
            display: true,
            text: this.datatitle(),
          },
        },
      },
      data: {
        // random data to validate chart generation
        labels: this.dataset().map((item) => item.category.toUpperCase()),
        datasets: [
          {
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
  datatitle() {
    return this.el.dataset.title;
  },
  mounted() {
    let list_of_data = this.dataset().map((item) => ({
      borderColor: transparentize(item.color, 0),
      borderWidth: 3,
      backgroundColor: transparentize(item.color, 0.8),
      label: item.category.toUpperCase(),
      data: [{ x: item.category.toUpperCase(), y: item.amount }],
    }));

    const ctx = this.el;
    const data = {
      type: "bar",
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: "top",
          },
          title: {
            display: true,
            text: this.datatitle(),
          },
        },
      },
      data: {
        // random data to validate chart generation
        //
        labels: this.dataset().map((item) => item.category.toUpperCase()),
        datasets: list_of_data,
      },
    };
    const chart = new Chart(ctx, data);
  },
};
