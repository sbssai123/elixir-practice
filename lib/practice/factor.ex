defmodule Practice.Factor do
  def factor(x) do
    factor_recurse(x, [], 2)
  end

  def factor_recurse(x, result, divisor) do
    cond do
      x < divisor ->
        result
      (rem x, divisor) == 0 ->
        result = result ++ [divisor]
        x = trunc(x / divisor)
        factor_recurse(x, result, divisor)
      (rem x, divisor) != 0 ->
        if divisor == 2 do
          factor_recurse(x, result, 3)
        else
          factor_recurse(x, result, divisor + 2)
        end
    end
  end

end
