defmodule Timemaster.JwtAuthToken do

  def decode(jwt_string, public_key_string) do
    case Timemaster.Token.verify_and_validate(jwt_string) do
      {:ok, claims} -> {:ok, claims}
      _ -> {:error, "Invalid JWT"}
    end
  end
end
