module calc.ast.differentiator;

import calc.ast.node;
import calc.ast.visitor;

struct Differentiator
{
	mixin Visitor;

	Expression differentiate(Expression node, string x)
	in
	{
		assert(node);
	}
	body
	{
		return this.dispatch!"this.visit"(node, x);
	}

	private Expression visit(Number node, string x)
	{
		return new Number(0);
	}

	private Expression visit(Variable node, string x)
	{
		return (node.name == x) ? new Number(1) : new Number(0);
	}

	private Expression visit(Addition node, string x)
	{
		return new Addition(this.differentiate(node.left, x), this.differentiate(node.right, x));
	}

	private Expression visit(Subtraction node, string x)
	{
		return new Subtraction(this.differentiate(node.left, x), this.differentiate(node.right, x));
	}

	private Expression visit(Multiplication node, string x)
	{
		auto left  = new Multiplication(this.differentiate(node.left, x), node.right);
		auto right = new Multiplication(node.left, this.differentiate(node.right, x));

		return new Addition(left, right);
	}

	private Expression visit(Division node, string x)
	{
		auto left  = new Multiplication(this.differentiate(node.left, x), node.right);
		auto right = new Multiplication(node.left, this.differentiate(node.right, x));
		auto denom = new Power(node.right, new Number(2));

		return new Division(new Subtraction(left, right), denom);
	}

	private Expression visit(Power node, string x)
	{
		auto left  = new Multiplication(this.differentiate(node.right, x), new Logarithm(node.left));
		auto right = new Multiplication(node.right, new Division(this.differentiate(node.left, x), node.left));

		return new Multiplication(node, new Addition(left, right));
	}

	private Expression visit(Positive node, string x)
	{
		return new Positive(this.differentiate(node.operand, x));
	}

	private Expression visit(Negative node, string x)
	{
		return new Negative(this.differentiate(node.operand, x));
	}

	private Expression visit(Logarithm node, string x)
	{
		return new Division(this.differentiate(node.operand, x), node.operand);
	}

	private Expression visit(Sine node, string x)
	{
		return new Multiplication(this.differentiate(node.operand, x), new Cosine(node.operand));
	}

	private Expression visit(Cosine node, string x)
	{
		return new Negative(new Multiplication(this.differentiate(node.operand, x), new Sine(node.operand)));
	}

	private Expression visit(Tangent node, string x)
	{
		return new Division(this.differentiate(node.operand, x), new Power(new Cosine(node.operand), new Number(2)));
	}
}
