-- STITCH (hehe) those .dat files 
local stitch = {}

stitch.encode = function(fileTable)
  if not assert(type(fileTable) == 'table', 'Not A Table') then return
  else
    
    local result = {}
    local header = {'HEAD:'}
    local curPos = 0
    
    for index, file in pairs(fileTable) do
      table.insert(header, string.format('%s:%d:%d;',index,curPos,#file)) -- 3rd argument: size in chars
      table.insert(result, file) 
      curPos = curPos + file:len()
    end
    
    table.insert(header,'\n')
    return table.concat(header)..table.concat(result)
  
  end

end

stitch.decode = function(encodedStr)

  if not assert(type(encodedStr) == 'string', 'Not A String') then return
  else
    local headerRemoved = false
    local result = {}

    for matchhead in string.gmatch(encodedStr,'[a-zA-Z.]+:%d+:%d+;') do
      
      if matchhead ~= nil then
        
        if not headerRemoved then
          encodedStr = encodedStr:gsub('HEAD:.+:%d+:%d+;\n?', '')
          headerRemoved = true
        end
      
      local regionBeggining=matchhead:match(':%d+:'):gsub(':+','')
      local regionSize=matchhead:match(':%d+;'):gsub('[:|;]+','')
      
      result[matchhead:match('[a-zA-Z.]+')] = encodedStr:sub(regionBeggining, regionBeggining + regionSize)
      
      else
        break

      end
    
    end
    return result
  end

end

return stitch