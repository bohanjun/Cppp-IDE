//
//  CDParser.swift
//  C+++
//
//  Created by 23786 on 2020/5/8.
//  Copyright © 2020 Zhu Yixuan. All rights reserved.
//

import Cocoa

class CDParser: NSObject {
    
    init(code: String) {
        super.init()
        
        self.buffer = code
        
    }

    var buffer: String!
    var pos: Int = -1
    var syn: Int = -1
    
    private var state: ParserResult = .all
    
    private enum ParserResult : Int {
        
        case all = 0
        case add = 1
        case minus = 2
        case multiply = 3
        case divide = 4
        case singleLineComment = 20
        case multipleLineComment = 21
        case multipleLineComment2 = 22
        case multipleLineComment3 = 23
        case leftAngleBracket = 5
        case smallerOrEqual = 24
        case rightAngleBracket = 6
        case biggerOrEqual = 25
        case equal = 7
        case equalEqual = 26
        case semicolon = 8
        case exclamation = 9
        case notEqual = 27
        case leftSquareBracket = 10
        case rightSquareBracket = 11
        case leftParentheses = 12
        case rightParentheses =  13
        case leftCurlyBraces = 14
        case rightCurlyBraces = 15
        case stringStart = 16
        case stringEnd = 28
        case comma = 17
        case letter = 18
        case keyword = 29
        case number = 19
        case float = 30
        case error = 99
        case whiteSpace = 31
        case end = 100
        case fileEnd = 101
        
    }
    

    func back() {
        pos -= 1
    }
    
    func getNext() -> Character? {
        if pos + 1 < buffer.count {
            pos += 1
            return Array(buffer)[pos]
        } else {
            return "\0"
            /*if pos != buffer.count {
                buffer.append("\n")
            } else {
                return nil
            }
            pos = 0
            pos += 1
            return Array(buffer)[pos]*/
        }
    }
    
