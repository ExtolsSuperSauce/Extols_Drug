postfx = {
    append = function(code, insert_after_line, file)
        if(insert_after_line ~= nil)then
            if(type(code) ~= "string")then
                error("append argument has to be a string!")
            else
                local post_final = ModTextFileGetContent(file)
                if(post_final ~= nil)then
        
                    lines = {}
                    for s in post_final:gmatch("[^\r\n]+") do
                        table.insert(lines, s)
                    end
                
                    content = ""

                    for i, line in ipairs(lines) do

                        if(string.match(line, insert_after_line))then
                            line = line..string.char(10)..code
                        end
                        content = content..line..string.char(10)
                    end
                    ModTextFileSetContent(file, content)
                end
                
            end
        else
            error("no insert line given!")
        end
    end,
    replace = function(to_replace, replacement, file)
        if(to_replace ~= nil)then
            if(type(replacement) ~= "string")then
                error("replacement text has to be a string!")
            else
                local post_final = ModTextFileGetContent(file)
                if(post_final ~= nil)then
        
                    content = post_final:gsub(to_replace, replacement)

                    ModTextFileSetContent(file, content)
                end
                
            end
        else
            error("no replace line given!")
        end
    end,
}
