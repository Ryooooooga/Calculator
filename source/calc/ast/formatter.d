module calc.ast.formatter;

import std.format;
import calc.ast.node;
import calc.ast.visitor;

struct Formatter
{
	mixin Visitor;

	string format(Expression node)
	in
	{
		assert(node);
	}
	body
	{
		return this.dispatch!"this.visit"(node);
	}

	private string visit(Number node)
	{
		return "%s".format(node.value);
	}

	private string visit(Variable node)
	{
		return node.name;
	}

	private string visit(Addition node)
	{
		return "(%s+%s)".format(this.format(node.left), this.format(node.right));
	}

	private string visit(Subtraction node)
	{
		return "(%s-%s)".format(this.format(node.left), this.format(node.right));
	}

	private string visit(Multiplication node)
	{
		return "(%s*%s)".format(this.format(node.left), this.format(node.right));
	}

	private string visit(Division node)
	{
		return "(%s/%s)".format(this.format(node.left), this.format(node.right));
	}

	private string visit(Power node)
	{
		return "(%s^%s)".format(this.format(node.left), this.format(node.right));
	}

	private string visit(Positive node)
	{
		return "+(%s)".format(this.format(node.operand));
	}

	private string visit(Negative node)
	{
		return "-(%s)".format(this.format(node.operand));
	}

	private string visit(Logarithm node)
	{
		return "log(%s)".format(this.format(node.operand));
	}

	private string visit(Sine node)
	{
		return "sin(%s)".format(this.format(node.operand));
	}

	private string visit(Cosine node)
	{
		return "cos(%s)".format(this.format(node.operand));
	}

	private string visit(Tangent node)
	{
		return "tan(%s)".format(this.format(node.operand));
	}
}
