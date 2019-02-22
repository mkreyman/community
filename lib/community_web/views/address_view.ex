defmodule CommunityWeb.AddressView do
  use CommunityWeb, :view

  def category_select_options(categories) do
    for category <- categories, do: category
  end
end
