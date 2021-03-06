local key, page = ...

if text:is_empty(page) then
    page = 1
end
local doc = http:get("https://truyen.tangthuvien.vn/ket-qua-tim-kiem?term=" .. key .. "&page=" .. page):html()

if doc ~= nil then
    local el = doc:select("#rank-view-list ul li")
    local novelList = {}
    local next

    local last = doc:select("ul.pagination > li > a"):last()
    if last ~= nil then
        next = regexp:find(last:attr("href"), "page=(\\d+)")
    end
    for i = 1, el:size() do
        local e = el:get(i - 1)
        local novel = {}
        local name = e:select("h4 > a"):text()
        if not text:is_empty(name) then
            novel["name"] = name
            novel["link"] = e:select("h4 > a"):attr("href")
            novel["description"] = e:select(".author"):text()
            novel["cover"] = e:select("img"):first():attr("src")
            novel["host"] = "https://truyen.tangthuvien.vn"
            table.insert(novelList, novel)
        end
    end
    return response:success(novelList, next)
end

return nil
