defmodule BudgetTrackerWeb.InvestmentLive.FormComponent do
  use BudgetTrackerWeb, :live_component

  alias BudgetTracker.Investments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage investment records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="investment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:account_type]} type="text" label="Account type" />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          prompt="Choose a value"
          options={Ecto.Enum.values(BudgetTracker.Investments.Investment, :type)}
        />
        <.input field={@form[:user_id]} type="hidden" value={@current_user.id} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Investment</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{investment: investment} = assigns, socket) do
    changeset = Investments.change_investment(investment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"investment" => investment_params}, socket) do
    changeset =
      socket.assigns.investment
      |> Investments.change_investment(investment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"investment" => investment_params}, socket) do
    save_investment(socket, socket.assigns.action, investment_params)
  end

  defp save_investment(socket, :edit, investment_params) do
    case Investments.update_investment(socket.assigns.investment, investment_params) do
      {:ok, investment} ->
        notify_parent({:saved, investment})

        {:noreply,
         socket
         |> put_flash(:info, "Investment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_investment(socket, :new, investment_params) do
    case Investments.create_investment(investment_params) do
      {:ok, investment} ->
        notify_parent({:saved, investment})

        {:noreply,
         socket
         |> put_flash(:info, "Investment created successfully")
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
