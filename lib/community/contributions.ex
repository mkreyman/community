defmodule Community.Contributions do
  @moduledoc """
  The Contributions context.
  """

  alias Community.Contributions.Donor

  def list_donors do
    [
      %Donor{
        id: "1",
        name: "JosÃ©",
        amount: 100.00,
        address: "123 Main St, Arvada, CO 80001",
        email: "jose@test.com",
        phone: "303-123-4567",
        receipt_emailed: true
      },
      %Donor{
        id: "2",
        name: "Bruce",
        amount: 50.00,
        address: "456 Main St, Arvada, CO 80002",
        email: "bruce@test.com",
        phone: "303-456-7890",
        receipt_emailed: nil
      },
      %Donor{
        id: "3",
        name: "Chris",
        amount: 10.00,
        address: "789 Main St, Arvada, CO 80003",
        email: nil,
        phone: "303-789-0123",
        receipt_emailed: nil
      }
    ]
  end

  def get_donor(id) do
    Enum.find(list_donors(), fn map -> map.id == id end)
  end

  def get_donor_by(params) do
    Enum.find(list_donors(), fn map ->
      Enum.all?(params, fn {key, val} -> Map.get(map, key) == val end)
    end)
  end
end
