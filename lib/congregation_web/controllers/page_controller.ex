defmodule CongregationWeb.PageController do
  use CongregationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
