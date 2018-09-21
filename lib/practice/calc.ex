defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr = String.split(expr, " ")
    pairings = create_pairings(expr)
    postfix = to_postfix(pairings, [])
    evaluate_postfix(postfix, [])
  end

  def evaluate_postfix(list, stack) do
    if list == [] do
      Enum.at(stack, 0)
    else
      first = List.first(list)
      rest = Enum.slice(list, 1, length(list))
      # if it is a number
      if not op?(first) do
        {num, _} = Integer.parse(first)
        evaluate_postfix(rest, [num] ++ stack)
      else
        num1 = Enum.at(stack, 0)
        num2 = Enum.at(stack, 1)
        rest_stack = Enum.slice(stack, 2, length(stack))
        new_stack = [eval_expression(num1, num2, first)] ++ rest_stack
        evaluate_postfix(rest, new_stack)
      end
    end
  end

  # Given two numbers and an operator, evaultes them and returns a number
  def eval_expression(num1, num2, op) do
    cond do
      op == "+" -> num1 + num2
      op == "-" -> num2 - num1
      op == "*" -> num1 * num2
      op == "/" -> num2 / num1
    end
  end

  # converts infix to postfix
  def to_postfix(list, operators) do
    if list == [] do
      [] ++ operators
    else
      first = List.first(list)
      rest = Enum.slice(list, 1, length(list))
      if elem(first, 0) == :num do
        [elem(first, 1)] ++ to_postfix(rest, operators)
      # We know it is an operator
      else
        if operators == [] or compare_operators(elem(first, 1), List.first(operators)) do
          operators = [elem(first, 1)] ++ operators
          to_postfix(rest, operators)
        else
          [List.first(operators)] ++ to_postfix(rest, Enum.slice(operators, 1, length(operators)) ++ [elem(first, 1)])
        end
      end
    end
  end


  # sees if op1 has precedence over op2
  def compare_operators(op1, op2) do
    if Enum.any?(["/", "*"], fn(s) -> s == op1 end) and Enum.any?(["+", "-"], fn(s) -> s == op2 end) do
      true
    else
      false
    end
  end


  def create_pairings(list) do
    if list == [] do
      []
    else
      first = List.first(list)
      rest = Enum.slice(list, 1, length(list))
      if op?(first) do
        [{:op, first}] ++ create_pairings(rest)
      else
        [{:num, first}] ++ create_pairings(rest)
      end
    end
  end

  # Determine whether a character is an operator. If it's not,
  # then it is a number
  def op?(char) do
    Enum.any?(["+", "-", "*", "/"], fn(s) -> s == char end)
  end

end

