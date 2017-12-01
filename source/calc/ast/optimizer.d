module calc.ast.optimizer;

import std.math;
import calc.ast.node;
import calc.ast.visitor;

struct Optimizer
{
	mixin Visitor;

	Expression optimize(Expression node)
	{
		assert(node);

		return this.dispatch!"this.visit"(node);
	}

	private Expression visit(Number node)
	{
		return node;
	}

	private Expression visit(Variable node)
	{
		return node;
	}

	private Expression visit(Addition node)
	{
		auto left  = this.optimize(node.left);
		auto right = this.optimize(node.right);

		{
			auto l = cast(Number)left;
			auto r = cast(Number)right;

			if (l && l.value == 0)
			{
				return right;
			}

			if (r && r.value == 0)
			{
				return left;
			}

			if (l && r)
			{
				return new Number(l.value + r.value);
			}
		}

		{
			auto l = cast(Negative)left;
			auto r = cast(Negative)right;

			if (l && r)
			{
				return this.optimize(new Negative(new Addition(l.operand, r.operand)));
			}

			if (l)
			{
				return this.optimize(new Subtraction(right, l.operand));
			}

			if (r)
			{
				return this.optimize(new Subtraction(left, r.operand));
			}
		}

		if (left == right)
		{
			return new Multiplication(new Number(2), left);
		}

		return new Addition(left, right);
	}

	private Expression visit(Subtraction node)
	{
		auto left  = this.optimize(node.left);
		auto right = this.optimize(node.right);

		{
			auto l = cast(Number)left;
			auto r = cast(Number)right;

			if (l && l.value == 0)
			{
				return right;
			}

			if (r && r.value == 0)
			{
				return left;
			}

			if (l && r)
			{
				return new Number(l.value - r.value);
			}
		}

		{
			auto l = cast(Negative)left;
			auto r = cast(Negative)right;

			if (l && r)
			{
				return this.optimize(new Subtraction(r.operand, l.operand));
			}

			if (l)
			{
				return this.optimize(new Negative(new Addition(l.operand, right)));
			}

			if (r)
			{
				return this.optimize(new Addition(left, r.operand));
			}
		}

		if (left == right)
		{
			return new Number(0);
		}

		return new Subtraction(left, right);
	}

	private Expression visit(Multiplication node)
	{
		auto left  = this.optimize(node.left);
		auto right = this.optimize(node.right);

		{
			auto l = cast(Number)left;
			auto r = cast(Number)right;

			if (l && l.value == 0)
			{
				return l;
			}

			if (r && r.value == 0)
			{
				return r;
			}

			if (l && l.value == 1)
			{
				return right;
			}

			if (r && r.value == 1)
			{
				return left;
			}

			if (l && l.value == -1)
			{
				return this.optimize(new Negative(right));
			}

			if (r && r.value == -1)
			{
				return this.optimize(new Negative(left));
			}

			if (l && r)
			{
				return this.optimize(new Number(l.value * r.value));
			}
		}

		{
			auto l = cast(Negative)left;
			auto r = cast(Negative)right;

			if (l && r)
			{
				return this.optimize(new Multiplication(l.operand, r.operand));
			}

			if (l)
			{
				return this.optimize(new Negative(new Multiplication(l.operand, right)));
			}

			if (r)
			{
				return this.optimize(new Negative(new Multiplication(left, r.operand)));
			}
		}

		{
			auto l = cast(Division)left;
			auto r = cast(Division)right;

			if (l && r)
			{
				auto num   = new Multiplication(l.left, r.left);
				auto denom = new Multiplication(l.right, r.right);

				return this.optimize(new Division(num, denom));
			}

			if (l)
			{
				return this.optimize(new Division(new Multiplication(l.left, right), l.right));
			}

			if (r)
			{
				return this.optimize(new Division(new Multiplication(left, r.left), r.right));
			}
		}

		if (left == right)
		{
			return new Power(left, new Number(2));
		}

		return new Multiplication(left, right);
	}

	private Expression visit(Division node)
	{
		auto left  = this.optimize(node.left);
		auto right = this.optimize(node.right);

		{
			auto l = cast(Number)left;
			auto r = cast(Number)right;

			if (l && r)
			{
				return new Number(l.value / r.value);
			}

			if (r && r.value == 1)
			{
				return left;
			}

			if (r && r.value == -1)
			{
				return this.optimize(new Negative(left));
			}

			if (l && l.value == 0)
			{
				return l;
			}
		}

		{
			auto l = cast(Negative)left;
			auto r = cast(Negative)right;

			if (l && r)
			{
				return this.optimize(new Division(l.operand, r.operand));
			}

			if (l)
			{
				return this.optimize(new Negative(new Division(l.operand, right)));
			}

			if (r)
			{
				return this.optimize(new Negative(new Division(left, r.operand)));
			}
		}

		if (left == right)
		{
			return new Number(1);
		}

		return new Division(left, right);
	}

	private Expression visit(Power node)
	{
		auto left  = this.optimize(node.left);
		auto right = this.optimize(node.right);

		auto l = cast(Number)left;
		auto r = cast(Number)right;

		if (l && r)
		{
			return new Number(l.value ^^ r.value);
		}

		if (r && r.value == 0)
		{
			return new Number(1);
		}

		if (r && r.value == 1)
		{
			return left;
		}

		if (r && r.value < 0)
		{
			return this.optimize(new Division(new Number(1), new Power(left, new Number(-r.value))));
		}

		return new Power(left, right);
	}

	private Expression visit(Positive node)
	{
		return this.optimize(node.operand);
	}

	private Expression visit(Negative node)
	{
		auto operand = this.optimize(node.operand);

		if (auto v = cast(Number)operand)
		{
			return new Number(-v.value);
		}

		if (auto v = cast(Negative)operand)
		{
			return v.operand;
		}

		return new Negative(operand);
	}

	private Expression visit(Logarithm node)
	{
		auto operand = this.optimize(node.operand);

		if (auto v = cast(Number)operand)
		{
			return new Number(log(v.value));
		}

		return new Logarithm(operand);
	}

	private Expression visit(Sine node)
	{
		auto operand = this.optimize(node.operand);

		if (auto v = cast(Number)operand)
		{
			return new Number(sin(v.value));
		}

		if (auto v = cast(Negative)operand)
		{
			return this.optimize(new Negative(new Sine(v.operand)));
		}

		return new Sine(operand);
	}

	private Expression visit(Cosine node)
	{
		auto operand = this.optimize(node.operand);

		if (auto v = cast(Number)operand)
		{
			return new Number(cos(v.value));
		}

		if (auto v = cast(Negative)operand)
		{
			return this.optimize(new Cosine(v.operand));
		}

		return new Cosine(operand);
	}

	private Expression visit(Tangent node)
	{
		auto operand = this.optimize(node.operand);

		if (auto v = cast(Number)operand)
		{
			return new Number(tan(v.value));
		}

		return new Tangent(operand);
	}
}
