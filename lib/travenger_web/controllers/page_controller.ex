defmodule TravengerWeb.PageController do
  use TravengerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
