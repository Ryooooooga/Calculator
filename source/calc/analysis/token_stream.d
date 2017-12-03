module calc.analysis.token_stream;

import calc.analysis.lexer;
import calc.analysis.token;

class TokenStream
{
	private Lexer   _lexer;
	private Token[] _queue;

	this(Lexer lexer) pure nothrow
	in
	{
		assert(lexer);
	}
	body
	{
		this._lexer = lexer;
		this._queue = [];
	}

	Token read()
	{
		auto t = this.peek(0);
		this._queue = this._queue[1..$];

		return t;
	}

	Token peek(size_t n)
	{
		while (n >= this._queue.length)
		{
			this._queue ~= this._lexer.read();
		}

		return this._queue[n];
	}
}
