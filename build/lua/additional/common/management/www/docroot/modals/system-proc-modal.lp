--pretranslated: do not change this file

-- Localization
gettext.textdomain('webui-core')

local ui_helper = require("web.ui_helper")
local post_helper = require("web.post_helper")

local proc_columns = {
  { --[1]
    header = T"Process ID",
    name = "process",
    param = "process",
    type = "text",
  },
  { --[2]
    header = T"Parent",
    name = "parent",
    param = "parent",
    type = "text",
  },
  { --[3]
    header = T"User",
    name = "user",
    param = "user",
    type = "text",
  },
  { --[4]
    header = T"State",
    name = "state",
    param = "state",
    type = "text",
  },
  { --[5]
    header = T"Memory",
    name = "virtual_memory_size",
    param = "virtual_memory_size",
    type = "text",
  },
  { --[6]
    header = T"Memory %",
    name = "virtual_memory_percent",
    param = "virtual_memory_percent",
    type = "text",
  },
  { --[6]
    header = T"CPU%",
    name = "cpu",
    param = "cpu",
    type = "text",
  },
  { --[6]
    header = T"Command",
    name = "command",
    param = "command",
    type = "text",
  },
}

local proc_options = {
  canEdit = false,
  canAdd = false,
  canDelete = false,
  tableid = "proctable",
  basepath = "rpc.gui.proc.processes.",
}

local proc_data, proc_helpmsg = post_helper.handleTableQuery(proc_columns, proc_options, nil, nil, nil)

  ngx.print('\
');  ngx.print(ui_helper.createHeader(T"Management", false, true, 5) ); ngx.print('\
<div class="modal-body update">\
');  
  local lp = require("web.lp")
  lp.setpath("/www/snippets/")
  lp.include("tabs-management.lp")
  ngx.print('\
');  
-- dummy form so that refresh button knows which page to reload, keep it
ngx.print('\
<form class="form-horizontal" method="post" action="modals/system-proc-modal.lp">\
  <fieldset id="system-proc-tab">\
    <legend>');  ngx.print( T"Processes" ); ngx.print('</legend>')
    local filterclass = {
        input = {
            id = "searchInput",
        }
    }
    local html = {}
    html[#html+1] = "<div class='control-group'><label class='control-label'>Filter</label><div class='controls'>"
    html[#html+1] = "<input data-type='search' name='Filter' class='edit-input span3' placeholder='Search For Processes...' id='searchInput' type='text'>"
    html[#html+1] = "</div></div>"
    ngx.print(html)
    ngx.print(ui_helper.createTable(proc_columns, proc_data, proc_options, nil, proc_helpmsg))
    ngx.print('\
  </fieldset>\
</form>\
</div>\
');  ngx.print(ui_helper.createFooter() ); ngx.print('\
<script>\
  (function() {\
    $("#searchInput").keyup(function () {\
      var data = this.value.toUpperCase().split(" ");\
      var jo = $("#proctable tbody").find("tr");\
      if (this.value == "") {\
          jo.show();\
          return;\
      }\
      jo.hide();\
      jo.filter(function (i, v) {\
          var $t = $(this);\
          for (var d = 0; d < data.length; ++d) {\
              if ($t.text().toUpperCase().indexOf(data[d]) > -1) {\
                  return true;\
              }\
          }\
          return false;\
      })\
      .show();\
    }).focus(function () {\
      this.value = "";\
      $(this).css({\
          "color": "black"\
      });\
      $(this).unbind(\'focus\');\
    }).css({\
      "color": "#C0C0C0"\
    });\
  }());\
</script>\
');
