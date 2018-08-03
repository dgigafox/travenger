defmodule TravengerWeb.Router do
  use TravengerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TravengerWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/user", TravengerWeb do
    pipe_through(:api)

    resources("/blogs", BlogController)
    resources("/users", UserController)

    resources("/groups", GroupController) do
      post("/join", GroupController, :join)
      post("/invite", GroupController, :invite)

      resources("/memberships", MembershipController) do
        put("/approve", MembershipController, :approve)
      end
    end

    resources("/events", EventController)
  end

  scope "/auth", TravengerWeb do
    pipe_through(:api)

    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
  end

  # Other scopes may use custom stacks.
  # scope "/api", TravengerWeb do
  #   pipe_through :api
  # end
end