    func getToken() {
        
        var ch: Character = " "
        var token: String = ""
        
        while true {
            
            if let c = getNext() {
                ch = c
                print("ch=\(ch) buffer=\(String(describing: buffer))")
            } else {
                break
            }
            
            while state != .end {
                
                switch state {
                    
                    case .all :
                        
                    switch ch {
                        
                        case "+": state = .add
                        case "-": state = .minus
                        case "*": state = .multiply
                        case "/": state = .divide
                        case "<": state = .leftAngleBracket
                        case ">": state = .rightAngleBracket
                        case "=": state = .equal
                        case ";": state = .semicolon
                        case "!": state = .exclamation
                        case "[": state = .leftSquareBracket
                        case "]": state = .rightSquareBracket
                        case "(": state = .leftParentheses
                        case ")": state = .rightParentheses
                        case "{": state = .leftCurlyBraces
                        case "}": state = .rightCurlyBraces
                        case "\"": state = .stringStart
                        case ",": state = .comma
                        case "\0": state = .fileEnd
                        
                        default:
                        if ch.isLetter {
                            state = .letter
                        } else if ch.isNumber {
                            state = .number
                        } else if ch.isWhitespace {
                            state = .whiteSpace
                        } else {
                            state = .error
                        }
                        
                    }
                    
                    case .whiteSpace:
                        ch = getNext()!
                        if ch.isWhitespace {
                            state = .whiteSpace
                        } else {
                            state = .all
                        }
                    
                    case .add:
                        token.append(ch)
                        ch = getNext()!
                        if ch.isNumber {
                            state = .number
                        } else {
                            back()
                            syn = 8
                            state = .end
                        }
                    
                    case .minus:
                        token.append(ch)
                        syn = 9
                        state = .end
                    
                    case .multiply:
                        token.append(ch)
                        syn = 10
                        state = .end
                    
                    case .divide:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "/" {
                            state = .singleLineComment
                        } else if ch == "*" {
                            state = .multipleLineComment
                        } else if ch.isNumber {
                            state = .number
                        } else {
                            back()
                            syn = 11
                            state = .end
                        }
                    
                    case .singleLineComment:
                        while let c = getNext() {
                            if c == "\n" {
                                ch = c
                                break
                            }
                        }
                        syn = 31
                        state = .end
                    
                    case .multipleLineComment:
                        ch = getNext()!
                        if ch == "*" {
                            state = .multipleLineComment2
                        } else {
                            state = .multipleLineComment
                        }
                    
                    case .multipleLineComment2:
                        ch = getNext()!
                        if ch == "*" {
                            state = .multipleLineComment2
                        } else if ch == "/" {
                            state = .multipleLineComment3
                        } else {
                            state = .multipleLineComment
                        }
                    
                    case .multipleLineComment3:
                        state = .end
                        syn = 32
                    
                    case .leftAngleBracket:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "=" {
                            state = .smallerOrEqual
                        } else {
                            back()
                            state = .end
                            syn = 12
                        }
                    
                    case .smallerOrEqual:
                        token.append(ch);
                        state = .end;
                        syn = 23
                    
                    case .rightAngleBracket:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "=" {
                            state = .biggerOrEqual
                        } else {
                            back()
                            state = .end
                            syn = 13
                        }
                        
                    case .biggerOrEqual:
                        token.append(ch)
                        state = .end
                        syn = 24
                    
                    case .equal:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "=" {
                            state = .equalEqual
                        } else {
                            back()
                            state = .end
                            syn = 14
                        }
                    
                    case .equalEqual:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 25
                        
                    case .semicolon:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 15
                    
                    case .exclamation:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "=" {
                            state = .notEqual
                        } else {
                            state = .error
                        }
                    
                    case .notEqual:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 26
                        
                    case .leftSquareBracket:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 17
                    
                    case .rightSquareBracket:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 18
                    
                    case .leftParentheses:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 19
                    
                    case .rightParentheses:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 20
                    
                    case .leftCurlyBraces:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 21
                    
                    case .rightCurlyBraces:
                        token.append(ch)
                        ch = getNext()!
                        state = .end
                        syn = 22
                    
                    case .stringStart:
                        token.append(ch)
                        ch = getNext()!
                        if ch == "\"" {
                            state = .stringEnd
                        } else {
                            state = .stringStart
                        }
                    
                    case .stringEnd:
                        token.append(ch)
                        state = .end
                        syn = 30
                    
                    case .comma:
                        token.append(ch)
                        state = .end
                        syn = 16
                    
                    case .letter:
                        token.append(ch)
                        ch = getNext()!
                        if ch.isLetter || ch.isNumber {
                            state = .letter
                        } else {
                            back()
                            state = .keyword
                        }
                        
                    case .keyword:
                        if token == "if" {
                            syn = 0
                        } else {
                            syn = 27
                            state = .end
                        }
                    
                    case .number:
                        token.append(ch)
                        ch = getNext()!
                        if ch.isNumber {
                            state = .number
                        } else if ch == "." {
                            state = .float
                        } else {
                            back()
                            state = .end
                            syn = 28
                        }
                    
                    case .float:
                        token.append(ch)
                        if ch.isNumber {
                            state = .float
                        } else {
                            back()
                            state = .end
                            syn = 29
                        }
                    
                    case .error:
                        print("\nerror: \(ch)")
                        ch = getNext()!
                        while !ch.isWhitespace || ch == ";" {
                            ch = getNext()!
                        }
                        back();
                        state = .end;
                        syn = -1
                    
                    case .end: break
                    
                    case .fileEnd: break
                    
                }
                    
                
                // print("state = \(state) pos = \(pos) token = \(token)")
                // print("ch = \'\(ch)\'")
                
                if state == .end && syn != -1 {
                        
                    switch syn {
                            
                        case 0:
                            print("Keyword: \(token)")
                            
                        case 27:
                            print("id: \(token)")
                            
                        case 28:
                            print("number: \(token)")
                            
                        case 29:
                            print("double: \(token)")
                            
                        case 30:
                            print("string: \(token)")
                            
                        case 31, 32: break
                            
                        default:
                            print("symbol: \(token)")
                            
                    }
                    
                    state = .all
                    syn = -1
                    token = ""
                        
                }
                
                if state == .end {
                    state = .all
                }
                
                if state == .fileEnd {
                    break
                }
                    
            }
            
            if state == .fileEnd {
                break
            }
                
        }
            
            
    }
        
        
}
    /*private:
        //char buffer[4096];        //读入源程序的缓冲区
        std::string buffer;
        int pos;                        //缓冲区位置
        int syn;                        //token类别
        int state;                        //DFA中的状态
        std::string sourcename;
        int filepos;
        std::ifstream infile;
        //int tsss;
        const int BUFFERLENGTH = 4096;
    public:
        Scanner(const char* s)
        {
            //if (source = fopen(s, "r"));
            //else exit(1);
            sourcename = s;
            infile.open(s);
            pos = 0;
            syn = -1;
            state = 0;
            filepos = 0;
            //fgets(buffer, BUFFERLENGTH, source);
            
        }
        void GetToken();                //在DFA上转移，识别token
        bool IsNum(const char c);
        bool IsLetter(const char c);
        char GetNext();                    //获取下一个字符
        void Back();                    //向前看完后回溯
        ~Scanner()
        {
            infile.close();
        }
    };
     
    
     
     
    void Scanner::GetToken()
    {
        char ch;
        constexpr int TOKENLENGTH = 256;
        char token[TOKENLENGTH];
        memset(token, 0, TOKENLENGTH);
        int tokenpos = 0;
        std::ofstream outfile("D://cminus//token.txt");
        while ((ch = GetNext()) != EOF)
        {
            //todo: 标识符，关键字，整型，浮点数运算符，注释，界符，字符串的dfa
            while (state != 100)
                switch (state)
                {
                case 0:                                    //开始状态
                    if (ch == '+') state = 1;
                    else if (ch == '-') state = 2;
                    else if (ch == '*') state = 3;
                    else if (ch == '/') state = 4;
                    else if (ch == '<') state = 5;
                    else if (ch == '>') state = 6;
                    else if (ch == '=') state = 7;
                    else if (ch == ';') state = 8;
                    else if (ch == '!') state = 9;
                    else if (ch == '[') state = 10;
                    else if (ch == ']') state = 11;
                    else if (ch == '(') state = 12;
                    else if (ch == ')') state = 13;
                    else if (ch == '{') state = 14;
                    else if (ch == '}') state = 15;
                    else if (ch == '"') state = 16;
                    else if (ch == ',')state = 17;
                    else if (IsLetter(ch)) state = 18;
                    else if (IsNum(ch)) state = 19;
                    else if (ch == ' ' || ch == '\t' || ch == '\n') state = 100;
                    else state = 99;            //异常
                    break;
                case 1:                                    //匹配到 +
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 19;
                    else
                    {
                        Back();
                        syn = 8;
                        state = 100;
                    }
                    break;
                case 2:                                    //匹配到 -
                    token[tokenpos++] = ch;
                    syn = 9;
                    state = 100;
                    break;
                case 3:                                    //匹配到 *
                    token[tokenpos++] = ch;
                    syn = 10;
                    state = 100;
                    break;
                case 4:                                    //匹配到 /
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '/') state = 20;
                    else if (ch == '*') state = 21;
                    else
                    {
                        Back();
                        state = 100;
                        syn = 11;
                    }
                    break;
                case 20:                                //匹配到 //
                    while ((ch = GetNext()) != '\n');
                    syn = 31;
                    state = 100;
                    break;
                case 21:                                // 匹配到 /*
                    ch = GetNext();
                    if (ch == '*') state = 22;
                    else state = 21;
                    break;
                case 22:                                //匹配到 /**
                    ch = GetNext();
                    if (ch == '*') state = 22;
                    else if (ch == '/')state = 23;
                    else state = 21;
                    break;
                case 23:                                //匹配到 /**/
                    state = 100;
                    syn = 32;
                    break;
                case 5:                                    //匹配到 <
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '=') state = 24;
                    else
                    {
                        Back();;
                        state = 100;
                        syn = 12;
                    }
                    break;
                case 24:                                //匹配到 <=
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 23;
                    break;
                case 6:                                    //匹配到 >
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '=') state = 25;
                    else
                    {
                        Back();
                        state = 100;
                        syn = 13;
                    }
                    break;
                case 25:                                //匹配到 >=
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 24;
                    break;
                case 7:                                    //匹配到 =
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '=') state = 26;
                    else
                    {
                        Back();
                        state = 100;
                        syn = 14;
                    }
                    break;
                case 26:                                //匹配到 ==
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 25;
                    break;
                case 8:                                    //匹配到 ；
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 15;
                    break;
                case 9:                                    //匹配到 !
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '=') state = 27;
                    else state = 99;
                    break;
                case 27:                                //匹配到 !=
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 26;
                    break;
                case 10:                                    //匹配到 [
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 17;
                    break;
                case 11:                                    //匹配到 ]
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 18;
                    break;
                case 12:                                    //匹配到 (
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 19;
                    break;
                case 13:                                    //匹配到 )
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 20;
                    break;
                case 14:                                    //匹配到 {
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 21;
                    break;
                case 15:                                    //匹配到 }
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 22;
                    break;
                case 16:                                    //匹配到 "……
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (ch == '"') state = 28;
                    else state = 16;
                    break;
                case 28:                                    //匹配到 "……"
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 30;
                    break;
                case 17:                                    //匹配到 ,
                    token[tokenpos++] = ch;
                    state = 100;
                    syn = 16;
                    break;
                case 18:                                    //匹配到字母
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsLetter(ch) || IsNum(ch)) state = 18;    //向前看一位还是数字或字母
                    else
                    {
                        Back();
                        state = 29;                            //向前看一位不属于标识符
                    }
                    break;
                case 29:                                    //判断匹配到的标识符是不是关键字
                    if (strcmp(token, "if") == 0)
                    {
                        state = 100;
                        syn = 0;
                    }
                    else if (strcmp(token, "else") == 0)
                    {
                        state = 100;
                        syn = 1;
                    }
                    else if (strcmp(token, "int") == 0)
                    {
                        state = 100;
                        syn = 2;
                    }
                    else if (strcmp(token, "double") == 0)
                    {
                        state = 100;
                        syn = 3;
                    }
                    else if (strcmp(token, "return") == 0)
                    {
                        state = 100;
                        syn = 4;
                    }
                    else if (strcmp(token, "void") == 0)
                    {
                        state = 100;
                        syn = 5;
                    }
                    else if (strcmp(token, "while") == 0)
                    {
                        state = 100;
                        syn = 6;
                    }
                    else if (strcmp(token, "char") == 0)
                    {
                        state = 100;
                        syn = 7;
                    }
                    else
                    {
                        state = 100;
                        syn = 27;
                    }
                    break;
                case 19:                                    //匹配到的是数字
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 19;                //下一位还是数字
                    else if (ch == '.') state = 30;            //下一位是.
                    else
                    {
                        Back();
                        state = 100;
                        syn = 28;
                    }
                    break;
                case 30:                                    //匹配到 digit D* .
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 30;
                    else if (ch == 'e') state = 31;
                    else
                    {
                        Back();
                        state = 100;
                        syn = 29;
                    }
                    break;
                case 31:                                    //匹配到 digit D* . D* e
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 32;
                    else if (ch == '-')state = 33;
                    else
                    {
                        Back();
                        state = 99;
                    }
                    break;
                case 32:                                    //匹配到 digit D* . D* e
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 32;
                    else
                    {
                        Back();
                        state = 100;
                        syn = 29;
                    }
                    break;
                case 33:                                    //匹配到 digit D* . D* e -
                    token[tokenpos++] = ch;
                    ch = GetNext();
                    if (IsNum(ch)) state = 32;
                    else
                    {
                        Back();
                        state = 99;
                    }
                    break;
                case 99:                                    //匹配中出错
                    std::cout << std::endl;
                    std::cout << "error" << std::endl;
                    std::cout << (int)ch << " " << ch << std::endl;
                    ch = GetNext();
                    while (ch != ' '&&ch != '\t'&&ch != '\n'&&ch != ';') ch = GetNext();
                    Back();
                    state = 100;
                    syn = -1;
                }
            if (state == 100 && syn != -1)                    //接受状态
            {
                switch (syn)
                {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                case 6:
                case 7:
                    outfile << "<" << "RESERVED WORD," << token << ">" << std::endl;
                    //outfile << "<" << token << ">" << std::endl;
                    break;
                case 27:
                    outfile << "<" << "ID," << token << ">" << std::endl;
                    break;
                case 28:
                    outfile << "<" << "NUM," << token << ">" << std::endl;
                    break;
                case 29:
                    outfile << "<" << "DOUBLE," << token << ">" << std::endl;
                    break;
                case 30:
                    outfile << "<" << "STRING," << token << ">" << std::endl;
                    break;
                case 31:
                case 32:
                    break;
                default:
                    outfile << "<" << "SYMBOL," << token << ">" << std::endl;
                    //outfile << "<" << token << ">" << std::endl;
                }
                memset(token, 0, TOKENLENGTH);
                tokenpos = 0;
                state = 0;
                syn = -1;
            }
            if (state = 100) state = 0;
        }
        outfile.close();
    }
     
    bool Scanner::IsNum(const char c)
    {
        return (c >= '0' && c <= '9');
    }
     
    bool Scanner::IsLetter(const char c)
    {
        return c >= 'a'&&c <= 'z' || c >= 'A'&&c <= 'Z';
    }
     
     
    char Scanner::GetNext()
    {
        if (pos < buffer.length())
        {
            return buffer[pos++];
        }
        else
        {
            if (std::getline(infile, buffer))
            {
                buffer.push_back('\n');
            }
            else
            {
                return EOF;
            }
            pos = 0;
            return buffer[pos++];
        }
    }
     
    void Scanner::Back()
    {
        pos -= 1;
}
 */

}
 */*/
