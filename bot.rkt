#lang racket

(require racket-cord)

(define bot-token "BOT_TOKEN")

(define myclient (make-client bot-token #:auto-shard #t))

(on-event
 'message-create myclient
 (lambda (client message)
   (unless (string=? (user-id (message-author message)) ; dont reply to ourselves
                     (user-id (client-user client)))
     (cond
       [(string-prefix? (message-content message) "s!echo ")
        (http:create-message client (message-channel-id message)
                             (string-trim (message-content message) "s!echo " #:right? #f))]
       [(equal? (message-content message) "s!pi")
        (http:create-message client (message-channel-id message)
                             "3.14159265358...")]
       [(equal? (message-content message) "s!whoami")
        (http:create-message client (message-channel-id message)
                             (string-append "Hi " (user-username (message-author message)) "!"))]
       ))))

 
(define dr (make-log-receiver discord-logger 'debug))
 
(thread
 (thunk
  (let loop ()
    (let ([v (sync dr)])
      (printf "[~a] ~a\n" (vector-ref v 0)
              (vector-ref v 1)))
    (loop))))
 

(start-client myclient)