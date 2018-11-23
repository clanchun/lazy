defmodule MyStream do
  import Lazy

  defmacro cons(a, b) do
    quote do
      [unquote(a) | delay(unquote(b))]
    end
  end

  def car(stream) do
    hd(stream)
  end

  def cdr(stream) do
    stream
    |> tl()
    |> force()
  end

  def at(stream, 0), do: car(stream)

  def at(stream, n) do
    stream
    |> cdr()
    |> at(n - 1)
  end

  def map([h | :eos], fun), do: [fun.(h) | :eos]

  def map(stream, fun) do
    cons(stream |> car() |> fun.(), stream |> cdr() |> map(fun))
  end

  def each([h | :eos], fun) do
    fun.(h)
    :ok
  end

  def each(stream, fun) do
    stream
    |> car()
    |> fun.()

    stream
    |> cdr()
    |> each(fun)
  end

  def seq(b, b), do: [b | :eos]

  def seq(a, b) do
    cons(a, seq(a + 1, b))
  end

  def lazy_sum([h | :eos]), do: h

  def lazy_sum(stream) do
    cons(car(stream), sum(cdr(stream)))
  end

  def sum(:eos), do: 0
  def sum([h | :eos]), do: h

  def sum(stream) do
    car(stream) + sum(cdr(stream))
  end
end
