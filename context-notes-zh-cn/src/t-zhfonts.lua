zhfonts = {}

local function init_fonts_table ()
    local f = {}
    f.serif, f.sans, f.mono = {}, {}, {}
    for k in pairs (f) do
	f[k] = {regular = {},bold = {}, italic = {}, bolditalic = {}}
    end
    return f
end

local cjkfonts, latinfonts = init_fonts_table (), init_fonts_table ()

cjkfonts.serif.regular    = {name = 'adobesongstd',  rscale = '1.0'}
cjkfonts.serif.bold       = {name = 'adobeheitistd',   rscale = '1.0'}
cjkfonts.serif.italic     = {name = 'adobesongstd',  rscale = '1.0'}
cjkfonts.serif.bolditalic = {name = 'adobeheitistd',   rscale = '1.0'}
cjkfonts.sans.regular     = {name = 'adobeheitistd',  rscale = '1.0'}
cjkfonts.sans.bold        = {name = 'adobeheitistd',   rscale = '1.0'}
cjkfonts.sans.italic      = {name = 'adobeheitistd',  rscale = '1.0'}
cjkfonts.sans.bolditalic  = {name = 'adobeheitistd',   rscale = '1.0'}
cjkfonts.mono.regular     = {name = 'adobesongstd', rscale = '1.0'}
cjkfonts.mono.bold        = {name = 'adobesongstd',   rscale = '1.0'}
cjkfonts.mono.italic      = {name = 'adobesongstd', rscale = '1.0'}
cjkfonts.mono.bolditalic  = {name = 'adobesongstd',   rscale = '1.0'}

latinfonts.serif.regular    = {name = 'texgyrepagellaregular'}
latinfonts.serif.bold       = {name = 'texgyrepagellabold'}
latinfonts.serif.italic     = {name = 'texgyrepagellaitalic'}
latinfonts.serif.bolditalic = {name = 'texgyrepagellabolditalic'}
latinfonts.sans.regular     = {name = 'texgyreherosregular'}
latinfonts.sans.bold        = {name = 'texgyreherosbold'}
latinfonts.sans.italic      = {name = 'texgyreherositalic'}
latinfonts.sans.bolditalic  = {name = 'texgyreherosbolditalic'}
latinfonts.mono.regular     = {name = 'lmmono10regular'}
latinfonts.mono.bold        = {name = 'lmmonolt10bold'}
latinfonts.mono.italic      = {name = 'lmmono10italic'}
latinfonts.mono.bolditalic  = {name = 'lmmonolt10boldoblique'}

local mathfonts = {roman = {}}
mathfonts.roman.name = 'xitsmathregular'
mathfonts.roman.feature = 'math\mathsizesuffix'
mathfonts.roman.goodies = 'xits-math'

local function strsplit(str, sep)
    local start_pos = 1
    local split_pos = 1
    local result = {}
    local stop_pos = nil
    while true do
        stop_pos = string.find (str, sep, start_pos)
        if not stop_pos then
            result[split_pos] = string.sub (str, start_pos, string.len(str))
            break
        end
        result[split_pos] = string.sub (str, start_pos, stop_pos - 1)
        start_pos = stop_pos + string.len(sep)
        split_pos = split_pos + 1
    end
    return result
end

local function strtrim (str)
    return string.gsub (str, "^%s*(.-)%s*$", "%1")
end

local function str_split_and_trim (str, sep)
    local strlist = strsplit (str, sep)
    local result  = {}
    for i, v in ipairs (strlist) do
	result[i] = strtrim (v)
    end
    return result
end

