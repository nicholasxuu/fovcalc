package main

import (
  "log"
  "net/http"
  "fmt"
  "io"
  "encoding/hex"
  "crypto/md5"
)

type Feedback struct {
  Name string
  Text string
  Md5 string
}

func main() {
  http.HandleFunc("/fovcalc_feedback", Handler)
  log.Println("Listening on :9933 ...")
  log.Fatal(http.ListenAndServe(":9933", nil))
}

func Handler(w http.ResponseWriter, r *http.Request) {
  feedback := extractFormData(r)

  if isValidMd5(feedback) {
    log.Printf("Received feedback:\nName:\n  %s\nText:\n  %s\n", feedback.Name, feedback.Text)
    fmt.Fprintf(w, "OK")
    return
  } else {
    http.Error(w, "Bad Request", 400)
  }
}

func extractFormData(r *http.Request) Feedback {
  r.ParseMultipartForm(8192)
  return Feedback{
    Name: r.PostForm.Get("feedback-name"),
    Text: r.PostForm.Get("feedback-text"),
    Md5: r.PostForm.Get("feedback-checksum"),
  }
}

func isValidMd5(feedback Feedback) bool {
  data := feedback.Name + feedback.Text
  return hexedHash(data) == feedback.Md5
}

func hexedHash(s string) string {
  hash := md5.New()
  io.WriteString(hash, s)
  return hex.EncodeToString(hash.Sum(nil))
}