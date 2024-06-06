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

 
# Converts specific JSON to JSON schema.
export def main [json: string, schema: int = 7, url: string = "doc"] {
    # if ($schema != 4 or $schema != 7) {
    #     print $"($schema == 7) ... eeeh ($schema)" 
    # }
    if url == "" {
        error make { msg: "Documentation url can't be empty." }
    }

    let schema = $"http://json-schema.org/draft-0($schema)/schema"

   $json | jq -b 'def to_title: . | gsub("(?<x>[A-Z])"; " \(.x)") | ascii_downcase;
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




export def v2 [json: string, schema: int = 7, url: string = "doc"] {
    if url == "" {
        error make { msg: "Documentation url can't be empty." }
    }

    let schema = $"http://json-schema.org/draft-0($schema)/schema"

    $json | jq -b 'def to_title: . | gsub("(?<x>[A-Z])"; " \(.x)") | ascii_downcase;
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
                        name: .key,
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
                    if .value | type == "boolean" then
                        { default: (.value // true) }
                    else
                        {}
                    end +
                    if .value | type == "string" then
                        { default: (.value // "example1") }
                    else
                        {}
                    end +
                    if .value | type == "number" then
                        { minimum: 0, maximum: 100, default: (.value // 0) }
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
                    name: .key,
                    description: .key | to_description
                } + (.value | wrap) + {
                    additionalProperties: false
                }
            end)
        };
    
    {
        "$schema": $schema,
        title: "config",
        description: "A config",
        required: [. | keys[]]
    } + (. | wrap)' --arg url $url --arg schema $schema

}


export def llmski [input_json: string, output_json: string, pattern_store: string] {

let prompt = $"You are an advanced language model tasked with enhancing a JSON schema generator. The goal is to infer additional properties from input JSON and make the schema more useful for an editor. Specifically, you need to:

1. **Identify and detail patterns**: Where it makes sense, identify patterns in string values and detail them.
2. **Store patterns in a reusable format**: Store these patterns in a separate JavaScript object with tags and descriptions for reuse in fitting places.

### Input JSON Example

```json
($input_json)
```

### Output JSON Schema Example

```json
($output_json)
```

### Patterns JavaScript Object

```javascript
const patterns = {
  alphanumeric: {
    pattern: '^[a-zA-Z0-9_]+$',
    tags: ['string', 'alphanumeric'],
    description: 'Matches alphanumeric characters including underscores.'
  },
  email: {
    pattern: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$',
    tags: ['string', 'email'],
    description: 'Matches standard email addresses.'
  },
  phoneNumber: {
    pattern: '^\\+?[1-9]\\d{1,14}$',
    tags: ['string', 'phone'],
    description: 'Matches international phone numbers.'
  }
};
```

current pattern store:

```javascript
($pattern_store)  
```


### Instructions

1. **Identify Patterns**: For each string value in the input JSON, identify if a common pattern can be applied e.g., email, phone number, alphanumeric.
2. **Detail Patterns**: Provide detailed regex patterns for these values.
3. **Store Patterns**: Store these patterns in a JavaScript object with appropriate tags and descriptions.
4. **Apply Patterns**: Use these patterns in the output JSON schema where applicable

### Example Process

1. **Identify**: The value `'example@example.com'` is identified as an email.
2. **Detail**: The regex pattern for an email is `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$`.
3. **Store**: Store this pattern in the `patterns` JavaScript object with tags `['string', 'email']` and a description.
4. **Apply**: Use this pattern in the JSON schema for the `email` property."

print $prompt
}


#
#  there are error in v2 command inside the jq string:
# ```
# unexpected '+', expecting ':', May need parentheses around object key expression at, (if .value | type == "number" then, May need parentheses around object key expressio, and syntax error, unexpected '+', expecting '}' (Windows cmd shell quoting issues?) , May need parentheses around object key expression, type: "object", syntax error, unexpected else (Windows cmd shell quoting issues?)
# ```
#




#
#
# to-json-schema llmski `{
#    "apiVersion": 2,
#    "title": "Collapsible Section",
#    "icon": "arrow-down-alt2",
#    "category": "esafe-neue",
#    "attributes": {
#      "title": {
#        "type": "string",
#        "default": "Click to Toggle"
#      },
#      "content": {
#        "type": "string",
#        "default": "This is the collapsible content."
#      },
#      "isOpen": {
#        "type": "boolean",
#        "default": false
#      }
#    }
#  }` `{
#   "$schema": "http://json-schema.org/draft-07/schema",
#   "title": "config",
#   "description": "A config",
#   "required": [
#     "apiVersion",
#     "attributes",
#     "category",
#     "icon",
#     "title"
#   ],
#   "type": "object",
#   "properties": {
#     "apiVersion": {
#       "name": "apiVersion",
#       "description": "api version#doc",
#       "type": "number",
#       "minimum": 0,
#       "maximum": 100,
#       "default": 2
#     },
#     "title": {
#       "name": "title",
#       "description": "title#doc",
#       "type": "string",
#       "pattern": "^[a-zA-Z0-9_]+$",
#       "default": "Collapsible Section"
#     },
#     "icon": {
#       "name": "icon",
#       "description": "icon#doc",
#       "type": "string",
#       "pattern": "^[a-zA-Z0-9_]+$",
#       "default": "arrow-down-alt2"
#     },
#     "category": {
#       "name": "category",
#       "description": "category#doc",
#       "type": "string",
#       "pattern": "^[a-zA-Z0-9_]+$",
#       "default": "esafe-neue"
#     },
#     "attributes": {
#       "name": "attributes",
#       "description": "attributes#doc",
#       "type": "object",
#       "properties": {
#         "title": {
#           "name": "title",
#           "description": "title#doc",
#           "type": "object",
#           "properties": {
#             "type": {
#               "name": "type",
#               "description": "type#doc",
#               "type": "string",
#               "pattern": "^[a-zA-Z0-9_]+$",
#               "default": "string"
#             },
#             "default": {
#               "name": "default",
#               "description": "default#doc",
#               "type": "string",
#               "pattern": "^[a-zA-Z0-9_]+$",
#               "default": "Click to Toggle"
#             }
#           },
#           "additionalProperties": false
#         },
#         "content": {
#           "name": "content",
#           "description": "content#doc",
#           "type": "object",
#           "properties": {
#             "type": {
#               "name": "type",
#               "description": "type#doc",
#               "type": "string",
#               "pattern": "^[a-zA-Z0-9_]+$",
#               "default": "string"
#             },
#             "default": {
#               "name": "default",
#               "description": "default#doc",
#               "type": "string",
#               "pattern": "^[a-zA-Z0-9_]+$",
#               "default": "This is the collapsible
# content."
#             }
#           },
#           "additionalProperties": false
#         },
#         "isOpen": {
#           "name": "isOpen",
#           "description": "is open#doc",
#           "type": "object",
#           "properties": {
#             "type": {
#               "name": "type",
#               "description": "type#doc",
#               "type": "string",
#               "pattern": "^[a-zA-Z0-9_]+$",
#               "default": "boolean"
#             },
#             "default": {
#               "name": "default",
#               "description": "default#doc",
#               "type": "boolean",
#               "default": false
#             }
#           },
#           "additionalProperties": false
#         }
#       },
#       "additionalProperties": false
#     }
#   }
# }` '{}'
