module calc.analysis.lexer;

import std.algorithm;
import std.array;
import std.conv;
import std.regex;
import std.typecons;
import calc.analysis.i_input_stream;
import calc.analysis.token;

class Lexer
{
	private IInputStream _stream;
	private string       _line;

	this(IInputStream stream) pure nothrow
	{
		assert(stream);

		this._stream = stream;
		this._line   = "";
	}

	Token read()
	{
		while (true)
		{
			if (this._line == "")
			{
				if (this._stream.eof)
				{
					return new Token(TokenKind.eof, "[EOF]");
				}

				this._line = this._stream.readLine;
			}

			// Whitespaces.
			{
				auto m = this._line.matchFirst(ctRegex!`^\s+`);

				if (!m.empty)
				{
					this._line.skipOver(m.hit);

					continue;
				}
			}

			// Numbers.
			{
				auto m = this._line.matchFirst(ctRegex!`^[0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?`);

				if (!m.empty)
				{
					this._line.skipOver(m.hit);

					return new Token(TokenKind.number, m.hit, m.hit.to!double);
				}
			}

			// Identifiers.
			{
				auto m = this._line.matchFirst(ctRegex!`^[A-Z_a-z][0-9A-Z_a-z]*'*`);

				if (!m.empty)
				{
					this._line.skipOver(m.hit);

					return new Token(TokenKind.identifier, m.hit);
				}
			}

			// Punctuators.
			{
				alias Word = Tuple!(string, "text", TokenKind, "kind");

				const punctuators =
				[
					Word("+", TokenKind.plus       ),
					Word("-", TokenKind.minus      ),
					Word("*", TokenKind.star       ),
					Word("/", TokenKind.slash      ),
					Word("=", TokenKind.assign     ),
					Word("(", TokenKind.leftParen  ),
					Word(")", TokenKind.rightParen ),
					Word(",", TokenKind.comma      ),
				].sort!"a.text.length > b.text.length".array;

				foreach (punct; punctuators)
				{
					if (this._line.skipOver(punct.text))
					{
						return new Token(punct.kind, punct.text);
					}
				}
			}

			// Unknown token.
			throw new Exception("Unexpected character.");
		}
	}
}
