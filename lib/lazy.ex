defmodule Lazy do
  @moduledoc """
  Documentation for Laziness.
  """

  defmacro delay(expr) do
    quote do
      fn ->
        unquote(expr)
      end
    end
  end

  defmacro force(expr) do
    quote do
      unquote(expr).()
    end
  end
end
