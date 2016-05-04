ROLES = {

    "admin" => { #role_id == 1
                 "home" => ["all"],
                 "products" => ["all"],
                 "items" => ["all"],
                 "users" => ["all"],
                 "logs" => ["all"],
                 "requests" => ["all"],
                 "colors" => ["all"],
                 "documents" => ["all"]
    },

    "manager" =>{ #role_id == 2
                  "home" => ["all"],
                  "products" => ["all"],
                  "items" => ["all"],
                  "users" => ["all"],
                  "logs" => ["all"],
                  "requests" => ["all"],
                  "colors" => ["all"],
                  "documents" => ["all"]
    },

    "location_manager" =>{ #role_id == 3
                           "home" => ["index"],
                           "products" => ["my_store", "stores", "inventory", "sales", "statistics"],
                           "items" => ["show_sale_dialog", "sale", "show_exchange_dialog", "exchange", "show_request_dialog", "request"],
                           "logs" => ["index", "my_transfers"],
                           "requests" => ["index", "create", "show_update_dialog", "update"],
                           "documents" => ["all"]
    },

    "salesman" =>{ #role_id == 5
                   "home" => ["index"],
                   "products" => ["my_store", "stores", "inventory", "sales", "statistics"],
                   "items" => ["show_sale_dialog", "sale", "show_exchange_dialog", "exchange", "show_request_dialog", "request"],
                   "logs" => ["index", "my_transfers"],
                   "requests" => ["index", "create"],
                   "documents" => ["all"]
    },

    "storageman" =>{ #role_id == 4
                     "home" => ["index"],
                     "products" => ["my_store", "stores", "inventory", "sales", "statistics", "new", "create", "edit", "update", "show", "delete_photo", "destroy"],
                     "items" => ["show_add_dialog", "add", "show_edit_dialog", "edit"],
                     "logs" => ["index", "my_transfers"],
                     "requests" => ["index", "show_update_dialog", "update"],
                     "colors" => ["all"],
                     "documents" => ["all"]
    }

}