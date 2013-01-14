module Logs =

let spacedcols = [ seq "line" . counter "item" . Build.opt_list [ seq "item" . store Rx.no_spaces ] Sep.space . Util.eol ]
let lns_spacedcols = spacedcols*

let date =
     let month = [ label "month" . store Rx.word ]
  in let day = [ label "day" . store Rx.integer ]
  in let time = [ label "time" . store /[0-9]+:[0-9]+:[0-9]+/ ]
  in [ label "date" . month . Sep.space
                    . day . Sep.space
                    . time ]

let syslog =
     let host = [ label "host" . store Rx.word? ]
  in let id = [ label "id" . Util.del_str "[" . store Rx.decimal . Util.del_str "]" ]
  in let service = [ label "service" . store Rx.word . id? . Sep.colon ]
  in let message = [ label "message" . store Rx.space_in? ]
  in [ seq "line" . date . Sep.space
                  . host . Sep.space
                  . service . Sep.opt_space
                  . message . Util.eol ]

let lns_syslog = syslog*
