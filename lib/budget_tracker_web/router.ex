defmodule BudgetTrackerWeb.Router do
  use BudgetTrackerWeb, :router

  import BudgetTrackerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BudgetTrackerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BudgetTrackerWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", BudgetTrackerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:budget_tracker, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BudgetTrackerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", BudgetTrackerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [
        {BudgetTrackerWeb.UserAuth, :redirect_if_user_is_authenticated},
        {BudgetTrackerWeb.UserAuth, :active_page}
      ] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", BudgetTrackerWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [
        {BudgetTrackerWeb.UserAuth, :ensure_authenticated},
        {BudgetTrackerWeb.UserAuth, :active_page}
      ] do
      live "/dashboard", DashboardLive.Index, :index
      live "/budget_settings", BudgetSettingLive.Index, :index
      live "/budget_settings/new", BudgetSettingLive.Index, :new
      live "/budget_settings/:id/edit", BudgetSettingLive.Index, :edit

      live "/budget_settings/:id", BudgetSettingLive.Show, :show
      live "/budget_settings/:id/show/edit", BudgetSettingLive.Show, :edit

      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", BudgetTrackerWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [
        {BudgetTrackerWeb.UserAuth, :mount_current_user},
        {BudgetTrackerWeb.UserAuth, :active_page}
      ] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
