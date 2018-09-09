# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Travenger.Repo.insert!(%Travenger.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
"priv/repo/seeds"
|> Path.join("**/*.exs")
|> Path.wildcard()
|> Enum.map(&Code.require_file/1)

# Keep test environment declarative and keep out seeders from it
if Mix.env() == :dev do
  TravengerSeeder.seed()
end
