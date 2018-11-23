defmodule Example do
  require Integer
  require MyStream

  def sum(n) do
    :lists.seq(1, n)
    |> Enum.map(&(&1 + 10))
    |> Enum.sum()
  end

  def lazy_sum(n) do
    MyStream.seq(1, n)
    |> MyStream.map(&(&1 + 10))
    |> MyStream.sum()
  end

  def naturals do
    integer_start_from(0)
  end

  defp integer_start_from(n) do
    MyStream.cons(n, integer_start_from(n + 1))
  end

  def stream_sqrt(x) do
    stream_sqrt(x, guesses(x))
  end

  defp stream_sqrt(x, guesses) do
    s = MyStream.car(guesses)

    if good_enough?(s, x) do
      s
    else
      stream_sqrt(x, MyStream.cdr(guesses))
    end
  end

  def guesses(x) do
    MyStream.cons(
      1,
      MyStream.map(
        guesses(x),
        fn guess -> sqrt_improve(guess, x) end
      )
    )
  end

  def sqrt(x) do
    sqrt_iter(1.0, x)
  end

  def sqrt_iter(guess, x) do
    if good_enough?(guess, x) do
      guess
    else
      sqrt_iter(sqrt_improve(guess, x), x)
    end
  end

  defp sqrt_improve(guess, x) do
    (guess + x / guess) / 2
  end

  defp good_enough?(guess, x) do
    abs(guess * guess - x) < 0.001
  end
end
