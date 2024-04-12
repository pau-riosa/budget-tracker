defmodule BudgetTrackerWeb.BudgetSettingLive.FormComponent do
  use BudgetTrackerWeb, :live_component

  alias BudgetTracker.BudgetSettings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage budget_setting records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="budget_setting-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:category]}
          type="select"
          label="Category"
          prompt="Choose a value"
          options={Ecto.Enum.values(BudgetTracker.BudgetSettings.BudgetSetting, :category)}
        />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:planned_amount]} type="number" label="Planned amount" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Budget setting</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{budget_setting: budget_setting} = assigns, socket) do
    changeset = BudgetSettings.change_budget_setting(budget_setting)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"budget_setting" => budget_setting_params}, socket) do
    changeset =
      socket.assigns.budget_setting
      |> BudgetSettings.change_budget_setting(budget_setting_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"budget_setting" => budget_setting_params}, socket) do
    save_budget_setting(socket, socket.assigns.action, budget_setting_params)
  end

  defp save_budget_setting(socket, :edit, budget_setting_params) do
    case BudgetSettings.update_budget_setting(
           socket.assigns.budget_setting,
           budget_setting_params
         ) do
      {:ok, budget_setting} ->
        notify_parent({:saved, budget_setting})

        {:noreply,
         socket
         |> put_flash(:info, "Budget setting updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_budget_setting(socket, :new, budget_setting_params) do
    case BudgetSettings.create_budget_setting(budget_setting_params) do
      {:ok, budget_setting} ->
        notify_parent({:saved, budget_setting})

        {:noreply,
         socket
         |> put_flash(:info, "Budget setting created successfully")
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
