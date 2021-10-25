defmodule ExPollWeb.OptionController do
  use ExPollWeb, :controller

  alias ExPoll.Polls
  alias ExPoll.Polls.Option

  action_fallback ExPollWeb.FallbackController

  def index(conn, _params) do
    options = Polls.list_options()
    render(conn, "index.json", options: options)
  end

  def create(conn, %{"option" => option_params}) do
    with {:ok, %Option{} = _option} <- Polls.create_option(option_params) do
      conn
      |> put_status(:created)
      #|> put_resp_header("location", Routes.option_path(conn, :show, option))
      #|> render("show.json", option: option)
    end
  end

  def show(conn, %{"id" => id}) do
    option = Polls.get_option!(id)
    render(conn, "show.json", option: option)
  end

  def update(conn, %{"id" => id, "option" => option_params}) do
    option = Polls.get_option!(id)

    with {:ok, %Option{} = option} <- Polls.update_option(option, option_params) do
      render(conn, "show.json", option: option)
    end
  end

  def delete(conn, %{"id" => id}) do
    option = Polls.get_option!(id)

    with {:ok, %Option{}} <- Polls.delete_option(option) do
      send_resp(conn, :no_content, "")
    end
  end
end