local function gen_cjk_typescript (ft)
    local fb = '\\definefontfallback'
    local fb_area = '[0x00400-0x2FA1F]'
    local s1 = nil

    context ('\\starttypescript[serif][zhfonts]')
    context ('\\setups[font:fallbacks:serif]')
    s = ft.serif.regular
    context (fb..'[zhSerif][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.serif.bold
    context (fb..'[zhSerifBold][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.serif.italic
    context (fb..'[zhSerifItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.serif.bolditalic
    context (fb..'[zhSerifBoldItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    context ('\\stoptypescript')

    context ('\\starttypescript[sans][zhfonts]')
    context ('\\setups[font:fallbacks:sans]')
    s = ft.sans.regular
    context (fb..'[zhSans][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.sans.bold
    context (fb..'[zhSansBold][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.sans.italic
    context (fb..'[zhSansItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.sans.bolditalic
    context (fb..'[zhSansBoldItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    context ('\\stoptypescript')

    context ('\\starttypescript[mono][zhfonts]')
    context ('\\setups[font:fallbacks:mono]')
    s = ft.mono.regular
    context (fb..'[zhMono][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.mono.bold
    context (fb..'[zhMonoBold][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.mono.italic
    context (fb..'[zhMonoItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    s = ft.mono.bolditalic
    context (fb..'[zhMonoBoldItalic][name:'..s.name..']'..fb_area..'[rscale='..s.rscale..']')
    context ('\\stoptypescript')
end

local function gen_latin_typescript (ft)
    local la = '\\definefontsynonym[latin'

    context ('\\starttypescript[serif][zhfonts]')
    context (la..'Serif][name:' .. ft.serif.regular.name .. ']')
    context (la..'SerifBold][name:' .. ft.serif.bold.name .. ']')
    context (la..'SerifItalic][name:' .. ft.serif.italic.name .. ']')
    context (la..'SerifBoldItalic][name:' .. ft.serif.bolditalic.name .. ']')
    context ('\\stoptypescript')

    context ('\\starttypescript[sans][zhfonts]')
    context (la..'Sans][name:' .. ft.sans.regular.name .. ']')
    context (la..'SansBold][name:' .. ft.sans.bold.name .. ']')
    context (la..'SansItalic][name:' .. ft.sans.italic.name .. ']')
    context (la..'SansBoldItalic][name:' .. ft.sans.bolditalic.name .. ']')
    context ('\\stoptypescript')

    context ('\\starttypescript[mono][zhfonts]')
    context (la..'Mono][name:' .. ft.mono.regular.name .. ']')
    context (la..'MonoBold][name:' .. ft.mono.bold.name .. ']')
    context (la..'MonoItalic][name:' .. ft.mono.italic.name .. ']')
    context (la..'MonoBoldItalic][name:' .. ft.mono.bolditalic.name .. ']')
    context ('\\stoptypescript')
end

local function gen_fallback_typescript ()
    context ('\\starttypescript[serif][zhfonts]')
    context ('\\setups[font:fallbacks:serif]')
    context ('\\definefontsynonym[zhSeriffallback][latinSerif][fallbacks=zhSerif]')
    context ('\\definefontsynonym[Serif][zhSeriffallback]')    
    context ('\\definefontsynonym[zhSerifBoldfallback][latinSerifBold][fallbacks=zhSerifBold]')
    context ('\\definefontsynonym[SerifBold][zhSerifBoldfallback]')   
    context ('\\definefontsynonym[zhSerifItalicfallback][latinSerifItalic][fallbacks=zhSerifItalic]')
    context ('\\definefontsynonym[SerifItalic][zhSerifItalicfallback]')
    context ('\\definefontsynonym[zhSerifBoldItalicfallback][latinSerifBoldItalic][fallbacks=zhSerifBoldItalic]')
    context ('\\definefontsynonym[SerifBoldItalic][zhSerifBoldItalicfallback]')
    context ('\\stoptypescript')

    context ('\\starttypescript[sans][zhfonts]')
    context ('\\setups[font:fallbacks:sans]')
    context ('\\definefontsynonym[zhSansfallback][latinSans][fallbacks=zhSans]')
    context ('\\definefontsynonym[Sans][zhSansfallback]')    
    context ('\\definefontsynonym[zhSansBoldfallback][latinSansBold][fallbacks=zhSansBold]')
    context ('\\definefontsynonym[SansBold][zhSansBoldfallback]')   
    context ('\\definefontsynonym[zhSansItalicfallback][latinSansItalic][fallbacks=zhSansItalic]')
    context ('\\definefontsynonym[SansItalic][zhSansItalicfallback]')
    context ('\\definefontsynonym[zhSansBoldItalicfallback][latinSansBoldItalic][fallbacks=zhSansBoldItalic]')
    context ('\\definefontsynonym[SansBoldItalic][zhSansBoldItalicfallback]')
    context ('\\stoptypescript')

    context ('\\starttypescript[mono][zhfonts]')
    context ('\\setups[font:fallbacks:mono]')
    context ('\\definefontsynonym[zhMonofallback][latinMono][fallbacks=zhMono]')
    context ('\\definefontsynonym[Mono][zhMonofallback]')    
    context ('\\definefontsynonym[zhMonoBoldfallback][latinMonoBold][fallbacks=zhMonoBold]')
    context ('\\definefontsynonym[MonoBold][zhMonoBoldfallback]')   
    context ('\\definefontsynonym[zhMonoItalicfallback][latinMonoItalic][fallbacks=zhMonoItalic]')
    context ('\\definefontsynonym[MonoItalic][zhMonoItalicfallback]')
    context ('\\definefontsynonym[zhMonoBoldItalicfallback][latinMonoBoldItalic][fallbacks=zhMonoBoldItalic]')
    context ('\\definefontsynonym[MonoBoldItalic][zhMonoBoldItalicfallback]')
    context ('\\stoptypescript')
end

local function gen_math_typescript (ft)
    if mathfonts.roman.name then
	local s = ft.roman
	context ('\\starttypescript[math][zhfonts]')
	context ('\\setups[font:fallbacks:math]')
	context ('\\definefontsynonym[MathRoman][name:'..s.name..'][features='..s.feature..', goodies='..s.goodies..']')
	context ('\\stoptypescript')
    end
end

local function gen_typeface ()
    context ('\\starttypescript[zhfonts]')
    context ('\\definetypeface[zhfonts][rm][serif][zhfonts][default][features=zh]')
    context ('\\definetypeface[zhfonts][ss][sans][zhfonts][default][features=zh]')
    context ('\\definetypeface[zhfonts][tt][mono][zhfonts][default]')
    if mathfonts.roman.name then
	context ('\\definetypeface[zhfonts][mm][math][zhfonts]')
    end
    context ('\\stoptypescript')
end

function zhfonts.gen_typescript ()
    gen_cjk_typescript (cjkfonts)
    gen_latin_typescript (latinfonts)
    gen_fallback_typescript ()
    gen_math_typescript (mathfonts)
    gen_typeface ()
end

local function setup_cjkfonts (meta, fontlist)
    local f, g = nil, nil
    for i, v in ipairs (fontlist) do
	f = str_split_and_trim (v, '=')
	g = str_split_and_trim (f[2], '@')
	if g[1] ~= '' then cjkfonts[meta][f[1]].name = g[1] end
	if g[2] then cjkfonts[meta][f[1]].rscale = g[2] end
    end
end

local function setup_latinfonts (meta, fontlist)
    local f, g = nil, nil
    for i, v in ipairs (fontlist) do
	f = str_split_and_trim (v, '=')
	latinfonts[meta][f[1]].name = f[2]
    end   
end

local function setup_mathfonts (fontlist)
    local f, g = nil, nil
    for i, v in ipairs (fontlist) do
	f = str_split_and_trim (v, '=')
	if f[2] ~= '' then 
	    mathfonts[f[1]].name = f[2]
	else
	    mathfonts[f[1]].name = nil
	end
    end   
end


local fontfeatures = "mode=node,protrusion=myvector,liga=yes,"
local function setup_fontfeatures (s)
    fontfeatures = fontfeatures .. s
    print (fontfeatures)
end

function zhfonts.setup (metainfo, fontinfo)
    local m = str_split_and_trim (metainfo, ',')
    local f = str_split_and_trim (fontinfo, ',')
    if #m == 1 and m[1] == 'feature' then setup_fontfeatures (fontinfo) end
    if #m == 1 and cjkfonts[m[1]] then setup_cjkfonts (m[1], f)  end
    if #m == 1 and m[1] == 'math' then setup_mathfonts (f) end
    if #m == 2 then
	if m[1] == 'latin' and latinfonts[m[2]] then setup_latinfonts (m[2], f) end
	if m[2] == 'latin' and latinfonts[m[1]] then setup_latinfonts (m[1], f) end	
    end
end

function zhfonts.use (param)
    context ('\\setscript[hanzi]')
    zhspuncs.opt ()
    context ('\\definefontfeature[zh][default][' .. fontfeatures .. ']')
    context ('\\setupalign[hz,hanging]')
    local f = strtrim (param)
    if f ~= "none" then
        zhfonts.gen_typescript ()
        if f ~= "hack" then
	    context ('\\usetypescript[zhfonts]')
            context ('\\setupbodyfont[zhfonts, ' .. param .. ']') 
        end
    end
end
