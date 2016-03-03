(require 'ert)
(require 'soundklaus-request)

(ert-deftest soundklaus-protocol-port-test ()
  (should-not (soundklaus-protocol-port nil))
  (should-not (soundklaus-protocol-port nil))
  (should-not (soundklaus-protocol-port "unknown"))
  (should (equal (soundklaus-protocol-port 'http) 80))
  (should (equal (soundklaus-protocol-port 'HTTP) 80))
  (should (equal (soundklaus-protocol-port "HTTP") 80))
  (should (equal (soundklaus-protocol-port "http") 80))
  (should (equal (soundklaus-protocol-port "https") 443)))

(ert-deftest soundklaus-request-headers-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-headers request)
                   '(("Accept" . "application/json"))))))

(ert-deftest soundklaus-request-method-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-method request) "GET"))))

(ert-deftest soundklaus-request-scheme-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-scheme request) 'https))))

(ert-deftest soundklaus-request-server-name-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-server-name request) "api.soundcloud.com"))))

(ert-deftest soundklaus-request-server-port-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-server-port request) 443))))

(ert-deftest soundklaus-request-uri-test ()
  (let ((request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-uri request) "/tracks"))))

(ert-deftest soundklaus-request-query-params-test ()
  (let* ((soundklaus-client-id "CLIENT-ID")
         (soundklaus-access-token "ACCESS-TOKEN")
         (request (soundklaus-make-request "/tracks")))
    (should (equal (soundklaus-request-query-params request)
                   `(("oauth_token" . ,soundklaus-access-token)
                     ("client_id" . ,soundklaus-client-id))))))

(ert-deftest soundklaus-request-url-test ()
  (let* ((soundklaus-client-id "CLIENT-ID")
         (soundklaus-access-token "ACCESS-TOKEN")
         (request (soundklaus-make-request "/tracks")))
    (should (string= (soundklaus-request-url request)
                     "https://api.soundcloud.com:443/tracks"))
    (should (string= (soundklaus-request-url request t)
                     "https://api.soundcloud.com:443/tracks?oauth_token=ACCESS-TOKEN&client_id=CLIENT-ID"))))

(ert-deftest soundklaus-send-sync-request-test ()
  (let* ((request (soundklaus-make-request "/tracks"))
         (response (soundklaus-send-sync-request request)))
    ;; TODO: Fix empty sporadic response 
    ;; (should (equal (request-response-status-code response) 200))
    ;; (should (request-response-data response))
    ))

(ert-deftest soundklaus-parse-params-test ()
  (should-not (soundklaus-parse-params nil))
  (should-not (soundklaus-parse-params ""))
  (should (equal (soundklaus-parse-params "limit=40") '(("limit" . "40"))))
  (should (equal (soundklaus-parse-params "limit=40&cursor=00000152-3b25-99d0-0000-0000467dce9a")
                 '(("limit" . "40")
                   ("cursor" . "00000152-3b25-99d0-0000-0000467dce9a")))))

(ert-deftest soundklaus-parse-url-test ()
  (let* ((url "https://api.soundcloud.com/me/activities?limit=40&cursor=00000152-3b25-99d0-0000-0000467dce9a")
         (request (soundklaus-parse-url url)))
    (should (equal (soundklaus-request-scheme request) 'https))
    (should (equal (soundklaus-request-server-name request) "api.soundcloud.com"))
    (should (equal (soundklaus-request-server-port request) 443))
    (should (equal (soundklaus-request-uri request) "/me/activities"))
    (should (equal (soundklaus-request-query-params request)
                   '(("limit" . "40")
                     ("cursor" . "00000152-3b25-99d0-0000-0000467dce9a"))))))

(ert-deftest soundklaus-next-offset-request-test ()
  (let* ((request (soundklaus-make-request "/tracks"))
	 (next (soundklaus-next-offset-request request))
	 (params (soundklaus-request-query-params next)))
    (should (equal 10 (cdr (assoc "limit" params))))
    (should (equal 10 (cdr (assoc "offset" params)))))
  (let* ((request (soundklaus-make-request "/tracks" :query-params '(("offset" . 10))))
	 (next (soundklaus-next-offset-request request))
	 (params (soundklaus-request-query-params next)))
    (should (equal 10 (cdr (assoc "limit" params))))
    (should (equal 20 (cdr (assoc "offset" params)))))
  (let* ((request (soundklaus-make-request "/tracks" :query-params '(("limit" . 5) ("offset" . 20))))
	 (next (soundklaus-next-offset-request request))
	 (params (soundklaus-request-query-params next)))
    (should (equal 5 (cdr (assoc "limit" params))))
    (should (equal 25 (cdr (assoc "offset" params))))))

(provide 'soundklaus-request-test)
