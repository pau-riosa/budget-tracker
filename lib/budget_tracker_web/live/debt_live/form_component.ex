defmodule BudgetTrackerWeb.DebtLive.FormComponent do
  use BudgetTrackerWeb, :live_component

  alias BudgetTracker.Debts

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage debt records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="debt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:debt_type]} type="text" label="Debt type" />
        <.input field={@form[:total_amount]} type="number" label="Total amount" step="any" />
        <.input
          field={@form[:monthly_payment_amount]}
          type="number"
          label="Monthly payment amount"
          step="any"
        />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Debt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{debt: debt} = assigns, socket) do
    changeset = Debts.change_debt(debt)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"debt" => debt_params}, socket) do
    changeset =
      socket.assigns.debt
      |> Debts.change_debt(debt_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"debt" => debt_params}, socket) do
    save_debt(socket, socket.assigns.action, debt_params)
  end

  defp save_debt(socket, :edit, debt_params) do
    case Debts.update_debt(socket.assigns.debt, debt_params) do
      {:ok, debt} ->
        notify_parent({:saved, debt})

        {:noreply,
         socket
         |> put_flash(:info, "Debt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_debt(socket, :new, debt_params) do
    case Debts.create_debt(debt_params) do
      {:ok, debt} ->
        notify_parent({:saved, debt})

        {:noreply,
         socket
         |> put_flash(:info, "Debt created successfully")
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
