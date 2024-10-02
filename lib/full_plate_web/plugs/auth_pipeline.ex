defmodule FullPlateWeb.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :full_plate_web,
    module: FullPlateWeb.Guardian,
    error_handler: FullPlateWeb.ErrorHandler

  plug Guardian.Plug.VerifyHeader, schema: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
