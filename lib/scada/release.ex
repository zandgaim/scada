defmodule Scada.Release do
  @app :scada

  def migrate do
    load_app()
    for repo <- repos() do
      IO.puts("Running migrations for #{inspect(repo)}")
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  defp load_app do
    Application.load(@app)
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end
end
