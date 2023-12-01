defmodule Tz.UpdatePeriodically do
  @moduledoc """
  A process enabling automatic IANA data updates periodically.
  """

  use GenServer
  require Logger
  alias Tz.HTTP
  alias Tz.IanaDataDir
  alias Tz.Updater

  defp maybe_recompile() do
    Logger.debug("Tz is checking for IANA time zone database updates")

    Updater.maybe_recompile()
  end

  @doc false
  def start_link(opts) do
    if IanaDataDir.forced_iana_version() do
      raise "cannot update time zone periods as version #{IanaDataDir.forced_iana_version()} has been forced through the :iana_version config"
    end

    HTTP.get_http_client!()

    GenServer.start_link(__MODULE__, opts)
  end

  @doc false
  def init(opts) do
    maybe_recompile()
    schedule_work(opts[:interval_in_days])
    {:ok, %{opts: opts}}
  end

  @doc false
  def handle_info(:work, %{opts: opts}) do
    maybe_recompile()
    schedule_work(opts[:interval_in_days])
    {:noreply, %{opts: opts}}
  end

  defp schedule_work(interval_in_days) do
    interval_in_days = interval_in_days || 1
    Process.send_after(self(), :work, interval_in_days * 24 * 60 * 60 * 1000)
  end
end
