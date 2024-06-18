const std = @import("std");
pub fn main()!void{
	var end_program:bool = false;
	while(!end_program){
		var input : [20]u8 = undefined;
		std.debug.print("z> ",.{});	
		defer std.debug.print("\n",.{});
		const user_input = try getInputValue(&input);
		
		if(std.mem.eql(u8,user_input,"exit")){
			std.debug.print("bye",.{});
			end_program = true;
			return;
		}
		var parser = Parser.init(user_input);
		const result = parser.parse();
		std.debug.print("{d}", .{result});

		//std.debug.print("{s}",.{user_input});		
	}
}


fn getInputValue(input : []u8)![]const u8{
	
	const stdin = std.io.getStdIn().reader();
	var val = try stdin.readUntilDelimiter(input[0..],'\n');
	const line = std.mem.trimRight(u8, val[0..val.len - 1], "\r");
	return line;
}


const Token = enum {
    Plus,
	Minus,
    Asterisk,
    Number,
    LParen,
    RParen,
    Eof,
};

const Tokenizer = struct {
    input: []const u8,
    index: usize,

    pub fn nextToken(self: *Tokenizer) Token {
        while (self.index < self.input.len) {
            const c = self.input[self.index];
            self.index += 1;
            switch (c) {
                '+' => return Token.Plus,
				'-' => return Token.Minus,
                '*' => return Token.Asterisk,
                '(' => return Token.LParen,
                ')' => return Token.RParen,
                '0'...'9', '.' => {
                    self.index -= 1;
                    return Token.Number;
                },
                ' ' => {}, // skip spaces
                else => @panic("Invalid character"),
            }
        }
        return Token.Eof;
    }

    pub fn numberValue(self: *Tokenizer) f64 {
        var value: f64 = 0;
        var is_float: bool = false;
        var fraction_multiplier: f64 = 0.1;

        while (self.index < self.input.len) {
            const c = self.input[self.index];
            if (c >= '0' and c <= '9') {
                if (is_float) {
                    value += fraction_multiplier * @as(f64,@floatFromInt(c - '0'));
                    fraction_multiplier *= 0.1;
                } else {
                    value = value * 10 + @as(f64,@floatFromInt(c - '0'));
                }
                self.index += 1;
            } else if (c == '.') {
                if (is_float) {
                    @panic("Invalid number format");
                }
                is_float = true;
                self.index += 1;
            } else {
                break;
            }
        }
        return value;
    }
};

const Parser = struct {
    tokenizer: Tokenizer,
    current_token: Token,

    pub fn init(input: []const u8) Parser {
        return Parser{
            .tokenizer = Tokenizer{ .input = input, .index = 0 },
            .current_token = Token.Eof,
        };
    }

    pub fn parse(self: *Parser) f64 {
        self.current_token = self.tokenizer.nextToken();
        const result = self.parseExpression();
		return result;
    }

    fn parseExpression(self: *Parser) f64 {
        var result = self.parseTerm();
        while (self.current_token == Token.Plus) {
            self.current_token = self.tokenizer.nextToken();
            result += self.parseTerm();
        }
		while (self.current_token == Token.Minus) {
            self.current_token = self.tokenizer.nextToken();
            result -= self.parseTerm();
        }
        return result;
    }

    fn parseTerm(self: *Parser) f64 {
        var result = self.parseFactor();
        while (self.current_token == Token.Asterisk) {
            self.current_token = self.tokenizer.nextToken();
            result *= self.parseFactor();
        }
        return result;
    }

    fn parseFactor(self: *Parser) f64 {
        if (self.current_token == Token.Number) {
            const value = self.tokenizer.numberValue();
            self.current_token = self.tokenizer.nextToken();
            return value;
        } else if (self.current_token == Token.LParen) {
            self.current_token = self.tokenizer.nextToken();
            const value = self.parseExpression();
            if (self.current_token != Token.RParen) {
                @panic("Expected closing parenthesis");
            }
            self.current_token = self.tokenizer.nextToken();
            return value;
        } else {
            @panic("Expected number or parenthesis");
        }
    }
};

