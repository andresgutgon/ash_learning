defmodule AshLearningWeb.ErrorHTMLTest do
  use AshLearningWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    conn = build_conn(:get, "/nonexistent")
    html = render_to_string(AshLearningWeb.ErrorHTML, "404", "html", %{conn: conn, status: 404})

    assert html =~ "404"
    assert html =~ "Page Not Found"
  end

  test "renders 500.html" do
    conn = build_conn(:get, "/boom")
    html = render_to_string(AshLearningWeb.ErrorHTML, "500", "html", %{conn: conn, status: 500})

    assert html =~ "500"
    assert html =~ "Server Error"
  end
end
