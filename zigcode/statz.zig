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
		std.debug.print("{}", .{result});

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
                '0'...'9' => {
                    self.index -= 1;
                    return Token.Number;
                },
                ' ' => {}, // skip spaces
                else => @panic("Invalid character"),
            }
        }
        return Token.Eof;
    }

    pub fn numberValue(self: *Tokenizer) i64 {
        var value: i64 = 0;
        while (self.index < self.input.len and self.input[self.index] >= '0' and self.input[self.index] <= '9') {
            value = value * 10 + @as(i64, self.input[self.index] - '0');
            self.index += 1;
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

    pub fn parse(self: *Parser) i64 {
        self.current_token = self.tokenizer.nextToken();
        return self.parseExpression();
    }

    fn parseExpression(self: *Parser) i64 {
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

    fn parseTerm(self: *Parser) i64 {
        var result = self.parseFactor();
        while (self.current_token == Token.Asterisk) {
            self.current_token = self.tokenizer.nextToken();
            result *= self.parseFactor();
        }
        return result;
    }

    fn parseFactor(self: *Parser) i64 {
        if (self.current_token == Token.Number) {
            const value = self.tokenizer.numberValue();
            self.current_token = self.tokenizer.nextToken();
            return value;
        } else {
            @panic("Expected number");
        }
    }
};
