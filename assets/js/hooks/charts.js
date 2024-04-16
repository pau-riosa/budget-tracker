import Chart from "chart.js/auto";
export const BarChart = {
  dataset() {
    return JSON.parse(this.el.dataset.items);
  },
  mounted() {
    let list_of_data = this.dataset().map((item) => ({
      color: item.color,
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
