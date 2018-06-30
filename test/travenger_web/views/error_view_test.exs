defmodule TravengerWeb.ErrorViewTest do
  use TravengerWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  alias TravengerWeb.ErrorView

  test "404.json returns errors" do
    assert render(ErrorView, "404.json", []) == %{
      errors: [%{
        status: "404",
        title: "Resource not found"
      }]
    }
  end

  test "renders 404.html" do
    assert render_to_string(ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(ErrorView, "505.html", []) ==
           "HTTP Version Not Supported"
  end
end
