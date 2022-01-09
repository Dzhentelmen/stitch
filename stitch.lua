-- STITCH (hehe) those .dat files 
local stitch = {
    ext = "st" -- preferred file extension for output archives
}

stitch.encode = function(fileTable)
    if not assert(type(fileTable) == "table", "Not A Table") then 
        return nil
    else
        local result = {}
        local curPos = 0

        local header = { "HEAD:" }
        
        for filename, content in pairs(fileTable) do
            local contentSize = #content

            table.insert(header, string.format("%s:%d:%d;", filename, curPos, contentSize)) -- 3rd argument: size in chars
            table.insert(result, content)

            curPos = curPos + contentSize
        end
        
        table.insert(header,'\n')

        return table.concat(header)..table.concat(result)
    end
end

stitch.decode = function(encodedStr)
    if not assert(type(encodedStr) == "string", "Not A String") then 
        return nil
    else
        local result = {}
        
        local header = encodedStr:match("HEAD:.+:%d+:%d+;\n?")
        encodedStr = encodedStr:gsub(header, "")
        
        for matchhead in header:gmatch("[a-zA-Z.]+:%d+:%d+;") do
            if matchhead ~= nil then
                --funny regex strip()
                local regionBeggining = matchhead:match(":%d+:"):gsub(":+", "")
                local regionSize = matchhead:match(":%d+;"):gsub("[:|;]+", "")

                result[matchhead:match("[a-zA-Z.]+")] = encodedStr:sub(regionBeggining, regionBeggining + regionSize)
            
            else
                break
            end
        end

        return result
    end
end

return stitch