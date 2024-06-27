# autocompletion for sql table types
export def column-types [] {
      ["INTEGER", "REAL", "TEXT", "BLOB", "NUMERIC", "BOOLEAN", "DATE", "DATETIME", "VARCHAR(N)", "CHAR(N)", "DOUBLE", "FLOAT", "INT", "TINYINT", "SMALLINT", "MEDIUMINT", "BIGINT", "UNSIGNED BIG INT", "INT2", "INT8", "CLOB"]
}




# Autocomplete for column properties
export def column-properties [] {
      ["PRIMARY KEY", "AUTOINCREMENT", "NOT NULL", "UNIQUE", "CHECK", "DEFAULT", "COLLATE", "FOREIGN KEY"]
}



 # Custom autocomplete function for columns
 def autocomplete-columns [
     partial: string
     ] {
           let parts = $partial | split column "@" 
               if ($parts | length) == 2 {
                         let prefix = $parts.0
                                 let suffix = $parts.1
                                         let type_suggestions = column-types | where $it =~ $suffix
                                                 let property_suggestions = column-properties | where $it =~ $suffix
                                                         let suggestions = ($type_suggestions | each { |t| $"($prefix)@($t)" }) + ($property_suggestions | each { |p| $"($prefix)@($p)" })
                                                                 $suggestions
                                                                     } else {
                                                                               []
                                                                                   }
     
    
}

# # helper for templates to build a db
# export def sqeel-table [
#     table_name: string@column-properties, 
#       [ [xbfb] ]  
#
#          ] {
#         
#         
#         
# # Construct the columns definition part of the SQL command
#     let columns_def = $columns | each { |col| 
#         let parts = $col | split column "@" 
#         $"($parts.0) ($parts.1)"
#     } | str join ", "
#     
#     # SQL command to create table if it doesn't exist
#     let sql = $"CREATE TABLE IF NOT EXISTS ($table_name) ($columns_def);"
#    } 
#
#
# $env.config = {
#       "completions": {
#                 "commands": {
#                               "sqeel-table": {
#                                                 "columns": "autocomplete-columns"
#                                                             }
#                                                                     }
#                                                                         }
# }
#                               

