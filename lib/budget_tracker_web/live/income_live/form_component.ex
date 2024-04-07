defmodule BudgetTrackerWeb.IncomeLive.FormComponent do
  use BudgetTrackerWeb, :live_component

  alias BudgetTracker.Incomes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage income records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="income-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:income_source]} type="text" label="Income source" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Income</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{income: income} = assigns, socket) do
    changeset = Incomes.change_income(income)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"income" => income_params}, socket) do
    changeset =
      socket.assigns.income
      |> Incomes.change_income(income_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"income" => income_params}, socket) do
    save_income(socket, socket.assigns.action, income_params)
  end

  defp save_income(socket, :edit, income_params) do
    case Incomes.update_income(socket.assigns.income, income_params) do
      {:ok, income} ->
        notify_parent({:saved, income})

        {:noreply,
         socket
         |> put_flash(:info, "Income updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_income(socket, :new, income_params) do
    case Incomes.create_income(income_params) do
      {:ok, income} ->
        notify_parent({:saved, income})

        {:noreply,
         socket
         |> put_flash(:info, "Income created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
