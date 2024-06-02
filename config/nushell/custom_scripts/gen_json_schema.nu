


# Notes

## - `title` properties are generated from input property names converting all
##   capital letters to lowercase with space before them like:
##   `someImportantKey` -> `some important key`
## - `description` properties are generated from input property names converting all
##   capital letters to lowercase with space before them and appended doc urls like:
##   `someImportantKey` -> `some important key\nhttps://some/documentation`
## - `type` properties are generated from input property values
## - `minimum` properties are generated for input properties containing `width`/
##   `height`/`size` word
## - `default` properties are generated for input properties not starting with
##   `my`/`sample`/`example` words
## - `example` properties are generated for input properties starting with
##   `my`/`sample`/`example` words
## 
## # Example
## 
## Input JSON:
## 
## ```json
## {
##     "size": "normal",
##     "myInput": 1,
##     "width": 21,
##     "files": ["test.blend", "test.blend"]
## }
## ```
## 
## Output JSON schema:
## 
## ```json
## {
##   "$schema": "http://json-schema.org/draft-07/schema",
##   "title": "config",
##   "description": "A config",
##   "type": "object",
##   "properties": {
##     "size": {
##       "title": "size",
##       "description": "size\nhttps://my-doc",
##       "type": "string",
##       "minimum": 0,
##       "default": "normal"
##     },
##     "myInput": {
##       "title": "my input",
##       "description": "my input\nhttps://my-doc",
##       "type": "number",
##       "examples": [
##         1
##       ]
##     },
##     "width": {
##       "title": "width",
##       "description": "width\nhttps://my-doc",
##       "type": "number",
##       "minimum": 0,
##       "default": 21
##     },
##     "files": {
##       "title": "files",
##       "description": "files\nhttps://my-doc",
##       "type": "array",
##       "uniqueItems": true,
##       "items": {
##         "description": "A file\nhttps://my-doc",
##         "type": "string"
##       },
##       "default": [
##         "test.blend",
##         "test.blend"
##       ]
##     }
##   }
## }
## ```


export def main [json: string, schema?: int, url: string = ""] {
#    if not $schema in [4, 7] {
#        error make { msg: $"'http://json-schema.org/draft-0($schema)/schema' is not supported yet." }
#    }
#    if url == "" {
#        error make { msg: "Documentation url can't be empty." }
#    }

    let schema = $"http://json-schema.org/draft-0($schema)/schema"

    $json | jq 'def to_title: . | gsub("(?<x>[A-Z])"; " \(.x)") | ascii_downcase;
    def to_description: . | to_title + "\n" + $url;
    
    def to_singular:
        if . | test("^[aeiouy]"; "i") then
            . | sub("^(?<x>.*?)s\n"; "An \(.x)\n")
        else
            . | sub("^(?<x>.*?)s\n"; "A \(.x)\n")
        end;
    
    def wrap: {
        type: "object",
        properties: with_entries(
            if .value | type != "object" then
                {
                    key,
                    value: ({
                        title: .key | to_title,
                        description: .key | to_description,
                        type: (.value | type),
                        
                    } +
                    if .key | test("width|height|size") then
                        { minimum: 0 }
                    else
                        {}
                    end +
                    if .value | type == "array" then
                        {
                            uniqueItems: true,
                            items: {
                                description: .key | to_description | to_singular
                            }
                        } *
                        if .value | length > 0 then
                            {
                                items: {
                                    type: .value[0] | type
                                }    
                            }
                        else
                            {}
                        end
                    else
                        {}
                    end +
                    if .key | test("^([Mm]y|[Ss]ample|[Ee]xample)[A-Z]") then
                        { examples: [.value] }
                    else
                        { default: .value }
                    end)
                }
            else
                .value = {
                    title: .key | to_title,
                    description: .key | to_description
                } + (.value | wrap) + {
                    additionalProperties: false
                }
            end)
        };
    
    {
        "$schema": $schema,
        title: "config",
        description: "A config"
    } + (. | wrap)' --arg url $url --arg schema $schema
}














